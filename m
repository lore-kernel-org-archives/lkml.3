Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758315AbaELUpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 16:45:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:56754 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaELUpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 16:45:24 -0400
Message-Id: <20140512190438.314125476@linutronix.de>
User-Agent: quilt/0.60-1
Date: Mon, 12 May 2014 20:45:32 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Darren Hart <darren@dvhart.com>,
        Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Clark Williams <williams@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Roland McGrath <roland@hack.frob.com>,
        Carlos ODonell <carlos@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [patch 0/3] futex/rtmutex: Fix issues exposed by trinity
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave reported recently that the trinity syscall fuzzer triggers a
warning in the rtmutex code via the futex syscall.

It took me quite a while to understand the issue, until I was able to
write a minimalistic reproducer.

The first two patches address the issues and the third one is adding
an unrelated sanity check to prevent user space from assigning PI
futexes to kernel threads.

I ran it through my usual tests (except of one, see below), Darrens
futex tester and it holds up against a 400 threads trinity whacking
for well above 12hrs now.

Staring three days into futex.c/rtmutex.c and a few GB of traces
definitly brings one in a lousy mood. But I discovered two things
which made me outright grumpy:

1) I wanted to add a test case for the rtmutex deadlock detection
   issue and found out that the in kernel rt-mutex tester which I
   wrote for the purpose of validating rt-mutex corner cases without
   the futex maze involved. And it actually catches issues which are
   not covered by lockdep.

   That tester got broken by a performance improvement patch 3 years
   ago: commit 8161239a8 (rtmutex: Simplify PI algorithm and make
   highest prio task get lock)

   The changelog of that commit sayed:

       need updated after this patch is accepted
           1) Document/*
	   2) the testcase scripts/rt-tester/t4-l2-pi-deboost.tst
   
   The changelog is correct in that point: It still needs to be
   updated.

   But it should not have been merged at all before this got updated
   and fixed!

   So I'm not blaming Lai for this, though he should have followed up
   as well. I'm blaming the maintainer who merged that code.
 
   Steven, I told you more than once, that your damned performance and
   feature mania is completely unacceptable.

   When the patch was posted, you were reviewing it. When I wanted to
   test it, it did not apply and you told me you'll fix it and pick it
   up. Sure you made it apply and you sticked it into a git tree and
   let Ingo pull it.

   I didn't pay much attention as I was happy with the idea in
   general. I trusted your review and judgement. My problem.

   Why on earth did you merge that patch even if the changelog mentions
   that Documentation was left stale and the tester broken?

   This is beyond sloppy and outright stupid.

   Get this fixed now!

   And those fixes are not going to be merged without my Reviewed-by.

   I'm not going to let your multi-reader patches anywhere near RT,
   unless this Documentation and tester issue is resolved.

   After that I'm going through them with a fine comb, as I really lost
   the last modicom of hope, that you can do something without leaving
   trainwrecks left and right.


2) glibc fun

   While writing an isolated test case for the trinity wreckage, I
   found out that glibc has an interesting misfeature:

   strace tells me:

   futex(0x600e00, FUTEX_LOCK_PI_PRIVATE, 1) = -1 EINVAL (Invalid argument)

   but the return value of pthread_mutex_lock() is 0

   Yay, for another master piece of trainwreck engineering!

   I checked the glibc source and of course neither the lock nor the unlock path
   gets any error code from the syscall propagated.

   The handling of -EDEADLOCK is even more impressive. Instead of
   propagating it to the caller something in the guts of glibc calls pause().

     futex(0x601300, FUTEX_LOCK_PI_PRIVATE, 1) = -1 EDEADLK (Resource deadlock avoided)
     pause(

   So any kind of futex wreckage which is not detectable by glibc
   itself ends up in a disaster one way or the other. How is Joe user
   of this stuff who reads the manpages supposed to find out that the
   kernel detected an inconsistent user space variable?

   If someone of the glibc folks can be bothered to look after that,
   I'm happy to provide the simple test cases, but I'm sure that
   looking at the code which simply ignores or pauses on kernel error
   return values is enough to figure out why its broken.

   This does not only apply to the PI version, the bog standard
   futexes have error returns from the kernel as well, which are
   handled in the same absurd way.

Yours grumpy

      tglx


