Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423272Ab3DFQNz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 12:13:55 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:37080 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423244Ab3DFQNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 12:13:54 -0400
MIME-Version: 1.0
In-Reply-To: <51602459.3040105@synopsys.com>
References: <alpine.LFD.2.02.1304031433350.21884@ionos>
	<1364998282-21437-1-git-send-email-vgupta@synopsys.com>
	<20130404152808.GB15261@ab42.lan>
	<515E54BD.2090300@synopsys.com>
	<51602459.3040105@synopsys.com>
Date: Sat, 6 Apr 2013 09:13:53 -0700
X-Google-Sender-Auth: BEiTS2vsumsyBvMcpAR3-zsZvuU
Message-ID: <CA+55aFw=-oJxujka-emxyRcY54MSe3qEjZ6xgzoE-roe3EFk5g@mail.gmail.com>
Subject: Re: [PATCH] [PATCH] Gaurantee spinlocks implicit barrier for !PREEMPT_COUNT
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is all *COMPLETELY* wrong.

Neither the normal preempt macros, nor the plain spinlocks, should
protect anything at all against interrupts.

The real protection should come from the  spin_lock_irqsave() in
lock_timer_base(), not from spinlocks, and not from preemption.

It sounds like ARC is completely buggered, and hasn't made the irq
disable be a compiler barrier. That's an ARC bug, and it's a big one,
and can affect a lot more than just the timers.

So the real fix is to add a "memory" clobber to
arch_local_irq_save/restore() and friends, so that the compiler
doesn't get to cache memory state from the irq-enabled region into the
irq-disabled one.

Fix ARC, don't try to blame generic code. You should have asked
yourself why only ARC saw this bug, when the code apparently works
fine for everybody else!

                   Linus

On Sat, Apr 6, 2013 at 6:34 AM, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
>> On 04/05/2013 10:06 AM, Vineet Gupta wrote:
>> Hi Thomas,
>>
>> Given that we are closing on 3.9 release, and that one/more of these patches fix a
>> real issue for us - can you please consider my earlier patch to fix
>> timer_pending() only for 3.9 [http://www.spinics.net/lists/kernel/msg1508224.html]
>> This will be a localized / low risk change for this late in cycle.
>>
>> For 3.10 - assuming preempt_* change is blessed, we can revert this one and add
>> that fuller/better fix.
>>
>> What do you think ?
>>
>> Thx,
>> -Vineet
>>
>
> Ping ! Sorry for pestering, but one of the fixes is needed before 3.9 goes out.
>
> Simple localized fix: http://www.spinics.net/lists/kernel/msg1508224.html
> Better but risky: http://www.spinics.net/lists/kernel/msg1510885.html
>
> Thx,
> -Vineet
