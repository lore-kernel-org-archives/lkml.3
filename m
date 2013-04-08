Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab3DHE05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 00:26:57 -0400
Received: from hermes.synopsys.com ([198.182.44.81]:38483 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab3DHE0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 00:26:55 -0400
Message-ID: <51624591.4010303@synopsys.com>
Date: Mon, 8 Apr 2013 09:50:33 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [PATCH] Gaurantee spinlocks implicit barrier for !PREEMPT_COUNT
References: <alpine.LFD.2.02.1304031433350.21884@ionos> <1364998282-21437-1-git-send-email-vgupta@synopsys.com> <20130404152808.GB15261@ab42.lan> <515E54BD.2090300@synopsys.com> <51602459.3040105@synopsys.com> <CA+55aFw=-oJxujka-emxyRcY54MSe3qEjZ6xgzoE-roe3EFk5g@mail.gmail.com>
In-Reply-To: <CA+55aFw=-oJxujka-emxyRcY54MSe3qEjZ6xgzoE-roe3EFk5g@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.39]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 04/06/2013 09:43 PM, Linus Torvalds wrote:
> This is all *COMPLETELY* wrong.
>
> Neither the normal preempt macros, nor the plain spinlocks, should
> protect anything at all against interrupts.
>
> The real protection should come from the  spin_lock_irqsave() in
> lock_timer_base(), not from spinlocks, and not from preemption.
>
> It sounds like ARC is completely buggered, and hasn't made the irq
> disable be a compiler barrier. That's an ARC bug, and it's a big one,
> and can affect a lot more than just the timers.
>
> So the real fix is to add a "memory" clobber to
> arch_local_irq_save/restore() and friends, so that the compiler
> doesn't get to cache memory state from the irq-enabled region into the
> irq-disabled one.
>
> Fix ARC, don't try to blame generic code. You should have asked
> yourself why only ARC saw this bug, when the code apparently works
> fine for everybody else!
>
>                    Linus

Christian had already proposed that change - only I was reluctant to take it - as
local_irq_* is used heavily in a configuration of ARC700 linux where (!SMP) cpu
doesn't support load-locked/store-conditional instructions - hence atomic R-M-W
sequences need those routines. Adding a mem clobber would lead to pathetic
generated code hence the reason it was likely removed by me at some point in time.

Also I'd thought that given that barriers are already present in PREEMPT_COUNT
variant of preempt_* macros we might as well add them to !PREEMPT_COUNT ones.

But thinking about it more - you are right (as you always are) - the situation I
saw with timers code, could very well show up with vanilla local_irq_save/restore
when a piece of code races with itself (specially for our mostly !SMP configs).
Would you be OK if I send the single patch to ARC by email (for 3.9-rc7) or you'd
rather have the pull request.

Thx,
-Vineet
