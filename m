Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbaFWIoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:44:24 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55585 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752625AbaFWIc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 067/111] mei: me: drop harmful wait optimization
Date: Mon, 23 Jun 2014 10:31:42 +0200
Message-Id: <cd07b1ac0cc3d6e2704575ea62884e886e6cefa1.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomas Winkler <tomas.winkler@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 07cd7be3d92eeeae1f92a017f2cfe4fdd9256526 upstream.

It my take time till ME_RDY will be cleared after the reset,
so we cannot check the bit before we got the interrupt

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.0.0

