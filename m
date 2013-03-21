Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933057Ab3CUWDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 18:03:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:33028 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144Ab3CUVxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:53:00 -0400
Message-Id: <20130321214930.752934102@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 21 Mar 2013 21:52:56 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 00/34] idle: Consolidate idle implementations
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each architecture implements its own cpu_idle() code, which is more or
less the same on all architectures (plus/minus a few bugs and a few
missing extra functionalities, instrumentation ...). That also forces
everyone who is interested in idle related features to add new
functionality to every architecture. What a waste.

Aside of that pointless code duplicaiton the ongoing quest to
consolidate the cpu hotplug code needs a common entry point for the
non boot cpus.

The following series implements a generic idle function and converts
most architectures over. I left out SPARC (it involves sparc asm) and
UM (it made me barf). If we can move those architectures as well, we
can get rid of the extra config switch and have everything
consolidated.

I spent a lot of time to make sure that the conversion preserved the
non obvious differences of the architecture implementations, but I
really need help from the affected maintainers to prove the
correctness.

Thanks,

	tglx
---
 arch/openrisc/kernel/idle.c                         |   73 ------------
 linux-2.6/arch/Kconfig                              |    3 
 linux-2.6/arch/alpha/Kconfig                        |    1 
 linux-2.6/arch/alpha/include/asm/thread_info.h      |    2 
 linux-2.6/arch/alpha/kernel/process.c               |   19 ---
 linux-2.6/arch/alpha/kernel/smp.c                   |    3 
 linux-2.6/arch/arc/Kconfig                          |    1 
 linux-2.6/arch/arc/kernel/process.c                 |   27 ----
 linux-2.6/arch/arc/kernel/smp.c                     |    2 
 linux-2.6/arch/arm/Kconfig                          |    2 
 linux-2.6/arch/arm/include/asm/system_misc.h        |    3 
 linux-2.6/arch/arm/kernel/process.c                 |  100 ++++-------------
 linux-2.6/arch/arm/kernel/smp.c                     |    2 
 linux-2.6/arch/arm/mach-gemini/idle.c               |    4 
 linux-2.6/arch/arm/mach-gemini/irq.c                |    2 
 linux-2.6/arch/arm/mach-ixp4xx/common.c             |    2 
 linux-2.6/arch/arm/mach-omap1/pm.c                  |    5 
 linux-2.6/arch/arm/mach-omap2/omap_hwmod.c          |    6 -
 linux-2.6/arch/arm/mach-omap2/pm.c                  |    5 
 linux-2.6/arch/arm/mach-orion5x/board-dt.c          |    2 
 linux-2.6/arch/arm/mach-orion5x/common.c            |    2 
 linux-2.6/arch/arm/mach-shark/core.c                |    2 
 linux-2.6/arch/arm/mach-shmobile/suspend.c          |    4 
 linux-2.6/arch/arm/mach-w90x900/dev.c               |    2 
 linux-2.6/arch/arm64/Kconfig                        |    1 
 linux-2.6/arch/arm64/kernel/process.c               |   43 -------
 linux-2.6/arch/arm64/kernel/smp.c                   |    2 
 linux-2.6/arch/avr32/Kconfig                        |    1 
 linux-2.6/arch/avr32/kernel/process.c               |   13 --
 linux-2.6/arch/avr32/kernel/time.c                  |    8 +
 linux-2.6/arch/avr32/mach-at32ap/include/mach/pm.h  |   24 ----
 linux-2.6/arch/avr32/mach-at32ap/pm-at32ap700x.S    |    7 -
 linux-2.6/arch/blackfin/Kconfig                     |    1 
 linux-2.6/arch/blackfin/kernel/process.c            |   30 -----
 linux-2.6/arch/blackfin/mach-common/smp.c           |    2 
 linux-2.6/arch/c6x/Kconfig                          |    1 
 linux-2.6/arch/c6x/kernel/process.c                 |   28 ----
 linux-2.6/arch/cris/Kconfig                         |    1 
 linux-2.6/arch/cris/arch-v10/kernel/process.c       |    3 
 linux-2.6/arch/cris/arch-v32/kernel/process.c       |   12 --
 linux-2.6/arch/cris/arch-v32/kernel/smp.c           |    4 
 linux-2.6/arch/cris/include/asm/processor.h         |    7 -
 linux-2.6/arch/cris/kernel/process.c                |   49 --------
 linux-2.6/arch/frv/Kconfig                          |    1 
 linux-2.6/arch/frv/kernel/process.c                 |   27 ----
 linux-2.6/arch/h8300/Kconfig                        |    1 
 linux-2.6/arch/h8300/kernel/process.c               |   35 ------
 linux-2.6/arch/hexagon/Kconfig                      |    1 
 linux-2.6/arch/hexagon/kernel/process.c             |   23 ----
 linux-2.6/arch/hexagon/kernel/smp.c                 |    2 
 linux-2.6/arch/ia64/Kconfig                         |    1 
 linux-2.6/arch/ia64/include/asm/thread_info.h       |    2 
 linux-2.6/arch/ia64/kernel/perfmon.c                |   13 --
 linux-2.6/arch/ia64/kernel/process.c                |   83 ++------------
 linux-2.6/arch/ia64/kernel/smpboot.c                |    2 
 linux-2.6/arch/m32r/Kconfig                         |    1 
 linux-2.6/arch/m32r/kernel/process.c                |   18 ---
 linux-2.6/arch/m32r/kernel/smpboot.c                |    2 
 linux-2.6/arch/m68k/Kconfig                         |    1 
 linux-2.6/arch/m68k/kernel/process.c                |   32 -----
 linux-2.6/arch/metag/Kconfig                        |    1 
 linux-2.6/arch/metag/include/asm/thread_info.h      |    2 
 linux-2.6/arch/metag/kernel/process.c               |   32 -----
 linux-2.6/arch/metag/kernel/smp.c                   |    2 
 linux-2.6/arch/microblaze/Kconfig                   |    2 
 linux-2.6/arch/microblaze/include/asm/processor.h   |    5 
 linux-2.6/arch/microblaze/include/asm/thread_info.h |    1 
 linux-2.6/arch/microblaze/kernel/process.c          |   65 -----------
 linux-2.6/arch/mips/Kconfig                         |    1 
 linux-2.6/arch/mips/kernel/process.c                |   46 ++------
 linux-2.6/arch/mips/kernel/smp.c                    |    2 
 linux-2.6/arch/mn10300/Kconfig                      |    1 
 linux-2.6/arch/mn10300/include/asm/thread_info.h    |    2 
 linux-2.6/arch/mn10300/kernel/process.c             |   70 +-----------
 linux-2.6/arch/mn10300/kernel/smp.c                 |    7 -
 linux-2.6/arch/openrisc/Kconfig                     |    1 
 linux-2.6/arch/openrisc/include/asm/thread_info.h   |    2 
 linux-2.6/arch/parisc/Kconfig                       |    1 
 linux-2.6/arch/parisc/include/asm/thread_info.h     |    2 
 linux-2.6/arch/parisc/kernel/process.c              |   22 ---
 linux-2.6/arch/parisc/kernel/smp.c                  |    2 
 linux-2.6/arch/powerpc/Kconfig                      |    1 
 linux-2.6/arch/powerpc/include/asm/thread_info.h    |    4 
 linux-2.6/arch/powerpc/kernel/idle.c                |   78 +++----------
 linux-2.6/arch/powerpc/kernel/smp.c                 |    2 
 linux-2.6/arch/s390/kernel/process.c                |   25 +---
 linux-2.6/arch/s390/kernel/smp.c                    |    3 
 linux-2.6/arch/score/Kconfig                        |    1 
 linux-2.6/arch/score/kernel/process.c               |   18 ---
 linux-2.6/arch/sh/Kconfig                           |    2 
 linux-2.6/arch/sh/include/asm/thread_info.h         |    4 
 linux-2.6/arch/sh/kernel/idle.c                     |  102 +----------------
 linux-2.6/arch/sh/kernel/smp.c                      |    2 
 linux-2.6/arch/sparc/include/asm/thread_info_32.h   |    2 
 linux-2.6/arch/sparc/include/asm/thread_info_64.h   |    2 
 linux-2.6/arch/tile/include/asm/thread_info.h       |    2 
 linux-2.6/arch/tile/kernel/process.c                |   61 +---------
 linux-2.6/arch/tile/kernel/smpboot.c                |    4 
 linux-2.6/arch/unicore32/Kconfig                    |    1 
 linux-2.6/arch/unicore32/kernel/process.c           |   21 ---
 linux-2.6/arch/x86/Kconfig                          |    1 
 linux-2.6/arch/x86/include/asm/thread_info.h        |    2 
 linux-2.6/arch/x86/kernel/process.c                 |  106 +++++-------------
 linux-2.6/arch/x86/kernel/smpboot.c                 |    2 
 linux-2.6/arch/x86/xen/smp.c                        |    2 
 linux-2.6/arch/xtensa/Kconfig                       |    1 
 linux-2.6/arch/xtensa/kernel/process.c              |   14 --
 linux-2.6/include/linux/cpu.h                       |   16 ++
 linux-2.6/include/linux/sched.h                     |   41 +++++++
 linux-2.6/init/main.c                               |    2 
 linux-2.6/kernel/Makefile                           |    1 
 linux-2.6/kernel/cpu/Makefile                       |    1 
 linux-2.6/kernel/cpu/idle.c                         |  115 ++++++++++++++++++++
 linux-2.6/kernel/sched/core.c                       |    5 
 114 files changed, 432 insertions(+), 1237 deletions(-)

