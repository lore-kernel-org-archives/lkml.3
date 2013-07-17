Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab3GQMOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 08:14:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:55706 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666Ab3GQMOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 08:14:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,684,1367996400"; 
   d="scan'208";a="346987215"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc 3.11 4/4] mei: me: fix waiting for hw ready
Date: Wed, 17 Jul 2013 15:13:17 +0300
Message-Id: <1374063197-26855-5-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374063197-26855-1-git-send-email-tomas.winkler@intel.com>
References: <1374063197-26855-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. MEI_INTEROP_TIMEOUT is in seconds not in jiffies
so we use mei_secs_to_jiffies macro
While cold boot is fast this is relevant in resume
2. wait_event_interruptible_timeout can return with
-ERESTARTSYS so do not override it with -ETIMEDOUT
3.Adjust error message

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index a0e19e6..b22c7e2 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -239,14 +239,18 @@ static int mei_me_hw_ready_wait(struct mei_device *dev)
 	if (mei_me_hw_is_ready(dev))
 		return 0;
 
+	dev->recvd_hw_ready = false;
 	mutex_unlock(&dev->device_lock);
 	err = wait_event_interruptible_timeout(dev->wait_hw_ready,
-			dev->recvd_hw_ready, MEI_INTEROP_TIMEOUT);
+			dev->recvd_hw_ready,
+			mei_secs_to_jiffies(MEI_INTEROP_TIMEOUT));
 	mutex_lock(&dev->device_lock);
 	if (!err && !dev->recvd_hw_ready) {
+		if (!err)
+			err = -ETIMEDOUT;
 		dev_err(&dev->pdev->dev,
-			"wait hw ready failed. status = 0x%x\n", err);
-		return -ETIMEDOUT;
+			"wait hw ready failed. status = %d\n", err);
+		return err;
 	}
 
 	dev->recvd_hw_ready = false;
-- 
1.8.1.2

