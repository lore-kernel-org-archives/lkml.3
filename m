Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab3EGOle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:41:34 -0400
Received: from relay3.sgi.com ([192.48.152.1]:49928 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755038Ab3EGOkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 10:40:39 -0400
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Russ Anderson <rja@sgi.com>, Russell King <linux@arm.linux.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH -v8 07/11] unicore32, prepare reboot_mode for moving to generic kernel code.
Date: Tue,  7 May 2013 09:39:51 -0500
Message-Id: <1367937595-32241-8-git-send-email-holt@sgi.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367937595-32241-1-git-send-email-holt@sgi.com>
References: <1367937595-32241-1-git-send-email-holt@sgi.com>
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
Cc: Russell King <linux@arm.linux.org.uk>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: the arch/x86 maintainers <x86@kernel.org>
Cc: Arm Mailing List <linux-arm-kernel@lists.infradead.org>
---
 arch/unicore32/kernel/process.c | 10 +++++-----
 arch/unicore32/kernel/setup.h   |  2 +-
 arch/unicore32/mm/mmu.c         |  2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/unicore32/kernel/process.c b/arch/unicore32/kernel/process.c
index c944769..9dc6e48 100644
--- a/arch/unicore32/kernel/process.c
+++ b/arch/unicore32/kernel/process.c
@@ -51,14 +51,14 @@ void arch_cpu_idle(void)
 	local_irq_enable();
 }
 
-static char reboot_mode = 'h';
+static enum reboot_mode reboot_mode;
 
 int __init reboot_setup(char *str)
 {
-	reboot_mode = str[0];
+	if ('s' == str[0])
+		reboot_mode = REBOOT_WARM;
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
+	if (reboot_mode == REBOOT_WARM) {
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
-- 
1.8.2.1

