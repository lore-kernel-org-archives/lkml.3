Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbaF3MGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:06:47 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52028 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753684AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 088/181] mei: me: fix hw ready reset flow
Date: Mon, 30 Jun 2014 13:51:49 +0200
Message-Id: <0308bc5118c452dbc16ea5c8e7c1c5d8cacd5391.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomas Winkler <tomas.winkler@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b04ada92ffaabb868497a1fce8e4f6bf74e5488f upstream

We cleared H_RST for H_CSR on spurious interrupt generated when ME_RDY
while cleared and not while  ME_RDY is set. The spurious interrupt
is not delivered on all platforms in this case the
driver may fail to initialize.

Cc: stable@vger.kernel.org #3.12
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/misc/mei/hw-me.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index aef6ec137acd..e513354f20a7 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -164,6 +164,9 @@ static void mei_me_hw_reset_release(struct mei_device *dev)
 	hcsr |= H_IG;
 	hcsr &= ~H_RST;
 	mei_hcsr_set(hw, hcsr);
+
+	/* complete this write before we set host ready on another CPU */
+	mmiowb();
 }
 /**
  * mei_me_hw_reset - resets fw via mei csr register.
@@ -214,6 +217,7 @@ static int mei_me_hw_reset(struct mei_device *dev, bool intr_enable)
 static void mei_me_host_set_ready(struct mei_device *dev)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
+	hw->host_hw_state = mei_hcsr_read(hw);
 	hw->host_hw_state |= H_IE | H_IG | H_RDY;
 	mei_hcsr_set(hw, hw->host_hw_state);
 }
@@ -506,19 +510,15 @@ irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id)
 	/*  check if we need to start the dev */
 	if (!mei_host_is_ready(dev)) {
 		if (mei_hw_is_ready(dev)) {
+			mei_me_hw_reset_release(dev);
 			dev_dbg(&dev->pdev->dev, "we need to start the dev.\n");
 
 			dev->recvd_hw_ready = true;
 			wake_up_interruptible(&dev->wait_hw_ready);
-
-			mutex_unlock(&dev->device_lock);
-			return IRQ_HANDLED;
 		} else {
-			dev_dbg(&dev->pdev->dev, "Reset Completed.\n");
-			mei_me_hw_reset_release(dev);
-			mutex_unlock(&dev->device_lock);
-			return IRQ_HANDLED;
+			dev_dbg(&dev->pdev->dev, "Spurious Interrupt\n");
 		}
+		goto end;
 	}
 	/* check slots available for reading */
 	slots = mei_count_full_read_slots(dev);
-- 
2.0.0

