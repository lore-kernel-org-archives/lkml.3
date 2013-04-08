Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965422Ab3DHPGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:06:55 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.105]:26927 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965002Ab3DHPGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:06:53 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-14.tower-201.messagelabs.com!1365433612!7207048!1
X-Originating-IP: [66.77.174.14]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
From: Hector Palacios <hector.palacios@digi.com>
To: <linux-watchdog@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux@roeck-us.net>, <wim@iguana.be>,
        <hector.palacios@digi.com>
Subject: [PATCH v3] watchdog: core: don't try to stop device if not running
Date: Mon, 8 Apr 2013 17:06:32 +0200
Message-ID: <1365433592-25687-1-git-send-email-hector.palacios@digi.com>
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
 - Make it less intrusive with 'if/else if' clauses.
 - Change the logic of 'err' variable for better readability of code.
 - Remove one-liner if brackets that broke coding sytle.
Changes from v2:
 - Revert "Change the logic of 'err'..." from v1 because otherwise the
   'else if' can't be reached if the watchdog is running.

 drivers/watchdog/watchdog_dev.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index ef8edec..6117c48 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -470,8 +470,10 @@ static int watchdog_release(struct inode *inode, struct file *file)
 	 * or if WDIOF_MAGICCLOSE is not set. If nowayout was set then
 	 * watchdog_stop will fail.
 	 */
-	if (test_and_clear_bit(WDOG_ALLOW_RELEASE, &wdd->status) ||
-	    !(wdd->info->options & WDIOF_MAGICCLOSE))
+	if (!test_bit(WDOG_ACTIVE, &wdd->status))
+		err = 0;
+	else if (test_and_clear_bit(WDOG_ALLOW_RELEASE, &wdd->status) ||
+		 !(wdd->info->options & WDIOF_MAGICCLOSE))
 		err = watchdog_stop(wdd);
 
 	/* If the watchdog was not stopped, send a keepalive ping */
-- 
1.8.2

