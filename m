Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbaFLXYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 19:24:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37227 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbaFLXSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 19:18:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 3.10 16/18] mei: me: drop harmful wait optimization
Date: Thu, 12 Jun 2014 16:22:20 -0700
Message-Id: <20140612232213.646704936@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140612232212.960235342@linuxfoundation.org>
References: <20140612232212.960235342@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Winkler <tomas.winkler@intel.com>

commit 07cd7be3d92eeeae1f92a017f2cfe4fdd9256526 upstream.

It my take time till ME_RDY will be cleared after the reset,
so we cannot check the bit before we got the interrupt

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/mei/hw-me.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -183,6 +183,7 @@ static void mei_me_hw_reset(struct mei_d
 	else
 		hcsr &= ~H_IE;
 
+	dev->recvd_hw_ready = false;
 	mei_me_reg_write(hw, H_CSR, hcsr);
 
 	if (dev->dev_state == MEI_DEV_POWER_DOWN)
@@ -233,10 +234,7 @@ static bool mei_me_hw_is_ready(struct me
 static int mei_me_hw_ready_wait(struct mei_device *dev)
 {
 	int err;
-	if (mei_me_hw_is_ready(dev))
-		return 0;
 
-	dev->recvd_hw_ready = false;
 	mutex_unlock(&dev->device_lock);
 	err = wait_event_interruptible_timeout(dev->wait_hw_ready,
 			dev->recvd_hw_ready,


