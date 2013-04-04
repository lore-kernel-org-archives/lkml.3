Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab3DDEj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 00:39:58 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:52746 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078Ab3DDEj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 00:39:56 -0400
From: Tony Chung <tonychung00@gmail.com>
To: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tony Chung <tonychung00@gmail.com>
Subject: [PATCH v3 1/2] watchdog: improve w83627hf_wdt to timeout in minute
Date: Wed,  3 Apr 2013 21:39:43 -0700
Message-Id: <1365050384-9130-1-git-send-email-tonychung00@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Watchdog should support timeout in minutes.
For example, crash dump will usually require 5+ minutes.

This patch increase the timeout from 255 seconds to (255*60) seconds and should be good for older LTS releases.
This patch need to be rewritten again when this driver migrate to new watchdog infrastructure.

Added a new max_timeout variable so we can change it if needed.

Signed-off-by: Tony Chung <tonychung00@gmail.com>
---
 drivers/watchdog/w83627hf_wdt.c |   74 ++++++++++++++++++++++++++++++--------
 1 files changed, 58 insertions(+), 16 deletions(-)

diff --git a/drivers/watchdog/w83627hf_wdt.c b/drivers/watchdog/w83627hf_wdt.c
index 92f1326..8f1111d 100644
--- a/drivers/watchdog/w83627hf_wdt.c
+++ b/drivers/watchdog/w83627hf_wdt.c
@@ -45,6 +45,7 @@
 
 #define WATCHDOG_NAME "w83627hf/thf/hg/dhg WDT"
 #define WATCHDOG_TIMEOUT 60		/* 60 sec default timeout */
+#define WATCHDOG_MAX_TIMEOUT	(60 * 255)
 
 static unsigned long wdt_is_open;
 static char expect_close;
@@ -55,11 +56,14 @@ static int wdt_io = 0x2E;
 module_param(wdt_io, int, 0);
 MODULE_PARM_DESC(wdt_io, "w83627hf/thf WDT io port (default 0x2E)");
 
+static bool use_minute; /* timeout unit in minutes if set */
+static const int max_timeout = WATCHDOG_MAX_TIMEOUT;
 static int timeout = WATCHDOG_TIMEOUT;	/* in seconds */
 module_param(timeout, int, 0);
 MODULE_PARM_DESC(timeout,
-		"Watchdog timeout in seconds. 1 <= timeout <= 255, default="
-				__MODULE_STRING(WATCHDOG_TIMEOUT) ".");
+		"Watchdog timeout in seconds. 1<= timeout <="
+			__MODULE_STRING(WATCHDOG_MAX_TIMEOUT) " (default="
+			__MODULE_STRING(WATCHDOG_TIMEOUT) ")");
 
 static bool nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, bool, 0);
@@ -107,6 +111,48 @@ static void w83627hf_unselect_wd_register(void)
 	outb_p(0xAA, WDT_EFER); /* Leave extended function mode */
 }
 
+/* setup CRF5 register */
+static void w83627hf_setup_crf5(void)
+{
+	unsigned char t;
+
+	outb_p(0xF5, WDT_EFER); /* Select CRF5 */
+	t = inb_p(WDT_EFDR);      /* read CRF5 */
+	t &= ~0x0C;               /* set second mode & disable keyboard
+				    turning off watchdog */
+	t |= 0x02;		  /* enable the WDTO# output low pulse
+				    to the KBRST# pin (PIN60) */
+	if (use_minute)
+		t |= 0x8;        /* set timeout in minute */
+
+	outb_p(t, WDT_EFDR);    /* Write back to CRF5 */
+}
+
+/* set use_minute if t > 255 */
+static inline int wdt_use_minute(int t)
+{
+	if (t > 255) {
+		t = DIV_ROUND_UP(t, 60); /* convert secs to minutes */
+		use_minute = 1;
+	} else {
+		use_minute = 0;
+	}
+
+	/* setup CRF5 for new timeout unit */
+	w83627hf_select_wd_register();
+	w83627hf_setup_crf5();
+	w83627hf_unselect_wd_register();
+
+	return t;
+}
+
+/* convert specified value to seconds if use_minute is set */
+static inline int wdt_get_timeout_secs(int t)
+{
+	return (use_minute) ? (t * 60) : t;
+}
+
+
 /* tyan motherboards seem to set F5 to 0x4C ?
  * So explicitly init to appropriate value. */
 
@@ -120,17 +166,11 @@ static void w83627hf_init(void)
 	t = inb_p(WDT_EFDR);      /* read CRF6 */
 	if (t != 0) {
 		pr_info("Watchdog already running. Resetting timeout to %d sec\n",
-			timeout);
+			wdt_get_timeout_secs(timeout));
 		outb_p(timeout, WDT_EFDR);    /* Write back to CRF6 */
 	}
 
-	outb_p(0xF5, WDT_EFER); /* Select CRF5 */
-	t = inb_p(WDT_EFDR);      /* read CRF5 */
-	t &= ~0x0C;               /* set second mode & disable keyboard
-				    turning off watchdog */
-	t |= 0x02;		  /* enable the WDTO# output low pulse
-				    to the KBRST# pin (PIN60) */
-	outb_p(t, WDT_EFDR);    /* Write back to CRF5 */
+	w83627hf_setup_crf5();
 
 	outb_p(0xF7, WDT_EFER); /* Select CRF7 */
 	t = inb_p(WDT_EFDR);      /* read CRF7 */
@@ -169,9 +209,9 @@ static int wdt_disable(void)
 
 static int wdt_set_heartbeat(int t)
 {
-	if (t < 1 || t > 255)
+	if (t < 1 || t > max_timeout)
 		return -EINVAL;
-	timeout = t;
+	timeout = wdt_use_minute(t);
 	return 0;
 }
 
@@ -190,7 +230,7 @@ static int wdt_get_time(void)
 
 	spin_unlock(&io_lock);
 
-	return timeleft;
+	return wdt_get_timeout_secs(timeleft);
 }
 
 static ssize_t wdt_write(struct file *file, const char __user *buf,
@@ -262,7 +302,8 @@ static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		wdt_ping();
 		/* Fall */
 	case WDIOC_GETTIMEOUT:
-		return put_user(timeout, p);
+		timeval = wdt_get_timeout_secs(timeout);
+		return put_user(timeval, p);
 	case WDIOC_GETTIMELEFT:
 		timeval = wdt_get_time();
 		return put_user(timeval, p);
@@ -346,7 +387,8 @@ static int __init wdt_init(void)
 
 	if (wdt_set_heartbeat(timeout)) {
 		wdt_set_heartbeat(WATCHDOG_TIMEOUT);
-		pr_info("timeout value must be 1 <= timeout <= 255, using %d\n",
+		pr_info("timeout value must be 1 <= timeout <= %d, using %d\n",
+			max_timeout,
 			WATCHDOG_TIMEOUT);
 	}
 
@@ -372,7 +414,7 @@ static int __init wdt_init(void)
 	}
 
 	pr_info("initialized. timeout=%d sec (nowayout=%d)\n",
-		timeout, nowayout);
+		wdt_get_timeout_secs(timeout), nowayout);
 
 out:
 	return ret;
-- 
1.7.0.4

