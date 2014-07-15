Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964875AbaGOVjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:39:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55076 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934025AbaGOVjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:39:19 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 063/198] mei: me: fix hw ready reset flow
Date: Tue, 15 Jul 2014 14:28:53 -0700
Message-Id: <1405459868-15089-64-git-send-email-kamal@canonical.com>
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

commit b04ada92ffaabb868497a1fce8e4f6bf74e5488f upstream.

We cleared H_RST for H_CSR on spurious interrupt generated when ME_RDY
while cleared and not while  ME_RDY is set. The spurious interrupt
is not delivered on all platforms in this case the
driver may fail to initialize.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ kamal: backport to 3.13-stable: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/misc/mei/hw-me.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 3412adc..f285dc1 100644
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
@@ -201,6 +204,7 @@ static int mei_me_hw_reset(struct mei_device *dev, bool intr_enable)
 static void mei_me_host_set_ready(struct mei_device *dev)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
+	hw->host_hw_state = mei_hcsr_read(hw);
 	hw->host_hw_state |= H_IE | H_IG | H_RDY;
 	mei_hcsr_set(hw, hw->host_hw_state);
 }
@@ -496,6 +500,7 @@ irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id)
 	/*  check if we need to start the dev */
 	if (!mei_host_is_ready(dev)) {
 		if (mei_hw_is_ready(dev)) {
+			mei_me_hw_reset_release(dev);
 			dev_dbg(&dev->pdev->dev, "we need to start the dev.\n");
 
 			dev->recvd_hw_ready = true;
@@ -504,8 +509,7 @@ irqreturn_t mei_me_irq_thread_handler(int irq, void *dev_id)
 			mutex_unlock(&dev->device_lock);
 			return IRQ_HANDLED;
 		} else {
-			dev_dbg(&dev->pdev->dev, "Reset Completed.\n");
-			mei_me_hw_reset_release(dev);
+			dev_dbg(&dev->pdev->dev, "Spurious Interrupt\n");
 			mutex_unlock(&dev->device_lock);
 			return IRQ_HANDLED;
 		}
-- 
1.9.1

