Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934165AbaGOVl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:41:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55150 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934081AbaGOVjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:39:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 064/198] mei: me: drop harmful wait optimization
Date: Tue, 15 Jul 2014 14:28:54 -0700
Message-Id: <1405459868-15089-65-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Winkler <tomas.winkler@intel.com>

commit 07cd7be3d92eeeae1f92a017f2cfe4fdd9256526 upstream.

It my take time till ME_RDY will be cleared after the reset,
so we cannot check the bit before we got the interrupt

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/misc/mei/hw-me.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index f285dc1..4835edc 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -186,6 +186,7 @@ static int mei_me_hw_reset(struct mei_device *dev, bool intr_enable)
 	else
 		hcsr &= ~H_IE;
 
+	dev->recvd_hw_ready = false;
 	mei_me_reg_write(hw, H_CSR, hcsr);
 
 	if (dev->dev_state == MEI_DEV_POWER_DOWN)
@@ -237,10 +238,7 @@ static bool mei_me_hw_is_ready(struct mei_device *dev)
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

