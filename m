Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966946AbaFROVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:21:38 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:39801 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756897AbaFROUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:20:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcBACOfoVOERCABjGdsb2JhbABarlABAQaZKAGBCRYPAQEBJzyEBAEFeRBRVxmIQscbhV4XhWKIL2QHFoQtBIo5i3ubLIFr
X-IPAS-Result: AtcBACOfoVOERCABjGdsb2JhbABarlABAQaZKAGBCRYPAQEBJzyEBAEFeRBRVxmIQscbhV4XhWKIL2QHFoQtBIo5i3ubLIFr
X-IronPort-AV: E=Sophos;i="5.01,501,1400014800"; 
   d="scan'208";a="112034682"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH kvm-unit-tests 3/5] x86: Test btcq with operand larger than 64
Date: Wed, 18 Jun 2014 17:19:52 +0300
Message-Id: <1403101194-23707-4-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403101194-23707-1-git-send-email-namit@cs.technion.ac.il>
References: <1403101194-23707-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, KVM did not calculate the offset for bit-operations correctly when
quad-word operands were used.  This test checks btcq when operand is larger
than 64 in order to check this scenario.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 x86/emulator.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/x86/emulator.c b/x86/emulator.c
index bf8a873..460949f 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -496,7 +496,7 @@ void test_btc(void *mem)
 {
 	unsigned int *a = mem;
 
-	memset(mem, 0, 3 * sizeof(unsigned int));
+	memset(mem, 0, 4 * sizeof(unsigned int));
 
 	asm ("btcl $32, %0" :: "m"(a[0]) : "memory");
 	asm ("btcl $1, %0" :: "m"(a[1]) : "memory");
@@ -505,6 +505,10 @@ void test_btc(void *mem)
 
 	asm ("btcl %1, %0" :: "m"(a[3]), "r"(-1) : "memory");
 	report("btcl reg, r/m", a[0] == 1 && a[1] == 2 && a[2] == 0x80000004);
+
+	asm ("btcq %1, %0" : : "m"(a[2]), "r"(-1l) : "memory");
+	report("btcq reg, r/m", a[0] == 1 && a[1] == 0x80000002 &&
+		a[2] == 0x80000004 && a[3] == 0);
 }
 
 void test_bsfbsr(void *mem)
-- 
1.9.1

