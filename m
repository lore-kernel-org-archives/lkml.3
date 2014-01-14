Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbaANIWz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 03:22:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbaANIWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 03:22:54 -0500
Date: Tue, 14 Jan 2014 16:23:23 +0800
From: Dave Young <dyoung@redhat.com>
To: wim@iguana.be
Cc: dzickus@redhat.com, bhe@redhat.com, vgoyal@redhat.com,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] watchdog: add a parameter for stop wdt before register
Message-ID: <20140114082323.GA4485@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kdump kernel watchdog could interrupt vmcore capturing because we
have no way to disable/stop it while crashing happens.

Add a module parameter stop_before_register so watchdog can be stopped
before register in driver loading path. Thus we can try to load the
watchdog driver as early as possible in kdump kernel to ensure vmcore
capturing.

Don Zickus mentioned that there's the case that bios start the watchdog
and it is expected that the kernel keep the watchdog alive. To address
this case I added the module parameter which is false by default so
it will stop the watchdog only when user provice kernel cmdline
"watchdog.stop_before_register=1".  

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 drivers/watchdog/watchdog_core.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- linux.orig/drivers/watchdog/watchdog_core.c
+++ linux/drivers/watchdog/watchdog_core.c
@@ -42,6 +42,7 @@
 
 static DEFINE_IDA(watchdog_ida);
 static struct class *watchdog_class;
+static bool stop_before_register;
 
 static void watchdog_check_min_max_timeout(struct watchdog_device *wdd)
 {
@@ -119,6 +120,9 @@ int watchdog_register_device(struct watc
 	if (wdd->ops->start == NULL || wdd->ops->stop == NULL)
 		return -EINVAL;
 
+	if (stop_before_register)
+		wdd->ops->stop(wdd);
+
 	watchdog_check_min_max_timeout(wdd);
 
 	/*
@@ -220,6 +224,8 @@ static void __exit watchdog_exit(void)
 subsys_initcall(watchdog_init);
 module_exit(watchdog_exit);
 
+module_param(stop_before_register, bool, 0644);
+
 MODULE_AUTHOR("Alan Cox <alan@lxorguk.ukuu.org.uk>");
 MODULE_AUTHOR("Wim Van Sebroeck <wim@iguana.be>");
 MODULE_DESCRIPTION("WatchDog Timer Driver Core");
