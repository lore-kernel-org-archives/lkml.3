Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935070Ab3DIRwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 13:52:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759308Ab3DIRwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 13:52:10 -0400
Date: Tue, 9 Apr 2013 13:51:43 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Jens Axboe <axboe@kernel.dk>
cc: Vivek Goyal <vgoyal@redhat.com>, Tejun Heo <tj@kernel.org>,
        Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>,
        dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>,
        dm-crypt@saout.de, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Christian Schmidt <schmidt@digadd.de>
Subject: dm-crypt parallelization patches
In-Reply-To: <20130328204522.GA25501@mtj.dyndns.org>
Message-ID: <Pine.LNX.4.64.1304091242350.10025@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1303252051520.9745@file.rdu.redhat.com>
 <20130326122713.GC27610@agk-dp.fab.redhat.com> <5151FF82.6090405@gmail.com>
 <20130326202837.GA5599@redhat.com> <20130328185327.GF14088@htj.dyndns.org>
 <20130328193343.GA15969@redhat.com> <20130328194443.GG14088@htj.dyndns.org>
 <20130328203808.GC15969@redhat.com> <20130328204522.GA25501@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I placed the dm-crypt parallization patches at: 
http://people.redhat.com/~mpatocka/patches/kernel/dm-crypt-paralelizace/current/

The patches paralellize dm-crypt and make it possible to use all processor 
cores.


The patch dm-crypt-remove-percpu.patch removes some percpu variables and 
replaces them with per-request variables.

The patch dm-crypt-unbound-workqueue.patch sets WQ_UNBOUND on the 
encryption workqueue, allowing the encryption to be distributed to all 
CPUs in the system.

The patch dm-crypt-offload-writes-to-thread.patch moves submission of all 
write requests to a single thread.

The patch dm-crypt-sort-requests.patch sorts write requests submitted by a 
single thread. The requests are sorted according to the sector number, 
rb-tree is used for efficient sorting.

Some usage notes:

* turn off automatic cpu frequency scaling (or set it to "performance"
  governor) - cpufreq doesn't recognize encryption workload correctly, 
  sometimes it underclocks all the CPU cores when there is some encryption 
  work to do, resulting in bad performance

* when using filesystem on encrypted dm-crypt device, reduce maximum 
  request size with "/sys/block/dm-2/queue/max_sectors_kb" (substitute 
  "dm-2" with the real name of your dm-crypt device). Note that having too 
  big requests means that there is a small number of requests and they 
  cannot be distributed to all available processors in parallel - it 
  results in worse performance. Having too small requests results in high 
  request overhead and also reduced performance. So you must find the 
  optimal request size for your system and workload. For me, when testing 
  this on ramdisk, the optimal is 8KiB. 

---

Now, the problem with I/O scheduler: when doing performance testing, it 
turns out that the parallel version is sometimes worse than the previous 
implementation.

When I create a 4.3GiB dm-crypt device on the top of dm-loop on the top of 
ext2 filesystem on 15k SCSI disk and run this command

time fio --rw=randrw --size=64M --bs=256k --filename=/dev/mapper/crypt 
--direct=1 --name=job1 --name=job2 --name=job3 --name=job4 --name=job5 
--name=job6 --name=job7 --name=job8 --name=job9 --name=job10 --name=job11 
--name=job12

the results are this:
CFQ scheduler:
--------------
no patches:
21.9s
patch 1:
21.7s
patches 1,2:
2:33s
patches 1,2 (+ nr_requests = 1280000)
2:18s
patches 1,2,3:
20.7s
patches 1,2,3,4:
20.7s

deadline scheduler:
-------------------
no patches:
27.4s
patch 1:
27.4s
patches 1,2:
27.8s
patches 1,2,3:
29.6s
patches 1,2,3,4:
29.6s


We can see that CFQ performs badly with the patch 2, but improves with the 
patch 3. All that patch 3 does is that it moves write requests from 
encryption threads to a separate thread.

So it seems that CFQ has some deficiency that it cannot merge adjacent 
requests done by different processes.

The problem is this:
- we have 256k write direct-i/o request
- it is broken to 4k bios (because we run on dm-loop on a filesystem with 
  4k block size)
- encryption of these 4k bios is distributed to 12 processes on a 12-core 
  machine
- encryption finishes out of order and in different processes, 4k bios 
  with encrypted data are submitted to CFQ
- CFQ doesn't merge them
- the disk is flooded with random 4k write requests, and performs much 
  worse than with 256k requests

Increasing nr_requests to 1280000 helps a little, but not much - it is 
still order of magnitute slower.

I'd like to ask if someone who knows the CFQ scheduler (Jens?) could look 
at it and find out why it doesn't merge requests from different processes. 

Why do I have to do a seemingly senseless operation (hand over write 
requests to a separate thread) in patch 3 to improve performance?

Mikulas
