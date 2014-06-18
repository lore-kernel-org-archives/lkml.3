Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966857AbaFROUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:20:11 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:9694 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756891AbaFROUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:20:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcBACOfoVOERCABjGdsb2JhbABarlABAQaZKAGBCRYPAQEBJzyEBAEFeRBRVxmIQscbhV4XhWKIL2QHFoQtBIo5pyeBaw
X-IPAS-Result: AtcBACOfoVOERCABjGdsb2JhbABarlABAQaZKAGBCRYPAQEBJzyEBAEFeRBRVxmIQscbhV4XhWKIL2QHFoQtBIo5pyeBaw
X-IronPort-AV: E=Sophos;i="5.01,501,1400014800"; 
   d="scan'208";a="112034689"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH kvm-unit-tests 4/5] x86: check cmov instruction on 64-bit
Date: Wed, 18 Jun 2014 17:19:53 +0300
Message-Id: <1403101194-23707-5-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403101194-23707-1-git-send-email-namit@cs.technion.ac.il>
References: <1403101194-23707-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cmov instruction on 64-bit with dword destination register operand should clear
bits [63:32].  This test checks this behavior due to previous KVM bug.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 x86/emulator.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/x86/emulator.c b/x86/emulator.c
index 460949f..1fd0ca6 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -710,6 +710,18 @@ static void test_shld_shrd(u32 *mem)
     report("shrd (cl)", *mem == ((0x12345678 >> 3) | (5u << 29)));
 }
 
+static void test_cmov(u32 *mem)
+{
+	u64 val;
+	*mem = 0xabcdef12u;
+	asm ("movq $0x1234567812345678, %%rax\n\t"
+	     "cmpl %%eax, %%eax\n\t"
+	     "cmovnel (%[mem]), %%eax\n\t"
+	     "movq %%rax, %[val]\n\t"
+	     : [val]"=r"(val) : [mem]"r"(mem) : "%rax", "cc");
+	report("cmovnel", val == 0x12345678ul);
+}
+
 #define INSN_XCHG_ALL				\
 	"xchg %rax, 0+save \n\t"		\
 	"xchg %rbx, 8+save \n\t"		\
@@ -1054,12 +1066,12 @@ int main()
 	test_sreg(mem);
 	test_lldt(mem);
 	test_ltr(mem);
+	test_cmov(mem);
 
 	test_mmx_movq_mf(mem, insn_page, alt_insn_page, insn_ram);
 	test_movabs(mem, insn_page, alt_insn_page, insn_ram);
 	test_smsw_reg(mem, insn_page, alt_insn_page, insn_ram);
 	test_nop(mem, insn_page, alt_insn_page, insn_ram);
-
 	test_crosspage_mmio(mem);
 
 	test_string_io_mmio(mem);
-- 
1.9.1

