Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405AbaLCB6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 20:58:07 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:55201 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbaLCB6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 20:58:04 -0500
Subject: [PATCH v3 0/3] Series short description
From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
To: <linux-mips@linux-mips.org>, <Zubair.Kakakhel@imgtec.com>,
        <geert+renesas@glider.be>, <david.daney@cavium.com>,
        <peterz@infradead.org>, <paul.gortmaker@windriver.com>,
        <davidlohr@hp.com>, <macro@linux-mips.org>, <chenhc@lemote.com>,
        <cl@linux.com>, <mingo@kernel.org>, <richard@nod.at>,
        <zajec5@gmail.com>, <james.hogan@imgtec.com>, <keescook@chromium.org>,
        <tj@kernel.org>, <alex@alex-smith.me.uk>, <pbonzini@redhat.com>,
        <blogic@openwrt.org>, <paul.burton@imgtec.com>,
        <qais.yousef@imgtec.com>, <linux-kernel@vger.kernel.org>,
        <ralf@linux-mips.org>, <markos.chandras@imgtec.com>,
        <dengcheng.zhu@imgtec.com>, <manuel.lauss@gmail.com>,
        <lars.persson@axis.com>
Date: Tue, 2 Dec 2014 17:57:59 -0800
Message-ID: <20141203015537.13886.50830.stgit@linux-yegoshin>
User-Agent: StGit/0.17.1-dirty
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

v2 changes:
    - Added an optimization during mmap switch - doesn't switch if the same
      thread is rescheduled and other threads don't intervene (Peter Zijlstra)
    - Fixed uMIPS support (Paul Burton)
    - Added unwinding of VDSO emulation stack at signal handler invocation,
      hiding an emulation page (Andy Lutomirski note in other patch comments)

V3 change: heavy preemption friendly.

---

Leonid Yegoshin (3):
      MIPS: mips_flush_cache_range is added
      MIPS: Setup an instruction emulation in VDSO protected page instead of user stack
      MIPS: set stack/data protection as non-executable


 arch/mips/include/asm/cacheflush.h   |    3 +
 arch/mips/include/asm/fpu_emulator.h |    2 
 arch/mips/include/asm/mmu.h          |    3 +
 arch/mips/include/asm/page.h         |    2 
 arch/mips/include/asm/processor.h    |    2 
 arch/mips/include/asm/switch_to.h    |   14 +++
 arch/mips/include/asm/thread_info.h  |    3 +
 arch/mips/include/asm/tlbmisc.h      |    1 
 arch/mips/include/asm/vdso.h         |    3 +
 arch/mips/kernel/process.c           |    7 ++
 arch/mips/kernel/signal.c            |    4 +
 arch/mips/kernel/vdso.c              |   43 +++++++++-
 arch/mips/math-emu/cp1emu.c          |    8 +-
 arch/mips/math-emu/dsemul.c          |  153 ++++++++++++++++++++++++++++------
 arch/mips/mm/c-octeon.c              |    8 ++
 arch/mips/mm/c-r3k.c                 |    8 ++
 arch/mips/mm/c-r4k.c                 |   43 ++++++++++
 arch/mips/mm/c-tx39.c                |    9 ++
 arch/mips/mm/cache.c                 |    4 +
 arch/mips/mm/fault.c                 |    5 +
 arch/mips/mm/tlb-r4k.c               |   42 +++++++++
 21 files changed, 335 insertions(+), 32 deletions(-)

--
Signature
