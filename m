Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894Ab3FALEd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 07:04:33 -0400
Received: from mout.gmx.net ([212.227.15.18]:64066 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756231Ab3FALEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 07:04:25 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+HVA49wkuHuArr1F96XNh2EPbuotOyRwCo+p/I2r
	7/2YUM0imzk3EQ
Message-ID: <1370084658.7268.19.camel@marge.simpson.net>
Subject: Re: [PATCH 2/4] ipc/sem: seperate wait-for-zero and alter tasks
 into seperate queues
From: Mike Galbraith <efault@gmx.de>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 01 Jun 2013 13:04:18 +0200
In-Reply-To: <1370080999.7268.5.camel@marge.simpson.net>
References: <1369559335-13491-1-git-send-email-manfred@colorfullife.com>
	 <1369559335-13491-3-git-send-email-manfred@colorfullife.com>
	 <51A39E71.70900@redhat.com> <51A9BCDA.9040006@colorfullife.com>
	 <1370080999.7268.5.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-06-01 at 12:03 +0200, Mike Galbraith wrote:

> -rtm is with our patches added, -rt is backport without.

Now same tree, turn off PREEMPT_FULL so the kernel is plain old PREEMPT.
Again, -rt is without your patches, -rtm with, followed by backing out
all ipc backports to end up at pre scalability series to show what the
set gains on this box.

vogelweide:/abuild/mike/:[0]# uname -r
3.8.13-rt9-rt
vogelweide:/abuild/mike/:[0]# ./semop-multi 256 64
cpus 64, threads: 256, semaphores: 64, test duration: 30 secs
total operations: 19102372, ops/sec 636745
vogelweide:/abuild/mike/:[0]# ./semop-multi 256 64
cpus 64, threads: 256, semaphores: 64, test duration: 30 secs
total operations: 19877668, ops/sec 662588
vogelweide:/abuild/mike/:[0]# ./semop-multi 256 64
cpus 64, threads: 256, semaphores: 64, test duration: 30 secs
total operations: 19610632, ops/sec 653687
vogelweide:/abuild/mike/:[0]# 
vogelweide:/abuild/mike/:[0]# ./osim 64 256 1000000 0 0
osim <sems> <tasks> <loops> <busy-in> <busy-out>
osim: using a semaphore array with 64 semaphores.
osim: using 256 tasks.
osim: each thread loops 3907 times
osim: each thread busyloops 0 loops outside and 0 loops inside.
total execution time: 1.893317 seconds for 1000192 loops
per loop execution time: 1.892 usec
vogelweide:/abuild/mike/:[0]# ./osim 64 256 1000000 0 0
osim <sems> <tasks> <loops> <busy-in> <busy-out>
osim: using a semaphore array with 64 semaphores.
osim: using 256 tasks.
osim: each thread loops 3907 times
osim: each thread busyloops 0 loops outside and 0 loops inside.
total execution time: 1.976055 seconds for 1000192 loops
per loop execution time: 1.975 usec
vogelweide:/abuild/mike/:[0]# ./osim 64 256 1000000 0 0
osim <sems> <tasks> <loops> <busy-in> <busy-out>
osim: using a semaphore array with 64 semaphores.
osim: using 256 tasks.
osim: each thread loops 3907 times
osim: each thread busyloops 0 loops outside and 0 loops inside.
total execution time: 1.651162 seconds for 1000192 loops
per loop execution time: 1.650 usec


vogelweide:/abuild/mike/:[0]# uname -r
3.8.13-rt9-rtm
vogelweide:/abuild/mike/:[0]# ./semop-multi 256 64
cpus 64, threads: 256, semaphores: 64, test duration: 30 secs
total operations: 22053968, ops/sec 735132
vogelweide:/abuild/mike/:[0]# ./semop-multi 256 64
cpus 64, threads: 256, semaphores: 64, test duration: 30 secs
total operations: 21295310, ops/sec 709843
vogelweide:/abuild/mike/:[0]# ./semop-multi 256 64
cpus 64, threads: 256, semaphores: 64, test duration: 30 secs
total operations: 21458002, ops/sec 715266
vogelweide:/abuild/mike/:[0]# 
vogelweide:/abuild/mike/:[0]# ./osim 64 256 1000000 0 0
osim <sems> <tasks> <loops> <busy-in> <busy-out>
osim: using a semaphore array with 64 semaphores.
osim: using 256 tasks.
osim: each thread loops 3907 times
osim: each thread busyloops 0 loops outside and 0 loops inside.
total execution time: 1.858765 seconds for 1000192 loops
per loop execution time: 1.858 usec
vogelweide:/abuild/mike/:[0]# ./osim 64 256 1000000 0 0
osim <sems> <tasks> <loops> <busy-in> <busy-out>
osim: using a semaphore array with 64 semaphores.
osim: using 256 tasks.
osim: each thread loops 3907 times
osim: each thread busyloops 0 loops outside and 0 loops inside.
total execution time: 1.806943 seconds for 1000192 loops
per loop execution time: 1.806 usec
vogelweide:/abuild/mike/:[0]# ./osim 64 256 1000000 0 0
osim <sems> <tasks> <loops> <busy-in> <busy-out>
osim: using a semaphore array with 64 semaphores.
osim: using 256 tasks.
osim: each thread loops 3907 times
osim: each thread busyloops 0 loops outside and 0 loops inside.
total execution time: 1.854004 seconds for 1000192 loops
per loop execution time: 1.853 usec

All ipc patches backed out.

vogelweide:/abuild/mike/:[0]# ./semop-multi 256 64
cpus 64, threads: 256, semaphores: 64, test duration: 30 secs
total operations: 8885026, ops/sec 296167
vogelweide:/abuild/mike/:[0]# ./semop-multi 256 64
cpus 64, threads: 256, semaphores: 64, test duration: 30 secs
total operations: 8791676, ops/sec 293055
vogelweide:/abuild/mike/:[0]# ./semop-multi 256 64
cpus 64, threads: 256, semaphores: 64, test duration: 30 secs
total operations: 8301092, ops/sec 276703
vogelweide:/abuild/mike/:[0]# 
vogelweide:/abuild/mike/:[0]# ./osim 64 256 1000000 0 0
osim <sems> <tasks> <loops> <busy-in> <busy-out>
osim: using a semaphore array with 64 semaphores.
osim: using 256 tasks.
osim: each thread loops 3907 times
osim: each thread busyloops 0 loops outside and 0 loops inside.
total execution time: 10.750488 seconds for 1000192 loops
per loop execution time: 10.748 usec
vogelweide:/abuild/mike/:[0]# ./osim 64 256 1000000 0 0
osim <sems> <tasks> <loops> <busy-in> <busy-out>
osim: using a semaphore array with 64 semaphores.
osim: using 256 tasks.
osim: each thread loops 3907 times
osim: each thread busyloops 0 loops outside and 0 loops inside.
total execution time: 10.737264 seconds for 1000192 loops
per loop execution time: 10.735 usec
vogelweide:/abuild/mike/:[0]# ./osim 64 256 1000000 0 0
osim <sems> <tasks> <loops> <busy-in> <busy-out>
osim: using a semaphore array with 64 semaphores.
osim: using 256 tasks.
osim: each thread loops 3907 times
osim: each thread busyloops 0 loops outside and 0 loops inside.
total execution time: 10.756395 seconds for 1000192 loops
per loop execution time: 10.754 usec



