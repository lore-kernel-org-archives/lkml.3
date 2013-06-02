Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab3FBFx1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 01:53:27 -0400
Received: from mout.gmx.net ([212.227.17.21]:49733 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221Ab3FBFxV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 01:53:21 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19M6ZIKhUJMLZlQx5Yz01Kkz/t6MDp6W0/5LO7vuy
	g51GaFC9bTYCIV
Message-ID: <1370152396.5874.41.camel@marge.simpson.net>
Subject: Re: sem_otime trashing
From: Mike Galbraith <efault@gmx.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Rik van Riel <riel@redhat.com>, Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 02 Jun 2013 07:53:16 +0200
In-Reply-To: <51AA455B.4060807@colorfullife.com>
References: <51AA455B.4060807@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-06-01 at 21:02 +0200, Manfred Spraul wrote: 
> Hi Rik,
> 
> I finally managed to get EFI boot, i.e. I'm now able to test on my i3 
> (2core+HT).
> 
> With semscale (i.e.: just overhead, perform semop=0 operations), the 
> scalability from 1 to 2 cores is good, but not linear:
> # semscale 10 | grep "interleave 2"
> > Cpus 1, interleave 2 delay 0: 35502103 in 10 secs
> > Cpus 2, interleave 2 delay 0: 53990954 in 10 secs
> ---
>   +53% when adding the 2nd core
> (interleave 2 to force to use different cores)
> 
> Did you consider moving sem_otime into the individual semaphores?
> I did that (gross patch attached), and the performance is significantly 
> better:
> 
> # semscale 10 | grep "interleave 2"
> Cpus 1, interleave 2 delay 0: 35585634 in 10 secs
> Cpus 2, interleave 2 delay 0: 70410230 in 10 secs
>       ---
>      +99% scalability when adding the 2nd core
> 
> Unfortunately I won't be able to read my mails next week, but the effect 
> was too significant not to share it immediately.

64 core box.

Previous numbers: 
vogelweide:/abuild/mike/:[0]# uname -r
3.8.13-rt9-rtm
vogelweide:/abuild/mike/:[0]# ./semop-multi 256 64
cpus 64, threads: 256, semaphores: 64, test duration: 30 secs
total operations: 33553800, ops/sec 1118460

New numbers:
vogelweide:/abuild/mike/:[0]# !./semop-multi
./semop-multi 256 64
cpus 64, threads: 256, semaphores: 64, test duration: 30 secs
total operations: 129474934, ops/sec 4315831

But, box rcu stalled on me.  It's looking like the scalability patches
are a bit racy rcu wise in an -rt kernel (oh dear).  So, build as plain
old PREEMPT again, eliminate -rt funnies.



Previous numbers: 
vogelweide:/abuild/mike/:[0]# ./semop-multi 256 64
cpus 64, threads: 256, semaphores: 64, test duration: 30 secs
total operations: 22053968, ops/sec 735132

vogelweide:/abuild/mike/:[0]# ./osim 64 256 1000000 0 0
osim <sems> <tasks> <loops> <busy-in> <busy-out>
osim: using a semaphore array with 64 semaphores.
osim: using 256 tasks.
osim: each thread loops 3907 times
osim: each thread busyloops 0 loops outside and 0 loops inside.
total execution time: 1.858765 seconds for 1000192 loops
per loop execution time: 1.858 usec

New numbers:
vogelweide:/abuild/mike/:[0]# !./semop
./semop-multi 256 64
cpus 64, threads: 256, semaphores: 64, test duration: 30 secs
total operations: 45521478, ops/sec 1517382
vogelweide:/abuild/mike/:[0]# !./osim
./osim 64 256 1000000 0 0
osim <sems> <tasks> <loops> <busy-in> <busy-out>
osim: using a semaphore array with 64 semaphores.
osim: using 256 tasks.
osim: each thread loops 3907 times
osim: each thread busyloops 0 loops outside and 0 loops inside.
total execution time: 0.350682 seconds for 1000192 loops
per loop execution time: 0.350 usec

(1.8->0.3?.. box, you ain't a race horse, you're a plow horse)

vogelweide:/abuild/mike/:[0]# ./osim 64 256 1000000 0 0
osim <sems> <tasks> <loops> <busy-in> <busy-out>
osim: using a semaphore array with 64 semaphores.
osim: using 256 tasks.
osim: each thread loops 3907 times
osim: each thread busyloops 0 loops outside and 0 loops inside.
total execution time: 0.276405 seconds for 1000192 loops
per loop execution time: 0.276 usec
vogelweide:/abuild/mike/:[0]# ./osim 64 256 1000000 0 0
osim <sems> <tasks> <loops> <busy-in> <busy-out>
osim: using a semaphore array with 64 semaphores.
osim: using 256 tasks.
osim: each thread loops 3907 times
osim: each thread busyloops 0 loops outside and 0 loops inside.
total execution time: 0.370041 seconds for 1000192 loops
per loop execution time: 0.369 usec
vogelweide:/abuild/mike/:[0]# ./osim 64 256 1000000 0 0
osim <sems> <tasks> <loops> <busy-in> <busy-out>
osim: using a semaphore array with 64 semaphores.
osim: using 256 tasks.
osim: each thread loops 3907 times
osim: each thread busyloops 0 loops outside and 0 loops inside.
total execution time: 0.502396 seconds for 1000192 loops
per loop execution time: 0.502 usec

(runtime)

vogelweide:/abuild/mike/:[0]# ./osim 64 256 10000000 0 0
osim <sems> <tasks> <loops> <busy-in> <busy-out>
osim: using a semaphore array with 64 semaphores.
osim: using 256 tasks.
osim: each thread loops 39063 times
osim: each thread busyloops 0 loops outside and 0 loops inside.
total execution time: 3.354423 seconds for 10000128 loops
per loop execution time: 0.335 usec
vogelweide:/abuild/mike/:[0]# ./osim 64 256 100000000 0 0
osim <sems> <tasks> <loops> <busy-in> <busy-out>
osim: using a semaphore array with 64 semaphores.
osim: using 256 tasks.
osim: each thread loops 390625 times
osim: each thread busyloops 0 loops outside and 0 loops inside.
total execution time: 41.180479 seconds for 100000000 loops
per loop execution time: 0.411 usec

Box likes your idea.

