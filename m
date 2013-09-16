Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582Ab3IPUq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 16:46:58 -0400
Received: from mga03.intel.com ([143.182.124.21]:18077 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab3IPUqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 16:46:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,918,1371106800"; 
   d="scan'208";a="295571790"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 5/7] mei: simplify mei_open error handling
Date: Mon, 16 Sep 2013 23:44:46 +0300
Message-Id: <1379364288-16374-6-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379364288-16374-1-git-send-email-tomas.winkler@intel.com>
References: <1379364288-16374-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Perform simple checks first and only then attempt to allocate cl structure.
2. Remove open_handler_count test, this is already checked in mei_cl_link function
3. return -EMFILE instead of -ENOENT as expected by user space

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/client.c |  8 +++++++-
 drivers/misc/mei/main.c   | 31 ++++++++++++++-----------------
 2 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 653b318..f62bf76 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -288,7 +288,13 @@ int mei_cl_link(struct mei_cl *cl, int id)
 
 	if (id >= MEI_CLIENTS_MAX) {
 		dev_err(&dev->pdev->dev, "id exceded %d", MEI_CLIENTS_MAX) ;
-		return -ENOENT;
+		return -EMFILE;
+	}
+
+	if (dev->open_handle_count >= MEI_MAX_OPEN_HANDLE_COUNT) {
+		dev_err(&dev->pdev->dev, "open_handle_count exceded %d",
+			MEI_MAX_OPEN_HANDLE_COUNT);
+		return -EMFILE;
 	}
 
 	dev->open_handle_count++;
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index c71420e..87ab5ca 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -60,48 +60,45 @@ static int mei_open(struct inode *inode, struct file *file)
 
 	int err;
 
-	err = -ENODEV;
 	if (!misc->parent)
-		goto out;
+		return -ENODEV;
 
 	pdev = container_of(misc->parent, struct pci_dev, dev);
 
 	dev = pci_get_drvdata(pdev);
 	if (!dev)
-		goto out;
+		return -ENODEV;
 
 	mutex_lock(&dev->device_lock);
-	err = -ENOMEM;
-	cl = mei_cl_allocate(dev);
-	if (!cl)
-		goto out_unlock;
+
+	cl = NULL;
 
 	err = -ENODEV;
 	if (dev->dev_state != MEI_DEV_ENABLED) {
 		dev_dbg(&dev->pdev->dev, "dev_state != MEI_ENABLED  dev_state = %s\n",
 		    mei_dev_state_str(dev->dev_state));
-		goto out_unlock;
-	}
-	err = -EMFILE;
-	if (dev->open_handle_count >= MEI_MAX_OPEN_HANDLE_COUNT) {
-		dev_err(&dev->pdev->dev, "open_handle_count exceded %d",
-			MEI_MAX_OPEN_HANDLE_COUNT);
-		goto out_unlock;
+		goto err_unlock;
 	}
 
+	err = -ENOMEM;
+	cl = mei_cl_allocate(dev);
+	if (!cl)
+		goto err_unlock;
+
+	/* open_handle_count check is handled in the mei_cl_link */
 	err = mei_cl_link(cl, MEI_HOST_CLIENT_ID_ANY);
 	if (err)
-		goto out_unlock;
+		goto err_unlock;
 
 	file->private_data = cl;
+
 	mutex_unlock(&dev->device_lock);
 
 	return nonseekable_open(inode, file);
 
-out_unlock:
+err_unlock:
 	mutex_unlock(&dev->device_lock);
 	kfree(cl);
-out:
 	return err;
 }
 
-- 
1.8.3.1

