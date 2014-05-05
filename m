Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440AbaEEWYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 18:24:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57334 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152AbaEEWYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 18:24:54 -0400
Date: Mon, 5 May 2014 15:24:31 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-73159fdcdb9be3eda61b846864352c29371baeb6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <e59a5f4362661f75dd4841fa74e1f2448045e245.1399317206.git.luto@amacapital.net>
References: <e59a5f4362661f75dd4841fa74e1f2448045e245.1399317206.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86, mm: Ensure correct alignment of the fixmap
Git-Commit-ID: 73159fdcdb9be3eda61b846864352c29371baeb6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  73159fdcdb9be3eda61b846864352c29371baeb6
Gitweb:     http://git.kernel.org/tip/73159fdcdb9be3eda61b846864352c29371baeb6
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Mon, 5 May 2014 12:19:31 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 5 May 2014 13:18:25 -0700

x86, mm: Ensure correct alignment of the fixmap

The early_ioremap code requires that its buffers not span a PMD
boundary.  The logic for ensuring that only works if the fixmap is
aligned, so assert that it's aligned correctly.

To make this work reliably, reserve_top_address needs to be
adjusted.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/e59a5f4362661f75dd4841fa74e1f2448045e245.1399317206.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
 
