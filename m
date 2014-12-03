Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbaLCXo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:44:29 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:43316 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaLCXo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:44:27 -0500
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org
Cc: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>, Zubair.Kakakhel@imgtec.com,
        geert+renesas@glider.be, peterz@infradead.org,
        paul.gortmaker@windriver.com, macro@linux-mips.org, chenhc@lemote.com,
        cl@linux.com, mingo@kernel.org, richard@nod.at, zajec5@gmail.com,
        james.hogan@imgtec.com, keescook@chromium.org, tj@kernel.org,
        alex@alex-smith.me.uk, pbonzini@redhat.com, blogic@openwrt.org,
        paul.burton@imgtec.com, qais.yousef@imgtec.com,
        linux-kernel@vger.kernel.org, markos.chandras@imgtec.com,
        dengcheng.zhu@imgtec.com, manuel.lauss@gmail.com,
        lars.persson@axis.com, David Daney <david.daney@cavium.com>
Subject: [PATCH 0/3] MIPS: Get ready for non-executable stack.
Date: Wed,  3 Dec 2014 15:44:15 -0800
Message-Id: <1417650258-2811-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Currently the MIPS FPU emulator uses eXecute Out of Line (XOL) on the
stack to handle instructions in the delay slots of FPU branches.
Because of this MIPS cannot have a non-executable stack.

A previous patch set from Leonid Yegoshin attempts to address the
problem by moving the XOL location to a thread private mapping of a
dedicated page.

I present here an alternative: Add an instruction set emulator and use
it to execute the FPU delay slot instructions.  The benefit of this
approach is that we don't have to allocate a page per user-space
thread for XOL, and we keep the TLB handling code slightly simpler as
a result.

Currently this is a proof of concept, as it doesn't yet handle MIPS64
nor microMIPS instructions.  But it is sufficient to run the entire
Debian distribution on a FPU-less CPU.

Comments welcome.

David Daney (3):
  MIPS: Add FPU emulator counter for non-FPU instructions emulated.
  MIPS: Add full ISA emulator.
  MIPS: Use full instruction emulation for FPU emulator delay slot
    emulation.

 arch/mips/include/asm/fpu_emulator.h |   1 +
 arch/mips/kernel/Makefile            |   3 +-
 arch/mips/kernel/insn-emul.c         | 815 +++++++++++++++++++++++++++++++++++
 arch/mips/math-emu/cp1emu.c          |  13 +-
 arch/mips/math-emu/me-debugfs.c      |   1 +
 5 files changed, 830 insertions(+), 3 deletions(-)
 create mode 100644 arch/mips/kernel/insn-emul.c

-- 
1.7.11.7

