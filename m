Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaKFRNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:13:20 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:37649 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbaKFRNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:13:16 -0500
From: Johan Hovold <johan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, Nix <nix@esperi.org.uk>,
        Paul Martin <pm@debian.org>, Daniel Silverstone <dsilvers@debian.org>,
        Oliver Neukum <oneukum@suse.de>, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable <stable@vger.kernel.org>
Subject: [PATCH] USB: cdc-acm: add quirk for control-line state requests
Date: Thu,  6 Nov 2014 18:08:33 +0100
Message-Id: <1415293713-3051-1-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20141106170456.GC26196@localhost>
References: <20141106170456.GC26196@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add new quirk for devices that cannot handle control-line state
requests.

Note that we currently send these requests to all devices, regardless of
whether they claim to support it, but that errors are only logged if
support is claimed.

Since commit 0943d8ead30e ("USB: cdc-acm: use tty-port dtr_rts"), which
only changed the timings for these requests slightly, this has been
reported to cause occasional firmware crashes on Simtec Electronics
Entropy Key devices after re-enumeration. Enable the quirk for this
device.

Reported-by: Nix <nix@esperi.org.uk>
Tested-by: Nix <nix@esperi.org.uk>
Cc: stable <stable@vger.kernel.org>	# v3.16
Signed-off-by: Johan Hovold <johan@kernel.org>
---

Greg, 

I believe this should into v3.18 as it fixes a reported regression with
these devices.

Johan


 drivers/usb/class/cdc-acm.c | 14 ++++++++++++--
 drivers/usb/class/cdc-acm.h |  2 ++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 9d6495424b06..077d58ac3dcb 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -148,8 +148,15 @@ static int acm_ctrl_msg(struct acm *acm, int request, int value,
 /* devices aren't required to support these requests.
  * the cdc acm descriptor tells whether they do...
  */
-#define acm_set_control(acm, control) \
-	acm_ctrl_msg(acm, USB_CDC_REQ_SET_CONTROL_LINE_STATE, control, NULL, 0)
+static inline int acm_set_control(struct acm *acm, int control)
+{
+	if (acm->quirks & QUIRK_CONTROL_LINE_STATE)
+		return -EOPNOTSUPP;
+
+	return acm_ctrl_msg(acm, USB_CDC_REQ_SET_CONTROL_LINE_STATE,
+			control, NULL, 0);
+}
+
 #define acm_set_line(acm, line) \
 	acm_ctrl_msg(acm, USB_CDC_REQ_SET_LINE_CODING, 0, line, sizeof *(line))
 #define acm_send_break(acm, ms) \
@@ -1320,6 +1327,7 @@ made_compressed_probe:
 	tty_port_init(&acm->port);
 	acm->port.ops = &acm_port_ops;
 	init_usb_anchor(&acm->delayed);
+	acm->quirks = quirks;
 
 	buf = usb_alloc_coherent(usb_dev, ctrlsize, GFP_KERNEL, &acm->ctrl_dma);
 	if (!buf) {
@@ -1687,6 +1695,8 @@ static const struct usb_device_id acm_ids[] = {
 	{ USB_DEVICE(0x0572, 0x1328), /* Shiro / Aztech USB MODEM UM-3100 */
 	.driver_info = NO_UNION_NORMAL, /* has no union descriptor */
 	},
+	{ USB_DEVICE(0x20df, 0x0001), /* Simtec Electronics Entropy Key */
+	.driver_info = QUIRK_CONTROL_LINE_STATE, },
 	{ USB_DEVICE(0x2184, 0x001c) },	/* GW Instek AFG-2225 */
 	{ USB_DEVICE(0x22b8, 0x6425), /* Motorola MOTOMAGX phones */
 	},
diff --git a/drivers/usb/class/cdc-acm.h b/drivers/usb/class/cdc-acm.h
index fc75651afe1c..d3251ebd09e2 100644
--- a/drivers/usb/class/cdc-acm.h
+++ b/drivers/usb/class/cdc-acm.h
@@ -121,6 +121,7 @@ struct acm {
 	unsigned int throttle_req:1;			/* throttle requested */
 	u8 bInterval;
 	struct usb_anchor delayed;			/* writes queued for a device about to be woken */
+	unsigned long quirks;
 };
 
 #define CDC_DATA_INTERFACE_TYPE	0x0a
@@ -132,3 +133,4 @@ struct acm {
 #define NOT_A_MODEM			BIT(3)
 #define NO_DATA_INTERFACE		BIT(4)
 #define IGNORE_DEVICE			BIT(5)
+#define QUIRK_CONTROL_LINE_STATE	BIT(6)
-- 
2.0.4

