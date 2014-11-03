Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbaKCUts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 15:49:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:31760 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446AbaKCUtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 15:49:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,308,1413270000"; 
   d="scan'208";a="616331431"
From: Stephanie Wallick <stephanie.s.wallick@intel.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        "Sean O. Stalley" <sean.stalley@intel.com>
Subject: [PATCH 02/10] added media agnostic (MA) USB HCD roothubs
Date: Mon,  3 Nov 2014 12:42:49 -0800
Message-Id: <1415047377-3139-3-git-send-email-stephanie.s.wallick@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415047377-3139-1-git-send-email-stephanie.s.wallick@intel.com>
References: <MA USB drivers>
 <1415047377-3139-1-git-send-email-stephanie.s.wallick@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is where we implement USB 2.0 and 3.0 roothubs. From the host's perspective,
hub state is set and tracked just like any other USB roothub. Likewise, requests
to the roothub appear to be handled like any other wired USB request.

Signed-off-by: Sean O. Stalley <sean.stalley@intel.com>
Signed-off-by: Stephanie Wallick <stephanie.s.wallick@intel.com>
---
 drivers/staging/mausb/drivers/mausb_hub.c | 851 ++++++++++++++++++++++++++++++
 drivers/staging/mausb/drivers/mausb_hub.h | 128 +++++
 2 files changed, 979 insertions(+)
 create mode 100644 drivers/staging/mausb/drivers/mausb_hub.c
 create mode 100644 drivers/staging/mausb/drivers/mausb_hub.h

diff --git a/drivers/staging/mausb/drivers/mausb_hub.c b/drivers/staging/mausb/drivers/mausb_hub.c
new file mode 100644
index 0000000..aebca54
--- /dev/null
+++ b/drivers/staging/mausb/drivers/mausb_hub.c
@@ -0,0 +1,851 @@
+/* Name:         mausb_hub.c
+ * Description:  mausb hub structures and functions
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
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/usb/hcd.h>
+#include <linux/platform_device.h>
+#include <linux/usb/ch11.h>
+#include <linux/usb/ch9.h>
+
+#include "mausb_hub.h"
+#include "mausb_hcd.h"
+
+/**
+ * Returns MA USB roothub data structure for a USB HCD.
+ */
+struct mausb_root_hub *usb_hcd_to_roothub(struct usb_hcd *hcd)
+{
+	struct mausb_hcd *mhcd = usb_hcd_to_mausb_hcd(hcd);
+
+	if (usb_hcd_is_primary_hcd(hcd))
+		return &mhcd->root_hub;
+	else
+		return &mhcd->shared_root_hub;
+}
+
+/**
+ * Returns true if the given is the superspeed HCD. Note: The primary HCD is
+ * High Speed and the shared HCD is SuperSpeed.
+ */
+bool mausb_is_ss_hcd(struct usb_hcd *hcd)
+{
+	if (usb_hcd_is_primary_hcd(hcd))
+		return false;
+	else
+		return true;
+}
+
+/**
+ * Sets downstream port link state.
+ *
+ * @mhcd:	MA USB hcd that owns port.
+ * @state:	Link state to be set (see USB 3.0 spec for link state values).
+ * @portnum:	Port number of link state to be set.
+ */
+void set_link_state(struct mausb_root_hub *roothub, int state, int portnum)
+{
+	struct usb_port_status   *port_stat;
+
+	port_stat = &roothub->port_status[portnum];
+
+		port_stat->wPortStatus &= LINK_STATE_MASK;
+		port_stat->wPortStatus |= state;
+}
+
+/**
+ * Generates connect or disconnect event for a roothub.
+ *
+ * @hcd:	HCD associated with roothub.
+ * @do_connect: 1 for connect, 0 for disconnect.
+ * @_portnum:	Port number of connected device.
+ * @is_SS:	True if roothub is SuperSpeed or higher, otherwise false.
+ */
+int port_connect(struct usb_hcd *hcd, int do_connect, int _portnum, bool is_SS)
+{
+	int			portnum = _portnum;
+	struct usb_port_status	*port_stat;
+	struct mausb_hcd	*mhcd = usb_hcd_to_mausb_hcd(hcd);
+	struct mausb_root_hub	*roothub = usb_hcd_to_roothub(hcd);
+
+	if (portnum >= MAUSB_ROOTHUB_NUM_PORTS) {
+		mausb_err(mhcd, "%s: port number %i is too large (max = %i)\n",
+			__func__, portnum, MAUSB_ROOTHUB_NUM_PORTS);
+		return -EINVAL;
+	}
+
+	/* if new connection, assign first empty port */
+	if (do_connect > 0) {
+		portnum = 0;
+		while (roothub->port_status[portnum].wPortStatus
+			& USB_PORT_STAT_CONNECTION) {
+			portnum++;
+		}
+
+		mausb_dbg(mhcd, "%s: assigned MA USB port number %d\n",
+		__func__, portnum);
+	}
+
+	/*
+	 * If new connection, we assigned portnum above, otherwise use portnum
+	 * passed in.
+	 */
+	port_stat = &roothub->port_status[portnum];
+
+	/*
+	 * Make sure port is powered. If not, clear status and disable.
+	 * Note that POWER bit is different for USB 2.0 and 3.0 hubs.
+	 */
+	if (is_SS) {
+		if ((port_stat->wPortStatus & USB_SS_PORT_STAT_POWER) == 0) {
+			port_stat->wPortStatus = 0;
+			port_stat->wPortChange = 0;
+			set_link_state(roothub, USB_SS_PORT_LS_SS_DISABLED,
+				portnum);
+
+			goto update;
+		}
+	} else {
+		if ((port_stat->wPortStatus & USB_PORT_STAT_POWER) == 0) {
+			port_stat->wPortStatus = 0;
+			port_stat->wPortChange = 0;
+
+			goto update;
+		}
+	}
+
+	/* disconnect if previously connected */
+	if (do_connect == 0 || mhcd->disabled) {
+		if ((port_stat->wPortStatus & USB_PORT_STAT_CONNECTION) == 1) {
+			port_stat->wPortStatus &= ~(USB_PORT_STAT_CONNECTION);
+			port_stat->wPortStatus &= ~(USB_PORT_STAT_ENABLE);
+			port_stat->wPortChange |= USB_PORT_STAT_C_CONNECTION;
+			if (is_SS)
+				set_link_state(roothub,
+					USB_SS_PORT_LS_RX_DETECT, portnum);
+		}
+	}
+	/* set bits for a new connection */
+	else if ((port_stat->wPortStatus & USB_PORT_STAT_CONNECTION) == 0) {
+		port_stat->wPortStatus |= USB_PORT_STAT_ENABLE;
+		port_stat->wPortStatus |= USB_PORT_STAT_CONNECTION;
+		port_stat->wPortChange |= USB_PORT_STAT_C_CONNECTION;
+	}
+
+update:
+	mausb_dbg(mhcd, "%s: port status is 0x%x port change is 0x%x\n",
+		__func__, port_stat->wPortStatus, port_stat->wPortChange);
+
+	/* let core know if there is a change in port status */
+	if (port_stat->wPortChange) {
+		set_bit(HCD_FLAG_POLL_RH, &hcd->flags);
+		usb_hcd_poll_rh_status(hcd);
+	}
+
+	return portnum;
+}
+
+/**
+ * @mhcd:       MA USB hcd with connect/disconnect event.
+ * @portnum:	MA USB port number with event.
+ * @do_connect: Determines whether or not a connection is set or removed.
+ *
+ * Called to initiate either a device connect or disconnect event. A do_connect
+ * value of 0 clears a connection. A do_connect value greater than 0 sets a
+ * connection. A do_connect value less than 0 produces an error.
+ *
+ * Returns port number. If connection, port number is newly assigned port
+ * number, otherwise it is the port number passed in as an argument.
+ */
+int mausb_connect(struct mausb_hcd *mhcd, int portnum, int do_connect)
+{
+	struct usb_hcd		*hcd = container_of((void *)mhcd,
+					struct usb_hcd, hcd_priv);
+	struct usb_hcd		*ss_hcd = mhcd->shared_hcd;
+
+	if (!mhcd->ma_dev.ms_driver) {
+		mausb_err(mhcd, "%s: no media specific driver\n", __func__);
+		return -ENODEV;
+	}
+
+	if (do_connect < 0) {
+		mausb_err(mhcd, "%s: invalid connection request %d\n", __func__,
+			do_connect);
+		return -EINVAL;
+	}
+
+	if (mhcd->ma_dev.ma_cap.dev_type > MAUSB_DEV_TYPE_SS_HUB) {
+		mausb_err(mhcd, "%s: invalid MA USB device type %i\n", __func__,
+			mhcd->ma_dev.ma_cap.dev_type);
+		return -EINVAL;
+	}
+
+	/*
+	 * One connection event for MA devices. Connect SS and SS+ devices to
+	 * 3.0 root hub and non-SS devices to 2.0 root hub.
+	 */
+	else if (mhcd->ma_dev.ma_cap.dev_type == MAUSB_DEV_TYPE_INTEGRATED) {
+		if (!mhcd->ma_dev.speed) {
+			mausb_err(mhcd, "%s: Speed Capability Descriptor not"
+				" found - non-hub MA USB devices require"
+				" a Speed Capability Descriptor\n", __func__);
+			return -EPROTO;
+		}
+
+		mausb_dbg(mhcd, "%s: %s MA USB device\n", __func__,
+			do_connect ? "connecting" : "disconnecting");
+
+		if (mhcd->ma_dev.speed->speed == MAUSB_DEV_CAP_SPEED_SUPER ||
+		    mhcd->ma_dev.speed->speed == MAUSB_DEV_CAP_SPEED_SS_PLUS) {
+			portnum = port_connect(ss_hcd, do_connect, portnum,
+					       true);
+		} else {
+			portnum = port_connect(hcd, do_connect, portnum, false);
+		}
+	}
+
+	/*
+	 * Hubs require two connection events - one for the integrated
+	 * USB 3.0 hub and one for the integrated USB 2.0 hub.
+	 */
+	else {
+		mausb_dbg(mhcd, "%s: %s MA USB hub\n", __func__,
+			do_connect ? "connecting" : "disconnecting");
+
+		portnum = port_connect(hcd, do_connect, portnum, false);
+		portnum = port_connect(ss_hcd, do_connect, portnum, true);
+	}
+
+	return 0;
+}
+
+/**
+ * Called by usb core when polling for a port status change.
+ *
+ * @hcd:	USB HCD being polled.
+ * @buf:	Holds port status changes (if any).
+ *
+ * Returns zero if there is no status change, otherwise returns number of
+ * bytes in buf. When there is a status change on a port, the bit indexed
+ * at the port number + 1 (e.g. bit 2 for port 1) is set in the buffer.
+ */
+int mausb_hub_status_data(struct usb_hcd *hcd, char *buf)
+{
+	int                      i;
+	u16                      port_change = 0;
+	u32                      status = 0;
+	int                      ret = 1;
+	struct mausb_hcd	 *mhcd = usb_hcd_to_mausb_hcd(hcd);
+	struct mausb_root_hub	 *roothub = usb_hcd_to_roothub(hcd);
+
+	/*
+	 * Buf should never be more that 2 bytes. USB 3.0 hubs cannot have
+	 * more than 15 downstream ports.
+	 */
+	buf[0] = 0;
+	if (MAUSB_ROOTHUB_NUM_PORTS > 7) {
+		buf[1] = 0;
+		ret++;
+	}
+
+	for (i = 0; i < MAUSB_ROOTHUB_NUM_PORTS; i++) {
+		port_change = roothub->port_status[i].wPortChange;
+		if (port_change)
+			status |= (1 << (i + 1));
+	}
+
+	mausb_dbg(mhcd, "%s: hub status is 0x%x\n", __func__, status);
+
+	/* hcd might be suspended, resume if there is a status change */
+	if (mhcd->disabled == 0) {
+		if ((hcd->state == HC_STATE_SUSPENDED) && status)
+			usb_hcd_resume_root_hub(hcd);
+	}
+
+	memcpy(buf, (char *)&status, ret);
+
+	return status ? ret : 0;
+}
+
+/**
+ * Sets the bitfields in the hub descriptor of the 2.0 root hub. Always
+ * returns zero.
+ */
+int mausb_set_hub_descriptor(struct usb_hub_descriptor *hub_des)
+{
+	/* set the values to the default */
+	hub_des->bDescLength          = sizeof(struct usb_hub_descriptor);
+	hub_des->bDescriptorType      = USB_DT_HUB;
+	hub_des->bNbrPorts            = MAUSB_ROOTHUB_NUM_PORTS;
+	hub_des->wHubCharacteristics  = MAUSB_ROOTHUB_CHAR;
+	hub_des->bPwrOn2PwrGood       = MAUSB_ROOTHUB_PWR_ON_2_PWR_GOOD;
+	hub_des->bHubContrCurrent     = MAUSB_ROOTHUB_CONTR_CURRENT;
+
+	return 0;
+}
+
+/**
+ * Sets the bitfields in the hub descriptor of the 3.0 root hub. Always
+ * returns zero.
+ */
+int mausb_set_ss_hub_descriptor(struct usb_hub_descriptor *hub_des)
+{
+	/* set the values to the default */
+	hub_des->bDescLength          = sizeof(struct usb_hub_descriptor);
+	hub_des->bDescriptorType      = USB_DT_SS_HUB;
+	hub_des->bNbrPorts            = MAUSB_ROOTHUB_NUM_PORTS;
+	hub_des->wHubCharacteristics  = MAUSB_ROOTHUB_CHAR;
+	hub_des->bPwrOn2PwrGood       = MAUSB_ROOTHUB_PWR_ON_2_PWR_GOOD;
+	hub_des->bHubContrCurrent     = MAUSB_ROOTHUB_CONTR_CURRENT;
+
+	/* USB3-specific parameters */
+	hub_des->u.ss.bHubHdrDecLat   = MAUSB_ROOTHUB_HDR_DEC_LAT;
+	hub_des->u.ss.wHubDelay       = MAUSB_ROOTHUB_DELAY;
+	hub_des->u.ss.DeviceRemovable = MAUSB_ALL_DEV_REMOVABLE;
+
+	return 0;
+}
+
+/**
+ * handles GetHubDescriptor requests to the root hub.
+ *
+ * @hcd:	USB HCD that owns root hub.
+ * @hub_des:    Hub descriptor to be copied.
+ * @wLength:    Maximum length that can be copied without overflowing
+ *		the buffer.
+ *
+ * Returns length of what was actually copied into the mausb hcd root hub
+ * descriptor. Note that this may be less than the total size of hub_des due
+ * to buffer size contraints.
+ */
+static int mausb_get_hub_descriptor(struct usb_hcd *hcd,
+		struct usb_hub_descriptor *hub_des, u16 wLength)
+{
+	struct mausb_hcd *mhcd = usb_hcd_to_mausb_hcd(hcd);
+
+	/* Don't overflow the buffer, and don't read more than you have. */
+	unsigned int cpyLength = min_t(u16, wLength,
+				       sizeof(struct usb_hub_descriptor));
+
+	if (mausb_is_ss_hcd(hcd))
+		memcpy(hub_des, &(mhcd->shared_root_hub.descriptor), cpyLength);
+	else
+		memcpy(hub_des, &(mhcd->root_hub.descriptor), cpyLength);
+
+	return cpyLength;
+}
+
+/**
+ * Handles requests to hub for the BOS.
+ *
+ * @ma_hcd:	MA USB HCD that owns hub.
+ * @bos:	MA USB BOS descriptor.
+ * @wLength:	Maximum length that can be copied without overflowing
+ *		the buffer.
+ *
+ * Returns length of what was actually copied into the MA USB hcd BOS
+ * descriptor. Note that this may be less than the total size of the BOS due
+ * to buffer size contraints.
+ */
+static int mausb_get_bos(struct mausb_hcd *ma_hcd,
+		struct mausb_host_bos *bos, u16 wLength)
+{
+	/* Don't overflow the buffer, and don't read more than you have. */
+	unsigned int cpyLength = min_t(u16, wLength,
+				       sizeof(struct mausb_host_bos));
+
+	memcpy(bos, &(ma_hcd->host_bos), cpyLength);
+
+	return cpyLength;
+}
+
+/**
+ * Initializes FS root hub port status values for a given MA USB roothub.
+ *
+ * All ports are initally powered and put in link state rx.detect to wait for
+ * a connection (or other event that changes link state). All other bits are
+ * cleared.
+ */
+int mausb_init_port_status(struct mausb_root_hub *mausb_rh)
+{
+	int	portnum = 0;
+
+	while (portnum < MAUSB_ROOTHUB_NUM_PORTS) {
+
+		/* set port power bit only */
+		mausb_rh->port_status[portnum].wPortStatus = 0x0;
+		mausb_rh->port_status[portnum].wPortStatus |=
+			USB_PORT_STAT_POWER;
+
+		/* make sure to start with no status changes */
+		mausb_rh->port_status[portnum].wPortChange = 0x0;
+		portnum++;
+	}
+
+	mausb_rh->rh_state = MAUSB_RH_RUNNING;
+
+	return 0;
+}
+
+/**
+ * Initializes SS root hub port status values for a given MA USb roothub.
+ *
+ * All ports are initally powered and put in link state rx.detect to wait for
+ * a connection (or other event that changes link state). All other bits are
+ * cleared.
+ */
+int mausb_init_ss_port_status(struct mausb_root_hub *mausb_rh)
+{
+	int	portnum = 0;
+
+	while (portnum < MAUSB_ROOTHUB_NUM_PORTS) {
+
+		/* set port power bit and put in link state rx.detect */
+		mausb_rh->port_status[portnum].wPortStatus = 0x0;
+		mausb_rh->port_status[portnum].wPortStatus |=
+			USB_SS_PORT_STAT_POWER;
+		mausb_rh->port_status[portnum].wPortStatus |=
+			USB_SS_PORT_LS_RX_DETECT;
+
+		/* make sure to start with no status changes */
+		mausb_rh->port_status[portnum].wPortChange = 0x0;
+		portnum++;
+	}
+
+	mausb_rh->rh_state = MAUSB_RH_RUNNING;
+
+	return 0;
+}
+
+/**
+ * Handles GetHubStatus request to root hub.
+ *
+ * @mhcd:	MA USB hcd that owns hub.
+ * @data:	Holds hub status to return to caller.
+ *
+ * Reads hub status from mhcd and gives it back to the caller via data.
+ * Returns the number of bytes copied into data.
+ */
+static int mausb_get_hub_status(struct usb_hcd *hcd, char *data)
+{
+	struct usb_hub_status   *hub_stat;
+	struct mausb_hcd	*mhcd = usb_hcd_to_mausb_hcd(hcd);
+	struct mausb_root_hub	*roothub = usb_hcd_to_roothub(hcd);
+
+	hub_stat = &roothub->status;
+	mausb_dbg(mhcd, "%s: hub status is 0x%x hub change is 0x%x\n",
+		__func__, hub_stat->wHubStatus, hub_stat->wHubChange);
+
+	((u16 *)data)[0] = cpu_to_le16(hub_stat->wHubStatus);
+	((u16 *)data)[1] = cpu_to_le16(hub_stat->wHubChange);
+
+	 return sizeof(hub_stat->wHubStatus) + sizeof(hub_stat->wHubChange);
+}
+
+/**
+ * Handles ClearHubFeature request to the root hub.
+ *
+ * @mhcd:	MA USB hcd that owns hub.
+ * @wValue:	Value that determines which feature is being cleared (see USB
+ *		3.0 spec for supported values).
+ *
+ * Returns 0 if sucessful, otherwise returns error to indicate invalid request.
+ */
+static int mausb_clear_hub_feature(struct usb_hcd *hcd, u16 wValue)
+{
+	int			err = 0;
+	struct usb_hub_status	*hub_stat;
+	struct mausb_hcd	*mhcd = usb_hcd_to_mausb_hcd(hcd);
+	struct mausb_root_hub	*roothub = usb_hcd_to_roothub(hcd);
+
+	hub_stat = &roothub->status;
+
+	switch (wValue) {
+	case C_HUB_LOCAL_POWER:
+		mausb_dbg(mhcd, "clearing HUB_LOCAL_POWER\n");
+		hub_stat->wHubChange &= ~(HUB_STATUS_LOCAL_POWER);
+		break;
+	case C_HUB_OVER_CURRENT:
+		mausb_dbg(mhcd, "clearing HUB_OVER_CURRENT\n");
+		hub_stat->wHubChange &= ~(HUB_STATUS_OVERCURRENT);
+		break;
+	default:
+		err = -EINVAL;
+		break;
+	}
+
+	return err;
+}
+
+/**
+ * Handles GetPortStatus request to root hub.
+ *
+ * @mhcd:    	MA USB hcd that owns hub.
+ * @portnum:	Port number for which status is requested.
+ * @data:    	Holds port status to return to caller.
+ *
+ * Reads port status from mhcd and returns it to caller via data. Also
+ * completes a port reset.
+ *
+ * Returns the number of bytes copied into data.
+ */
+static int mausb_get_port_status(struct usb_hcd *hcd, int portnum, char *data)
+{
+	struct usb_port_status	*port_stat;
+	struct mausb_hcd	*mhcd = usb_hcd_to_mausb_hcd(hcd);
+	struct mausb_root_hub	*roothub = usb_hcd_to_roothub(hcd);
+
+	/*
+	 * Note: from USB core perspective ports are 1-indexed, mhcd uses
+	 * zero-indexing.
+	 */
+	port_stat = &roothub->port_status[portnum - 1];
+
+	/*
+	 * USB core sends a GetPortStatus request to complete a port reset.
+	 * After reset, port is enabled and link state is U0 (3.0 only).
+	 */
+	if (port_stat->wPortStatus & USB_PORT_STAT_RESET) {
+		port_stat->wPortStatus &= ~(USB_PORT_STAT_RESET);
+		port_stat->wPortStatus |= USB_PORT_STAT_ENABLE;
+
+		if (mausb_is_ss_hcd(hcd))
+			set_link_state(roothub, USB_SS_PORT_LS_U0, portnum - 1);
+	}
+
+	((u16 *)data)[0] = cpu_to_le16(port_stat->wPortStatus);
+	((u16 *)data)[1] = cpu_to_le16(port_stat->wPortChange);
+
+	mausb_dbg(mhcd, "%s: Port status is 0x%x Port change is 0x%x\n",
+		__func__, ((u16 *)data)[0], port_stat->wPortChange);
+
+	return sizeof(port_stat->wPortStatus) + sizeof(port_stat->wPortChange);
+}
+
+/**
+ * Handles SetPortFeature request to root hub.
+ *
+ * @mhcd:    	MA USB hcd that owns hub.
+ * @portnum:	Port number for which feature set is requested (port
+ *		number is from usb core perspective, i.e. not zero-indexed).
+ * @wValue:	Feature to be set (see USB 3.0 spec for supported values).
+ * @wIndex:	Contains link state to be set (ignored for requests other
+ *              than set link state).
+ *
+ * Sets the bit associated with a particular feature in the status bit field
+ * of the port specified by portnum. Note that ports are zero indexed in the
+ * hub, but indexed starting with one in the usb core (e.g. port 2 from the
+ * core's perspective is port 1 to the hub).
+ *
+ * Returns zero for all supported requests. Returns an error value if a feature
+ * is not supported.
+ */
+static int mausb_set_port_feature(struct usb_hcd *hcd, int portnum, u16 wValue,
+		u16 wIndex)
+{
+	int			err = 0;
+	u8			link_state = 0;
+	struct usb_port_status	*port_stat;
+	struct mausb_hcd	*mhcd = usb_hcd_to_mausb_hcd(hcd);
+	struct mausb_root_hub	*roothub = usb_hcd_to_roothub(hcd);
+
+	port_stat = &roothub->port_status[portnum - 1];
+
+	switch (wValue) {
+	case USB_PORT_FEAT_RESET:
+		mausb_dbg(mhcd, "setting PORT_RESET feature\n");
+		port_stat->wPortStatus |= USB_PORT_STAT_RESET;
+		port_stat->wPortChange |= USB_PORT_STAT_C_RESET;
+		break;
+	case USB_PORT_FEAT_BH_PORT_RESET:
+		mausb_dbg(mhcd, "setting BH_PORT_RESET\n");
+		break;
+	case USB_PORT_FEAT_POWER:
+		mausb_dbg(mhcd, "setting PORT_POWER feature\n");
+		port_stat->wPortStatus |= USB_SS_PORT_STAT_POWER;
+		set_link_state(roothub, USB_SS_PORT_LS_RX_DETECT, portnum - 1);
+		break;
+	case USB_PORT_FEAT_U1_TIMEOUT:
+		mausb_dbg(mhcd, "setting PORT_U1_TIMEOUT\n");
+		break;
+	case USB_PORT_FEAT_U2_TIMEOUT:
+		mausb_dbg(mhcd, "setting PORT_U2_TIMEOUT\n");
+		break;
+	case USB_PORT_FEAT_LINK_STATE:
+		link_state = wIndex >> 8;
+		if (link_state == SS_DISABLED) {
+			mausb_dbg(mhcd, "setting link state to ss.disabled\n");
+			mhcd->disabled = 1;
+			clear_bit(HCD_FLAG_POLL_RH, &hcd->flags);
+			set_link_state(roothub, USB_SS_PORT_LS_SS_DISABLED,
+				portnum - 1);
+			mausb_connect(mhcd, portnum - 1, 0);
+		}
+
+		else if (link_state == RX_DETECT) {
+			mausb_dbg(mhcd, "setting link state to rx.detect\n");
+			mhcd->disabled = 0;
+			set_link_state(roothub, USB_SS_PORT_LS_RX_DETECT,
+				portnum - 1);
+		}
+	break;
+	case USB_PORT_FEAT_REMOTE_WAKE_MASK:
+		mausb_dbg(mhcd, "setting PORT_REMOTE_WAKE_MASK\n");
+	break;
+	case USB_PORT_FEAT_FORCE_LINKPM_ACCEPT:
+		mausb_dbg(mhcd, "setting FORCE_LINKPM_ACCEPT\n");
+	break;
+	default:
+		 err = -EINVAL;
+	break;
+	}
+
+	return err;
+}
+
+/**
+ * Handles ClearPortFeature request to the root hub.
+ *
+ * @mhcd:     	MA USB hcd that owns hub.
+ * @portnum:	Port number for which feature clear is requested (port
+ *              number is from usb core perspective, i.e. not zero-indexed).
+ * @wValue:	Feature to clear (see USB 3.0 spec for supported values).
+ *
+ * Clears the bit associated with a particular feature in the status bit field
+ * of the port specified by portnum. Note that ports are zero indexed in the
+ * hub, but indexed starting with one in the usb core (e.g. port 2 from the
+ * core's perspective is port 1 to the hub).
+ *
+ * Returns zero for all supported requests. Returns an error value if a feature
+ * is not supported.
+ */
+static int mausb_clear_port_feature(struct usb_hcd *hcd, int portnum,
+		u16 wValue)
+{
+	int			 err = 0;
+	struct usb_port_status	*port_stat;
+	struct mausb_hcd	*mhcd = usb_hcd_to_mausb_hcd(hcd);
+	struct mausb_root_hub	 *roothub = usb_hcd_to_roothub(hcd);
+
+	port_stat = &roothub->port_status[portnum - 1];
+
+	switch (wValue) {
+	case USB_PORT_FEAT_POWER:
+		mausb_dbg(mhcd, "clearing PORT_POWER feature\n");
+		port_stat->wPortStatus &= ~(USB_SS_PORT_STAT_POWER);
+		break;
+	case USB_PORT_FEAT_C_CONNECTION:
+		mausb_dbg(mhcd, "clearing PORT_C_CONNECTION feature\n");
+		port_stat->wPortChange &= ~(USB_PORT_STAT_C_CONNECTION);
+		break;
+	case USB_PORT_FEAT_C_RESET:
+		mausb_dbg(mhcd, "clearing PORT_RESET feature\n");
+		port_stat->wPortStatus &= ~(USB_PORT_STAT_RESET);
+		port_stat->wPortChange &= ~(USB_PORT_STAT_C_RESET);
+		/* prevent excessive polling after reset */
+		clear_bit(HCD_FLAG_POLL_RH, &hcd->flags);
+		break;
+	case USB_PORT_FEAT_C_OVER_CURRENT:
+		mausb_dbg(mhcd, "clearing PORT_OVER_CURRENT feature\n");
+		port_stat->wPortChange &= ~(USB_PORT_STAT_C_OVERCURRENT);
+	case USB_PORT_FEAT_C_PORT_LINK_STATE:
+	case USB_PORT_FEAT_C_PORT_CONFIG_ERROR:
+	case USB_PORT_FEAT_C_BH_PORT_RESET:
+		break;
+	default:
+		err = -EINVAL;
+		break;
+	}
+
+	return err;
+}
+
+/**
+ * Handles getDescriptor requests to the roothub.
+ *
+ * @ma_hcd:	MA USB hcd that owns hub.
+ * @wValue:	Contains descriptor type in upper byte (see USB 3.0 spec for
+ *              descriptor types).
+ * @buf:	Holds descriptor to return to caller.
+ * @wLength:	Expected descriptor length.
+ *
+ * If successful, returns actual length of descriptor in buf. Otherwise returns
+ * error value.
+ */
+static int mausb_get_descriptor(struct mausb_hcd *ma_hcd, u16 wValue,
+		char *buf, u16 wLength)
+{
+	int	ret;
+
+	/*
+	 * per USB spec, section 9.4.3, the DT is contained in the upper byte
+	 * of wValue
+	 */
+	u8  bDesType = (wValue >> 8);
+
+	switch (bDesType) {
+	case USB_DT_DEVICE:
+		mausb_err(ma_hcd, "USB_DT_DEVICE not supported\n");
+		ret = -EPIPE;
+		break;
+	case USB_DT_CONFIG:
+		ret = 0;
+		break;
+	case USB_DT_BOS:
+		ret = mausb_get_bos(ma_hcd, (struct mausb_host_bos *) buf,
+			wLength);
+		mausb_dbg(ma_hcd, "%s: bos copied to buffer, wTotalLength %x\n",
+			__func__,
+			((struct mausb_host_bos *) buf)->bos_des.wTotalLength);
+		break;
+	case USB_DT_STRING:
+		ret = 0;
+		break;
+	default: /* invalid request */
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+/**
+ * Handles requests from usb core to hub.
+ *
+ * @hcd:	USB hcd that owns hub.
+ * @typeReq:	Request type (see USB 3.0 spec for request types).
+ * @wValue:	Feature selector for hub/port feature requests,
+ *		descriptor type and index for hub descriptor requests,
+ *		hub depth for hub depth requests,zero for all other requests.
+ * @wIndex:	Port number for port requests, zero or language id for hub
+ *		descriptor requests, zero for all other requests.
+ * @buf:	Buffer for requested descriptor or status (if applicable).
+ * @wLength:	Descriptor length for descriptor requests, otherwise zero.
+ *
+ * Called by the USB core to make a request to the root hub. mausb_hub_control
+ * parses the request and routes it to the appropriate mausb helper function.
+ *
+ * If successful, returns descriptor length for descriptor request or zero for
+ * other requests. Otherwise returns error value.
+ */
+int mausb_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
+		u16 wIndex, char *buf, u16 wLength)
+{
+	int		err = 0;
+	int		portnum = (wIndex & 0xFF);
+	struct		mausb_hcd *mhcd = usb_hcd_to_mausb_hcd(hcd);
+
+	if (portnum > MAUSB_ROOTHUB_NUM_PORTS) {
+		mausb_err(mhcd, "port number %d is invalid\n", portnum);
+		return -EINVAL;
+	}
+
+	switch (typeReq) {
+	case MAUSB_REQ_GET_DES:
+		err = mausb_get_descriptor(usb_hcd_to_mausb_hcd(hcd),
+			wValue, buf, wLength);
+		err = sizeof(struct mausb_host_bos);
+		break;
+	case ClearHubFeature:
+		mausb_dbg(mhcd, "clearing hub feature %d\n", wValue);
+		err = mausb_clear_hub_feature(hcd, wValue);
+		break;
+	case ClearPortFeature:
+		mausb_dbg(mhcd, "clearing port %d feature %d\n", portnum,
+			wValue);
+		err = mausb_clear_port_feature(hcd, portnum, wValue);
+		break;
+	case GetHubDescriptor:
+		err = mausb_get_hub_descriptor(hcd,
+			(struct usb_hub_descriptor *) buf, wLength);
+		break;
+	case GetHubStatus:
+		mausb_dbg(mhcd, "getting hub status\n");
+		err = mausb_get_hub_status(hcd, buf);
+		break;
+	case GetPortStatus:
+		mausb_dbg(mhcd, "getting port %d status\n", portnum);
+		err = mausb_get_port_status(hcd, portnum, buf);
+		break;
+	/* SetHubFeature support is optional (only used for diagnostics) */
+	case SetHubFeature:
+		err = 0;
+		break;
+	case SetPortFeature:
+		mausb_dbg(mhcd, "setting port %d feature %d\n", portnum,
+			wValue);
+		mausb_set_port_feature(hcd, portnum, wValue, wIndex);
+		break;
+	case SetHubDepth:
+		err = 0;
+		break;
+	case GetPortErrorCount:
+		err = 0;
+		break;
+	default:
+		err = -EINVAL;
+		break;
+	}
+
+	return err;
+}
+
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_AUTHOR("Intel");
+MODULE_DESCRIPTION("mausb driver");
diff --git a/drivers/staging/mausb/drivers/mausb_hub.h b/drivers/staging/mausb/drivers/mausb_hub.h
new file mode 100644
index 0000000..7670c1b
--- /dev/null
+++ b/drivers/staging/mausb/drivers/mausb_hub.h
@@ -0,0 +1,128 @@
+/* name:	 mausb_hub.h
+ * description:  header file for mausb hub
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
+#ifndef __MAUSB_HUB_H
+#define __MAUSB_HUB_H
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/usb/hcd.h>
+#include <linux/platform_device.h>
+#include <linux/usb/ch11.h>
+
+/* root hub Parameters */
+#define MAUSB_ROOTHUB_CHAR (HUB_CHAR_LPSM | HUB_CHAR_INDV_PORT_OCPM)
+#define MAUSB_ROOTHUB_NUM_PORTS		1
+#define MAUSB_ROOTHUB_PWR_ON_2_PWR_GOOD 0
+#define MAUSB_ROOTHUB_CONTR_CURRENT     0
+#define MAUSB_ROOTHUB_HDR_DEC_LAT       0	/* < 0 uS */
+#define MAUSB_ROOTHUB_DELAY             0	/* 0 nS */
+#define MAUSB_ALL_DEV_REMOVABLE		0x0000  /* All devices are removable */
+
+/* per USB3 spec, section 9.4.3 */
+#define MAUSB_REQ_GET_DES (0x8000 | USB_REQ_GET_DESCRIPTOR)
+
+/* link state selectors for set_port_feature request to root hub */
+#define SS_DISABLED	4
+#define RX_DETECT	5
+
+/* mask used to clear port link state bits (bits 5-8) in wPortStatus */
+#define	LINK_STATE_MASK			0xFE1F
+
+/* forward declarations */
+struct mausb_root_hub;
+struct mausb_hcd;
+
+/* root hub states */
+enum mausb_rh_state {
+	MAUSB_RH_RESETTING,
+	MAUSB_RH_SUSPEND,
+	MAUSB_RH_RUNNING
+};
+
+/**
+ * Contains all the structures required to emulate a root hub. One instance
+ * exists per root hub.
+ */
+struct __attribute__((__packed__)) mausb_root_hub {
+
+	/* hub parameters */
+	struct usb_hub_descriptor descriptor;
+	struct usb_hub_status     status;
+
+	/* port parameters*/
+	struct usb_port_status    port_status[MAUSB_ROOTHUB_NUM_PORTS];
+
+	/* root hub state */
+	enum   mausb_rh_state     rh_state;
+
+};
+
+/* function declarations */
+bool    mausb_is_ss_hcd(struct usb_hcd *hcd);
+int	mausb_hub_status_data(struct usb_hcd *hcd, char *buf);
+int	mausb_set_hub_descriptor(struct usb_hub_descriptor *hub_des);
+int	mausb_set_ss_hub_descriptor(struct usb_hub_descriptor *hub_des);
+int	mausb_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
+		u16 wIndex, char *buf, u16 wLength);
+int	mausb_init_port_status(struct mausb_root_hub *mausb_rh);
+int	mausb_init_ss_port_status(struct mausb_root_hub *mausb_rh);
+int	mausb_connect(struct mausb_hcd *hcd, int portnum, int do_connect);
+struct  mausb_root_hub *usb_hcd_to_roothub(struct usb_hcd *hcd);
+
+
+#endif
-- 
1.9.1

