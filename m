Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbbAEXGV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 18:06:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079AbbAEXGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 18:06:20 -0500
Date: Mon, 5 Jan 2015 18:05:59 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Johannes Weiner <hannes@cmpxchg.org>
cc: Vlastimil Babka <vbabka@suse.cz>, Leon Romanovsky <leon@leon.nu>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Dirty pages underflow on 3.14.23
Message-ID: <alpine.LRH.2.02.1501051744020.5119@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I would like to report a memory management bug where the dirty pages count 
underflowed.

It happened after some time that the Dirty pages count underflowed, as can 
be seen in /proc/meminfo. The underflow condition was persistent, 
/proc/meminfo was showing the big value even when the system was 
completely idle. The counter never returned to zero.

The system didn't crash, but it became very slow - because of the big 
value in the "Dirty" field, lazy writing was not working anymore, any 
process that created a dirty page triggered immediate writeback, which 
slowed down the system very much. The only fix was to reboot the machine.

The kernel version where this happened is 3.14.23. The kernel is compiled 
without SMP and with peemption. The system is single-core 32-bit x86.

The bug probably happened during git pull or apt-get update, though one 
can't be sure that these commands caused it.

I see that 3.14.24 containes some fix for underflow (commit 
6619741f17f541113a02c30f22a9ca22e32c9546, upstream commit 
abe5f972912d086c080be4bde67750630b6fb38b), but it doesn't seem that that 
commit fixes this condition. If you have a commit that could fix this, say 
it.

Mikulas


MemTotal:         253504 kB
MemFree:            6128 kB
MemAvailable:      54956 kB
Buffers:            1376 kB
Cached:            45284 kB
SwapCached:        40432 kB
Active:           105596 kB
Inactive:         111672 kB
Active(anon):      82772 kB
Inactive(anon):    88604 kB
Active(file):      22824 kB
Inactive(file):    23068 kB
Unevictable:           4 kB
Mlocked:               4 kB
SwapTotal:       4242896 kB
SwapFree:        4144248 kB
Dirty:          4294944344 kB
Writeback:             8 kB
AnonPages:        167484 kB
Mapped:             7808 kB
Shmem:               768 kB
Slab:              19072 kB
SReclaimable:      10448 kB
SUnreclaim:         8624 kB
KernelStack:        1136 kB
PageTables:         2032 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:     4369648 kB
Committed_AS:     398032 kB
VmallocTotal:     778184 kB
VmallocUsed:       38316 kB
VmallocChunk:     707540 kB
AnonHugePages:         0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       4096 kB
DirectMap4k:       20416 kB
DirectMap4M:      241664 kB
