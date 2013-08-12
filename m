Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377Ab3HLRfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:35:51 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:54406 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3HLRft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:35:49 -0400
MIME-Version: 1.0
In-Reply-To: <20130812115113.GE27162@twins.programming.kicks-ass.net>
References: <20130812115113.GE27162@twins.programming.kicks-ass.net>
Date: Mon, 12 Aug 2013 10:35:48 -0700
X-Google-Sender-Auth: 6OFwnDCFoS-h7xDU73dcXsW4kOY
Message-ID: <CA+55aFznj9WqGa_Qa0B4=5iTio2br54uJG7xkm6otN2sG2P=8w@mail.gmail.com>
Subject: Re: [RFC] per-cpu preempt_count
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <bitbucket@online.de>, Peter Anvin <hpa@zytor.com>,
        Andi Kleen <ak@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 4:51 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> The below boots to wanting to mount a root filesystem with
> CONFIG_PREEMPT=y using kvm -smp 4.

But doesn't work in general? Or you just never tested?

I think that "thread_info->preempt_count" variable would need to be
renamed to "saved_preempt_count" or similar to make sure we catch any
users. But the patch certainly looks simple otherwise.

I'm pretty sure I had a discussion about this with Paul McKenney some
time ago (because the RCU readlock is the most noticeable user of the
preempt count - the others tend to be hidden inside the out-of-line
spinlock functions etc), and I thought he had tried this and had some
problems. Maybe we've fixed things since, or maybe he missed some
case..

But if the patch really is this simple, then we should just do it. Of
course, we should double-check that the percpu preempt count is in a
cacheline that is already accessed (preferably already dirtied) by the
context switching code.  And I think this should be an
architecture-specific thing, because using a percpu variable might be
good on some architectures but not others. So I get the feeling that
it should be in the x86 __switch_to(), rather than in the generic
code. I think it would fit very well with the per-cpu "old_rsp" and
"current_task" updates that we already do.

> Adding TIF_NEED_RESCHED into the preempt count would allow a single test
> in preempt_check_resched() instead of still needing the TI. Removing
> PREEMPT_ACTIVE from preempt count should allow us to get rid of
> ti::preempt_count altogether.
>
> The only problem with TIF_NEED_RESCHED is that its cross-cpu which would
> make the entire thing atomic which would suck donkey balls so maybe we
> need two separate per-cpu variables?

Agreed. Making it atomic would suck, and cancel all advantages of the
better code generation to access it. Good point.

And yeah, it could be two variables in the same cacheline or something.

                 Linus
