Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbaFEX5L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 19:57:11 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:35331 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbaFEX5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 19:57:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ag8CAPECkVOERCABjGdsb2JhbABZg1nDbgGBCBYOAQEBJzyCJgEFeRBAEVcZiELNYYUxF45SBxaEKgSKJYtkmTuBQw
X-IPAS-Result: Ag8CAPECkVOERCABjGdsb2JhbABZg1nDbgGBCBYOAQEBJzyCJgEFeRBAEVcZiELNYYUxF45SBxaEKgSKJYtkmTuBQw
X-IronPort-AV: E=Sophos;i="4.98,984,1392156000"; 
   d="scan'208";a="110197068"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH kvm-unit-tests 2/2] x86: realmode: test smsw behavior with register operand
Date: Fri,  6 Jun 2014 02:56:53 +0300
Message-Id: <1402012613-29891-3-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402012613-29891-1-git-send-email-namit@cs.technion.ac.il>
References: <53908C66.20600@redhat.com>
 <1402012613-29891-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The smsw instruction has an undocumented behavior, in which the high-order
16-bits of CR0 are also saved in a 32-bit destination register.  This is
similar to the way smsw behaves in long-mode. However, it is hard to test the
long-mode case, since we need to cause an "invalid guest state" in long-mode.

The test works as follows: it sets CR0.CD (bit 30), so any of the high 16-bits
would be set.  It then executes smsw to register destination and compares the
register value with that of CR0.  CR0 value is restored when the test is done.

This test is expected to fail only when unrestricted mode is disabled or
unsupported.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 x86/realmode.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/x86/realmode.c b/x86/realmode.c
index 839ac34..6e74883 100644
--- a/x86/realmode.c
+++ b/x86/realmode.c
@@ -1646,6 +1646,20 @@ void test_dr_mod(void)
 	report("mov dr with mod bits", R_AX | R_BX, outregs.eax == 0xaced);
 }
 
+void test_smsw(void)
+{
+	MK_INSN(smsw, "movl %cr0, %ebx\n\t"
+		      "movl %ebx, %ecx\n\t"
+		      "or $0x40000000, %ebx\n\t"
+		      "movl %ebx, %cr0\n\t"
+		      "smswl %eax\n\t"
+		      "movl %ecx, %cr0\n\t");
+	inregs.eax = 0x12345678;
+	exec_in_big_real_mode(&insn_smsw);
+	report("smsw", R_AX | R_BX | R_CX, outregs.eax == outregs.ebx);
+}
+
+
 void realmode_start(void)
 {
 	test_null();
@@ -1692,6 +1706,7 @@ void realmode_start(void)
 	test_salc();
 	test_fninit();
 	test_dr_mod();
+	test_smsw();
 	test_nopl();
 	test_perf_loop();
 	test_perf_mov();
-- 
1.9.1

