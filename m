Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbaEZVHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 17:07:23 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:60478 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbaEZVHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 17:07:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwBAL6sg1OERCABjGdsb2JhbABZsXaUUAGBFxYOAQEBJzyCJgEFeRBRVxmIQs9ehUMXjlIHFoQqBINehj2mOg
X-IPAS-Result: AvwBAL6sg1OERCABjGdsb2JhbABZsXaUUAGBFxYOAQEBJzyCJgEFeRBRVxmIQs9ehUMXjlIHFoQqBINehj2mOg
X-IronPort-AV: E=Sophos;i="4.98,914,1392156000"; 
   d="scan'208";a="108639856"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH kvm-unit-tests] x86: test mov DR with ignored mod bits
Date: Tue, 27 May 2014 00:06:57 +0300
Message-Id: <1401138417-29949-1-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <538330D8.40602@redhat.com>
References: <538330D8.40602@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tests whether the emulator ignores the mod bits on mov DR instruction.  The
test performs regular mov to DR0 and reads back the data using custom mov from
DR0 while mod bits are set to zero. The expected result is obviously the value
which was written to DR0 before.

The test is performed in realmode and is only expected to fail if the CPU does
not support unrestricted mode. Note that mov-CR/DR in protected mode are
usually not handled by the emulator, as their data is available in the exit
information fields.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 x86/realmode.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/x86/realmode.c b/x86/realmode.c
index 9c22d41..839ac34 100644
--- a/x86/realmode.c
+++ b/x86/realmode.c
@@ -1636,6 +1636,16 @@ static void test_perf_memory_rmw(void)
 	print_serial(" cycles/emulated memory RMW instruction\n");
 }
 
+void test_dr_mod(void)
+{
+	MK_INSN(drmod, "movl %ebx, %dr0\n\t"
+		       ".byte 0x0f \n\t .byte 0x21 \n\t .byte 0x0\n\t");
+	inregs.eax = 0xdead;
+	inregs.ebx = 0xaced;
+	exec_in_big_real_mode(&insn_drmod);
+	report("mov dr with mod bits", R_AX | R_BX, outregs.eax == 0xaced);
+}
+
 void realmode_start(void)
 {
 	test_null();
@@ -1681,6 +1691,7 @@ void realmode_start(void)
 	test_xlat();
 	test_salc();
 	test_fninit();
+	test_dr_mod();
 	test_nopl();
 	test_perf_loop();
 	test_perf_mov();
-- 
1.9.1

