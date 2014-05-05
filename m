Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbaEETTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 15:19:46 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:44771 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbaEETTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 15:19:44 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v5 1/7] x86,mm: Ensure correct alignment of the fixmap
Date: Mon,  5 May 2014 12:19:31 -0700
Message-Id: <e59a5f4362661f75dd4841fa74e1f2448045e245.1399317206.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <cover.1399317206.git.luto@amacapital.net>
References: <cover.1399317206.git.luto@amacapital.net>
In-Reply-To: <cover.1399317206.git.luto@amacapital.net>
References: <cover.1399317206.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The early_ioremap code requires that its buffers not span a PMD
boundary.  The logic for ensuring that only works if the fixmap is
aligned, so assert that it's aligned correctly.

To make this work reliably, reserve_top_address needs to be
adjusted.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/mm/ioremap.c | 6 ++++++
 arch/x86/mm/pgtable.c | 6 +++---
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 597ac15..6ef98c5 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -355,6 +355,12 @@ void __init early_ioremap_init(void)
 {
 	pmd_t *pmd;
 
+#ifdef CONFIG_X86_64
+	BUILD_BUG_ON((fix_to_virt(0) + PAGE_SIZE) & ((1 << PMD_SHIFT) - 1));
+#else
+	WARN_ON((fix_to_virt(0) + PAGE_SIZE) & ((1 << PMD_SHIFT) - 1));
+#endif
+
 	early_ioremap_setup();
 
 	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index c96314a..5f8bdda 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -449,9 +449,9 @@ void __init reserve_top_address(unsigned long reserve)
 {
 #ifdef CONFIG_X86_32
 	BUG_ON(fixmaps_set > 0);
-	printk(KERN_INFO "Reserving virtual address space above 0x%08x\n",
-	       (int)-reserve);
-	__FIXADDR_TOP = -reserve - PAGE_SIZE;
+	__FIXADDR_TOP = round_down(-reserve, 1 << PMD_SHIFT) - PAGE_SIZE;
+	printk(KERN_INFO "Reserving virtual address space above 0x%08lx (rounded to 0x%08lx)\n",
+	       -reserve, __FIXADDR_TOP + PAGE_SIZE);
 #endif
 }
 
-- 
1.9.0

