Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbaGOOmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 10:42:06 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:64872 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbaGOOmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 10:42:02 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmwBANQ8xVOERCABjGdsb2JhbABZhDfJNwGBCxYPAQEBJzyEBAEFeRBRVxmIQsNYhjQXj0sHFoQtBYpbqClp
X-IPAS-Result: AmwBANQ8xVOERCABjGdsb2JhbABZhDfJNwGBCxYPAQEBJzyEBAEFeRBRVxmIQsNYhjQXj0sHFoQtBYpbqClp
X-IronPort-AV: E=Sophos;i="5.01,665,1400014800"; 
   d="scan'208";a="115672210"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH kvm-unit-tests] x86: Check DR6.RTM is writable
Date: Tue, 15 Jul 2014 17:41:56 +0300
Message-Id: <1405435316-9506-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405435066-8936-1-git-send-email-namit@cs.technion.ac.il>
References: <1405435066-8936-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently discovered bug shows DR6.RTM is fixed to one. The bug is only apparent
when the host emulates the MOV-DR instruction or when the host debugs the
guest kernel. This patch tests whether DR6.RTM is indeed accessible according
to RTM support as reported by cpuid.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 x86/emulator.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/x86/emulator.c b/x86/emulator.c
index 1fd0ca6..f68882f 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -3,6 +3,7 @@
 #include "libcflat.h"
 #include "desc.h"
 #include "types.h"
+#include "processor.h"
 
 #define memset __builtin_memset
 #define TESTDEV_IO_PORT 0xe0
@@ -870,6 +871,19 @@ static void test_nop(uint64_t *mem, uint8_t *insn_page,
 	report("nop", outregs.rax == inregs.rax);
 }
 
+static void test_mov_dr(uint64_t *mem, uint8_t *insn_page,
+		uint8_t *alt_insn_page, void *insn_ram)
+{
+	bool rtm_support = cpuid(7).b & (1 << 11);
+	unsigned long dr6_fixed_1 = rtm_support ? 0xfffe0ff0ul : 0xffff0ff0ul;
+	inregs = (struct regs){ .rax = 0 };
+	MK_INSN(mov_to_dr6, "movq %rax, %dr6\n\t");
+	trap_emulator(mem, alt_insn_page, &insn_mov_to_dr6);
+	MK_INSN(mov_from_dr6, "movq %dr6, %rax\n\t");
+	trap_emulator(mem, alt_insn_page, &insn_mov_from_dr6);
+	report("mov_dr6", outregs.rax == dr6_fixed_1);
+}
+
 static void test_crosspage_mmio(volatile uint8_t *mem)
 {
     volatile uint16_t w, *pw;
@@ -1072,6 +1086,7 @@ int main()
 	test_movabs(mem, insn_page, alt_insn_page, insn_ram);
 	test_smsw_reg(mem, insn_page, alt_insn_page, insn_ram);
 	test_nop(mem, insn_page, alt_insn_page, insn_ram);
+	test_mov_dr(mem, insn_page, alt_insn_page, insn_ram);
 	test_crosspage_mmio(mem);
 
 	test_string_io_mmio(mem);
-- 
1.9.1

