Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbaHYVy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 17:54:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:11405 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbaHYVyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 17:54:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,398,1406617200"; 
   d="scan'208";a="563299546"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 01/10] mei: enable adding more IOCTL handlers
Date: Tue, 26 Aug 2014 00:53:19 +0300
Message-Id: <1409003608-30274-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle ioctls in a switch statement so we can
add more commands easily

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/main.c | 53 ++++++++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 25 deletions(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 957f44a..2f80c77 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -523,8 +523,6 @@ static long mei_ioctl(struct file *file, unsigned int cmd, unsigned long data)
 	struct mei_connect_client_data *connect_data = NULL;
 	int rets;
 
-	if (cmd != IOCTL_MEI_CONNECT_CLIENT)
-		return -EINVAL;
 
 	if (WARN_ON(!cl || !cl->dev))
 		return -ENODEV;
@@ -539,34 +537,39 @@ static long mei_ioctl(struct file *file, unsigned int cmd, unsigned long data)
 		goto out;
 	}
 
-	dev_dbg(&dev->pdev->dev, ": IOCTL_MEI_CONNECT_CLIENT.\n");
-
-	connect_data = kzalloc(sizeof(struct mei_connect_client_data),
+	switch (cmd) {
+	case IOCTL_MEI_CONNECT_CLIENT:
+		dev_dbg(&dev->pdev->dev, ": IOCTL_MEI_CONNECT_CLIENT.\n");
+		connect_data = kzalloc(sizeof(struct mei_connect_client_data),
 							GFP_KERNEL);
-	if (!connect_data) {
-		rets = -ENOMEM;
-		goto out;
-	}
-	dev_dbg(&dev->pdev->dev, "copy connect data from user\n");
-	if (copy_from_user(connect_data, (char __user *)data,
-				sizeof(struct mei_connect_client_data))) {
-		dev_dbg(&dev->pdev->dev, "failed to copy data from userland\n");
-		rets = -EFAULT;
-		goto out;
-	}
+		if (!connect_data) {
+			rets = -ENOMEM;
+			goto out;
+		}
 
-	rets = mei_ioctl_connect_client(file, connect_data);
+		if (copy_from_user(connect_data, (char __user *)data,
+				sizeof(struct mei_connect_client_data))) {
+			dev_dbg(&dev->pdev->dev, "failed to copy data from userland\n");
+			rets = -EFAULT;
+			goto out;
+		}
 
-	/* if all is ok, copying the data back to user. */
-	if (rets)
-		goto out;
+		rets = mei_ioctl_connect_client(file, connect_data);
+		if (rets)
+			goto out;
 
-	dev_dbg(&dev->pdev->dev, "copy connect data to user\n");
-	if (copy_to_user((char __user *)data, connect_data,
+		/* if all is ok, copying the data back to user. */
+		if (copy_to_user((char __user *)data, connect_data,
 				sizeof(struct mei_connect_client_data))) {
-		dev_dbg(&dev->pdev->dev, "failed to copy data to userland\n");
-		rets = -EFAULT;
-		goto out;
+			dev_dbg(&dev->pdev->dev, "failed to copy data to userland\n");
+			rets = -EFAULT;
+			goto out;
+		}
+
+		break;
+	default:
+		dev_err(&dev->pdev->dev, ": unsupported ioctl %d.\n", cmd);
+		rets = -ENOIOCTLCMD;
 	}
 
 out:
-- 
1.9.3

