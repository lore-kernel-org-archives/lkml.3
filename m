Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab3BRQZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:25:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33999 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661Ab3BRQZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:25:17 -0500
Date: Mon, 18 Feb 2013 08:23:51 -0800
From: tip-bot for Alexander Holler <tipbot@zytor.com>
Message-ID: <tip-20bf062c6575e162ede00308ca3a5714ca112009@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, holler@ahsoftware.de,
        akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, holler@ahsoftware.de,
        akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <1361029097-8308-1-git-send-email-holler@ahsoftware.de>
References: <1361029097-8308-1-git-send-email-holler@ahsoftware.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86/memtest: Shorten time for tests
Git-Commit-ID: 20bf062c6575e162ede00308ca3a5714ca112009
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 18 Feb 2013 08:23:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  20bf062c6575e162ede00308ca3a5714ca112009
Gitweb:     http://git.kernel.org/tip/20bf062c6575e162ede00308ca3a5714ca112009
Author:     Alexander Holler <holler@ahsoftware.de>
AuthorDate: Sat, 16 Feb 2013 16:38:17 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 18 Feb 2013 09:28:42 +0100

x86/memtest: Shorten time for tests

By just reversing the order memtest is using the test patterns,
an additional round to zero the memory is not necessary.

This might save up to a second or even more for setups which are
doing tests on every boot.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1361029097-8308-1-git-send-email-holler@ahsoftware.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
