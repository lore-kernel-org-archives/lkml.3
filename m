Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659Ab3IQSxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 14:53:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:54483 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab3IQSxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 14:53:07 -0400
Message-Id: <20130917182350.449685712@linutronix.de>
User-Agent: quilt/0.60-1
Date: Tue, 17 Sep 2013 18:53:04 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
References: <20130917082838.218329307@infradead.org>
Subject: [patch 0/6] Make all preempt_count related constants generic
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no point in having PREEMPT_ACTIVE and HARDIRQ_BITS defined by
an architecture.

The PREEMPT_ACTIVE bit manipulation in the low level entry code is
historical and has been replaced by preempt_schedule_irq().

The HARDIRQ_BITS constant could be 1 in theory because we run all
interrupt handlers with interrupts disabled nowadays. Though we have
some palaeontolical drivers (IDE) which still enable interrupts in the
interrupt handler, so we need to allow at least some limited nesting.

This series converts the remaining low level PREEMPT_ACTIVE users to
utilize preempt_schedule_irq() and moves the PREEMPT_ACTIVE and
HARDIRQ_BITS defines to the core code.

I stumbled over this historical left overs while trying to implement a
lazy interrupt disable scheme (which still has some rough edges due to
completely braindamaged hardware).

Peter, it would be nice if you could pick that up into your
preempt/need_resched series.

Thanks,

	tglx
---
 arch/alpha/include/asm/thread_info.h      |    2 -
 arch/arc/include/asm/thread_info.h        |    2 -
 arch/arm/include/asm/thread_info.h        |    6 ----
 arch/arm64/include/asm/thread_info.h      |    6 ----
 arch/avr32/include/asm/thread_info.h      |    2 -
 arch/blackfin/include/asm/hardirq.h       |    3 --
 arch/blackfin/include/asm/thread_info.h   |    2 -
 arch/c6x/include/asm/thread_info.h        |    2 -
 arch/cris/include/asm/hardirq.h           |   12 --------
 arch/cris/include/asm/thread_info.h       |    2 -
 arch/frv/include/asm/thread_info.h        |    2 -
 arch/h8300/include/asm/hardirq.h          |   12 --------
 arch/h8300/include/asm/thread_info.h      |    2 -
 arch/h8300/kernel/entry.S                 |    6 ----
 arch/hexagon/include/asm/thread_info.h    |    4 --
 arch/ia64/include/asm/thread_info.h       |    3 --
 arch/ia64/kernel/entry.S                  |   15 ----------
 arch/m32r/include/asm/hardirq.h           |   16 -----------
 arch/m32r/include/asm/thread_info.h       |    2 -
 arch/m32r/kernel/entry.S                  |    8 -----
 arch/m68k/include/asm/hardirq.h           |   11 --------
 arch/m68k/include/asm/thread_info.h       |    2 -
 arch/metag/include/asm/thread_info.h      |    2 -
 arch/microblaze/include/asm/thread_info.h |    2 -
 arch/mips/include/asm/thread_info.h       |    2 -
 arch/mn10300/include/asm/thread_info.h    |    2 -
 arch/parisc/include/asm/thread_info.h     |    3 --
 arch/powerpc/include/asm/thread_info.h    |    2 -
 arch/s390/include/asm/hardirq.h           |    2 -
 arch/s390/include/asm/thread_info.h       |    2 -
 arch/score/include/asm/thread_info.h      |    2 -
 arch/sh/include/asm/thread_info.h         |    2 -
 arch/sh/kernel/entry-common.S             |    6 +---
 arch/sparc/include/asm/hardirq_32.h       |    1 
 arch/sparc/include/asm/hardirq_64.h       |    2 -
 arch/sparc/include/asm/thread_info_32.h   |    2 -
 arch/sparc/include/asm/thread_info_64.h   |    2 -
 arch/sparc/kernel/rtrap_64.S              |    5 ---
 arch/tile/include/asm/hardirq.h           |    2 -
 arch/tile/include/asm/thread_info.h       |    2 -
 arch/um/include/asm/thread_info.h         |    2 -
 arch/unicore32/include/asm/thread_info.h  |    6 ----
 arch/x86/include/asm/thread_info.h        |    2 -
 arch/xtensa/include/asm/thread_info.h     |    2 -
 include/linux/preempt_mask.h              |   41 ++++++++----------------------
 45 files changed, 17 insertions(+), 201 deletions(-)

