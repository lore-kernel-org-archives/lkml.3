Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031492AbaGDWZD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:25:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57755 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760850AbaGDWXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:23:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 3.10 40/46] mei: me: fix hw ready reset flow
Date: Fri,  4 Jul 2014 15:19:44 -0700
Message-Id: <20140704221604.119442752@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221602.280733370@linuxfoundation.org>
References: <20140704221602.280733370@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/misc/mei/hw-me.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -164,6 +164,9 @@ static void mei_me_hw_reset_release(stru
 	hcsr |= H_IG;
 	hcsr &= ~H_RST;
 	mei_hcsr_set(hw, hcsr);
+
+	/* complete this write before we set host ready on another CPU */
+	mmiowb();
 }
 /**
  * mei_me_hw_reset - resets fw via mei csr register.
@@ -214,6 +217,7 @@ static void mei_me_hw_reset(struct mei_d
 static void mei_me_host_set_ready(struct mei_device *dev)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
+	hw->host_hw_state = mei_hcsr_read(hw);
 	hw->host_hw_state |= H_IE | H_IG | H_RDY;
 	mei_hcsr_set(hw, hw->host_hw_state);
 }
@@ -506,19 +510,15 @@ irqreturn_t mei_me_irq_thread_handler(in
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


