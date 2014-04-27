Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577AbaD0MnR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 08:43:17 -0400
Received: from mga03.intel.com ([143.182.124.21]:53253 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbaD0MnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 08:43:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,937,1389772800"; 
   d="scan'208";a="424537409"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: set connecting state just upon connection request is sent to the fw
Date: Sun, 27 Apr 2014 15:42:21 +0300
Message-Id: <1398602541-15981-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Adding power gating introduced new waiting state for client also during
connection attempt, a connection request can be queued for later either due
device is power gated or due to other on going connection.
We setting client connection state before start of full connect procedure so
in both cased the client state will be MEI_FILE_CONNECTING
which create interlock between the two connection attempts, both
detecting that another connection is in progress.

The interlock is resolved by moving client to connecting state
only upon connection request transmission, so the  first
cb in queue can be processed.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c | 2 --
 drivers/misc/mei/bus.c    | 2 --
 drivers/misc/mei/client.c | 1 +
 drivers/misc/mei/main.c   | 1 -
 drivers/misc/mei/wd.c     | 2 --
 5 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index b8deb34..0d6234d 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -111,8 +111,6 @@ int mei_amthif_host_init(struct mei_device *dev)
 		return ret;
 	}
 
-	cl->state = MEI_FILE_CONNECTING;
-
 	ret = mei_cl_connect(cl, NULL);
 
 	dev->iamthif_state = MEI_IAMTHIF_IDLE;
diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index ddc5ac9..bac5d49 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -427,8 +427,6 @@ int mei_cl_enable_device(struct mei_cl_device *device)
 
 	mutex_lock(&dev->device_lock);
 
-	cl->state = MEI_FILE_CONNECTING;
-
 	err = mei_cl_connect(cl, NULL);
 	if (err < 0) {
 		mutex_unlock(&dev->device_lock);
diff --git a/drivers/misc/mei/client.c b/drivers/misc/mei/client.c
index 0c70459..684e3b5 100644
--- a/drivers/misc/mei/client.c
+++ b/drivers/misc/mei/client.c
@@ -597,6 +597,7 @@ int mei_cl_connect(struct mei_cl *cl, struct file *file)
 
 	/* run hbuf acquire last so we don't have to undo */
 	if (!mei_cl_is_other_connecting(cl) && mei_hbuf_acquire(dev)) {
+		cl->state = MEI_FILE_CONNECTING;
 		if (mei_hbm_cl_connect_req(dev, cl)) {
 			rets = -ENODEV;
 			goto out;
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 1474131..66f0a1a 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -467,7 +467,6 @@ static int mei_ioctl_connect_client(struct file *file,
 	}
 
 	cl->me_client_id = dev->me_clients[i].client_id;
-	cl->state = MEI_FILE_CONNECTING;
 
 	dev_dbg(&dev->pdev->dev, "Connect to FW Client ID = %d\n",
 			cl->me_client_id);
diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index ebf1cbc..a84a664 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -84,8 +84,6 @@ int mei_wd_host_init(struct mei_device *dev)
 		return ret;
 	}
 
-	cl->state = MEI_FILE_CONNECTING;
-
 	ret = mei_cl_connect(cl, NULL);
 
 	if (ret) {
-- 
1.9.0

