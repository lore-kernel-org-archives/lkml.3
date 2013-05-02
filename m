Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab3EBO71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 10:59:27 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:56977 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab3EBO70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 10:59:26 -0400
Date: Thu, 2 May 2013 16:58:09 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jonas Gorski <jogo@openwrt.org>, eunb.song@samsung.com,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MIPS: Enable interrupts in arch_cpu_idle()
Message-ID: <20130502145809.GA16236@linux-mips.org>
References: <20522420.158691367384219315.JavaMail.weblogic@epml17>
 <CAOiHx=mBPHmDse4EwL-+Fgmpz0=XhcgF_0nWdyvErFO4NU7E0Q@mail.gmail.com>
 <alpine.LFD.2.02.1305021241040.3972@ionos>
 <CAOiHx=mA-htk_2daeE9WpbEVV9YLvfLc1NYZZR=JeDdibchCnw@mail.gmail.com>
 <alpine.LFD.2.02.1305021527010.3972@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1305021527010.3972@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 04:33:52PM +0200, Thomas Gleixner wrote:

> commit cdbedc61c8 (mips: Use generic idle loop) broke MIPS as I did
> not realize that MIPS wants to invoke the wait instructions with
> interrupts enabled. Don't ask why that works correctly; Ralf suggested
> to get thoroughly drunk before even thinking about it. Looking sober
> at commit c65a5480 ([MIPS] Fix potential latency problem due to
> non-atomic cpu_wait) is not recommended.
> 
> Enable interrupts in arch_cpu_idle() on mips to repair the issue.
> 
> Reported-and-tested-by: Jonas Gorski <jogo@openwrt.org>
> Reported-by: EunBong Song <eunb.song@samsung.com>
> Booze-recommended-by: Ralf Baechle <ralf@linux-mips.org>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

A very sobering commit message ;-)

The underlying issue is that the WAIT instruction on MIPS is architecturally
defined as "[...] It is implementation-dependent whether the pipeline
restarts when a non-enabled interrupt is requested.  [...]"

arch_local_irq_disable() disables interrupts by clearing the IE bit in
the CPU status register, thus disabling all interrupts.  If no a WAIT
instruction is executed it's legal for a CPU to stop the pipeline for
good.  Which obviously is pretty stupidtastik behaviour.

For a while we just used to live with the race condition resulting from
not disabling interrupts in the idle loop.  Then c65a5480 fixed this by
checking if we're returning to the WAIT instruction in the idle loop
when returning from an interrupt and iff so, rolling back the
program counter to point to the if (test_thread_flag(TIF_NEED_RESCHED))
test at the beginning of rollback_r4k_wait.

Linux knows which CPUs have the problematic behaviour and uses this special
variant of the idle loop only where needed.

  Ralf
