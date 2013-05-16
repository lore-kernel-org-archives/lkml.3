Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872Ab3EPQR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 12:17:28 -0400
Received: from relay3.sgi.com ([192.48.152.1]:57136 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754622Ab3EPQPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 12:15:12 -0400
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Russ Anderson <rja@sgi.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH -v11 resend 07/11] unicore32, prepare reboot_mode for moving to generic kernel code.
Date: Thu, 16 May 2013 11:14:46 -0500
Message-Id: <1368720890-57711-8-git-send-email-holt@sgi.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368720890-57711-1-git-send-email-holt@sgi.com>
References: <1368720890-57711-1-git-send-email-holt@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prepares for the moving the parsing of reboot= to the generic
kernel code by making reboot_mode into a more generic form.

Signed-off-by: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Russ Anderson <rja@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: the arch/x86 maintainers <x86@kernel.org>
Cc: Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Acked-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---

Changes since -v8
 - Switched from using REBOOT_WARM/COLD to HARD/SOFT.
---
 arch/unicore32/kernel/process.c | 10 +++++-----
 arch/unicore32/kernel/setup.h   |  2 +-
 arch/unicore32/mm/mmu.c         |  2 +-
 include/linux/reboot.h          |  2 ++
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/unicore32/kernel/process.c b/arch/unicore32/kernel/process.c
index c944769..93dd035 100644
--- a/arch/unicore32/kernel/process.c
+++ b/arch/unicore32/kernel/process.c
@@ -51,14 +51,14 @@ void arch_cpu_idle(void)
 	local_irq_enable();
 }
 
-static char reboot_mode = 'h';
+static enum reboot_mode reboot_mode = REBOOT_HARD;
 
 int __init reboot_setup(char *str)
 {
-	reboot_mode = str[0];
+	if ('s' == str[0])
+		reboot_mode = REBOOT_SOFT;
 	return 1;
 }
-
 __setup("reboot=", reboot_setup);
 
 void machine_halt(void)
@@ -88,7 +88,7 @@ void machine_restart(char *cmd)
 	 * we may need it to insert some 1:1 mappings so that
 	 * soft boot works.
 	 */
-	setup_mm_for_reboot(reboot_mode);
+	setup_mm_for_reboot();
 
 	/* Clean and invalidate caches */
 	flush_cache_all();
@@ -102,7 +102,7 @@ void machine_restart(char *cmd)
 	/*
 	 * Now handle reboot code.
 	 */
-	if (reboot_mode == 's') {
+	if (reboot_mode == REBOOT_SOFT) {
 		/* Jump into ROM at address 0xffff0000 */
 		cpu_reset(VECTORS_BASE);
 	} else {
diff --git a/arch/unicore32/kernel/setup.h b/arch/unicore32/kernel/setup.h
index 30f749d..f5c51b8 100644
--- a/arch/unicore32/kernel/setup.h
+++ b/arch/unicore32/kernel/setup.h
@@ -22,7 +22,7 @@ extern void puv3_ps2_init(void);
 extern void pci_puv3_preinit(void);
 extern void __init puv3_init_gpio(void);
 
-extern void setup_mm_for_reboot(char mode);
+extern void setup_mm_for_reboot(void);
 
 extern char __stubs_start[], __stubs_end[];
 extern char __vectors_start[], __vectors_end[];
diff --git a/arch/unicore32/mm/mmu.c b/arch/unicore32/mm/mmu.c
index 43c20b4..4f5a532 100644
--- a/arch/unicore32/mm/mmu.c
+++ b/arch/unicore32/mm/mmu.c
@@ -445,7 +445,7 @@ void __init paging_init(void)
  * the user-mode pages.  This will then ensure that we have predictable
  * results when turning the mmu off
  */
-void setup_mm_for_reboot(char mode)
+void setup_mm_for_reboot(void)
 {
 	unsigned long base_pmdval;
 	pgd_t *pgd;
diff --git a/include/linux/reboot.h b/include/linux/reboot.h
index 37d56c3..ca29a6f 100644
--- a/include/linux/reboot.h
+++ b/include/linux/reboot.h
@@ -13,6 +13,8 @@
 enum reboot_mode {
 	REBOOT_COLD = 0,
 	REBOOT_WARM,
+	REBOOT_HARD,
+	REBOOT_SOFT,
 };
 
 extern int register_reboot_notifier(struct notifier_block *);
-- 
1.8.2.1

