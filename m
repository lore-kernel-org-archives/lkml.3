Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbaJDDRW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 23:17:22 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:8826 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025AbaJDDRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 23:17:20 -0400
Subject: [PATCH 0/3] MIPS executable stack protection
To: <linux-mips@linux-mips.org>, <Zubair.Kakakhel@imgtec.com>,
        <david.daney@cavium.com>, <peterz@infradead.org>,
        <paul.gortmaker@windriver.com>, <davidlohr@hp.com>,
        <macro@linux-mips.org>, <chenhc@lemote.com>, <zajec5@gmail.com>,
        <james.hogan@imgtec.com>, <keescook@chromium.org>,
        <alex@alex-smith.me.uk>, <tglx@linutronix.de>, <blogic@openwrt.org>,
        <jchandra@broadcom.com>, <paul.burton@imgtec.com>,
        <qais.yousef@imgtec.com>, <linux-kernel@vger.kernel.org>,
        <ralf@linux-mips.org>, <markos.chandras@imgtec.com>,
        <manuel.lauss@gmail.com>, <akpm@linux-foundation.org>,
        <lars.persson@axis.com>
From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
Date: Fri, 3 Oct 2014 20:17:14 -0700
Message-ID: <20141004030438.28569.85536.stgit@linux-yegoshin>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.65.146]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements an executable stack protection in MIPS.

It sets up a per-thread 'VDSO' page and appropriate TLB support.
Page is set write-protected from user and is maintained via kernel VA.
MIPS FPU emulation is shifted to new page and stack is relieved for
execute protection as is as all data pages in default setup during ELF
binary initialization. The real protection is controlled by GLIBC and
it can do stack protected now as it is done in other architectures and
I learned today that GLIBC team is ready for this.

Note: actual execute-protection depends from HW capability, of course.

This patch is required for MIPS32/64 R2 emulation on MIPS R6 architecture.
Without it 'ssh-keygen' crashes pretty fast on attempt to execute instruction
in stack.
---

Leonid Yegoshin (3):
      MIPS: mips_flush_cache_range is added
      MIPS: Setup an instruction emulation in VDSO protected page instead of user stack
      MIPS: set stack/data protection as non-executable


 arch/mips/include/asm/cacheflush.h  |    3 +
 arch/mips/include/asm/mmu.h         |    2 +
 arch/mips/include/asm/page.h        |    2 -
 arch/mips/include/asm/processor.h   |    2 -
 arch/mips/include/asm/switch_to.h   |   12 ++++
 arch/mips/include/asm/thread_info.h |    3 +
 arch/mips/include/asm/tlbmisc.h     |    1 
 arch/mips/include/asm/vdso.h        |    2 +
 arch/mips/kernel/process.c          |    7 ++
 arch/mips/kernel/vdso.c             |   41 ++++++++++++-
 arch/mips/math-emu/dsemul.c         |  114 ++++++++++++++++++++++++++---------
 arch/mips/mm/c-octeon.c             |    8 ++
 arch/mips/mm/c-r3k.c                |    8 ++
 arch/mips/mm/c-r4k.c                |   43 +++++++++++++
 arch/mips/mm/c-tx39.c               |    9 +++
 arch/mips/mm/cache.c                |    4 +
 arch/mips/mm/fault.c                |    5 ++
 arch/mips/mm/tlb-r4k.c              |   39 ++++++++++++
 18 files changed, 273 insertions(+), 32 deletions(-)

-- 
Signature
