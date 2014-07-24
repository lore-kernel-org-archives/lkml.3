Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934440AbaGXJrg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:47:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54787 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309AbaGXJra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:47:30 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 044/128] mei: me: fix hw ready reset flow
Date: Thu, 24 Jul 2014 10:44:53 +0100
Message-Id: <1406195177-8656-45-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.11: based on backport for 3.10 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/misc/mei/hw-me.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index e2ca1574d22a..8ed62292926f 100644
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
1.9.1

