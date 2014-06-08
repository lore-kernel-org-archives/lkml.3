Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbaFHKFb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 06:05:31 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:18024 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbaFHKF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 06:05:29 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar4DACo0lFOERCABjGdsb2JhbABZrzoBAQaZEAGBAhYPAQEBJzyEBAEFeRBRVxmIQsgxhTEXhV2JDwcWhCsEiiymeQ
X-IPAS-Result: Ar4DACo0lFOERCABjGdsb2JhbABZrzoBAQaZEAGBAhYPAQEBJzyEBAEFeRBRVxmIQsgxhTEXhV2JDwcWhCsEiiymeQ
X-IronPort-AV: E=Sophos;i="4.98,998,1392156000"; 
   d="scan'208";a="110400825"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH kvm-unit-tests v2] x86: emulator: long mode smsw tests
Date: Sun,  8 Jun 2014 13:02:45 +0300
Message-Id: <1402221765-24337-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <5391760E.2030401@redhat.com>
References: <5391760E.2030401@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SMSW instruction on long-mode is performed according to the operand size, if
the destination operand is a register.  This patch tests whether it is
performed correctly instead of always using two-bytes operands (as KVM
previously did).  Note that when a dword destination operand is used, the
result is zero-extended to qword on long-mode.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 x86/emulator.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/x86/emulator.c b/x86/emulator.c
index 033f246..f653127 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -825,6 +825,26 @@ static void test_movabs(uint64_t *mem, uint8_t *insn_page,
     report("64-bit mov imm2", outregs.rcx == 0x9090909090909090);
 }
 
+static void test_smsw_reg(uint64_t *mem, uint8_t *insn_page,
+		      uint8_t *alt_insn_page, void *insn_ram)
+{
+	unsigned long cr0 = read_cr0();
+	inregs = (struct regs){ .rax = 0x1234567890abcdeful };
+
+	MK_INSN(smsww, "smsww %ax\n\t");
+	trap_emulator(mem, alt_insn_page, &insn_smsww);
+	report("16-bit smsw reg", (u16)outregs.rax == (u16)cr0 &&
+				  outregs.rax >> 16 == inregs.rax >> 16);
+
+	MK_INSN(smswl, "smswl %eax\n\t");
+	trap_emulator(mem, alt_insn_page, &insn_smswl);
+	report("32-bit smsw reg", outregs.rax == (u32)cr0);
+
+	MK_INSN(smswq, "smswq %rax\n\t");
+	trap_emulator(mem, alt_insn_page, &insn_smswq);
+	report("64-bit smsw reg", outregs.rax == cr0);
+}
+
 static void test_crosspage_mmio(volatile uint8_t *mem)
 {
     volatile uint16_t w, *pw;
@@ -1024,6 +1044,7 @@ int main()
 
 	test_mmx_movq_mf(mem, insn_page, alt_insn_page, insn_ram);
 	test_movabs(mem, insn_page, alt_insn_page, insn_ram);
+	test_smsw_reg(mem, insn_page, alt_insn_page, insn_ram);
 
 	test_crosspage_mmio(mem);
 
-- 
1.9.1

