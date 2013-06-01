Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328Ab3FAKDb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 06:03:31 -0400
Received: from mout.gmx.net ([212.227.15.18]:62262 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759300Ab3FAKD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 06:03:26 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19fA9ZmuxxfM/lWgb70THfHIYGNAo94LhuwopAKIy
	+AXPQvai4l11E4
Message-ID: <1370080999.7268.5.camel@marge.simpson.net>
Subject: Re: [PATCH 2/4] ipc/sem: seperate wait-for-zero and alter tasks
 into seperate queues
From: Mike Galbraith <efault@gmx.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 01 Jun 2013 12:03:19 +0200
In-Reply-To: <51A9BCDA.9040006@colorfullife.com>
References: <1369559335-13491-1-git-send-email-manfred@colorfullife.com>
	 <1369559335-13491-3-git-send-email-manfred@colorfullife.com>
	 <51A39E71.70900@redhat.com> <51A9BCDA.9040006@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-06-01 at 11:20 +0200, Manfred Spraul wrote: 
> Hi Rik,
> 
> On 05/27/2013 07:57 PM, Rik van Riel wrote:
> > On 05/26/2013 05:08 AM, Manfred Spraul wrote:
> >> Introduce seperate queues for operations that do not modify the
> >> semaphore values.
> >> Advantages:
> >> - Simpler logic in check_restart().
> >> - Faster update_queue(): Right now, all wait-for-zero operations
> >>    are always tested, even if the semaphore value is not 0.
> >> - wait-for-zero gets again priority, as in linux <=3.0.9
> >
> > Whether this complexity is wanted is not for
> > me to decide, as I am not the ipc/sem.c
> > maintainer. I'll leave that up to Andrew and Linus.
> >
> We can have only one: Either more logic or unoptimized loops.
> But I don't think that the complexity increases that much, e.g. some 
> parts (e.g. check_restart()) get much simpler.
> 
> But:
> Mike Galbraith ran 3.10-rc3 with and without my changes on a 4-socket 
> 64-core system, and for me the results appears to be quite slow:
> - semop-multi 256 64: around 600.000 ops/sec, both with and without my 
> additional patches [difference around 1%]
>      That is slower than my 1.4 GHz i3 with 3.9 - I get around 1.000.000 
> ops/sec
>      Is that expected?
>      My only idea would be trashing from writing sma->sem_otime.
> 
> - osim [i.e.: with reschedules] is much slower: around 21 us per schedule.
>      Perhaps the scheduler didn't pair the threads optimally: intra-cpu 
> reschedules
>      take around 2 us on my i3, inter-cpu reschedules around 16 us.

I got -rt backports working, and it's faster at semop-multi, but one
hell of a lot slower at osim.  The goto again loop in sem_lock() is a
livelock in -rt, I had to do that differently.

-rtm is with our patches added, -rt is backport without.

vogelweide:/abuild/mike/:[0]# uname -r
3.8.13-rt9-rtm
vogelweide:/abuild/mike/:[0]# ./semop-multi 256 64
cpus 64, threads: 256, semaphores: 64, test duration: 30 secs
total operations: 33553800, ops/sec 1118460
vogelweide:/abuild/mike/:[0]# ./semop-multi 256 64
cpus 64, threads: 256, semaphores: 64, test duration: 30 secs
total operations: 33344598, ops/sec 1111486
vogelweide:/abuild/mike/:[0]# ./semop-multi 256 64
cpus 64, threads: 256, semaphores: 64, test duration: 30 secs
total operations: 33655348, ops/sec 1121844
vogelweide:/abuild/mike/:[0]# 
vogelweide:/abuild/mike/:[130]# ./osim 64 256 1000000 0 0
osim <sems> <tasks> <loops> <busy-in> <busy-out>
osim: using a semaphore array with 64 semaphores.
osim: using 256 tasks.
osim: each thread loops 3907 times
osim: each thread busyloops 0 loops outside and 0 loops inside.
total execution time: 12.296215 seconds for 1000192 loops
per loop execution time: 12.293 usec
vogelweide:/abuild/mike/:[0]# ./osim 64 256 1000000 0 0
osim <sems> <tasks> <loops> <busy-in> <busy-out>
osim: using a semaphore array with 64 semaphores.
osim: using 256 tasks.
osim: each thread loops 3907 times
osim: each thread busyloops 0 loops outside and 0 loops inside.
total execution time: 11.613663 seconds for 1000192 loops
per loop execution time: 11.611 usec
vogelweide:/abuild/mike/:[0]# ./osim 64 256 1000000 0 0
osim <sems> <tasks> <loops> <busy-in> <busy-out>
osim: using a semaphore array with 64 semaphores.
osim: using 256 tasks.
osim: each thread loops 3907 times
osim: each thread busyloops 0 loops outside and 0 loops inside.
total execution time: 13.755537 seconds for 1000192 loops
per loop execution time: 13.752 usec

vogelweide:/abuild/mike/:[0]# uname -r
3.8.13-rt9-rt
vogelweide:/abuild/mike/:[0]# ./semop-multi 256 64
cpus 64, threads: 256, semaphores: 64, test duration: 30 secs
total operations: 37343656, ops/sec 1244788
vogelweide:/abuild/mike/:[0]# ./semop-multi 256 64
cpus 64, threads: 256, semaphores: 64, test duration: 30 secs
total operations: 37226496, ops/sec 1240883
vogelweide:/abuild/mike/:[0]# ./semop-multi 256 64
cpus 64, threads: 256, semaphores: 64, test duration: 30 secs
total operations: 36730816, ops/sec 1224360
vogelweide:/abuild/mike/:[0]# 
vogelweide:/abuild/mike/:[0]# ./osim 64 256 1000000 0 0
osim <sems> <tasks> <loops> <busy-in> <busy-out>
osim: using a semaphore array with 64 semaphores.
osim: using 256 tasks.
osim: each thread loops 3907 times
osim: each thread busyloops 0 loops outside and 0 loops inside.
total execution time: 12.676632 seconds for 1000192 loops
per loop execution time: 12.674 usec
vogelweide:/abuild/mike/:[0]# ./osim 64 256 1000000 0 0
osim <sems> <tasks> <loops> <busy-in> <busy-out>
osim: using a semaphore array with 64 semaphores.
osim: using 256 tasks.
osim: each thread loops 3907 times
osim: each thread busyloops 0 loops outside and 0 loops inside.
total execution time: 14.166756 seconds for 1000192 loops
per loop execution time: 14.164 usec
vogelweide:/abuild/mike/:[0]# ./osim 64 256 1000000 0 0
osim <sems> <tasks> <loops> <busy-in> <busy-out>
osim: using a semaphore array with 64 semaphores.
osim: using 256 tasks.
osim: each thread loops 3907 times
osim: each thread busyloops 0 loops outside and 0 loops inside.
total execution time: 15.116200 seconds for 1000192 loops
per loop execution time: 15.113 use

