Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966831AbaFROUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:20:08 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:39801 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756887AbaFROUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:20:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcBACOfoVOERCABjGdsb2JhbABarlABAQaZKAGBCRYPAQEBJzyEBAEFeRBRVxmIQscbhV4XhWKJEwcWhC0EijmnJw
X-IPAS-Result: AtcBACOfoVOERCABjGdsb2JhbABarlABAQaZKAGBCRYPAQEBJzyEBAEFeRBRVxmIQscbhV4XhWKJEwcWhC0EijmnJw
X-IronPort-AV: E=Sophos;i="5.01,501,1400014800"; 
   d="scan'208";a="112034671"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH kvm-unit-tests 1/5] x86: Testing nop instruction on 64-bit
Date: Wed, 18 Jun 2014 17:19:50 +0300
Message-Id: <1403101194-23707-2-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403101194-23707-1-git-send-email-namit@cs.technion.ac.il>
References: <1403101194-23707-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, nop instruction emulation on 64-bit caused RAX bits [63:32] to be
cleared.  This test checks the behavior is correct and RAX is unmodified.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 x86/emulator.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/x86/emulator.c b/x86/emulator.c
index f653127..bf8a873 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -845,6 +845,15 @@ static void test_smsw_reg(uint64_t *mem, uint8_t *insn_page,
 	report("64-bit smsw reg", outregs.rax == cr0);
 }
 
+static void test_nop(uint64_t *mem, uint8_t *insn_page,
+		uint8_t *alt_insn_page, void *insn_ram)
+{
+	inregs = (struct regs){ .rax = 0x1234567890abcdeful };
+	MK_INSN(nop, "nop\n\t");
+	trap_emulator(mem, alt_insn_page, &insn_nop);
+	report("nop", outregs.rax == inregs.rax);
+}
+
 static void test_crosspage_mmio(volatile uint8_t *mem)
 {
     volatile uint16_t w, *pw;
@@ -1045,6 +1054,7 @@ int main()
 	test_mmx_movq_mf(mem, insn_page, alt_insn_page, insn_ram);
 	test_movabs(mem, insn_page, alt_insn_page, insn_ram);
 	test_smsw_reg(mem, insn_page, alt_insn_page, insn_ram);
+	test_nop(mem, insn_page, alt_insn_page, insn_ram);
 
 	test_crosspage_mmio(mem);
 
-- 
1.9.1

