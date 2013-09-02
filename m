Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757769Ab3IBAMF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 20:12:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:29144 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757609Ab3IBAMB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 20:12:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1003,1367996400"; 
   d="scan'208";a="395354858"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 3/5] mei: mei_write correct checks for copy_from_user
Date: Mon,  2 Sep 2013 03:11:02 +0300
Message-Id: <1378080664-7274-4-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1378080664-7274-1-git-send-email-tomas.winkler@intel.com>
References: <1378080664-7274-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

1. return -EFUALT when copy_from_user fails
2. display error message on failure in error level

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 173ff09..5ff810b 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -404,8 +404,11 @@ static ssize_t mei_write(struct file *file, const char __user *ubuf,
 		goto out;
 
 	rets = copy_from_user(write_cb->request_buffer.data, ubuf, length);
-	if (rets)
+	if (rets) {
+		dev_err(&dev->pdev->dev, "failed to copy data from userland\n");
+		rets = -EFAULT;
 		goto out;
+	}
 
 	if (cl == &dev->iamthif_cl) {
 		rets = mei_amthif_write(dev, write_cb);
@@ -567,7 +570,7 @@ static long mei_ioctl(struct file *file, unsigned int cmd, unsigned long data)
 	dev_dbg(&dev->pdev->dev, "copy connect data from user\n");
 	if (copy_from_user(connect_data, (char __user *)data,
 				sizeof(struct mei_connect_client_data))) {
-		dev_dbg(&dev->pdev->dev, "failed to copy data from userland\n");
+		dev_err(&dev->pdev->dev, "failed to copy data from userland\n");
 		rets = -EFAULT;
 		goto out;
 	}
-- 
1.8.3.1

