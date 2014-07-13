Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbaGMPb2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 11:31:28 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:42867 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbaGMPa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 11:30:59 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-watchdog@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Wim Van Sebroeck <wim@iguana.be>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jonas Jensen <jonas.jensen@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Tomasz Figa <t.figa@samsung.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH v4 6/7] watchdog: alim7101: Register restart handler with restart notifier
Date: Sun, 13 Jul 2014 08:30:30 -0700
Message-Id: <1405265431-4561-7-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405265431-4561-1-git-send-email-linux@roeck-us.net>
References: <1405265431-4561-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel core now provides an API to trigger a system restart.
Register with it to restart the system instead of misusing the
reboot notifier.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v4: Set restart notifier priority to 128.
v3: No change
v2: No change

 drivers/watchdog/alim7101_wdt.c | 42 +++++++++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/watchdog/alim7101_wdt.c b/drivers/watchdog/alim7101_wdt.c
index 996b2f7..069c2e2 100644
--- a/drivers/watchdog/alim7101_wdt.c
+++ b/drivers/watchdog/alim7101_wdt.c
@@ -301,6 +301,28 @@ static struct miscdevice wdt_miscdev = {
 	.fops	=	&wdt_fops,
 };
 
+static int wdt_restart_notify(struct notifier_block *this, unsigned long mode,
+			      void *cmd)
+{
+	/*
+	 * Cobalt devices have no way of rebooting themselves other
+	 * than getting the watchdog to pull reset, so we restart the
+	 * watchdog on reboot with no heartbeat.
+	 */
+	wdt_change(WDT_ENABLE);
+
+	/* loop until the watchdog fires */
+	while (true)
+		;
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block wdt_restart_notifier = {
+	.notifier_call = wdt_restart_notify,
+	.priority = 128,
+};
+
 /*
  *	Notifier for system down
  */
@@ -311,15 +333,6 @@ static int wdt_notify_sys(struct notifier_block *this,
 	if (code == SYS_DOWN || code == SYS_HALT)
 		wdt_turnoff();
 
-	if (code == SYS_RESTART) {
-		/*
-		 * Cobalt devices have no way of rebooting themselves other
-		 * than getting the watchdog to pull reset, so we restart the
-		 * watchdog on reboot with no heartbeat
-		 */
-		wdt_change(WDT_ENABLE);
-		pr_info("Watchdog timer is now enabled with no heartbeat - should reboot in ~1 second\n");
-	}
 	return NOTIFY_DONE;
 }
 
@@ -338,6 +351,7 @@ static void __exit alim7101_wdt_unload(void)
 	/* Deregister */
 	misc_deregister(&wdt_miscdev);
 	unregister_reboot_notifier(&wdt_notifier);
+	unregister_restart_notifier(&wdt_restart_notifier);
 	pci_dev_put(alim7101_pmu);
 }
 
@@ -390,11 +404,17 @@ static int __init alim7101_wdt_init(void)
 		goto err_out;
 	}
 
+	rc = register_restart_notifier(&wdt_restart_notifier);
+	if (rc) {
+		pr_err("cannot register reboot notifier (err=%d)\n", rc);
+		goto err_out_reboot;
+	}
+
 	rc = misc_register(&wdt_miscdev);
 	if (rc) {
 		pr_err("cannot register miscdev on minor=%d (err=%d)\n",
 		       wdt_miscdev.minor, rc);
-		goto err_out_reboot;
+		goto err_out_restart;
 	}
 
 	if (nowayout)
@@ -404,6 +424,8 @@ static int __init alim7101_wdt_init(void)
 		timeout, nowayout);
 	return 0;
 
+err_out_restart:
+	unregister_restart_notifier(&wdt_restart_notifier);
 err_out_reboot:
 	unregister_reboot_notifier(&wdt_notifier);
 err_out:
-- 
1.9.1

