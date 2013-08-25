Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab3HYJwp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 05:52:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:34236 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756338Ab3HYJwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 05:52:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,951,1367996400"; 
   d="scan'208";a="351301665"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>, stable@vger.kernel.org
Subject: [3.10][PATCH 3/4] mei: me: fix waiting for hw ready
Date: Sun, 25 Aug 2013 12:49:48 +0300
Message-Id: <1377424189-5508-4-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377424189-5508-1-git-send-email-tomas.winkler@intel.com>
References: <1377424189-5508-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stable: 3.10
commit dab9bf41b23fe700c4a74133e41eb6a21706031e upstream


1. MEI_INTEROP_TIMEOUT is in seconds not in jiffies
so we use mei_secs_to_jiffies macro
While cold boot is fast this is relevant in resume
2. wait_event_interruptible_timeout can return with
-ERESTARTSYS so do not override it with -ETIMEDOUT
3.Adjust error message

Cc: stable@vger.kernel.org
Tested-by: Shuah Khan <shuah.kh@samsung.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 0310859..700fe55 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -238,14 +238,18 @@ static int mei_me_hw_ready_wait(struct mei_device *dev)
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

