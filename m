Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab3IJN4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 09:56:42 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:37042 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab3IJN4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 09:56:40 -0400
Date: Tue, 10 Sep 2013 15:56:36 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 0/7] preempt_count rework -v2
Message-ID: <20130910135636.GA8268@gmail.com>
References: <20130910130811.507933095@infradead.org>
 <20130910135152.GD7537@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910135152.GD7537@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> So what we do in kick_process() is:
> 
>         preempt_disable();
>         cpu = task_cpu(p);
>         if ((cpu != smp_processor_id()) && task_curr(p))
>                 smp_send_reschedule(cpu);
>         preempt_enable();
> 
> The preempt_disable() looks sweet:
> 
> >   ffffffff8106f3f1:       65 ff 04 25 e0 b7 00    incl   %gs:0xb7e0
> >   ffffffff8106f3f8:       00 
> 
> and the '*' you marked is the preempt_enable() portion, which, with your 
> new code, looks like this:
> 
>  #define preempt_check_resched() \
>  do { \
>         if (unlikely(!*preempt_count_ptr())) \
>                 preempt_schedule(); \
>  } while (0)
> 
> Which GCC translates to:
> 
> > * ffffffff8106f42a:       65 ff 0c 25 e0 b7 00    decl   %gs:0xb7e0
> >   ffffffff8106f431:       00 
> > * ffffffff8106f432:       0f 94 c0                sete   %al
> > * ffffffff8106f435:       84 c0                   test   %al,%al
> > * ffffffff8106f437:       75 02                   jne    ffffffff8106f43b <kick_process+0x4b>

Correction, so this comes from the new x86-specific optimization:

+static __always_inline bool __preempt_count_dec_and_test(void)
+{
+       unsigned char c;
+
+       asm ("decl " __percpu_arg(0) "; sete %1"
+                       : "+m" (__preempt_count), "=qm" (c));
+
+       return c != 0;
+}

And that's where the sete and test originates from.

Couldn't it be improved by merging the preempt_schedule() call into a new 
primitive, keeping the call in the regular flow, or using section tricks 
to move it out of line? The scheduling case is a slowpath in most cases.

Thanks,

	Ingo
