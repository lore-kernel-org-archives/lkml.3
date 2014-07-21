Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314AbaGULlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:41:21 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:8967 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754916AbaGULlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:41:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjcBAKb7zFOERCABjGdsb2JhbABZ0SUBgRoWDwEBASc9hAQBBXkQUVcZiEK4J4ZMF45nZAcWhDAFil+oPGmBAw
X-IPAS-Result: AjcBAKb7zFOERCABjGdsb2JhbABZ0SUBgRoWDwEBASc9hAQBBXkQUVcZiEK4J4ZMF45nZAcWhDAFil+oPGmBAw
X-IronPort-AV: E=Sophos;i="5.01,700,1400014800"; 
   d="scan'208";a="116353629"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH kvm-unit-tests 1/3] x86: Check rflags.rf is cleared after emulation
Date: Mon, 21 Jul 2014 14:39:52 +0300
Message-Id: <1405942794-22681-2-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405942794-22681-1-git-send-email-namit@cs.technion.ac.il>
References: <1405942650-22589-1-git-send-email-namit@cs.technion.ac.il>
 <1405942794-22681-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RFLAGS.RF should be cleared after every instruction emulation. Recently
discovered bug indicated this is not the case. This patch adds a test to check
this behavior. It is done by setting RF, executing IRET and checking whether
the saved RF is cleared. Since the flags are saved several instructions after
IRET is executed, RF should be cleared.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 x86/realmode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/x86/realmode.c b/x86/realmode.c
index 10c3e03..09e6aa7 100644
--- a/x86/realmode.c
+++ b/x86/realmode.c
@@ -744,7 +744,7 @@ void test_iret()
 	MK_INSN(iret_flags32, "pushfl\n\t"
 			      "popl %eax\n\t"
 			      "andl $~0x2, %eax\n\t"
-			      "orl $0xffc08028, %eax\n\t"
+			      "orl $0xffc18028, %eax\n\t"
 			      "pushl %eax\n\t"
 			      "pushl %cs\n\t"
 			      "call 1f\n\t"
@@ -773,6 +773,7 @@ void test_iret()
 
 	exec_in_big_real_mode(&insn_iret_flags32);
 	report("iret 3", R_AX, 1);
+	report("rflags.rf", ~0, !(outregs.eflags & (1 << 16)));
 
 	exec_in_big_real_mode(&insn_iret_flags16);
 	report("iret 4", R_AX, 1);
-- 
1.9.1

