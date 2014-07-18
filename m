Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761124AbaGRJL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:11:28 -0400
Received: from mail1.skidata.com ([91.230.2.99]:46334 "EHLO mail1.skidata.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760610AbaGRJLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:11:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuYEAP3jyFOsEApK/2dsb2JhbABZhDcEzC+BH3aEMRM/KBQ0TgEJBAWIR7Alk1sXj0uETQEEmx+HPoQhjBRqgUU
X-IPAS-Result: AuYEAP3jyFOsEApK/2dsb2JhbABZhDcEzC+BH3aEMRM/KBQ0TgEJBAWIR7Alk1sXj0uETQEEmx+HPoQhjBRqgUU
Date: Fri, 18 Jul 2014 11:11:21 +0200
From: Richard Leitner <richard.leitner@skidata.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] usb: gadget: serial: replace {V,}DBG macro with dev_{v,}dbg
Message-ID: <20140718111121.7a400529@lxbuild.skidata.net>
Organization: SKIDATA AG
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.60.30]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the VDBG and DBG macro with the kernels "proper" debug macros
(dev_vdbg and dev_dbg) in f_acm.c, f_obex.c & f_serial.c

Signed-off-by: Richard Leitner <richard.leitner@skidata.com>
---
 drivers/usb/gadget/f_acm.c    |   41 ++++++++++++++++++++++++-----------------
 drivers/usb/gadget/f_obex.c   |   22 ++++++++++++++--------
 drivers/usb/gadget/f_serial.c |   11 +++++++----
 3 files changed, 45 insertions(+), 29 deletions(-)

diff --git a/drivers/usb/gadget/f_acm.c b/drivers/usb/gadget/f_acm.c
index ab1065a..beac376 100644
--- a/drivers/usb/gadget/f_acm.c
+++ b/drivers/usb/gadget/f_acm.c
@@ -313,14 +313,14 @@ static void acm_complete_set_line_coding(struct usb_ep *ep,
 	struct usb_composite_dev *cdev = acm->port.func.config->cdev;
 
 	if (req->status != 0) {
-		DBG(cdev, "acm ttyGS%d completion, err %d\n",
+		dev_dbg(&cdev->gadget->dev, "acm ttyGS%d completion, err %d\n",
 				acm->port_num, req->status);
 		return;
 	}
 
 	/* normal completion */
 	if (req->actual != sizeof(acm->port_line_coding)) {
-		DBG(cdev, "acm ttyGS%d short resp, len %d\n",
+		dev_dbg(&cdev->gadget->dev, "acm ttyGS%d short resp, len %d\n",
 				acm->port_num, req->actual);
 		usb_ep_set_halt(ep);
 	} else {
@@ -397,14 +397,16 @@ static int acm_setup(struct usb_function *f, const struct usb_ctrlrequest *ctrl)
 
 	default:
 invalid:
-		VDBG(cdev, "invalid control req%02x.%02x v%04x i%04x l%d\n",
+		dev_vdbg(&cdev->gadget->dev,
+			"invalid control req%02x.%02x v%04x i%04x l%d\n",
 			ctrl->bRequestType, ctrl->bRequest,
 			w_value, w_index, w_length);
 	}
 
 	/* respond with data transfer or status phase? */
 	if (value >= 0) {
-		DBG(cdev, "acm ttyGS%d req%02x.%02x v%04x i%04x l%d\n",
+		dev_dbg(&cdev->gadget->dev,
+			"acm ttyGS%d req%02x.%02x v%04x i%04x l%d\n",
 			acm->port_num, ctrl->bRequestType, ctrl->bRequest,
 			w_value, w_index, w_length);
 		req->zero = 0;
@@ -428,10 +430,12 @@ static int acm_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 
 	if (intf == acm->ctrl_id) {
 		if (acm->notify->driver_data) {
-			VDBG(cdev, "reset acm control interface %d\n", intf);
+			dev_vdbg(&cdev->gadget->dev,
+				 "reset acm control interface %d\n", intf);
 			usb_ep_disable(acm->notify);
 		} else {
-			VDBG(cdev, "init acm ctrl interface %d\n", intf);
+			dev_vdbg(&cdev->gadget->dev,
+				 "init acm ctrl interface %d\n", intf);
 			if (config_ep_by_speed(cdev->gadget, f, acm->notify))
 				return -EINVAL;
 		}
@@ -440,11 +444,13 @@ static int acm_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 
 	} else if (intf == acm->data_id) {
 		if (acm->port.in->driver_data) {
-			DBG(cdev, "reset acm ttyGS%d\n", acm->port_num);
+			dev_dbg(&cdev->gadget->dev,
+				"reset acm ttyGS%d\n", acm->port_num);
 			gserial_disconnect(&acm->port);
 		}
 		if (!acm->port.in->desc || !acm->port.out->desc) {
-			DBG(cdev, "activate acm ttyGS%d\n", acm->port_num);
+			dev_dbg(&cdev->gadget->dev,
+				"activate acm ttyGS%d\n", acm->port_num);
 			if (config_ep_by_speed(cdev->gadget, f,
 					       acm->port.in) ||
 			    config_ep_by_speed(cdev->gadget, f,
@@ -467,7 +473,7 @@ static void acm_disable(struct usb_function *f)
 	struct f_acm	*acm = func_to_acm(f);
 	struct usb_composite_dev *cdev = f->config->cdev;
 
-	DBG(cdev, "acm ttyGS%d deactivated\n", acm->port_num);
+	dev_dbg(&cdev->gadget->dev, "acm ttyGS%d deactivated\n", acm->port_num);
 	gserial_disconnect(&acm->port);
 	usb_ep_disable(acm->notify);
 	acm->notify->driver_data = NULL;
@@ -537,8 +543,8 @@ static int acm_notify_serial_state(struct f_acm *acm)
 
 	spin_lock(&acm->lock);
 	if (acm->notify_req) {
-		DBG(cdev, "acm ttyGS%d serial state %04x\n",
-				acm->port_num, acm->serial_state);
+		dev_dbg(&cdev->gadget->dev, "acm ttyGS%d serial state %04x\n",
+			acm->port_num, acm->serial_state);
 		status = acm_cdc_notify(acm, USB_CDC_NOTIFY_SERIAL_STATE,
 				0, &acm->serial_state, sizeof(acm->serial_state));
 	} else {
@@ -691,12 +697,13 @@ acm_bind(struct usb_configuration *c, struct usb_function *f)
 	if (status)
 		goto fail;
 
-	DBG(cdev, "acm ttyGS%d: %s speed IN/%s OUT/%s NOTIFY/%s\n",
-			acm->port_num,
-			gadget_is_superspeed(c->cdev->gadget) ? "super" :
-			gadget_is_dualspeed(c->cdev->gadget) ? "dual" : "full",
-			acm->port.in->name, acm->port.out->name,
-			acm->notify->name);
+	dev_dbg(&cdev->gadget->dev,
+		"acm ttyGS%d: %s speed IN/%s OUT/%s NOTIFY/%s\n",
+		acm->port_num,
+		gadget_is_superspeed(c->cdev->gadget) ? "super" :
+		gadget_is_dualspeed(c->cdev->gadget) ? "dual" : "full",
+		acm->port.in->name, acm->port.out->name,
+		acm->notify->name);
 	return 0;
 
 fail:
diff --git a/drivers/usb/gadget/f_obex.c b/drivers/usb/gadget/f_obex.c
index aebae18..29a5496 100644
--- a/drivers/usb/gadget/f_obex.c
+++ b/drivers/usb/gadget/f_obex.c
@@ -200,19 +200,22 @@ static int obex_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 		if (alt != 0)
 			goto fail;
 		/* NOP */
-		DBG(cdev, "reset obex ttyGS%d control\n", obex->port_num);
+		dev_dbg(&cdev->gadget->dev,
+			"reset obex ttyGS%d control\n", obex->port_num);
 
 	} else if (intf == obex->data_id) {
 		if (alt > 1)
 			goto fail;
 
 		if (obex->port.in->driver_data) {
-			DBG(cdev, "reset obex ttyGS%d\n", obex->port_num);
+			dev_dbg(&cdev->gadget->dev,
+				"reset obex ttyGS%d\n", obex->port_num);
 			gserial_disconnect(&obex->port);
 		}
 
 		if (!obex->port.in->desc || !obex->port.out->desc) {
-			DBG(cdev, "init obex ttyGS%d\n", obex->port_num);
+			dev_dbg(&cdev->gadget->dev,
+				"init obex ttyGS%d\n", obex->port_num);
 			if (config_ep_by_speed(cdev->gadget, f,
 					       obex->port.in) ||
 			    config_ep_by_speed(cdev->gadget, f,
@@ -224,7 +227,8 @@ static int obex_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 		}
 
 		if (alt == 1) {
-			DBG(cdev, "activate obex ttyGS%d\n", obex->port_num);
+			dev_dbg(&cdev->gadget->dev,
+				"activate obex ttyGS%d\n", obex->port_num);
 			gserial_connect(&obex->port, obex->port_num);
 		}
 
@@ -252,7 +256,7 @@ static void obex_disable(struct usb_function *f)
 	struct f_obex	*obex = func_to_obex(f);
 	struct usb_composite_dev *cdev = f->config->cdev;
 
-	DBG(cdev, "obex ttyGS%d disable\n", obex->port_num);
+	dev_dbg(&cdev->gadget->dev, "obex ttyGS%d disable\n", obex->port_num);
 	gserial_disconnect(&obex->port);
 }
 
@@ -269,7 +273,8 @@ static void obex_connect(struct gserial *g)
 
 	status = usb_function_activate(&g->func);
 	if (status)
-		DBG(cdev, "obex ttyGS%d function activate --> %d\n",
+		dev_dbg(&cdev->gadget->dev,
+			"obex ttyGS%d function activate --> %d\n",
 			obex->port_num, status);
 }
 
@@ -284,7 +289,8 @@ static void obex_disconnect(struct gserial *g)
 
 	status = usb_function_deactivate(&g->func);
 	if (status)
-		DBG(cdev, "obex ttyGS%d function deactivate --> %d\n",
+		dev_dbg(&cdev->gadget->dev,
+			"obex ttyGS%d function deactivate --> %d\n",
 			obex->port_num, status);
 }
 
@@ -383,7 +389,7 @@ static int obex_bind(struct usb_configuration *c, struct usb_function *f)
 		obex->can_activate = true;
 
 
-	DBG(cdev, "obex ttyGS%d: %s speed IN/%s OUT/%s\n",
+	dev_dbg(&cdev->gadget->dev, "obex ttyGS%d: %s speed IN/%s OUT/%s\n",
 			obex->port_num,
 			gadget_is_dualspeed(c->cdev->gadget) ? "dual" : "full",
 			obex->port.in->name, obex->port.out->name);
diff --git a/drivers/usb/gadget/f_serial.c b/drivers/usb/gadget/f_serial.c
index 9ecbcbf..faa3de0 100644
--- a/drivers/usb/gadget/f_serial.c
+++ b/drivers/usb/gadget/f_serial.c
@@ -155,11 +155,13 @@ static int gser_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 	/* we know alt == 0, so this is an activation or a reset */
 
 	if (gser->port.in->driver_data) {
-		DBG(cdev, "reset generic ttyGS%d\n", gser->port_num);
+		dev_dbg(&cdev->gadget->dev,
+			"reset generic ttyGS%d\n", gser->port_num);
 		gserial_disconnect(&gser->port);
 	}
 	if (!gser->port.in->desc || !gser->port.out->desc) {
-		DBG(cdev, "activate generic ttyGS%d\n", gser->port_num);
+		dev_dbg(&cdev->gadget->dev,
+			"activate generic ttyGS%d\n", gser->port_num);
 		if (config_ep_by_speed(cdev->gadget, f, gser->port.in) ||
 		    config_ep_by_speed(cdev->gadget, f, gser->port.out)) {
 			gser->port.in->desc = NULL;
@@ -176,7 +178,8 @@ static void gser_disable(struct usb_function *f)
 	struct f_gser	*gser = func_to_gser(f);
 	struct usb_composite_dev *cdev = f->config->cdev;
 
-	DBG(cdev, "generic ttyGS%d deactivated\n", gser->port_num);
+	dev_dbg(&cdev->gadget->dev,
+		"generic ttyGS%d deactivated\n", gser->port_num);
 	gserial_disconnect(&gser->port);
 }
 
@@ -239,7 +242,7 @@ static int gser_bind(struct usb_configuration *c, struct usb_function *f)
 			gser_ss_function);
 	if (status)
 		goto fail;
-	DBG(cdev, "generic ttyGS%d: %s speed IN/%s OUT/%s\n",
+	dev_dbg(&cdev->gadget->dev, "generic ttyGS%d: %s speed IN/%s OUT/%s\n",
 			gser->port_num,
 			gadget_is_superspeed(c->cdev->gadget) ? "super" :
 			gadget_is_dualspeed(c->cdev->gadget) ? "dual" : "full",
-- 
1.7.10.4

