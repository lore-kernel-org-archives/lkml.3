Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901AbaIJVdg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 17:33:36 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:34837 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbaIJVde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 17:33:34 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Iacob <iacobcatalin@gmail.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 0/8] nohz: Fix nohz kick irq work on tick v2
Date: Wed, 10 Sep 2014 23:33:20 +0200
Message-Id: <1410384808-14760-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The nohz kick uses irq work to restart the tick but it relies on irq
work to run on its own IPI. Otherwise the kick runs on the tick and
bad things happen when it tries to cancel the tick hrtimer from itself.

That 2nd version addresses Peterz review.

Note I only tested x86. Just waiting for general agreement before testing
more seriously.

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	nohz/fixes-v2

HEAD: 863bea6acd4c9151f9be2fa623e8fee588d4e58c

Thanks,
	Frederic
---

Frederic Weisbecker (7):
      nohz: Move nohz full init call to tick init
      irq_work: Force raised irq work to run on irq work interrupt
      x86: Tell irq work about self IPI support
      arm: Tell irq work about self IPI support
      arm64: Tell irq work about self IPI support
      nohz: Consolidate nohz full init code
      nohz: nohz full depends on irq work self IPI support

Peter Zijlstra (1):
      irq_work: Introduce arch_irq_work_has_interrupt()


 arch/alpha/include/asm/Kbuild      |  1 +
 arch/arc/include/asm/Kbuild        |  1 +
 arch/arm/include/asm/irq_work.h    | 11 ++++++++
 arch/arm/kernel/smp.c              |  2 +-
 arch/arm64/include/asm/Kbuild      |  2 +-
 arch/arm64/include/asm/irq_work.h  | 11 ++++++++
 arch/arm64/include/asm/smp.h       |  2 ++
 arch/arm64/kernel/smp.c            |  2 +-
 arch/avr32/include/asm/Kbuild      |  1 +
 arch/blackfin/include/asm/Kbuild   |  1 +
 arch/c6x/include/asm/Kbuild        |  1 +
 arch/cris/include/asm/Kbuild       |  1 +
 arch/frv/include/asm/Kbuild        |  1 +
 arch/hexagon/include/asm/Kbuild    |  1 +
 arch/ia64/include/asm/Kbuild       |  1 +
 arch/m32r/include/asm/Kbuild       |  1 +
 arch/m68k/include/asm/Kbuild       |  1 +
 arch/metag/include/asm/Kbuild      |  1 +
 arch/microblaze/include/asm/Kbuild |  1 +
 arch/mips/include/asm/Kbuild       |  1 +
 arch/mn10300/include/asm/Kbuild    |  1 +
 arch/openrisc/include/asm/Kbuild   |  1 +
 arch/parisc/include/asm/Kbuild     |  1 +
 arch/powerpc/include/asm/Kbuild    |  1 +
 arch/s390/include/asm/Kbuild       |  1 +
 arch/score/include/asm/Kbuild      |  1 +
 arch/sh/include/asm/Kbuild         |  1 +
 arch/sparc/include/asm/Kbuild      |  1 +
 arch/tile/include/asm/Kbuild       |  1 +
 arch/um/include/asm/Kbuild         |  1 +
 arch/unicore32/include/asm/Kbuild  |  1 +
 arch/x86/include/asm/irq_work.h    | 11 ++++++++
 arch/x86/kernel/irq_work.c         |  2 +-
 arch/xtensa/include/asm/Kbuild     |  1 +
 include/asm-generic/irq_work.h     | 10 ++++++++
 include/linux/irq_work.h           |  3 +++
 include/linux/tick.h               |  2 --
 init/main.c                        |  1 -
 kernel/irq_work.c                  | 13 ++++++++--
 kernel/time/tick-common.c          |  1 +
 kernel/time/tick-internal.h        |  7 +++++
 kernel/time/tick-sched.c           | 52 ++++++++++++++++++++++++--------------
 kernel/time/timer.c                |  2 +-
 43 files changed, 131 insertions(+), 29 deletions(-)
