Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478Ab3GQMOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 08:14:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:55706 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651Ab3GQMOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 08:14:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,684,1367996400"; 
   d="scan'208";a="346987199"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc 3.11 2/4] mei: me: fix reset state machine
Date: Wed, 17 Jul 2013 15:13:15 +0300
Message-Id: <1374063197-26855-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374063197-26855-1-git-send-email-tomas.winkler@intel.com>
References: <1374063197-26855-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ME HW ready bit is down after hw reset was asserted or on error.
Only on error we need to enter the reset flow, additional reset
need to be prevented when reset was triggered during
initialization , power up/down or a reset is already in progress

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index e4f8dec..a0e19e6 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -483,7 +483,9 @@ irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id)
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

