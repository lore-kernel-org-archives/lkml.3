Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161968Ab3DEQK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 12:10:57 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.97]:30099 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161930Ab3DEQK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 12:10:56 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-11.tower-200.messagelabs.com!1365178254!11790719!1
X-Originating-IP: [66.77.174.13]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <515EF748.6060504@digi.com>
Date: Fri, 5 Apr 2013 18:09:44 +0200
From: Hector Palacios <hector.palacios@digi.com>
Organization: Digi International
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: <linux-watchdog@vger.kernel.org>, <wim@iguana.be>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC] watchdog: core: don't try to stop device if not running
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
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
  drivers/watchdog/watchdog_dev.c |   38 +++++++++++++++++++++-----------------
  1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index ef8edec..adadbdd 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -463,24 +463,28 @@ out:
  static int watchdog_release(struct inode *inode, struct file *file)
  {
  	struct watchdog_device *wdd = file->private_data;
-	int err = -EBUSY;

-	/*
-	 * We only stop the watchdog if we received the magic character
-	 * or if WDIOF_MAGICCLOSE is not set. If nowayout was set then
-	 * watchdog_stop will fail.
-	 */
-	if (test_and_clear_bit(WDOG_ALLOW_RELEASE, &wdd->status) ||
-	    !(wdd->info->options & WDIOF_MAGICCLOSE))
-		err = watchdog_stop(wdd);
-
-	/* If the watchdog was not stopped, send a keepalive ping */
-	if (err < 0) {
-		mutex_lock(&wdd->lock);
-		if (!test_bit(WDOG_UNREGISTERED, &wdd->status))
-			dev_crit(wdd->dev, "watchdog did not stop!\n");
-		mutex_unlock(&wdd->lock);
-		watchdog_ping(wdd);
+	if (test_bit(WDOG_ACTIVE, &wdd->status)) {
+		int err = -EBUSY;
+
+		/*
+		 * We only stop the watchdog if we received the magic character
+		 * or if WDIOF_MAGICCLOSE is not set. If nowayout was set then
+		 * watchdog_stop will fail.
+		 */
+		if (test_and_clear_bit(WDOG_ALLOW_RELEASE, &wdd->status) ||
+		    !(wdd->info->options & WDIOF_MAGICCLOSE)) {
+			err = watchdog_stop(wdd);
+		}
+
+		/* If the watchdog was not stopped, send a keepalive ping */
+		if (err < 0) {
+			mutex_lock(&wdd->lock);
+			if (!test_bit(WDOG_UNREGISTERED, &wdd->status))
+				dev_crit(wdd->dev, "watchdog did not stop!\n");
+			mutex_unlock(&wdd->lock);
+			watchdog_ping(wdd);
+		}
  	}

  	/* Allow the owner module to be unloaded again */
-- 
1.7.9.5
