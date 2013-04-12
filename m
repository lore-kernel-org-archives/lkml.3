Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab3DLGv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 02:51:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49381 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776Ab3DLGvz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 02:51:55 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "wim@iguana.be" <wim@iguana.be>
CC: "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] watchdog: fix cleanup device code on registration
Thread-Topic: [PATCH 2/2] watchdog: fix cleanup device code on registration
Thread-Index: Ac43SjRLQa28PaoHS3u5DAJMESPU8Q==
Date: Fri, 12 Apr 2013 06:51:48 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E4BBCA@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Duplicate lines of code are moved to cleanup_dev section.
And it returns 0 explicitly in case of no error.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/watchdog/watchdog_dev.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 42bfc9a..37c2dcc 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -613,11 +613,7 @@ int watchdog_dev_register(struct watchdog_device *watchdog)
 	if (err) {
 		pr_err("watchdog%d unable to add device %d:%d\n",
 			watchdog->id,  MAJOR(watchdog_devt), watchdog->id);
-		if (watchdog->id == 0) {
-			misc_deregister(&watchdog_miscdev);
-			old_wdd = NULL;
-		}
-		return err;
+		goto cleanup_dev;
 	}
 
 	/* Activate the watchdog automatically by the driver itself */
@@ -625,13 +621,17 @@ int watchdog_dev_register(struct watchdog_device *watchdog)
 		err = watchdog_auto_start(watchdog);
 		if (err) {
 			cdev_del(&watchdog->cdev);
-			if (watchdog->id == 0) {
-				misc_deregister(&watchdog_miscdev);
-				old_wdd = NULL;
-			}
+			goto cleanup_dev;
 		}
 	}
 
+	return 0;
+
+cleanup_dev:
+	if (watchdog->id == 0) {
+		misc_deregister(&watchdog_miscdev);
+		old_wdd = NULL;
+	}
 	return err;
 }
 
-- 
1.7.9.5


Best Regards,
Milo


