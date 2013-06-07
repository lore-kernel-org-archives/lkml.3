Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab3FGXIM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:08:12 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:49729 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813Ab3FGXDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:03:53 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 20/31] mips/kvm: Hook into TLB fault handlers.
Date: Fri,  7 Jun 2013 16:03:24 -0700
Message-Id: <1370646215-6543-21-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

If the CPU is operating in guest mode when a TLB related excpetion
occurs, give KVM a chance to do emulation.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/mm/fault.c       | 8 ++++++++
 arch/mips/mm/tlbex-fault.S | 6 ++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/mips/mm/fault.c b/arch/mips/mm/fault.c
index 0fead53..9391da49 100644
--- a/arch/mips/mm/fault.c
+++ b/arch/mips/mm/fault.c
@@ -26,6 +26,7 @@
 #include <asm/ptrace.h>
 #include <asm/highmem.h>		/* For VMALLOC_END */
 #include <linux/kdebug.h>
+#include <asm/kvm_mips_vz.h>
 
 /*
  * This routine handles page faults.  It determines the address,
@@ -50,6 +51,13 @@ asmlinkage void __kprobes do_page_fault(struct pt_regs *regs, unsigned long writ
 	       field, regs->cp0_epc);
 #endif
 
+#ifdef CONFIG_KVM_MIPSVZ
+	if (test_tsk_thread_flag(current, TIF_GUESTMODE)) {
+		if (mipsvz_page_fault(regs, write, address))
+			return;
+	}
+#endif
+
 #ifdef CONFIG_KPROBES
 	/*
 	 * This is to notify the fault handler of the kprobes.	The
diff --git a/arch/mips/mm/tlbex-fault.S b/arch/mips/mm/tlbex-fault.S
index 318855e..df0f70b 100644
--- a/arch/mips/mm/tlbex-fault.S
+++ b/arch/mips/mm/tlbex-fault.S
@@ -14,6 +14,12 @@
 	NESTED(tlb_do_page_fault_\write, PT_SIZE, sp)
 	SAVE_ALL
 	MFC0	a2, CP0_BADVADDR
+#ifdef CONFIG_KVM_MIPSVZ
+	mfc0	v0, CP0_BADINSTR
+	mfc0	v1, CP0_BADINSTRP
+	sw	v0, PT_BADINSTR(sp)
+	sw	v1, PT_BADINSTRP(sp)
+#endif
 	KMODE
 	move	a0, sp
 	REG_S	a2, PT_BVADDR(sp)
-- 
1.7.11.7

