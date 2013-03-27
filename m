Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab3C0XkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 19:40:05 -0400
Received: from mail-qe0-f74.google.com ([209.85.128.74]:37824 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab3C0XkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 19:40:03 -0400
From: Michael Spang <spang@chromium.org>
To: Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Spang <spang@chromium.org>
Subject: [PATCH] serial: samsung: Use printk instead of printascii for S3C_PMDBG
Date: Wed, 27 Mar 2013 19:39:58 -0400
Message-Id: <1364427598-17899-1-git-send-email-spang@chromium.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Users should use no_console_suspend if they want output during
suspend, rather than relying on DEBUG_LL. Using DEBUG_LL has two
disadvantages:

1. It doesn't respect power management. When the UART is suspended
   the clock is stopped, and trying to use DEBUG_LL will just hang.

   This means if the user selects CONFIG_SAMSUNG_PM_DEBUG but does
   NOT disable console suspend, the system will hang during suspend.

2. It skips syslog and other console devices such as pstore.

Signed-off-by: Michael Spang <spang@chromium.org>
---
 arch/arm/plat-samsung/include/plat/pm.h | 14 --------------
 arch/arm/plat-samsung/pm.c              | 13 -------------
 2 files changed, 27 deletions(-)

diff --git a/arch/arm/plat-samsung/include/plat/pm.h b/arch/arm/plat-samsung/include/plat/pm.h
index f6fcade..6d6e2a8 100644
--- a/arch/arm/plat-samsung/include/plat/pm.h
+++ b/arch/arm/plat-samsung/include/plat/pm.h
@@ -116,21 +116,7 @@ extern int s3c_irqext_wake(struct irq_data *data, unsigned int state);
 
 /* PM debug functions */
 
-#ifdef CONFIG_SAMSUNG_PM_DEBUG
-/**
- * s3c_pm_dbg() - low level debug function for use in suspend/resume.
- * @msg: The message to print.
- *
- * This function is used mainly to debug the resume process before the system
- * can rely on printk/console output. It uses the low-level debugging output
- * routine printascii() to do its work.
- */
-extern void s3c_pm_dbg(const char *msg, ...);
-
-#define S3C_PMDBG(fmt...) s3c_pm_dbg(fmt)
-#else
 #define S3C_PMDBG(fmt...) printk(KERN_DEBUG fmt)
-#endif
 
 #ifdef CONFIG_S3C_PM_DEBUG_LED_SMDK
 /**
diff --git a/arch/arm/plat-samsung/pm.c b/arch/arm/plat-samsung/pm.c
index 002b147..7459fc6 100644
--- a/arch/arm/plat-samsung/pm.c
+++ b/arch/arm/plat-samsung/pm.c
@@ -43,19 +43,6 @@ unsigned long s3c_pm_flags;
 */
 
 #ifdef CONFIG_SAMSUNG_PM_DEBUG
-extern void printascii(const char *);
-
-void s3c_pm_dbg(const char *fmt, ...)
-{
-	va_list va;
-	char buff[256];
-
-	va_start(va, fmt);
-	vsnprintf(buff, sizeof(buff), fmt, va);
-	va_end(va);
-
-	printascii(buff);
-}
 
 static inline void s3c_pm_debug_init(void)
 {
-- 
1.8.1.3

