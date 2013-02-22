Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab3BVVIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 16:08:19 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:61181 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874Ab3BVVIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 16:08:18 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1302221605520.22263@ionos>
References: <1361496971-16939-1-git-send-email-fweisbec@gmail.com>
	<1361496971-16939-3-git-send-email-fweisbec@gmail.com>
	<alpine.LFD.2.02.1302221528470.22263@ionos>
	<20130222150444.GD18149@somewhere.redhat.com>
	<alpine.LFD.2.02.1302221605520.22263@ionos>
Date: Fri, 22 Feb 2013 13:08:17 -0800
X-Google-Sender-Auth: 1QhbD85dqStbro5cGQnjcYAjqMc
Message-ID: <CA+55aFxOreKQ-uzfMtXEb6XH4D8By2i=qOxfDLJnchSYsa34PQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] irq: Cleanup context state transitions in irq_exit()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 7:06 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>>
>> I prefer to let you guys have the final word on this patch. Whether you
>> apply it or not, I fear I'll never be entirely happy either way :)
>> That's the sad fate of dealing with circular dependencies...
>
> plus the butt ugly softirq semantics or the lack thereof ...

The softirq semantics are perfectly fine. Don't blame softirq for the
fact that irq_exit() has had shit-for-brains for a long time.

Just move the whole "invoke_softirq()" thing down to *after* the
tick_nohz_irq_exit() stuff. And that "wakeup_softirqd()" is garbage
too, since the whole thing should only be used for the
"force_irqthreads" case (which invoke_softirq()" got right.

And get rid of that final

 #ifndef __ARCH_IRQ_EXIT_IRQS_DISABLED
        local_irq_restore(flags);
 #endif

because even if the architecture enters irq_exit() with interrupts
enabled, we should damn well exit with them disabled so that there are
no races with new recursive interrupts (other than the ones that
wakeup_softirqd already handled).

In other words, I think all those special cases are indeed indicative
of something being wrong, but that "something" is not the softirq
code. Don't blame that. Blame the fact that irq_exit() is simply
written wrong. The softirq code should be done last (it used to be
done from the asm code), and the whole comment about
tick_nohz_irq_exit() perhaps changing something looks like pure and
utter garbage.

Don't blame the wrong code here.

               Linus
