Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325Ab3HYJwO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 05:52:14 -0400
Received: from mga03.intel.com ([143.182.124.21]:34236 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756234Ab3HYJwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 05:52:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,951,1367996400"; 
   d="scan'208";a="351301658"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>, stable@vger.kernel.org
Subject: [3.10][PATCH 1/4] mei: me: fix reset state machine
Date: Sun, 25 Aug 2013 12:49:46 +0300
Message-Id: <1377424189-5508-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1377424189-5508-1-git-send-email-tomas.winkler@intel.com>
References: <1377424189-5508-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stable: 3.10
commit  315a383ad7dbd484fafb93ef08038e3dbafbb7a8 upstream


ME HW ready bit is down after hw reset was asserted or on error.
Only on error we need to enter the reset flow, additional reset
need to be prevented when reset was triggered during
initialization , power up/down or a reset is already in progress

Cc: stable@vger.kernel.org
Tested-by: Shuah Khan <shuah.kh@samsung.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 822170f..0310859 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -482,7 +482,9 @@ irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id)
 	/* check if ME wants a reset */
 	if (!mei_hw_is_ready(dev) &&
 	    dev->dev_state != MEI_DEV_RESETTING &&
-	    dev->dev_state != MEI_DEV_INITIALIZING) {
+	    dev->dev_state != MEI_DEV_INITIALIZING &&
+	    dev->dev_state != MEI_DEV_POWER_DOWN &&
+	    dev->dev_state != MEI_DEV_POWER_UP) {
 		dev_dbg(&dev->pdev->dev, "FW not ready.\n");
 		mei_reset(dev, 1);
 		mutex_unlock(&dev->device_lock);
-- 
1.8.1.2

