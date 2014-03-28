Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbaC1V1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 17:27:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:53238 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051AbaC1V1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 17:27:19 -0400
Message-ID: <1396041923.11529.23.camel@pasglop>
Subject: Re: [PATCH] powerpc/irq: Remove HAVE_IRQ_EXIT_ON_IRQ_STACK feature
 at powerpc platform
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Dongsheng Wang <dongsheng.wang@freescale.com>
Cc: fweisbec@gmail.com, scottwood@freescale.com, leoli@freescale.com,
        jason.jin@freescale.com, tie-fei.zang@freescale.com,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Paul Mackerras <paulus@au1.ibm.com>,
        James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sat, 29 Mar 2014 08:25:23 +1100
In-Reply-To: <1395992312-23035-1-git-send-email-dongsheng.wang@freescale.com>
References: <1395992312-23035-1-git-send-email-dongsheng.wang@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.90 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-28 at 15:38 +0800, Dongsheng Wang wrote:
> From: Wang Dongsheng <dongsheng.wang@freescale.com>
> 
> If softirq use hardirq stack, we will get kernel painc when a hard irq coming again
> during __do_softirq enable local irq to deal with softirq action. So we need to switch
> satck into softirq stack when invoke soft irq.

Yes, an interrupt can potentially nest but we should be near the top of
the stack at that point, as the comment says in softirq.c, it should
be fine. And your backtrace doesn't seem to indicate a major overflow.

The code in do_IRQ() will make sure we don't switch stack again if
we were already on either hard or softirq stack.

I need a better analysis of your problem. Is that really a stack
overflow ? Or is it a false positive due to a bug in the overflow
detection ?

I moved around the code that updates KSP_LIMIT in 32-bit to asm in
misc_32.S a while ago since we don't do that on 64-bit, maybe we are
getting it wrong...

Cheers,
Ben.


