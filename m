Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374Ab3FCWN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 18:13:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2298 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759088Ab3FCWMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 18:12:35 -0400
X-Authority-Analysis: v=2.0 cv=BcJaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=ckvJjgcNJdAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KbHWfzvD86IA:10 a=_jlGtV7tAAAA:8 a=u6Kjp6XQMGfe5Rn6x1sA:9 a=L1RTw_NLzc0A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130603221159.981651136@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 03 Jun 2013 18:11:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Arkadiusz Miskiewicz <arekm@maven.pl>, Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@iguana.be>
Subject: [45/65] watchdog: Fix race condition in registration code
References: <20130603221016.243553628@goodmis.org>
Content-Disposition: inline; filename=0045-watchdog-Fix-race-condition-in-registration-code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.5 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 60403f7a4d9368d187f79cba5e4672d01df37574 ]

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/watchdog/watchdog_dev.c |    3 ++-
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
1.7.10.4


