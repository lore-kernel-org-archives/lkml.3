Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbaKCUt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 15:49:57 -0500
Received: from mga01.intel.com ([192.55.52.88]:65374 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078AbaKCUtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 15:49:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,308,1413270000"; 
   d="scan'208";a="616331429"
From: Stephanie Wallick <stephanie.s.wallick@intel.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        "Sean O. Stalley" <sean.stalley@intel.com>
Subject: [PATCH 01/10] added media agnostic (MA) USB HCD driver
Date: Mon,  3 Nov 2014 12:42:48 -0800
Message-Id: <1415047377-3139-2-git-send-email-stephanie.s.wallick@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415047377-3139-1-git-send-email-stephanie.s.wallick@intel.com>
References: <MA USB drivers>
 <1415047377-3139-1-git-send-email-stephanie.s.wallick@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is where we interface with the existing USB stack and implement the
functionality of a USB host controller driver. From the host's perspective,
we appear as just another USB host controller. However, instead of passing
traffic along a wired USB bus, the driver hands USB packets off for transport
per Media Agnostic USB protocol.

Signed-off-by: Sean O. Stalley <sean.stalley@intel.com>
Signed-off-by: Stephanie Wallick <stephanie.s.wallick@intel.com>
---
 drivers/staging/mausb/drivers/mausb_hcd.c | 970 ++++++++++++++++++++++++++++++
 drivers/staging/mausb/drivers/mausb_hcd.h | 171 ++++++
 2 files changed, 1141 insertions(+)
 create mode 100755 drivers/staging/mausb/drivers/mausb_hcd.c
 create mode 100644 drivers/staging/mausb/drivers/mausb_hcd.h

diff --git a/drivers/staging/mausb/drivers/mausb_hcd.c b/drivers/staging/mausb/drivers/mausb_hcd.c
new file mode 100755
index 0000000..03e8f0f
--- /dev/null
+++ b/drivers/staging/mausb/drivers/mausb_hcd.c
@@ -0,0 +1,970 @@
+/* Name:	mausb_hcd.c
+ * Description: Creates and initializes a virtual USB host controller driver
+ *	        for the Media Agnostic USB host driver.
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * Contact Information:
+ * Sean Stalley, sean.stalley@intel.com
+ * Stephanie Wallick, stephanie.s.wallick@intel.com
+ * 2111 NE 25th Avenue
+ * Hillsboro, Oregon 97124
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#define DEBUG
+
+#include <linux/init.h>
+#include <linux/wait.h>
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/usb/hcd.h>
+#include <linux/platform_device.h>
+#include <linux/usb/ch11.h>
+#include <linux/pm_runtime.h>
+#include <linux/usb/gadget.h>
+#include <linux/kthread.h>
+#include <linux/random.h>
+
+#include "mausb_hcd.h"
+#include "mausb_hub.h"
+#include "mausb_pkt.h"
+#include "mausb_mem-host.h"
+#include "mausb_msapi.h"
+#include "mausb_mgmt.h"
+#include "mausb_state.h"
+#include "mausb_tx.h"
+
+static struct platform_device mausb_pdev;
+
+struct api_context {
+	struct completion	done;
+	int			status;
+};
+
+/*
+ * pointer conversion functions
+ */
+inline struct mausb_hcd *usb_hcd_to_mausb_hcd(struct usb_hcd *hcd)
+{
+	if (usb_hcd_is_primary_hcd(hcd))
+		return *((struct mausb_hcd **) (hcd->hcd_priv));
+	else
+		return *((struct mausb_hcd **) (hcd->primary_hcd->hcd_priv));
+}
+
+inline struct usb_hcd *mausb_hcd_to_usb_hcd(struct mausb_hcd *mhcd)
+{
+	if (mhcd->shared_hcd && !usb_hcd_is_primary_hcd(mhcd->shared_hcd))
+		return mhcd->shared_hcd;
+	else
+		return mhcd->usb_hcd;
+}
+
+inline struct device *mausb_hcd_to_dev(struct mausb_hcd *mhcd)
+{
+	return mausb_hcd_to_usb_hcd(mhcd)->self.controller;
+}
+
+inline struct mausb_urb *usb_urb_to_mausb_urb(struct urb *urb)
+{
+	return (struct mausb_urb *) urb->hcpriv;
+}
+/* ----------------------------------------------------------------- */
+
+/**
+ * @maurb:	Media agnostic structure with URB to release.
+ * @status:	Status for URB that is getting released.
+ *
+ * Removes an URB from the queue, deletes the media agnostic information in
+ * the urb, and gives the URB back to the HCD. Caller must be holding the
+ * driver's spinlock.
+ */
+void mausb_unlink_giveback_urb(struct mausb_urb *maurb, int status)
+{
+	struct urb		*urb;
+	struct usb_hcd		*hcd;
+	struct api_context	*ctx = NULL;
+	struct mausb_hcd	*mhcd = platform_get_drvdata(&mausb_pdev);
+	unsigned long		irq_flags;
+
+	if (!mhcd) {
+		printk(KERN_ERR "%s: No MA USB HCD\n", __func__);
+		return;
+	}
+
+	hcd = mausb_hcd_to_usb_hcd(mhcd);
+
+	spin_lock_irqsave(&mhcd->giveback_lock, irq_flags);
+
+	if (!maurb) {
+		mausb_err(mhcd, "%s: no maurb\n", __func__);
+		spin_unlock_irqrestore(&mhcd->giveback_lock, irq_flags);
+		return;
+	} else {
+		urb = maurb->urb;
+		ctx = urb->context;
+	}
+
+	if (!urb) {
+		mausb_err(mhcd, "%s: no urb\n", __func__);
+		mausb_internal_drop_maurb(maurb, mhcd);
+		spin_unlock_irqrestore(&mhcd->giveback_lock, irq_flags);
+		return;
+	}
+
+	mausb_dbg(mhcd, "%s: returning urb with status %i\n", __func__, status);
+
+	usb_hcd_unlink_urb_from_ep(hcd, urb);
+	usb_hcd_giveback_urb(hcd, urb, status);
+
+	/* remove the mausb-specific data */
+	mausb_internal_drop_maurb(maurb, mhcd);
+
+	spin_unlock_irqrestore(&mhcd->giveback_lock, irq_flags);
+}
+
+/**
+ * Adds an URB to the endpoint queue then calls the URB handler. URB is wrapped
+ * in media agnostic structure before being enqueued.
+ */
+static int mausb_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
+		gfp_t memflags)
+{
+	int			ret = 0;
+	struct mausb_urb	*maurb;
+	struct mausb_hcd	*mhcd;
+	struct mausb_host_ep	*ep;
+	unsigned long		irq_flags;
+
+	if (!hcd || !urb) {
+		printk(KERN_ERR "%s: no %s\n", __func__,
+			(hcd ? "urb" : "USB hcd"));
+	}
+
+	mhcd = usb_hcd_to_mausb_hcd(hcd);
+	ep   = usb_to_ma_endpoint(urb->ep);
+
+	if (!ep || !mhcd) {
+		mausb_err(mhcd, "%s: no %s\n", __func__,
+			(ep ? "MA USB HCD" : "endpoint"));
+		return -EINVAL;
+	}
+
+	if (urb->status != -EINPROGRESS) {
+		mausb_err(mhcd, "%s: urb already unlinked, status is %i\n",
+			__func__, urb->status);
+		return urb->status;
+	}
+
+	/* If the endpoint isn't activated, we can't enqueue anything. */
+	if (MAUSB_EP_HANDLE_UNASSIGNED == ep->ep_handle_state) {
+		mausb_err(mhcd, "%s: endpoint handle unassigned\n", __func__);
+		return -EPIPE;
+	}
+
+	if (USB_SPEED_FULL != urb->dev->speed) /* suppress checks */
+		ep->max_pkt = usb_endpoint_maxp(&urb->ep->desc);
+
+	/* initialize the maurb */
+	maurb = mausb_alloc_maurb(ep, memflags);
+	if (!maurb) {
+		mausb_err(mhcd, "could not allocate memory for MA USB urb\n");
+		return -ENOMEM;
+	}
+
+	/* set maurb member values */
+	maurb->urb = urb;
+	urb->hcpriv = maurb;
+
+	/* submit urb to hcd and add to endpoint queue */
+	ret = usb_hcd_link_urb_to_ep(hcd, urb);
+	if (ret < 0) {
+		mausb_err(mhcd, "urb enqueue failed: error %d\n", ret);
+		usb_hcd_unlink_urb_from_ep(hcd, urb);
+		return ret;
+	}
+
+	/* get usb device and increment reference counter */
+	if (!mhcd->udev) {
+		mhcd->udev = urb->dev;
+		usb_get_dev(mhcd->udev);
+	}
+
+	/* add urb to queue list */
+	spin_lock_irqsave(&ep->ep_lock, irq_flags);
+	list_add_tail(&maurb->urb_list, &ep->urb_list);
+	spin_unlock_irqrestore(&ep->ep_lock, irq_flags);
+
+	/* add urb to ma hcd urb list */
+	spin_lock_irqsave(&mhcd->urb_list_lock, irq_flags);
+	list_add_tail(&maurb->ma_hcd_urb_list, &mhcd->enqueue_urb_list);
+	spin_unlock_irqrestore(&mhcd->urb_list_lock, irq_flags);
+
+	/* send to MA transfer process */
+	wake_up(&mhcd->waitq);
+
+	return ret;
+}
+
+/**
+ * Dequeues an URB.
+ */
+static int mausb_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
+{
+	int			ret	= 0;
+	struct mausb_hcd	*mhcd = usb_hcd_to_mausb_hcd(hcd);
+	struct mausb_host_ep	*ep = usb_to_ma_endpoint(urb->ep);
+	struct mausb_urb	*maurb = usb_urb_to_mausb_urb(urb);
+	unsigned long		irq_flags;
+
+	/* For debugging - we want to know who initiated URB dequeue. */
+	dump_stack();
+
+	if (ep->active_transfer == maurb) {
+		ret = mausb_tx_dev_mgmt_req_ep(CancelTransferReq,
+			&mhcd->ma_dev.mgmt, maurb->dev, true, ep);
+
+		spin_lock_irqsave(&ep->ep_lock, irq_flags);
+		ep->active_transfer = NULL;
+		ep->state.tx_pending = 0;
+		spin_unlock_irqrestore(&ep->ep_lock, irq_flags);
+	}
+
+	/*
+	 * Make sure urb hasn't been unlinked or already completed.
+	 * Dequeue must fail if usb_hcd_check_unlink_urb() fails.
+	 */
+	spin_lock_irqsave(&ep->ep_lock, irq_flags);
+	ret = usb_hcd_check_unlink_urb(hcd, urb, status);
+
+	if (ret < 0) {
+		spin_unlock_irqrestore(&ep->ep_lock, irq_flags);
+		mausb_err(mhcd, "%s: urb already unlinked or completed, %d\n",
+			__func__, ret);
+		return ret;
+	}
+
+	/* check to make sure our urb queue is not empty */
+	if (list_empty(&ep->urb_list)) {
+		spin_unlock_irqrestore(&ep->ep_lock, irq_flags);
+		mausb_err(mhcd, "%s: urb queue is empty\n", __func__);
+		return -ENXIO;
+	}
+
+	spin_unlock_irqrestore(&ep->ep_lock, irq_flags);
+
+	/* now we can give back URB */
+	spin_lock_irqsave(&mhcd->hcd_lock, irq_flags);
+	mausb_unlink_giveback_urb(maurb, -EINPROGRESS);
+	spin_unlock_irqrestore(&mhcd->hcd_lock, irq_flags);
+
+	return ret;
+}
+
+/**
+ * Called by usb core to suspend the bus. Once suspended, hcd waits in
+ * that state until it is resumed by mausb_bus_resume().
+ *
+ * Note: sections are commented out to accomidate devices that don't yet
+ * support SleepReq packets.
+ *
+ * Always returns zero.
+ */
+static int mausb_bus_suspend(struct usb_hcd *hcd)
+{
+/*	int			ret = 0; */
+	struct mausb_hcd	*mhcd = usb_hcd_to_mausb_hcd(hcd);
+/*	struct mausb_dev	*top_dev = mhcd->ma_dev.top_dev; */
+	struct mausb_root_hub	*roothub = usb_hcd_to_roothub(hcd);
+
+/*	if (NULL != top_dev) {
+		ret = mausb_tx_dev_mgmt_req(SleepReq,
+			&mhcd->ma_dev.mgmt, top_dev, true);
+		if (ret < 0)
+			return ret;
+	}
+*/
+	/* stop polling */
+	clear_bit(HCD_FLAG_POLL_RH, &hcd->flags);
+
+	/*
+	 * Avoid suspend/resume race condition by making sure there aren't any
+	 * devices in the middle of resuming. If a connected device is
+	 * resuming, suspend should fail.
+	 */
+	if (mhcd->resuming) {
+		mausb_err(mhcd, "%s: suspend failed, device is resuming\n",
+			 __func__);
+		return -EBUSY;
+	}
+
+	mausb_dbg(mhcd, "%s: suspending mausb driver\n", __func__);
+
+	roothub->rh_state = MAUSB_RH_SUSPEND;
+	hcd->state = HC_STATE_SUSPENDED;
+
+	return 0;
+}
+
+/**
+ * Called by usb core to resume hcd after bus suspension.
+ *
+ * Returns 0 if resume was successful, otherwise returns negative error
+ * value.
+ */
+static int mausb_bus_resume(struct usb_hcd *hcd)
+{
+	int ret = 0;
+	struct mausb_hcd *mhcd = usb_hcd_to_mausb_hcd(hcd);
+	struct mausb_dev *top_dev = mhcd->ma_dev.top_dev;
+	struct mausb_root_hub	 *roothub = usb_hcd_to_roothub(hcd);
+
+	if (!HCD_HW_ACCESSIBLE(hcd)) {
+		mausb_err(mhcd, "%s: hcd not fully powered\n", __func__);
+		return -ESHUTDOWN;
+	}
+
+	mausb_dbg(mhcd, "%s: resuming mausb driver\n", __func__);
+
+	hcd->state = HC_STATE_RUNNING;
+	roothub->rh_state = MAUSB_RH_RUNNING;
+
+	if (NULL != top_dev) {
+		ret = mausb_tx_dev_mgmt_req(WakeReq, &mhcd->ma_dev.mgmt,
+			top_dev, true);
+
+		if (ret < 0) {
+			mausb_err(mhcd, "%s: WakeReq was unsuccessful"
+				" (error %i)\n", __func__, ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * Returns the hardware-chosen device address.
+ */
+static int mausb_address_device(struct usb_hcd *hcd, struct usb_device *udev)
+{
+	int			ret = 0;
+	struct ma_dev		*ma_dev;
+	struct mausb_dev	*mausb_dev;
+	struct mausb_host_ep	*ma_ep;
+	struct mausb_hcd	*mhcd = usb_hcd_to_mausb_hcd(hcd);
+
+	if (NULL == mhcd)
+		return -EINVAL;
+
+	ma_dev = &mhcd->ma_dev;
+	if (NULL == ma_dev)
+		return -EINVAL;
+
+	mausb_dev = mausb_find_dev_host(ma_dev, udev);
+	if (NULL == mausb_dev)
+		return -ENODEV;
+
+	ret = mausb_tx_dev_mgmt_req(USBDevHandleReq, &ma_dev->mgmt,
+		mausb_dev, true);
+
+	if (-ETIMEDOUT == ret) {
+		mausb_err(mhcd, "USBDevHandleReq timed out\n");
+	} else if (0 > ret) {
+		mausb_err(mhcd, "USBDevHandleReq failed with error %i\n", ret);
+	} else {
+		ret = mausb_tx_dev_mgmt_req(EPHandleReq, &ma_dev->mgmt,
+			mausb_dev, true);
+
+		if (-ETIMEDOUT == ret) {
+			mausb_err(mhcd, "EPHandleReq timed out\n");
+		} else if (0 > ret) {
+			mausb_err(mhcd, "EPHandleReq failed with error %i\n",
+					ret);
+		} else {
+			ret = mausb_tx_dev_mgmt_req(SetUSBDevAddrReq,
+				&ma_dev->mgmt, mausb_dev, true);
+
+			if (-ETIMEDOUT == ret) {
+				mausb_err(mhcd, "SetUSBDevAddrReq timed out\n");
+			} else if (0 > ret) {
+				mausb_err(mhcd, "SetUSBDevAddrReq failed with"
+					" error %i\n", ret);
+			} else {
+				ma_ep = mausb_find_ep_host(&udev->ep0,
+					mausb_dev);
+				ret = mausb_tx_dev_mgmt_req_ep(ModifyEP0Req,
+					&ma_dev->mgmt, mausb_dev, true, ma_ep);
+			}
+		}
+	}
+
+	/* TODO: handle failed enumeration */
+
+	return 0;
+}
+
+/**
+ * Resets everything to default values. Always returns zero.
+ */
+static int mausb_reset(struct usb_hcd *hcd)
+{
+	struct mausb_hcd	 *mhcd = usb_hcd_to_mausb_hcd(hcd);
+	struct mausb_root_hub	 *roothub = usb_hcd_to_roothub(hcd);
+
+	mausb_dbg(mhcd, "%s: resetting MA USB host driver . . .\n", __func__);
+
+	roothub->rh_state = MAUSB_RH_RESETTING;
+
+	if (mausb_is_ss_hcd(hcd)) {
+		hcd->speed = HCD_USB3;
+		hcd->self.root_hub->speed = USB_SPEED_SUPER;
+	} else {
+		hcd->speed = HCD_USB2;
+		hcd->self.root_hub->speed = USB_SPEED_HIGH;
+		hcd->has_tt = 1;
+	}
+
+	hcd->uses_new_polling = 1;
+	hcd->self.sg_tablesize = 0;
+
+	mausb_init_port_status(&mhcd->root_hub);
+	mausb_init_port_status(&mhcd->shared_root_hub);
+
+	return 0;
+}
+
+int mausb_hcd_thread(void *data)
+{
+	struct mausb_hcd *mhcd = (struct mausb_hcd *)data;
+	struct mausb_urb *ma_urb, *next_ma_urb;
+	struct mausb_host_ep *ma_ep;
+	unsigned long irq_flags;
+
+	while (!kthread_should_stop()) {
+		spin_lock_irqsave(&mhcd->urb_list_lock, irq_flags);
+		list_for_each_entry_safe(ma_urb, next_ma_urb,
+			&mhcd->enqueue_urb_list, ma_hcd_urb_list) {
+
+			list_move(&ma_urb->ma_hcd_urb_list,
+				&mhcd->transfer_urb_list);
+
+			spin_unlock_irqrestore(&mhcd->urb_list_lock, irq_flags);
+
+			ma_ep = ma_urb->ep;
+			start_ma_transfer(ma_ep, ma_urb,
+				usb_pipein(ma_urb->urb->pipe));
+
+			spin_lock_irqsave(&mhcd->urb_list_lock, irq_flags);
+		}
+		spin_unlock_irqrestore(&mhcd->urb_list_lock, irq_flags);
+
+		wait_event_interruptible(mhcd->waitq,
+			!list_empty(&mhcd->enqueue_urb_list) ||
+			kthread_should_stop());
+	}
+
+	do_exit(0);
+	return 0;
+}
+
+/**
+ * Tells the hcd to start running. Always returns zero.
+ */
+static int mausb_start(struct usb_hcd *hcd)
+{
+	struct mausb_hcd	 *mhcd = usb_hcd_to_mausb_hcd(hcd);
+	struct mausb_root_hub	 *roothub = usb_hcd_to_roothub(hcd);
+
+	mausb_dbg(mhcd, "%s: starting MA USB driver . . .\n", __func__);
+
+	hcd->state = HC_STATE_RUNNING;
+	roothub->rh_state = MAUSB_RH_RUNNING;
+
+	spin_lock_init(&mhcd->hcd_lock);
+	INIT_LIST_HEAD(&mhcd->ma_dev.dev_list);
+	INIT_LIST_HEAD(&mhcd->enqueue_urb_list);
+	spin_lock_init(&mhcd->urb_list_lock);
+	INIT_LIST_HEAD(&mhcd->transfer_urb_list);
+	spin_lock_init(&mhcd->giveback_lock);
+	init_waitqueue_head(&mhcd->waitq);
+	mhcd->ma_hcd_task_data = (void *)mhcd;
+	mhcd->ma_hcd_task = kthread_run(mausb_hcd_thread,
+		mhcd->ma_hcd_task_data, "mausb_hcd_thread");
+
+	return 0;
+}
+
+/**
+ * Called when driver is removed (specifically during usb_remove_hcd). This is
+ * where we tell the hcd to stop writing memory and doing I/O.
+ */
+static void mausb_stop(struct usb_hcd *hcd)
+{
+	struct mausb_hcd	*mhcd = usb_hcd_to_mausb_hcd(hcd);
+
+	if (mhcd->ma_hcd_task != NULL) {
+		kthread_stop(mhcd->ma_hcd_task);
+		mhcd->ma_hcd_task = NULL;
+	}
+
+	mausb_dbg(mhcd, "%s: stopping mausb driver . . .\n", __func__);
+}
+
+static const struct hc_driver mausb_hc_driver = {
+	.description = "mausb-hcd",
+	.product_desc = "mausb pseudo-host controller",
+	.hcd_priv_size = sizeof(struct mausb_hcd),
+	.irq = NULL,
+	.flags = HCD_USB3,
+	.reset = &mausb_reset,
+	.start = &mausb_start,
+	.stop = &mausb_stop,
+	.urb_enqueue = &mausb_urb_enqueue,
+	.urb_dequeue = &mausb_urb_dequeue,
+	.hub_status_data = &mausb_hub_status_data,
+	.hub_control = &mausb_hub_control,
+	.bus_suspend = &mausb_bus_suspend,
+	.bus_resume = &mausb_bus_resume,
+	.alloc_dev = &mausb_alloc_dev,
+	.free_dev =  &mausb_free_dev,
+	.add_endpoint =    &mausb_add_endpoint,
+	.drop_endpoint =   &mausb_drop_endpoint,
+	.check_bandwidth = &mausb_check_bandwidth,
+	.reset_bandwidth = &mausb_reset_bandwidth,
+	.address_device =  &mausb_address_device,
+};
+
+/**
+ * Sets the host_bos fields to the proper initial values per USB3 spec,
+ * section 10.13.1.
+ */
+static int mausb_set_host_bos(struct mausb_host_bos *host_bos)
+{
+	/* BOS Descriptor */
+	host_bos->bos_des.bLength         = USB_DT_BOS_SIZE;
+	host_bos->bos_des.bDescriptorType = USB_DT_BOS;
+	host_bos->bos_des.wTotalLength    = sizeof(struct mausb_host_bos);
+	host_bos->bos_des.bNumDeviceCaps  = MAUSB_HOST_NUM_DEV_CAPS;
+
+	/* SuperSpeed USB Device Capability */
+	host_bos->ss_cap_des.bLength               = USB_DT_USB_SS_CAP_SIZE;
+	host_bos->ss_cap_des.bDescriptorType       = USB_DT_DEVICE_CAPABILITY;
+	host_bos->ss_cap_des.bDevCapabilityType    = USB_SS_CAP_TYPE;
+	host_bos->ss_cap_des.bmAttributes          = USB_LTM_SUPPORT;
+	host_bos->ss_cap_des.wSpeedSupported       = USB_5GBPS_OPERATION;
+	host_bos->ss_cap_des.bFunctionalitySupport = MAUSB_SUPER_SPEED;
+	host_bos->ss_cap_des.bU1devExitLat         = MAUSB_HOST_U1_DEV_EXIT_LAT;
+	host_bos->ss_cap_des.bU2DevExitLat         = MAUSB_HOST_U2_DEV_EXIT_LAT;
+
+	return 0;
+}
+
+/**
+ * @req:	The incoming MA USB management request packet to handle.
+ * @resp:	The MA USB management response packet to send out.
+ * @mgmt:	The MA USB HCD's management structure.
+ *
+ * This function handles management requests to the HCD. It parses the packet
+ * and makes the necessary function calls into the system.
+ *
+ * Note: this function only completes the packet type, status and
+ * request-specific data-fields. the remainder of the fields are set
+ * by mausb_rx_mgmt_req
+ */
+static int hcd_mgmt_req_switch(struct mausb_mgmt_pkt *req,
+		struct mausb_mgmt_pkt *resp, struct mausb_mgmt *mgmt)
+{
+	int ret = 0;
+
+	switch (req->common.pkt_type) {
+
+	/* TODO: handle unimplemented request types */
+	case RemoteWakeReq:
+	case DevInitDisconnectReq:
+		break;
+	case PingReq:
+		resp->common.pkt_type   = PingResp;
+		resp->common.pkt_status = NO_ERROR;
+		break;
+	/* invalid packet type */
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static int mausb_transfer_mgmt_packet(struct ms_pkt *ms_pkt, void *context);
+
+/**
+ * Generates the mass_id used to initialize an MA USB device. Uses a random
+ * number generator to choose a random id between 1 and 254.
+ *
+ * Returns the random id chosen.
+ */
+static __u8 get_mass_id(void)
+{
+       __u8 id;
+
+       get_random_bytes(&id, sizeof(id));
+
+       /* Note: this function is twice as likely to pick 1 or 2 */
+       id = (id % (MASS_ID_MAX - MASS_ID_MIN + 1) + MASS_ID_MIN);
+
+       return id;
+}
+
+/**
+ * Initializes MA USB hcd roothub descriptors and ports.
+ *
+ * Always returns zero.
+ */
+static int create_mausb_hcd(struct mausb_hcd *mausb_hcd)
+{
+	if (mausb_hcd == NULL)
+		return -ENOMEM;
+
+	/* set the roothub descriptor to the proper initial values */
+	mausb_set_hub_descriptor(&mausb_hcd->root_hub.descriptor);
+	mausb_set_ss_hub_descriptor(&mausb_hcd->shared_root_hub.descriptor);
+
+	/* set the host_bos to the proper values */
+	mausb_set_host_bos(&mausb_hcd->host_bos);
+
+	/* initialize port status values */
+	mausb_init_port_status(&mausb_hcd->root_hub);
+	mausb_init_ss_port_status(&mausb_hcd->shared_root_hub);
+
+	/* initialize the MA USB device structure */
+	mausb_init_ma_device(&mausb_hcd->ma_dev, MAUSB_DEV_ADDR, get_mass_id(),
+		mausb_hcd, NULL, &hcd_mgmt_req_switch, &mausb_device_connect);
+
+	return 0;
+}
+
+/**
+ * probe function
+ */
+static int mausb_probe(struct platform_device *mausb_pdev)
+{
+	int			ret = 0;
+	const char		*bus_name = "MAUSB";
+	unsigned int		mausb_irqnum = 0;
+	struct usb_hcd		*usb_hcd;
+	struct mausb_hcd	*mhcd;
+
+	/* create our USB 2.0 roothub */
+	usb_hcd = usb_create_hcd(&mausb_hc_driver, &mausb_pdev->dev, bus_name);
+	if (usb_hcd == NULL) {
+		dev_err(&mausb_pdev->dev, "%s: could not create USB HCD\n",
+			__func__);
+		return -ENOMEM;
+	}
+
+	/* create our data structure that holds MA USB data */
+	mhcd = kzalloc(sizeof(struct mausb_hcd), GFP_KERNEL);
+	ret = create_mausb_hcd(mhcd);
+	if (ret < 0) {
+		dev_err(&mausb_pdev->dev, "%s: could not create MA USB HCD"
+			" (error %i)\n", __func__, ret);
+
+		if (ret != -ENOMEM)
+			kfree(mhcd);
+
+		return ret;
+	}
+
+	/*
+	 * Everyone exchanges pointers so we can move between data types with
+	 * minimal pointer juju.
+	 */
+	platform_set_drvdata(mausb_pdev, mhcd);
+	*((struct mausb_hcd **) usb_hcd->hcd_priv) = mhcd;
+	mhcd->usb_hcd = usb_hcd;
+
+	/*
+	 * Finish initializing generic members of USB 2.0 HCD, register the bus,
+	 * request IRQ line, call driver's reset() and start() routines.
+	 */
+	ret = usb_add_hcd(usb_hcd, mausb_irqnum, IRQF_SHARED);
+	if (ret) {
+		dev_err(&mausb_pdev->dev, "%s: could not add USB HCD"
+			" (error %i)\n", __func__, ret);
+
+		usb_remove_hcd(usb_hcd);
+		kfree(mhcd);
+
+		return ret;
+	}
+
+	/* add our USB 3.0 roothub */
+	mhcd->shared_hcd = usb_create_shared_hcd(&mausb_hc_driver,
+		&mausb_pdev->dev, bus_name, usb_hcd);
+
+	if (mhcd->shared_hcd == NULL) {
+		dev_dbg(&mausb_pdev->dev,
+			"%s: could not create shared USB HCD\n", __func__);
+
+		usb_remove_hcd(usb_hcd);
+		kfree(mhcd);
+
+		return -ENOMEM;
+	}
+
+	ret = usb_add_hcd(mhcd->shared_hcd, mausb_irqnum, IRQF_SHARED);
+
+	if (ret) {
+		dev_err(&mausb_pdev->dev, "%s: could not add shared"
+			" USB HCD (error %i)\n", __func__, ret);
+
+		usb_remove_hcd(usb_hcd);
+		kfree(mhcd);
+	}
+
+	return ret;
+}
+
+/**
+ * remove function
+ */
+static int mausb_remove(struct platform_device *mausb_pdev)
+{
+	int			ret = 0;
+	struct usb_hcd		*hcd, *shared_hcd;
+	struct mausb_hcd	*mhcd = platform_get_drvdata(mausb_pdev);
+
+	if (mhcd == NULL) {
+		dev_err(&mausb_pdev->dev,
+			"%s:MA USB HCD not found\n", __func__);
+		return 0;
+	}
+
+	hcd = mhcd->usb_hcd;
+	shared_hcd = mhcd->shared_hcd;
+
+	if (mhcd->shared_hcd) {
+		usb_remove_hcd(mhcd->shared_hcd);
+		usb_put_hcd(mhcd->shared_hcd);
+		mhcd->shared_hcd = NULL;
+	}
+
+	usb_remove_hcd(hcd);
+	usb_put_hcd(hcd);
+
+	kfree(mhcd);
+
+	return ret;
+}
+
+/**
+ * Release function.
+ */
+static void mausb_dev_release(struct device *dev)
+{
+	/* TODO: if we dynamically allocate anything, free it here */
+}
+
+static struct platform_driver mausb_driver = {
+	.probe = mausb_probe,
+	.remove = mausb_remove,
+	.driver = {
+		.name = MAUSB_NAME,
+		.owner = THIS_MODULE,
+	},
+};
+
+static struct platform_device mausb_pdev = {
+	.name = MAUSB_NAME,
+	.id = 0,
+};
+
+/**
+ * @pkt		The incoming MA USB packet to parse.
+ * @context	The MA USB HCD's management structure.
+ *
+ * Used to transfer MA USB management packets to and from an MA USB device.
+ */
+static int mausb_transfer_mgmt_packet(struct ms_pkt *ms_pkt, void *context)
+{
+	int			ret;
+	struct mausb_mgmt	*mgmt;
+	struct mausb_hcd	*mhcd = platform_get_drvdata(&mausb_pdev);
+	struct mausb_pkt	*pkt = mausb_pkt_from_ms_pkt_ma_dev(ms_pkt,
+					&mhcd->ma_dev, GFP_ATOMIC);
+
+	if ((NULL == context) || (NULL == pkt)) {
+		mausb_err(mhcd, "%s: received NULL input\n", __func__);
+		return -EFAULT;
+	}
+
+	mgmt = (struct mausb_mgmt *) context;
+
+	ret = mausb_rx_mgmt(pkt, mgmt);
+
+	return ret;
+}
+
+/**
+ * @drv:	The media specific driver structure that provides an interface
+ *		for the media agnostic driver.
+ *
+ * Registers a media specific driver with the MA USB HCD.
+ */
+struct mausb_ma_drv *mausb_register_ms_driver(struct mausb_ms_drv *drv)
+{
+	struct mausb_hcd	*mhcd = platform_get_drvdata(&mausb_pdev);
+	unsigned long		irq_flags;
+
+	spin_lock_irqsave(&mhcd->hcd_lock, irq_flags);
+	mhcd->ma_dev.ms_driver = drv;
+	spin_unlock_irqrestore(&mhcd->hcd_lock, irq_flags);
+
+	/* Open the management channel */
+	mausb_add_mgmt_channel(&mhcd->ma_dev.mgmt, drv,
+			 &mausb_transfer_mgmt_packet, &mausb_mgmt_pkt_sent);
+
+	return &mhcd->ma_dev.ma_drv;
+}
+EXPORT_SYMBOL(mausb_register_ms_driver);
+
+/**
+ * Called by a media specific driver to indicate that an MA USB device has been
+ * connected and is ready to receive MA USB packets.
+ */
+int mausb_device_connect(int on)
+{
+	int status = 0;
+	/* TODO: don't want portnum hard coded when we add more ports */
+	int portnum = 0;
+	struct mausb_hcd	*mhcd = platform_get_drvdata(&mausb_pdev);
+
+	/*  connection event */
+	if (on) {
+		/* reset MA USB device */
+		status = mausb_tx_dev_mgmt_req(DevResetReq, &mhcd->ma_dev.mgmt,
+			NULL, true);
+
+		if (status < 0) {
+			mausb_err(mhcd, "%s: cannot reset MA device,"
+				" error %i\n", __func__, status);
+			return status;
+		}
+
+		/* send CapResp packet */
+		if (0 <= status) {
+			status = mausb_tx_dev_mgmt_req(CapReq,
+				&mhcd->ma_dev.mgmt, NULL, true);
+		}
+
+		if (status < 0) {
+			mausb_err(mhcd, "%s: cannot get device capabilities,"
+				" error %i\n", __func__, status);
+			return status;
+		}
+	}
+
+	status = mausb_connect(mhcd, portnum, on);
+
+	return status;
+}
+
+/**
+ * initialization function
+ */
+static int mausb_hcd_init(void)
+{
+	int ret;
+
+	/* register HCD driver */
+	ret = platform_driver_register(&mausb_driver);
+	if (ret < 0) {
+		printk(KERN_DEBUG "%s: failed to register HC driver: "
+			" error number %d\n", __func__, ret);
+
+	} else {
+		/* register HCD device */
+		ret = platform_device_register(&mausb_pdev);
+
+		if (ret < 0) {
+			printk(KERN_DEBUG "%s: failed to register HC device:"
+				"error number %d\n", __func__, ret);
+			platform_driver_unregister(&mausb_driver);
+		} else {
+			/* direct the release function (for exiting) */
+			mausb_pdev.dev.release = &mausb_dev_release;
+
+			if (ret < 0) {
+				printk(KERN_DEBUG "failed to register HC"
+					" chardev: error number %d\n", ret);
+				platform_driver_unregister(&mausb_driver);
+				platform_device_unregister(&mausb_pdev);
+			}
+		}
+	}
+
+	return ret;
+}
+module_init(mausb_hcd_init);
+
+/**
+ * Exit function.
+ */
+static void mausb_hcd_exit(void)
+{
+	/* deregister HC device */
+	platform_device_unregister(&mausb_pdev);
+
+	/* deregister HC driver */
+	platform_driver_unregister(&mausb_driver);
+}
+module_exit(mausb_hcd_exit);
+
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_AUTHOR("Intel");
+MODULE_DESCRIPTION("MA USB driver");
diff --git a/drivers/staging/mausb/drivers/mausb_hcd.h b/drivers/staging/mausb/drivers/mausb_hcd.h
new file mode 100644
index 0000000..29c431a
--- /dev/null
+++ b/drivers/staging/mausb/drivers/mausb_hcd.h
@@ -0,0 +1,171 @@
+/* Name:         mausb_hcd.h
+ * Description:  header file for mausb_hcd.c
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * Contact Information:
+ * Sean Stalley, sean.stalley@intel.com
+ * Stephanie Wallick, stephanie.s.wallick@intel.com
+ * 2111 NE 25th Avenue
+ * Hillsboro, Oregon 97124
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2014 Intel Corporation.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef __MAUSB_HCD_H
+#define __MAUSB_HCD_H
+
+#include <linux/spinlock.h>
+
+#include "mausb_hub.h"
+#include "mausb_pkt.h"
+#include "mausb_mem.h"
+#include "mausb_const.h"
+
+#define MAUSB_NAME "mausb"
+
+#define mausb_info(mhcd, fmt, args...) \
+	dev_info(mausb_hcd_to_usb_hcd(mhcd)->self.controller , fmt , ## args)
+#define mausb_dbg(mhcd, fmt, args...) \
+	dev_dbg(mausb_hcd_to_usb_hcd(mhcd)->self.controller , fmt , ## args)
+#define mausb_warn(mhcd, fmt, args...) \
+	dev_warn(mausb_hcd_to_usb_hcd(mhcd)->self.controller , fmt , ## args)
+#define mausb_err(mhcd, fmt, args...) \
+	dev_err(mausb_hcd_to_usb_hcd(mhcd)->self.controller , fmt , ## args)
+
+/* Transfer directions */
+#define PIPE_DIR_OUT 0
+#define PIPE_DIR_IN 1
+
+/* Host BOS parameters */
+#define MAUSB_HOST_NUM_DEV_CAPS 1
+#define MAUSB_HOST_U1_DEV_EXIT_LAT 0
+#define MAUSB_HOST_U2_DEV_EXIT_LAT 0
+
+/* TEMPORARY: the mausb device will have this handle */
+#define MAUSB_DEV_ADDR 0x54
+#define MAUSB_MASS_ID  0x25
+
+struct mausb_ms_drv;
+
+/**
+ * This structure holds the information set in a get bos descriptor request.
+ *
+ * @bos_des:     Binary Object Store Descriptor, per USB2.0 Spec
+ * @ss_cap_des:  SuperSpeed Capability Descriptor, per USB3.0 Spec
+ */
+struct __attribute__((__packed__)) mausb_host_bos {
+	struct usb_bos_descriptor             bos_des;
+	struct usb_ss_cap_descriptor          ss_cap_des;
+};
+
+/**
+ * This structure holds all of the MA USB-specific data.
+ *
+ * All data listed in this structure is protected by the hcd_lock.
+ * if you want to use any of this data, you need to be in possession
+ * of this lock.
+ *
+ * @root_hub:		Contains all of the data for the USB 2.0 roothub.
+ *			This includes status, state and descriptors.
+ * @shared_root_hub:	Contains all of the data for the USB 3.0 roothub.
+ *			This includes status, state and descriptors
+ * @host_bos:		Stores the host's BOS descriptor
+ * @udev:		Pointer to the usb device we are currently sending
+ *			a packet to.
+ * @shared_hcd:		The second host controller structure for the MAUSB
+ *			driver. We need this because we do SuperSpeed, which
+ *			requires 2 root hubs.
+ * @ma_dev:		The connected MA USB device
+ * @ma_hcd_task:	Task for handling urb queue
+ * @ma_hcd_task_data:	Context for ma_hcd_task
+ * @waitq:		Event trigger for dequeue
+ * @enqueue_urb_list:	List of enqueued urbs from core
+ * @transfer_urb_list:	List of urbs awaiting ma transfer
+ * @urb_list_lock:	Lock for accessing urb lists
+ * @hcd_lock:		Lock for accessing data in this structure. note that
+ *			endpoints have their own locks. When accessing
+ *			endpoint data, this lock should NOT be held
+ * @giveback_lock:	spin lock to prevent preemption when give back an urb
+ * @resuming:		Set to 1 when HCD is resuming
+ * @disabled:		Set to 1 when hcd is disabled
+ */
+struct __attribute__((__packed__)) mausb_hcd  {
+	struct mausb_root_hub	root_hub;
+	struct mausb_root_hub	shared_root_hub;
+
+	struct mausb_host_bos	host_bos;
+
+	struct usb_device	*udev;
+
+	struct usb_hcd		*usb_hcd;
+	struct usb_hcd		*shared_hcd;
+
+	struct ma_dev		ma_dev;
+	struct task_struct	*ma_hcd_task;
+	void			*ma_hcd_task_data;
+	wait_queue_head_t	waitq;
+	struct list_head	enqueue_urb_list;
+	struct list_head	transfer_urb_list;
+	spinlock_t		urb_list_lock;
+	spinlock_t		hcd_lock;
+	spinlock_t		giveback_lock;
+	unsigned int		resuming:1;
+	unsigned int		disabled:1;
+};
+
+/* Pointer conversion functions */
+inline struct mausb_hcd *usb_hcd_to_mausb_hcd(struct usb_hcd *hcd);
+inline struct usb_hcd *mausb_hcd_to_usb_hcd(struct mausb_hcd *mhcd);
+inline struct device *mausb_hcd_to_dev(struct mausb_hcd *mhcd);
+inline struct mausb_urb *usb_urb_to_mausb_urb(struct urb *urb);
+
+/* URB handling functions */
+void mausb_unlink_giveback_urb(struct mausb_urb *maurb, int status);
+
+/* Connection event function */
+int mausb_device_connect(int);
+
+#endif
-- 
1.9.1

