Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964855AbaGCJWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:22:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51694 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196AbaGCJWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:22:02 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 052/198] mei: me: drop harmful wait optimization
Date: Thu,  3 Jul 2014 10:18:15 +0100
Message-Id: <1404379241-8590-53-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Winkler <tomas.winkler@intel.com>

commit 07cd7be3d92eeeae1f92a017f2cfe4fdd9256526 upstream.

It my take time till ME_RDY will be cleared after the reset,
so we cannot check the bit before we got the interrupt

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/misc/mei/hw-me.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 3412adcdaeb0..6cba26d9465f 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -183,6 +183,7 @@ static int mei_me_hw_reset(struct mei_device *dev, bool intr_enable)
 	else
 		hcsr &= ~H_IE;
 
+	dev->recvd_hw_ready = false;
 	mei_me_reg_write(hw, H_CSR, hcsr);
 
 	if (dev->dev_state == MEI_DEV_POWER_DOWN)
@@ -233,10 +234,7 @@ static bool mei_me_hw_is_ready(struct mei_device *dev)
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
1.9.1

