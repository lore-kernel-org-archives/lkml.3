Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbaHULcD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:32:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:4850 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724AbaHULbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:31:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,908,1400050800"; 
   d="scan'208";a="587969547"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 14/14] mei: use connect_data on the stack
Date: Thu, 21 Aug 2014 14:29:23 +0300
Message-Id: <1408620563-25834-14-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408620563-25834-1-git-send-email-tomas.winkler@intel.com>
References: <1408620563-25834-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need for dynamic allocation for connect_data.
We can use variable on the stack and make code less
error prone and simple

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/main.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 2f80c77..d60621e 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -433,9 +433,6 @@ static int mei_ioctl_connect_client(struct file *file,
 	int rets;
 
 	cl = file->private_data;
-	if (WARN_ON(!cl || !cl->dev))
-		return -ENODEV;
-
 	dev = cl->dev;
 
 	if (dev->dev_state != MEI_DEV_ENABLED) {
@@ -506,7 +503,6 @@ end:
 	return rets;
 }
 
-
 /**
  * mei_ioctl - the IOCTL function
  *
@@ -520,7 +516,7 @@ static long mei_ioctl(struct file *file, unsigned int cmd, unsigned long data)
 {
 	struct mei_device *dev;
 	struct mei_cl *cl = file->private_data;
-	struct mei_connect_client_data *connect_data = NULL;
+	struct mei_connect_client_data connect_data;
 	int rets;
 
 
@@ -540,26 +536,19 @@ static long mei_ioctl(struct file *file, unsigned int cmd, unsigned long data)
 	switch (cmd) {
 	case IOCTL_MEI_CONNECT_CLIENT:
 		dev_dbg(&dev->pdev->dev, ": IOCTL_MEI_CONNECT_CLIENT.\n");
-		connect_data = kzalloc(sizeof(struct mei_connect_client_data),
-							GFP_KERNEL);
-		if (!connect_data) {
-			rets = -ENOMEM;
-			goto out;
-		}
-
-		if (copy_from_user(connect_data, (char __user *)data,
+		if (copy_from_user(&connect_data, (char __user *)data,
 				sizeof(struct mei_connect_client_data))) {
 			dev_dbg(&dev->pdev->dev, "failed to copy data from userland\n");
 			rets = -EFAULT;
 			goto out;
 		}
 
-		rets = mei_ioctl_connect_client(file, connect_data);
+		rets = mei_ioctl_connect_client(file, &connect_data);
 		if (rets)
 			goto out;
 
 		/* if all is ok, copying the data back to user. */
-		if (copy_to_user((char __user *)data, connect_data,
+		if (copy_to_user((char __user *)data, &connect_data,
 				sizeof(struct mei_connect_client_data))) {
 			dev_dbg(&dev->pdev->dev, "failed to copy data to userland\n");
 			rets = -EFAULT;
@@ -567,13 +556,13 @@ static long mei_ioctl(struct file *file, unsigned int cmd, unsigned long data)
 		}
 
 		break;
+
 	default:
 		dev_err(&dev->pdev->dev, ": unsupported ioctl %d.\n", cmd);
 		rets = -ENOIOCTLCMD;
 	}
 
 out:
-	kfree(connect_data);
 	mutex_unlock(&dev->device_lock);
 	return rets;
 }
-- 
1.9.3

