Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbaFKUlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 16:41:35 -0400
Received: from smtp26.sms.unimo.it ([155.185.44.26]:57213 "EHLO
	smtp26.sms.unimo.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaFKUjs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 16:39:48 -0400
Subject: Re: BFQ speed tests [was Re: [PATCH RFC - TAKE TWO - 00/12] New version of the BFQ I/O Scheduler]
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=windows-1252
From: Paolo Valente <paolo.valente@unimore.it>
In-Reply-To: <20140604100358.GA4799@amd.pavel.ucw.cz>
Date: Wed, 11 Jun 2014 22:39:31 +0200
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Li Zefan <lizefan@huawei.com>, Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <DE2B8BBD-EFC6-46C7-8B0E-DC2CBCBDBC6A@unimore.it>
References: <20140528221929.GG1419@htj.dyndns.org> <1401354343-5527-1-git-send-email-paolo.valente@unimore.it> <20140530160712.GG24871@htj.dyndns.org> <464F6CBE-A63E-46EF-A90D-BF8450430444@unimore.it> <20140530232804.GA5057@htj.dyndns.org> <20140602111432.GA3737@amd.pavel.ucw.cz> <20140602130226.GA14654@amd.pavel.ucw.cz> <FCFE0106-A4DD-4DEF-AAAE-040F3823A447@unimore.it> <20140604100358.GA4799@amd.pavel.ucw.cz>
To: Pavel Machek <pavel@ucw.cz>
X-Mailer: Apple Mail (2.1878.2)
UNIMORE-X-SA-Score: -2.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Il giorno 04/giu/2014, alle ore 12:03, Pavel Machek <pavel@ucw.cz> ha scritto:

> Hi!
> 
>> Should this attempt be useless as well, I will, if you do not mind, try by asking you more details about your system and reproducing your configuration as much as I can.
>> 
> 
> Try making BFQ the default scheduler. That seems to break it for me,
> when selected at runtime, it looks stable.

As I have already written to you privately, we have fixed the bug. It was a
clerical error, made while turning the original patchset into the series of
patches we have then submitted.

The new patchset is available here:
http://algogroup.unimore.it/people/paolo/disk_sched/debugging-patches/3.16.0-rc0-v7rc5.tgz

I’m not submitting this new, fixed patchset by email, because, before doing that,
we want to apply all the changes recommended by Tejun, and try to turn the
new patchset into a 'transformer' of cfq into bfq (of course, should it be better
to proceed in a different way also for this intermediate new version of bfq,
we are willing to).

> 
> Anyway, here are some speed tests. Background load:
> […]
> root@duo:/data/tmp# echo cfq > /sys/block/sda/queue/scheduler 
> root@duo:/data/tmp# echo 3 > /proc/sys/vm/drop_caches
> root@duo:/data/tmp# cat /dev/zero > delme; cat /dev/zero > delme;cat
> /dev/zero > delme;cat /dev/zero > delme;cat /dev/zero > delme;cat
> /dev/zero > delme
> 
> (Machine was running out of disk space.)
> 
> (I alternate between cfq and bfq).
> 
> Benchmark. I chose git describe because it is part of kernel build
> sometimes .. and I actually wait for that.
> […]

We have solved also this regression, related to both the queue-merge
mechanism and the heuristic for providing a low-latency to soft real-time
applications. The new patchset contains also this fix. We have repeated
your tests (and other similar tests) with this fixed version of bfq.
These are now our results with your tests.

# Test with background writes

[root@bfq-testbed data]# echo cfq > /sys/block/sda/queue/scheduler
[root@bfq-testbed data]# echo 3 > /proc/sys/vm/drop_caches
[root@bfq-testbed data]# cat /dev/zero > delme; cat /dev/zero > delme;cat
/dev/zero > delme;cat /dev/zero > delme;cat /dev/zero > delme;cat
/dev/zero > delme

[root@bfq-testbed linux-lkml]# time git describe
v3.15-rc8-78-gd531c25

# BFQ
0.24user 0.14system 0:07.42elapsed 5%CPU
# CFQ
0.24user 0.16system 0:08.39elapsed 4%CPU
# BFQ
0.25user 0.15system 0:08.45elapsed 4%CPU
# CFQ
0.26user 0.15system 0:09.11elapsed 4%CPU

# Results without background workload

# BFQ
0.23user 0.12system 0:07.23elapsed 4%CPU
# CFQ
0.25user 0.13system 0:07.36elapsed 5%CPU
# BFQ
0.23user 0.14system 0:07.24elapsed 5%CPU
# CFQ
0.22user 0.14system 0:07.36elapsed 5%CPU

Any feedback on these and other tests is more than welcome.

Thanks,
Paolo

