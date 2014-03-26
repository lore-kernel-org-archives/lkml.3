Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbaCZDB5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 23:01:57 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:39956 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbaCZDB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 23:01:56 -0400
From: Daeseok Youn <daeseok.youn@gmail.com>
To: martyn.welch@ge.com, manohar.vanga@gmail.com, gregkh@linuxfoundation.org
Cc: asierra@xes-inc.com, lisa@xenapiadmin.com, yongjun_wei@trendmicro.com.cn,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: vme: fix memory leak in vme_user_probe()
Date: Wed, 26 Mar 2014 12:01:48 +0900
Message-ID: <3217679.sqG7Yrhs8H@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If vme_master_request() returns NULL when it failed,
it need to free buffers for master.

And also removes unreachable code in vme_user_probe().

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/vme/devices/vme_user.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index 7927927..ffb4eee 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -776,7 +776,8 @@ static int vme_user_probe(struct vme_dev *vdev)
 		image[i].kern_buf = kmalloc(image[i].size_buf, GFP_KERNEL);
 		if (image[i].kern_buf == NULL) {
 			err = -ENOMEM;
-			goto err_master_buf;
+			vme_master_free(image[i].resource);
+			goto err_master;
 		}
 	}
 
@@ -819,8 +820,6 @@ static int vme_user_probe(struct vme_dev *vdev)
 
 	return 0;
 
-	/* Ensure counter set correcty to destroy all sysfs devices */
-	i = VME_DEVS;
 err_sysfs:
 	while (i > 0) {
 		i--;
@@ -830,12 +829,10 @@ err_sysfs:
 
 	/* Ensure counter set correcty to unalloc all master windows */
 	i = MASTER_MAX + 1;
-err_master_buf:
-	for (i = MASTER_MINOR; i < (MASTER_MAX + 1); i++)
-		kfree(image[i].kern_buf);
 err_master:
 	while (i > MASTER_MINOR) {
 		i--;
+		kfree(image[i].kern_buf);
 		vme_master_free(image[i].resource);
 	}
 
-- 
1.7.4.4


