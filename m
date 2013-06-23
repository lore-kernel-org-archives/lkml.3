Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab3FWTvx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 15:51:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:63530 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902Ab3FWTvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 15:51:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,923,1363158000"; 
   d="scan'208";a="334281826"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: check whether hw start has succeeded
Date: Sun, 23 Jun 2013 22:49:04 +0300
Message-Id: <1372016944-19223-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hw start may fail therefore the reset flow has
to check for the return value

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/init.c    | 7 ++++++-
 drivers/misc/mei/mei_dev.h | 4 ++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/mei/init.c b/drivers/misc/mei/init.c
index 1525388..6fc573c 100644
--- a/drivers/misc/mei/init.c
+++ b/drivers/misc/mei/init.c
@@ -181,7 +181,12 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 		return;
 	}
 
-	mei_hw_start(dev);
+	ret = mei_hw_start(dev);
+	if (ret) {
+		dev_err(&dev->pdev->dev, "hw_start failed disabling the device\n");
+		dev->dev_state = MEI_DEV_DISABLED;
+		return;
+	}
 
 	dev_dbg(&dev->pdev->dev, "link is established start sending messages.\n");
 	/* link is established * start sending messages.  */
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 1aa4997..7b918b2 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -544,9 +544,9 @@ static inline int mei_hw_reset(struct mei_device *dev, bool enable)
 	return dev->ops->hw_reset(dev, enable);
 }
 
-static inline void mei_hw_start(struct mei_device *dev)
+static inline int mei_hw_start(struct mei_device *dev)
 {
-	dev->ops->hw_start(dev);
+	return dev->ops->hw_start(dev);
 }
 
 static inline void mei_clear_interrupts(struct mei_device *dev)
-- 
1.8.1.2

