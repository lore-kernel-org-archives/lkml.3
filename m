Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966972AbaFROVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:21:39 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:30903 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896AbaFROUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:20:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcBACOfoVOERCABjGdsb2JhbABarlABAQaZKAGBCRYPAQEBJzyEBAEFeRBRVxmIQscbhV4XhWKJEwcWhC0EijmnJw
X-IPAS-Result: AtcBACOfoVOERCABjGdsb2JhbABarlABAQaZKAGBCRYPAQEBJzyEBAEFeRBRVxmIQscbhV4XhWKJEwcWhC0EijmnJw
X-IronPort-AV: E=Sophos;i="5.01,501,1400014800"; 
   d="scan'208";a="112034678"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH kvm-unit-tests 2/5] x86: test xadd with two identical operands
Date: Wed, 18 Jun 2014 17:19:51 +0300
Message-Id: <1403101194-23707-3-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403101194-23707-1-git-send-email-namit@cs.technion.ac.il>
References: <1403101194-23707-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, KVM emulated xadd incorrectly when the source and destination
operands were identical.  The expected result is that the register would hold
the sum (2x) and not the previous value (x).  This test checks this behavior.
It should be executed with a disabled unrestricted mode.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 x86/realmode.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/x86/realmode.c b/x86/realmode.c
index dc4a1d3..10c3e03 100644
--- a/x86/realmode.c
+++ b/x86/realmode.c
@@ -1663,6 +1663,14 @@ void test_smsw(void)
 	report("smsw", R_AX | R_BX | R_CX, outregs.eax == outregs.ebx);
 }
 
+void test_xadd(void)
+{
+	MK_INSN(xadd, "xaddl %eax, %eax\n\t");
+	inregs.eax = 0x12345678;
+	exec_in_big_real_mode(&insn_xadd);
+	report("xadd", R_AX, outregs.eax == inregs.eax * 2);
+}
+
 
 void realmode_start(void)
 {
@@ -1712,6 +1720,7 @@ void realmode_start(void)
 	test_dr_mod();
 	test_smsw();
 	test_nopl();
+	test_xadd();
 	test_perf_loop();
 	test_perf_mov();
 	test_perf_arith();
-- 
1.9.1

