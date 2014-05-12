Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaELJU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:20:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:19660 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbaELJUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:20:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1033,1389772800"; 
   d="scan'208";a="510161866"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [char-misc 2/3] mei: me: drop harmful wait optimization
Date: Mon, 12 May 2014 12:19:40 +0300
Message-Id: <1399886381-16040-3-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1399886381-16040-1-git-send-email-tomas.winkler@intel.com>
References: <1399886381-16040-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It my take time till ME_RDY will be cleared after the reset,
so we cannot check the bit before we got the interrupt

Cc: stable@vger.kernel.org
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
---
 drivers/misc/mei/hw-me.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index ac76a63..031efcf 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -203,6 +203,7 @@ static int mei_me_hw_reset(struct mei_device *dev, bool intr_enable)
 	else
 		hcsr &= ~H_IE;
 
+	dev->recvd_hw_ready = false;
 	mei_me_reg_write(hw, H_CSR, hcsr);
 
 	if (intr_enable == false)
@@ -254,10 +255,7 @@ static bool mei_me_hw_is_ready(struct mei_device *dev)
 static int mei_me_hw_ready_wait(struct mei_device *dev)
 {
 	int err;
-	if (mei_me_hw_is_ready(dev))
-		return 0;
 
-	dev->recvd_hw_ready = false;
 	mutex_unlock(&dev->device_lock);
 	err = wait_event_interruptible_timeout(dev->wait_hw_ready,
 			dev->recvd_hw_ready,
-- 
1.9.0

