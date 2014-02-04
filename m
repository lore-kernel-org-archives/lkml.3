Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934723AbaBDVMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:12:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57258 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934329AbaBDVL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:11:57 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sudeep Dutt <sudeep.dutt@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Siva Krishna Kumar Reddy Yerramreddy 
	<siva.krishna.kumar.reddy.yerramreddy@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>
Subject: [PATCH 3.13 076/140] misc: mic: bug fix for interrupt acknowledgement in MSI/INTx case.
Date: Tue,  4 Feb 2014 13:11:03 -0800
Message-Id: <20140204211039.131302018@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>

commit df5e4e8b576108f88f79e5b4c984d51d460d2360 upstream.

The interrupt handler (mic_interrupt), called in the MSI/INTx mode,
writes to the interrupt sources register to acknowledge the
interrupt and then calls the corresponding callback handlers to handle
the same. These callback handlers acknowledge the interrupts again
leading to missed interrupts. This patch fixes the issue by removing
the interrupt acknowlegment code from the callback handlers.

Reviewed-by: Sudeep Dutt <sudeep.dutt@intel.com>
Reviewed-by: Nikhil Rao <nikhil.rao@intel.com>
Reviewed-by: Siva Krishna Kumar Reddy Yerramreddy <siva.krishna.kumar.reddy.yerramreddy@intel.com>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/mic/host/mic_device.h |    3 +++
 drivers/misc/mic/host/mic_main.c   |    2 +-
 drivers/misc/mic/host/mic_virtio.c |    2 +-
 drivers/misc/mic/host/mic_x100.c   |   36 ++++++++++++++++++++----------------
 4 files changed, 25 insertions(+), 18 deletions(-)

--- a/drivers/misc/mic/host/mic_device.h
+++ b/drivers/misc/mic/host/mic_device.h
@@ -134,6 +134,8 @@ struct mic_device {
  * @send_intr: Send an interrupt for a particular doorbell on the card.
  * @ack_interrupt: Hardware specific operations to ack the h/w on
  * receipt of an interrupt.
+ * @intr_workarounds: Hardware specific workarounds needed after
+ * handling an interrupt.
  * @reset: Reset the remote processor.
  * @reset_fw_ready: Reset firmware ready field.
  * @is_fw_ready: Check if firmware is ready for OS download.
@@ -149,6 +151,7 @@ struct mic_hw_ops {
 	void (*write_spad)(struct mic_device *mdev, unsigned int idx, u32 val);
 	void (*send_intr)(struct mic_device *mdev, int doorbell);
 	u32 (*ack_interrupt)(struct mic_device *mdev);
+	void (*intr_workarounds)(struct mic_device *mdev);
 	void (*reset)(struct mic_device *mdev);
 	void (*reset_fw_ready)(struct mic_device *mdev);
 	bool (*is_fw_ready)(struct mic_device *mdev);
--- a/drivers/misc/mic/host/mic_main.c
+++ b/drivers/misc/mic/host/mic_main.c
@@ -115,7 +115,7 @@ static irqreturn_t mic_shutdown_db(int i
 	struct mic_device *mdev = data;
 	struct mic_bootparam *bootparam = mdev->dp;
 
-	mdev->ops->ack_interrupt(mdev);
+	mdev->ops->intr_workarounds(mdev);
 
 	switch (bootparam->shutdown_status) {
 	case MIC_HALTED:
--- a/drivers/misc/mic/host/mic_virtio.c
+++ b/drivers/misc/mic/host/mic_virtio.c
@@ -369,7 +369,7 @@ static irqreturn_t mic_virtio_intr_handl
 	struct mic_vdev *mvdev = data;
 	struct mic_device *mdev = mvdev->mdev;
 
-	mdev->ops->ack_interrupt(mdev);
+	mdev->ops->intr_workarounds(mdev);
 	schedule_work(&mvdev->virtio_bh_work);
 	return IRQ_HANDLED;
 }
--- a/drivers/misc/mic/host/mic_x100.c
+++ b/drivers/misc/mic/host/mic_x100.c
@@ -174,35 +174,38 @@ static void mic_x100_send_intr(struct mi
 }
 
 /**
- * mic_ack_interrupt - Device specific interrupt handling.
- * @mdev: pointer to mic_device instance
+ * mic_x100_ack_interrupt - Read the interrupt sources register and
+ * clear it. This function will be called in the MSI/INTx case.
+ * @mdev: Pointer to mic_device instance.
  *
- * Returns: bitmask of doorbell events triggered.
+ * Returns: bitmask of interrupt sources triggered.
  */
 static u32 mic_x100_ack_interrupt(struct mic_device *mdev)
 {
-	u32 reg = 0;
-	struct mic_mw *mw = &mdev->mmio;
 	u32 sicr0 = MIC_X100_SBOX_BASE_ADDRESS + MIC_X100_SBOX_SICR0;
+	u32 reg = mic_mmio_read(&mdev->mmio, sicr0);
+	mic_mmio_write(&mdev->mmio, reg, sicr0);
+	return reg;
+}
+
+/**
+ * mic_x100_intr_workarounds - These hardware specific workarounds are
+ * to be invoked everytime an interrupt is handled.
+ * @mdev: Pointer to mic_device instance.
+ *
+ * Returns: none
+ */
+static void mic_x100_intr_workarounds(struct mic_device *mdev)
+{
+	struct mic_mw *mw = &mdev->mmio;
 
 	/* Clear pending bit array. */
 	if (MIC_A0_STEP == mdev->stepping)
 		mic_mmio_write(mw, 1, MIC_X100_SBOX_BASE_ADDRESS +
 			MIC_X100_SBOX_MSIXPBACR);
 
-	if (mdev->irq_info.num_vectors <= 1) {
-		reg = mic_mmio_read(mw, sicr0);
-
-		if (unlikely(!reg))
-			goto done;
-
-		mic_mmio_write(mw, reg, sicr0);
-	}
-
 	if (mdev->stepping >= MIC_B0_STEP)
 		mdev->intr_ops->enable_interrupts(mdev);
-done:
-	return reg;
 }
 
 /**
@@ -553,6 +556,7 @@ struct mic_hw_ops mic_x100_ops = {
 	.write_spad = mic_x100_write_spad,
 	.send_intr = mic_x100_send_intr,
 	.ack_interrupt = mic_x100_ack_interrupt,
+	.intr_workarounds = mic_x100_intr_workarounds,
 	.reset = mic_x100_hw_reset,
 	.reset_fw_ready = mic_x100_reset_fw_ready,
 	.is_fw_ready = mic_x100_is_fw_ready,


