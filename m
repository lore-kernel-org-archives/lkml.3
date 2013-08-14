Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850Ab3HNNfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 09:35:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54863 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932823Ab3HNNe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 09:34:59 -0400
Message-Id: <20130814131539.790947874@chello.nl>
User-Agent: quilt/0.60-1
Date: Wed, 14 Aug 2013 15:15:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 0/5] preempt_count rework
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches optimize preempt_enable by firstly folding the preempt and
need_resched tests into one -- this should work for all architectures. And
secondly by providing per-arch preempt_count implementations; with x86 using
per-cpu preempt_count for fastest access.

These patches have so far only been compiled for defconfig-x86_64 +
CONFIG_PREEMPT=y and boot tested with kvm -smp 4 upto wanting to mount root.

It still needs asm volatile("call preempt_schedule": : :"memory"); as per
Andi's other patches to avoid the C calling convention cluttering the
preempt_enable() sites.

---
 arch/alpha/include/asm/Kbuild      |  1 +
 arch/arc/include/asm/Kbuild        |  1 +
 arch/arm/include/asm/Kbuild        |  1 +
 arch/arm64/include/asm/Kbuild      |  1 +
 arch/avr32/include/asm/Kbuild      |  1 +
 arch/blackfin/include/asm/Kbuild   |  1 +
 arch/c6x/include/asm/Kbuild        |  1 +
 arch/cris/include/asm/Kbuild       |  1 +
 arch/frv/include/asm/Kbuild        |  1 +
 arch/h8300/include/asm/Kbuild      |  1 +
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
 arch/x86/include/asm/thread_info.h |  5 ++---
 arch/x86/kernel/asm-offsets.c      |  1 -
 arch/x86/kernel/cpu/common.c       |  5 +++++
 arch/x86/kernel/entry_32.S         |  7 ++-----
 arch/x86/kernel/entry_64.S         |  4 +---
 arch/x86/kernel/process_32.c       | 10 ++++++++++
 arch/x86/kernel/process_64.c       | 10 ++++++++++
 arch/xtensa/include/asm/Kbuild     |  1 +
 include/linux/preempt.h            | 49 ++++++++++++++++++++++++++++++++++++++-----------
 include/linux/sched.h              |  2 +-
 include/linux/thread_info.h        |  1 +
 include/trace/events/sched.h       |  2 +-
 init/main.c                        |  2 +-
 kernel/context_tracking.c          |  3 +--
 kernel/cpu/idle.c                  | 10 ++++++++++
 kernel/sched/core.c                | 31 +++++++++++++++++++------------
 kernel/softirq.c                   |  4 ++--
 kernel/timer.c                     |  8 ++++----
 lib/smp_processor_id.c             |  3 +--
 47 files changed, 138 insertions(+), 48 deletions(-)

