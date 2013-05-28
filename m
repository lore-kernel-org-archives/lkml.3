Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933957Ab3E1V0H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:26:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59818 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933709Ab3E1V0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:26:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Guenter Roeck <linux@roeck-us.net>, Wim Van Sebroeck <wim@iguana.be>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 54/78] watchdog: Fix race condition in registration code
Date: Tue, 28 May 2013 14:20:03 -0700
Message-Id: <1369776027-17859-55-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit 60403f7a4d9368d187f79cba5e4672d01df37574 upstream.

A race condition exists when registering the first watchdog device.
Sequence of events:

- watchdog_register_device calls watchdog_dev_register
- watchdog_dev_register creates the watchdog misc device by calling
  misc_register.
  At that time, the matching character device (/dev/watchdog0) does not yet
  exist, and old_wdd is not set either.
- Userspace gets an event and opens /dev/watchdog
- watchdog_open is called and sets wdd = old_wdd, which is still NULL,
  and tries to dereference it. This causes the kernel to panic.

Seen with systemd trying to open /dev/watchdog immediately after
it was created.

Reported-by: Arkadiusz Miskiewicz <arekm@maven.pl>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Arkadiusz Miskiewicz <arekm@maven.pl>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/watchdog/watchdog_dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index ef8edec..05a5310 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -524,6 +524,7 @@ int watchdog_dev_register(struct watchdog_device *watchdog)
 	int err, devno;
 
 	if (watchdog->id == 0) {
+		old_wdd = watchdog;
 		watchdog_miscdev.parent = watchdog->parent;
 		err = misc_register(&watchdog_miscdev);
 		if (err != 0) {
@@ -532,9 +533,9 @@ int watchdog_dev_register(struct watchdog_device *watchdog)
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
1.8.1.2

