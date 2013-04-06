Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461Ab3DFEYi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 00:24:38 -0400
Received: from mail.active-venture.com ([67.228.131.205]:57131 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab3DFEYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 00:24:37 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Fri, 05 Apr 2013 23:24:37 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: linux-watchdog@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Wim Van Sebroeck <wim@iguana.be>,
        Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] watchdog: Fix race condition in registration code
Date: Fri,  5 Apr 2013 21:22:43 -0700
Message-Id: <1365222163-26761-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A race condition exists when registering the first watchdog device.
Sequence of events:

- watchdog_register_device calls watchdog_dev_register
- watchdog_dev_register creates the watchdog misc device by calling
  misc_register.
  At that time, the matching character device (/dev/watchdog0) does not yet
  exist, and old_wdd is not set either.
- Userspace gets an event and opens /dev/watchdog
- watchdog_open is called and sets sets wdd = old_wdd, which is still NULL,
  and tries to dereference it. This causes the kernel to panic.

Seen with systemd trying to open /dev/watchdog immediately after
it was created.

Reported-by: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
Arkadiusz,

would be great if you can test this in your system.

 drivers/watchdog/watchdog_dev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 08b48bb..faf4e18 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -523,6 +523,7 @@ int watchdog_dev_register(struct watchdog_device *watchdog)
 	int err, devno;
 
 	if (watchdog->id == 0) {
+		old_wdd = watchdog;
 		watchdog_miscdev.parent = watchdog->parent;
 		err = misc_register(&watchdog_miscdev);
 		if (err != 0) {
@@ -531,9 +532,9 @@ int watchdog_dev_register(struct watchdog_device *watchdog)
 			if (err == -EBUSY)
 				pr_err("%s: a legacy watchdog module is probably present.\n",
 					watchdog->info->identity);
+			old_wdd = NULL;
 			return err;
 		}
-		old_wdd = watchdog;
 	}
 
 	/* Fill in the data structures */
-- 
1.7.9.7

