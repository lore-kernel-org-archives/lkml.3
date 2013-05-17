Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab3EQVqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:46:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54312 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198Ab3EQVhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arkadiusz Miskiewicz <arekm@maven.pl>,
        Guenter Roeck <linux@roeck-us.net>, Wim Van Sebroeck <wim@iguana.be>
Subject: [ 076/102] watchdog: Fix race condition in registration code
Date: Fri, 17 May 2013 14:36:31 -0700
Message-Id: <20130517213252.311871344@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/watchdog/watchdog_dev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -523,6 +523,7 @@ int watchdog_dev_register(struct watchdo
 	int err, devno;
 
 	if (watchdog->id == 0) {
+		old_wdd = watchdog;
 		watchdog_miscdev.parent = watchdog->parent;
 		err = misc_register(&watchdog_miscdev);
 		if (err != 0) {
@@ -531,9 +532,9 @@ int watchdog_dev_register(struct watchdo
 			if (err == -EBUSY)
 				pr_err("%s: a legacy watchdog module is probably present.\n",
 					watchdog->info->identity);
+			old_wdd = NULL;
 			return err;
 		}
-		old_wdd = watchdog;
 	}
 
 	/* Fill in the data structures */


