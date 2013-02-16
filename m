Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab3BPPjk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 10:39:40 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:56852 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab3BPPji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 10:39:38 -0500
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Alexander Holler <holler@ahsoftware.de>
Subject: [PATCH] x86: memtest: shorten time for tests
Date: Sat, 16 Feb 2013 16:38:17 +0100
Message-Id: <1361029097-8308-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By just reversing the order memtest is using the test patterns, an
additional round to zero the memory is not necessary.

This might save up to a second or even more for setups which are
doing tests on every boot.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 arch/x86/mm/memtest.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
index c80b9fb..8dabbed 100644
--- a/arch/x86/mm/memtest.c
+++ b/arch/x86/mm/memtest.c
@@ -9,6 +9,7 @@
 #include <linux/memblock.h>
 
 static u64 patterns[] __initdata = {
+	/* The first entry has to be 0 to leave memtest with zeroed memory */
 	0,
 	0xffffffffffffffffULL,
 	0x5555555555555555ULL,
@@ -110,15 +111,8 @@ void __init early_memtest(unsigned long start, unsigned long end)
 		return;
 
 	printk(KERN_INFO "early_memtest: # of tests: %d\n", memtest_pattern);
-	for (i = 0; i < memtest_pattern; i++) {
+	for (i = memtest_pattern-1; i < UINT_MAX; --i) {
 		idx = i % ARRAY_SIZE(patterns);
 		do_one_pass(patterns[idx], start, end);
 	}
-
-	if (idx > 0) {
-		printk(KERN_INFO "early_memtest: wipe out "
-		       "test pattern from memory\n");
-		/* additional test with pattern 0 will do this */
-		do_one_pass(0, start, end);
-	}
 }
-- 
1.8.1.2

