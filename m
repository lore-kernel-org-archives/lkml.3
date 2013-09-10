Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab3IJPOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 11:14:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49616 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab3IJPOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 11:14:30 -0400
Date: Tue, 10 Sep 2013 17:14:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 0/7] preempt_count rework -v2
Message-ID: <20130910151420.GG31370@twins.programming.kicks-ass.net>
References: <20130910130811.507933095@infradead.org>
 <20130910135152.GD7537@gmail.com>
 <20130910135636.GA8268@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130910135636.GA8268@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 03:56:36PM +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@kernel.org> wrote:

> > > * ffffffff8106f42a:       65 ff 0c 25 e0 b7 00    decl   %gs:0xb7e0
> > >   ffffffff8106f431:       00 
> > > * ffffffff8106f432:       0f 94 c0                sete   %al
> > > * ffffffff8106f435:       84 c0                   test   %al,%al
> > > * ffffffff8106f437:       75 02                   jne    ffffffff8106f43b <kick_process+0x4b>
> 
> Correction, so this comes from the new x86-specific optimization:
> 
> +static __always_inline bool __preempt_count_dec_and_test(void)
> +{
> +       unsigned char c;
> +
> +       asm ("decl " __percpu_arg(0) "; sete %1"
> +                       : "+m" (__preempt_count), "=qm" (c));
> +
> +       return c != 0;
> +}
> 
> And that's where the sete and test originates from.

Correct, used in:

#define preempt_enable() \
do { \
        barrier(); \
        if (unlikely(preempt_count_dec_and_test())) \
                __preempt_schedule(); \
} while (0)

> Couldn't it be improved by merging the preempt_schedule() call into a new 
> primitive, keeping the call in the regular flow, or using section tricks 
> to move it out of line? The scheduling case is a slowpath in most cases.

Not if we want to keep using the GCC unlikely thing afaik. That said,
all this inline asm stuff is isn't my strong point, so maybe someone
else has a good idea.

But I really think fixing GCC would be good, as we have the same pattern
with all *_and_test() functions.

