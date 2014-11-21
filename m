Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaKUUBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 15:01:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbaKUUBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 15:01:39 -0500
Date: Fri, 21 Nov 2014 21:01:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aaron Tomlin <atomlin@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/3] exit: reparent: avoid find_new_reaper() if no
	children
Message-ID: <20141121200138.GA21656@redhat.com>
References: <20141120183400.GA9622@redhat.com> <20141120183423.GA10270@redhat.com> <20141120143722.af15074e6922108962e84649@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120143722.af15074e6922108962e84649@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20, Andrew Morton wrote:
>
> On Thu, 20 Nov 2014 19:34:23 +0100 Oleg Nesterov <oleg@redhat.com> wrote:
>
> > $ time ./test 16 16536 shows:
> >
> > 		real		user		sys
> > 	-	5m37.628s	0m4.437s	8m5.560s
> > 	+	0m50.032s	0m7.130s	1m4.927s
>
> Is that the best you can do?

Unfortunately these changes do not even try to solve the main problem,
tasklist_lock doesn't scale simply because it is global. These changes
make sense (I hope) anyway, even if/when we redesign the locking. But
so far I do not have a good plan.

> (I assume the increase in user time was a glitch?)

To be honest, I didn't even notice this change. I repeated the testing
before/after this patch and (to my surprize) the "user" numbers are more
or less stable, and /usr/bin/time reports the increase.

1. First of all: this is impossible ;)

   Note that this test-case uses SIGTRAP to trigger the coredumping.
   This means that exit_notify() can only be called when all threads
   are already in kernel mode, the coredumping thread sleeps until
   they all are parked in exit_mm(). Until then this patch has no
   effect.

2. With this patch applied, I added mdelay(2) into forget_original_parent(),
   right after find_child_reaper(). And yes, this changes the numbers too:

   		real		user		sys
   		10m1.225s	0m5.443s	17m25.797s

   note that "user time" goes down.

3. So I think that this just reminds that utime/stime accounting isn't
   precise. sum_exec_runtime is accurate and thus we can more or less
   trust utime + stime, but utime/stime is random. Plus scale_stime()
   doesn't look very accurate too.

4. In this particular case the accounting is even more impresize, this
   test-case spends a lot of time in kernel mode with irqs disabled and
   this "freezes" task->stime.

5. That said, I still can't really understand why "user" grows. If I
   understand the calculations in cputime_adjust() correctly (probably
   I don't), it should not.

In short, I am a bit confused but I still don't think that this increase
is real.

Oleg.

