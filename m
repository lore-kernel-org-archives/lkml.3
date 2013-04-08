Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934786Ab3DHJMZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:12:25 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.197]:17880 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760532Ab3DHJMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:12:20 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-12.tower-45.messagelabs.com!1365412337!27657729!1
X-Originating-IP: [66.77.174.13]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
From: Hector Palacios <hector.palacios@digi.com>
To: <linux-watchdog@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux@roeck-us.net>, <wim@iguana.be>,
        <hector.palacios@digi.com>
Subject: [PATCH v2] watchdog: core: don't try to stop device if not running
Date: Mon, 8 Apr 2013 11:10:58 +0200
Message-ID: <1365412258-10785-1-git-send-email-hector.palacios@digi.com>
X-Mailer: git-send-email 1.8.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A watchdog device may be stopped from userspace using WDIOC_SETOPTIONS
ioctl and flag WDIOS_DISABLECARD. If the device is closed after this
operation, watchdog_release() is called and status bits checked for
stopping it. Besides, if the device has not been unregistered a critical
message "watchdog did not stop!" is printed, although the ioctl may have
successfully stopped it already.

Without the patch a user application sample code like this will successfully
stop the watchdog, but the kernel will output the message
"watchdog did not stop!":

	wd_fd = open("/dev/watchdog", O_RDWR);

	flags = WDIOS_DISABLECARD;
	ioctl(wd_fd, WDIOC_SETOPTIONS, &flags);

	close(wd_fd);

Signed-off-by: Hector Palacios <hector.palacios@digi.com>
---

Changes from v1:
- Make it less intrusive with 'if/else if' clauses
- Change the logic of 'err' variable for better readability of code
- Remove one-liner if brackets that broke coding sytle

 drivers/watchdog/watchdog_dev.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index ef8edec..8e0f1b8 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -463,15 +463,17 @@ out:
 static int watchdog_release(struct inode *inode, struct file *file)
 {
 	struct watchdog_device *wdd = file->private_data;
-	int err = -EBUSY;
+	int err = 0;
 
 	/*
 	 * We only stop the watchdog if we received the magic character
 	 * or if WDIOF_MAGICCLOSE is not set. If nowayout was set then
 	 * watchdog_stop will fail.
 	 */
-	if (test_and_clear_bit(WDOG_ALLOW_RELEASE, &wdd->status) ||
-	    !(wdd->info->options & WDIOF_MAGICCLOSE))
+	if (test_bit(WDOG_ACTIVE, &wdd->status))
+		err = -EBUSY;
+	else if (test_and_clear_bit(WDOG_ALLOW_RELEASE, &wdd->status) ||
+		 !(wdd->info->options & WDIOF_MAGICCLOSE))
 		err = watchdog_stop(wdd);
 
 	/* If the watchdog was not stopped, send a keepalive ping */
-- 
1.8.2

