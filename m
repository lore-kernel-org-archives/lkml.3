Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab3IWSAD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:00:03 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:31149 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab3IWSAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:00:01 -0400
Message-ID: <5240819F.4050903@tilera.com>
Date: Mon, 23 Sep 2013 13:59:59 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@au1.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        James Hogan <james.hogan@imgtec.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC GIT PULL] softirq: Consolidation and stack overrun fix
References: <1379620267-25191-1-git-send-email-fweisbec@gmail.com>	<CA+55aFyXf370Ds6FH5wPPycZLSPD5qiP7rjWqxwDetfHfKjg1w@mail.gmail.com>	<alpine.DEB.2.02.1309201244080.4089@ionos.tec.linutronix.de>	<20130920162603.GA30381@localhost.localdomain>	<CA+55aFyBcjP2U6ipzZay=FdhzA4oFNwE4tU0OcJJhwFvgoeALw@mail.gmail.com>	<CAFTL4hzucS5nJbCrArPv9zfY=QpyUESMK2Th0tKFHVCjDP7-eA@mail.gmail.com>	<1379799901.24090.6.camel@pasglop>	<523E4F8A.7020708@zytor.com>	<1379824754.24090.11.camel@pasglop>	<1379824861.24090.12.camel@pasglop>	<20130922162410.GA10649@laptop.programming.kicks-ass.net>	<1379887000.24090.19.camel@pasglop> <CA+55aFwaf_Wst=AS75ydBJVQ6aJxPfAzXdt-UXj3qC9WeUt7kw@mail.gmail.com>
In-Reply-To: <CA+55aFwaf_Wst=AS75ydBJVQ6aJxPfAzXdt-UXj3qC9WeUt7kw@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/22/2013 6:23 PM, Linus Torvalds wrote:
> Alternatively, make %r13 point to the percpu side, but make sure that
> you always use an asm accessor to fetch the value. In particular, I
> think you need to make __my_cpu_offset be an inline asm that fetches
> %r13 into some other register. Otherwise you can never get it right.

We just came up against this on tilegx with a customer bug report in a
PREEMPT environment.  On tile, %tp is a GPR that points to the percpu area.
The following seems to be the right abstraction -- though I'd also argue
that letting barrier() clobber not just memory, but %tp, might be a better
solution, but it's not clear what the best way is to do per-architecture
overrides of per-compiler definitions like barrier().  See also the ARM v7
code, which has to do something similar, though their percpu pointer is
not a GPR, which changes the tradeoffs somewhat.

register unsigned long my_cpu_offset_reg asm("tp");

#ifdef CONFIG_PREEMPT
/*
 * For full preemption, we can't just use the register variable
 * directly, since we need barrier() to hazard against it, causing the
 * compiler to reload anything computed from a previous "tp" value.
 * But we also don't want to use volatile asm, since we'd like the
 * compiler to be able to cache the value across multiple percpu reads.
 * So we use a fake stack read as a hazard against barrier().
 */
static inline unsigned long __my_cpu_offset(void)
{
        unsigned long tp;
        register unsigned long *sp asm("sp");
        asm("move %0, tp" : "=r" (tp) : "m" (*sp));
        return tp;
}
#define __my_cpu_offset __my_cpu_offset()
#else
/*
 * We don't need to hazard against barrier() since "tp" doesn't ever
 * change with PREEMPT_NONE, and with PREEMPT_VOLUNTARY it only
 * changes at function call points, at which we are already re-reading
 * the value of "tp" due to "my_cpu_offset_reg" being a global variable.
 */
#define __my_cpu_offset my_cpu_offset_reg
#endif

#define set_my_cpu_offset(tp) (my_cpu_offset_reg = (tp))

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com
