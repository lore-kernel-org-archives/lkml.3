Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbaFEX5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 19:57:38 -0400
Received: from mailgw12.technion.ac.il ([132.68.225.12]:49228 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaFEX5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 19:57:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ag8CAPECkVOERCABjGdsb2JhbABZx0cBgQgWDgEBASc8giYBBXkQQBFXGYhCzWGFMReOUgcWhCoEiiWmYg
X-IPAS-Result: Ag8CAPECkVOERCABjGdsb2JhbABZx0cBgQgWDgEBASc8giYBBXkQQBFXGYhCzWGFMReOUgcWhCoEiiWmYg
X-IronPort-AV: E=Sophos;i="4.98,984,1392156000"; 
   d="scan'208";a="110197070"
From: Nadav Amit <namit@cs.technion.ac.il>
To: pbonzini@redhat.com
Cc: gleb@kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH kvm-unit-tests1/2] x86: emulator: additional smsw test-case
Date: Fri,  6 Jun 2014 02:56:52 +0300
Message-Id: <1402012613-29891-2-git-send-email-namit@cs.technion.ac.il>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402012613-29891-1-git-send-email-namit@cs.technion.ac.il>
References: <53908C66.20600@redhat.com>
 <1402012613-29891-1-git-send-email-namit@cs.technion.ac.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An additional test case for the emulator was added to test smsw which is
trapped by the emulator.  The other existing test-cases occur in the guest (at
least on VMX), since the values are read directly from the CR0 read shadow.

Signed-off-by: Nadav Amit <namit@cs.technion.ac.il>
---
 x86/emulator.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/x86/emulator.c b/x86/emulator.c
index 20e3a45..033f246 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -336,7 +336,7 @@ void test_incdecnotneg(void *mem)
     report("lock notb", *mb == vb);
 }
 
-void test_smsw(void)
+void test_smsw(uint64_t *h_mem)
 {
 	char mem[16];
 	unsigned short msw, msw_orig, *pmsw;
@@ -355,6 +355,12 @@ void test_smsw(void)
 		if (i != 4 && pmsw[i])
 			zero = 0;
 	report("smsw (2)", msw == pmsw[4] && zero);
+
+	/* Trigger exit on smsw */
+	*h_mem = 0x12345678abcdeful;
+	asm volatile("smsw %0" : "=m"(*h_mem));
+	report("smsw (3)", msw == (unsigned short)*h_mem &&
+		(*h_mem & ~0xfffful) == 0x12345678ab0000ul);
 }
 
 void test_lmsw(void)
@@ -998,7 +1004,7 @@ int main()
 
 	test_cr8();
 
-	test_smsw();
+	test_smsw(mem);
 	test_lmsw();
 	test_ljmp(mem);
 	test_stringio();
-- 
1.9.1

