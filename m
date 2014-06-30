Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbaF3IgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 04:36:23 -0400
Received: from mail1.skidata.com ([91.230.2.99]:54265 "EHLO mail1.skidata.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214AbaF3IgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 04:36:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqIEAFUgsVOsEApK/2dsb2JhbABag19axVoBgSN1hAQBBScTPxAYFCUPSAYKBAWIR64hmCsXjwcHhEMBBJpdgUeFaZASgi4
X-IPAS-Result: AqIEAFUgsVOsEApK/2dsb2JhbABag19axVoBgSN1hAQBBScTPxAYFCUPSAYKBAWIR64hmCsXjwcHhEMBBJpdgUeFaZASgi4
Date: Mon, 30 Jun 2014 10:36:16 +0200
From: Richard Leitner <richard.leitner@skidata.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCHv2] usb: gadget: serial: replace hardcoded ttyGS with PREFIX
Message-ID: <20140630103616.620a13a2@lxbuild.skidata.net>
In-Reply-To: <20140630083205.596557f1@lxbuild.skidata.net>
References: <20140627133721.10ca6cab@lxbuild.skidata.net>
	<20140627174628.GA1449@kroah.com>
	<20140630083205.596557f1@lxbuild.skidata.net>
Organization: SKIDATA AG
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.60.30]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaces all hardcoded ttyGS strings with the PREFIX macro.
Due to the fact the strings are spread over different source files the
PREFIX definition is moved to u_serial.h

Signed-off-by: Richard Leitner <richard.leitner@skidata.com>
---
v2: removed checkpatch.pl resovling (will be in a separate patch)
---
 drivers/usb/gadget/f_acm.c    |   36 ++++++++++++++++++------------------
 drivers/usb/gadget/f_obex.c   |   27 ++++++++++++++-------------
 drivers/usb/gadget/f_serial.c |   10 +++++-----
 drivers/usb/gadget/u_serial.c |   30 +++++++++++++++---------------
 drivers/usb/gadget/u_serial.h |    1 +
 5 files changed, 53 insertions(+), 51 deletions(-)

diff --git a/drivers/usb/gadget/f_acm.c b/drivers/usb/gadget/f_acm.c
index ab1065a..c6e6457 100644
--- a/drivers/usb/gadget/f_acm.c
+++ b/drivers/usb/gadget/f_acm.c
@@ -313,15 +313,15 @@ static void acm_complete_set_line_coding(struct usb_ep *ep,
 	struct usb_composite_dev *cdev = acm->port.func.config->cdev;
 
 	if (req->status != 0) {
-		DBG(cdev, "acm ttyGS%d completion, err %d\n",
-				acm->port_num, req->status);
+		DBG(cdev, "acm %s%d completion, err %d\n",
+				PREFIX, acm->port_num, req->status);
 		return;
 	}
 
 	/* normal completion */
 	if (req->actual != sizeof(acm->port_line_coding)) {
-		DBG(cdev, "acm ttyGS%d short resp, len %d\n",
-				acm->port_num, req->actual);
+		DBG(cdev, "acm %s%d short resp, len %d\n",
+				PREFIX, acm->port_num, req->actual);
 		usb_ep_set_halt(ep);
 	} else {
 		struct usb_cdc_line_coding	*value = req->buf;
@@ -404,15 +404,15 @@ invalid:
 
 	/* respond with data transfer or status phase? */
 	if (value >= 0) {
-		DBG(cdev, "acm ttyGS%d req%02x.%02x v%04x i%04x l%d\n",
-			acm->port_num, ctrl->bRequestType, ctrl->bRequest,
-			w_value, w_index, w_length);
+		DBG(cdev, "acm %s%d req%02x.%02x v%04x i%04x l%d\n",
+			PREFIX, acm->port_num, ctrl->bRequestType,
+			ctrl->bRequest,	w_value, w_index, w_length);
 		req->zero = 0;
 		req->length = value;
 		value = usb_ep_queue(cdev->gadget->ep0, req, GFP_ATOMIC);
 		if (value < 0)
-			ERROR(cdev, "acm response on ttyGS%d, err %d\n",
-					acm->port_num, value);
+			ERROR(cdev, "acm response on %s%d, err %d\n",
+					PREFIX, acm->port_num, value);
 	}
 
 	/* device either stalls (value < 0) or reports success */
@@ -440,11 +440,11 @@ static int acm_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 
 	} else if (intf == acm->data_id) {
 		if (acm->port.in->driver_data) {
-			DBG(cdev, "reset acm ttyGS%d\n", acm->port_num);
+			DBG(cdev, "reset acm %s%d\n", PREFIX, acm->port_num);
 			gserial_disconnect(&acm->port);
 		}
 		if (!acm->port.in->desc || !acm->port.out->desc) {
-			DBG(cdev, "activate acm ttyGS%d\n", acm->port_num);
+			DBG(cdev, "activate acm %s%d\n", PREFIX, acm->port_num);
 			if (config_ep_by_speed(cdev->gadget, f,
 					       acm->port.in) ||
 			    config_ep_by_speed(cdev->gadget, f,
@@ -467,7 +467,7 @@ static void acm_disable(struct usb_function *f)
 	struct f_acm	*acm = func_to_acm(f);
 	struct usb_composite_dev *cdev = f->config->cdev;
 
-	DBG(cdev, "acm ttyGS%d deactivated\n", acm->port_num);
+	DBG(cdev, "acm %s%d deactivated\n", PREFIX, acm->port_num);
 	gserial_disconnect(&acm->port);
 	usb_ep_disable(acm->notify);
 	acm->notify->driver_data = NULL;
@@ -522,8 +522,8 @@ static int acm_cdc_notify(struct f_acm *acm, u8 type, u16 value,
 
 	if (status < 0) {
 		ERROR(acm->port.func.config->cdev,
-				"acm ttyGS%d can't notify serial state, %d\n",
-				acm->port_num, status);
+				"acm %s%d can't notify serial state, %d\n",
+				PREFIX, acm->port_num, status);
 		acm->notify_req = req;
 	}
 
@@ -537,8 +537,8 @@ static int acm_notify_serial_state(struct f_acm *acm)
 
 	spin_lock(&acm->lock);
 	if (acm->notify_req) {
-		DBG(cdev, "acm ttyGS%d serial state %04x\n",
-				acm->port_num, acm->serial_state);
+		DBG(cdev, "acm %s%d serial state %04x\n",
+				PREFIX, acm->port_num, acm->serial_state);
 		status = acm_cdc_notify(acm, USB_CDC_NOTIFY_SERIAL_STATE,
 				0, &acm->serial_state, sizeof(acm->serial_state));
 	} else {
@@ -691,8 +691,8 @@ acm_bind(struct usb_configuration *c, struct usb_function *f)
 	if (status)
 		goto fail;
 
-	DBG(cdev, "acm ttyGS%d: %s speed IN/%s OUT/%s NOTIFY/%s\n",
-			acm->port_num,
+	DBG(cdev, "acm %s%d: %s speed IN/%s OUT/%s NOTIFY/%s\n",
+			PREFIX, acm->port_num,
 			gadget_is_superspeed(c->cdev->gadget) ? "super" :
 			gadget_is_dualspeed(c->cdev->gadget) ? "dual" : "full",
 			acm->port.in->name, acm->port.out->name,
diff --git a/drivers/usb/gadget/f_obex.c b/drivers/usb/gadget/f_obex.c
index aebae18..e0276fe 100644
--- a/drivers/usb/gadget/f_obex.c
+++ b/drivers/usb/gadget/f_obex.c
@@ -200,19 +200,19 @@ static int obex_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 		if (alt != 0)
 			goto fail;
 		/* NOP */
-		DBG(cdev, "reset obex ttyGS%d control\n", obex->port_num);
+		DBG(cdev, "reset obex %s%d control\n", PREFIX, obex->port_num);
 
 	} else if (intf == obex->data_id) {
 		if (alt > 1)
 			goto fail;
 
 		if (obex->port.in->driver_data) {
-			DBG(cdev, "reset obex ttyGS%d\n", obex->port_num);
+			DBG(cdev, "reset obex %s%d\n", PREFIX, obex->port_num);
 			gserial_disconnect(&obex->port);
 		}
 
 		if (!obex->port.in->desc || !obex->port.out->desc) {
-			DBG(cdev, "init obex ttyGS%d\n", obex->port_num);
+			DBG(cdev, "init obex %s%d\n", PREFIX, obex->port_num);
 			if (config_ep_by_speed(cdev->gadget, f,
 					       obex->port.in) ||
 			    config_ep_by_speed(cdev->gadget, f,
@@ -224,7 +224,8 @@ static int obex_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 		}
 
 		if (alt == 1) {
-			DBG(cdev, "activate obex ttyGS%d\n", obex->port_num);
+			DBG(cdev, "activate obex %s%d\n",
+			    PREFIX, obex->port_num);
 			gserial_connect(&obex->port, obex->port_num);
 		}
 
@@ -252,7 +253,7 @@ static void obex_disable(struct usb_function *f)
 	struct f_obex	*obex = func_to_obex(f);
 	struct usb_composite_dev *cdev = f->config->cdev;
 
-	DBG(cdev, "obex ttyGS%d disable\n", obex->port_num);
+	DBG(cdev, "obex %s%d disable\n", PREFIX, obex->port_num);
 	gserial_disconnect(&obex->port);
 }
 
@@ -269,8 +270,8 @@ static void obex_connect(struct gserial *g)
 
 	status = usb_function_activate(&g->func);
 	if (status)
-		DBG(cdev, "obex ttyGS%d function activate --> %d\n",
-			obex->port_num, status);
+		DBG(cdev, "obex %s%d function activate --> %d\n",
+			PREFIX, obex->port_num, status);
 }
 
 static void obex_disconnect(struct gserial *g)
@@ -284,8 +285,8 @@ static void obex_disconnect(struct gserial *g)
 
 	status = usb_function_deactivate(&g->func);
 	if (status)
-		DBG(cdev, "obex ttyGS%d function deactivate --> %d\n",
-			obex->port_num, status);
+		DBG(cdev, "obex %s%d function deactivate --> %d\n",
+			PREFIX, obex->port_num, status);
 }
 
 /*-------------------------------------------------------------------------*/
@@ -377,14 +378,14 @@ static int obex_bind(struct usb_configuration *c, struct usb_function *f)
 	 */
 	status = usb_function_deactivate(f);
 	if (status < 0)
-		WARNING(cdev, "obex ttyGS%d: can't prevent enumeration, %d\n",
-			obex->port_num, status);
+		WARNING(cdev, "obex %s%d: can't prevent enumeration, %d\n",
+			PREFIX, obex->port_num, status);
 	else
 		obex->can_activate = true;
 
 
-	DBG(cdev, "obex ttyGS%d: %s speed IN/%s OUT/%s\n",
-			obex->port_num,
+	DBG(cdev, "obex %s%d: %s speed IN/%s OUT/%s\n",
+			PREFIX, obex->port_num,
 			gadget_is_dualspeed(c->cdev->gadget) ? "dual" : "full",
 			obex->port.in->name, obex->port.out->name);
 
diff --git a/drivers/usb/gadget/f_serial.c b/drivers/usb/gadget/f_serial.c
index 9ecbcbf..c62a31d 100644
--- a/drivers/usb/gadget/f_serial.c
+++ b/drivers/usb/gadget/f_serial.c
@@ -155,11 +155,11 @@ static int gser_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 	/* we know alt == 0, so this is an activation or a reset */
 
 	if (gser->port.in->driver_data) {
-		DBG(cdev, "reset generic ttyGS%d\n", gser->port_num);
+		DBG(cdev, "reset generic %s%d\n", PREFIX, gser->port_num);
 		gserial_disconnect(&gser->port);
 	}
 	if (!gser->port.in->desc || !gser->port.out->desc) {
-		DBG(cdev, "activate generic ttyGS%d\n", gser->port_num);
+		DBG(cdev, "activate generic %s%d\n", PREFIX, gser->port_num);
 		if (config_ep_by_speed(cdev->gadget, f, gser->port.in) ||
 		    config_ep_by_speed(cdev->gadget, f, gser->port.out)) {
 			gser->port.in->desc = NULL;
@@ -176,7 +176,7 @@ static void gser_disable(struct usb_function *f)
 	struct f_gser	*gser = func_to_gser(f);
 	struct usb_composite_dev *cdev = f->config->cdev;
 
-	DBG(cdev, "generic ttyGS%d deactivated\n", gser->port_num);
+	DBG(cdev, "generic %s%d deactivated\n", PREFIX, gser->port_num);
 	gserial_disconnect(&gser->port);
 }
 
@@ -239,8 +239,8 @@ static int gser_bind(struct usb_configuration *c, struct usb_function *f)
 			gser_ss_function);
 	if (status)
 		goto fail;
-	DBG(cdev, "generic ttyGS%d: %s speed IN/%s OUT/%s\n",
-			gser->port_num,
+	DBG(cdev, "generic %s%d: %s speed IN/%s OUT/%s\n",
+			PREFIX, gser->port_num,
 			gadget_is_superspeed(c->cdev->gadget) ? "super" :
 			gadget_is_dualspeed(c->cdev->gadget) ? "dual" : "full",
 			gser->port.in->name, gser->port.out->name);
diff --git a/drivers/usb/gadget/u_serial.c b/drivers/usb/gadget/u_serial.c
index ad0aca8..b87d386 100644
--- a/drivers/usb/gadget/u_serial.c
+++ b/drivers/usb/gadget/u_serial.c
@@ -57,8 +57,6 @@
  * is managed in userspace ... OBEX, PTP, and MTP have been mentioned.
  */
 
-#define PREFIX	"ttyGS"
-
 /*
  * gserial is the lifecycle interface, used by USB functions
  * gs_port is the I/O nexus, used by the tty driver
@@ -778,8 +776,8 @@ static int gs_open(struct tty_struct *tty, struct file *file)
 		spin_lock_irq(&port->port_lock);
 
 		if (status) {
-			pr_debug("gs_open: ttyGS%d (%p,%p) no buffer\n",
-				port->port_num, tty, file);
+			pr_debug("gs_open: %s%d (%p,%p) no buffer\n",
+				 PREFIX, port->port_num, tty, file);
 			port->openclose = false;
 			goto exit_unlock_port;
 		}
@@ -801,14 +799,14 @@ static int gs_open(struct tty_struct *tty, struct file *file)
 	if (port->port_usb) {
 		struct gserial	*gser = port->port_usb;
 
-		pr_debug("gs_open: start ttyGS%d\n", port->port_num);
+		pr_debug("gs_open: start %s%d\n", PREFIX, port->port_num);
 		gs_start_io(port);
 
 		if (gser->connect)
 			gser->connect(gser);
 	}
 
-	pr_debug("gs_open: ttyGS%d (%p,%p)\n", port->port_num, tty, file);
+	pr_debug("gs_open: %s%d (%p,%p)\n", PREFIX, port->port_num, tty, file);
 
 	status = 0;
 
@@ -844,7 +842,8 @@ static void gs_close(struct tty_struct *tty, struct file *file)
 		goto exit;
 	}
 
-	pr_debug("gs_close: ttyGS%d (%p,%p) ...\n", port->port_num, tty, file);
+	pr_debug("gs_close: %s%d (%p,%p) ...\n",
+		 PREFIX, port->port_num, tty, file);
 
 	/* mark port as closing but in use; we can drop port lock
 	 * and sleep if necessary
@@ -882,8 +881,8 @@ static void gs_close(struct tty_struct *tty, struct file *file)
 
 	port->openclose = false;
 
-	pr_debug("gs_close: ttyGS%d (%p,%p) done!\n",
-			port->port_num, tty, file);
+	pr_debug("gs_close: %s%d (%p,%p) done!\n",
+			PREFIX, port->port_num, tty, file);
 
 	wake_up(&port->port.close_wait);
 exit:
@@ -896,8 +895,8 @@ static int gs_write(struct tty_struct *tty, const unsigned char *buf, int count)
 	unsigned long	flags;
 	int		status;
 
-	pr_vdebug("gs_write: ttyGS%d (%p) writing %d bytes\n",
-			port->port_num, tty, count);
+	pr_vdebug("gs_write: %s%d (%p) writing %d bytes\n",
+			PREFIX, port->port_num, tty, count);
 
 	spin_lock_irqsave(&port->port_lock, flags);
 	if (count)
@@ -996,8 +995,8 @@ static int gs_break_ctl(struct tty_struct *tty, int duration)
 	int		status = 0;
 	struct gserial	*gser;
 
-	pr_vdebug("gs_break_ctl: ttyGS%d, send break (%d) \n",
-			port->port_num, duration);
+	pr_vdebug("gs_break_ctl: %s%d, send break (%d)\n",
+			PREFIX, port->port_num, duration);
 
 	spin_lock_irq(&port->port_lock);
 	gser = port->port_usb;
@@ -1210,7 +1209,8 @@ int gserial_connect(struct gserial *gser, u8 port_num)
 	 * protocol about open/close status (connect/disconnect).
 	 */
 	if (port->port.count) {
-		pr_debug("gserial_connect: start ttyGS%d\n", port->port_num);
+		pr_debug("gserial_connect: start %s%d\n",
+			 PREFIX, port->port_num);
 		gs_start_io(port);
 		if (gser->connect)
 			gser->connect(gser);
@@ -1324,7 +1324,7 @@ static int userial_init(void)
 		goto fail;
 	}
 
-	pr_debug("%s: registered %d ttyGS* device%s\n", __func__,
+	pr_debug("%s: registered %d %s* device%s\n", __func__, PREFIX,
 			MAX_U_SERIAL_PORTS,
 			(MAX_U_SERIAL_PORTS == 1) ? "" : "s");
 
diff --git a/drivers/usb/gadget/u_serial.h b/drivers/usb/gadget/u_serial.h
index c20210c..9ab3614 100644
--- a/drivers/usb/gadget/u_serial.h
+++ b/drivers/usb/gadget/u_serial.h
@@ -15,6 +15,7 @@
 #include <linux/usb/composite.h>
 #include <linux/usb/cdc.h>
 
+#define PREFIX			"ttyGS"
 #define MAX_U_SERIAL_PORTS	4
 
 struct f_serial_opts {
-- 
1.7.10.4

