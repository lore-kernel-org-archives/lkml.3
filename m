Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964959Ab3DKN3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:29:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161250Ab3DKN3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:29:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 10/26] fsl_udc: Don't use create_proc_read_entry() [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, viro@ZenIV.linux.org.uk,
        Li Yang <leoli@freescale.com>, linuxppc-dev@lists.ozlabs.org
Date: Thu, 11 Apr 2013 14:29:01 +0100
Message-ID: <20130411132901.32763.85189.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
References: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use create_proc_read_entry() as that is deprecated, but rather use
proc_create_data() and seq_file instead.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Li Yang <leoli@freescale.com>
cc: Felipe Balbi <balbi@ti.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: linux-usb@vger.kernel.org
cc: linuxppc-dev@lists.ozlabs.org
---

 drivers/usb/gadget/fsl_udc_core.c |  124 +++++++++++++------------------------
 1 file changed, 43 insertions(+), 81 deletions(-)

diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index 04d5fef..ede70ff 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -2038,47 +2038,37 @@ static int fsl_udc_stop(struct usb_gadget *g,
 
 static const char proc_filename[] = "driver/fsl_usb2_udc";
 
-static int fsl_proc_read(char *page, char **start, off_t off, int count,
-		int *eof, void *_dev)
+static int fsl_proc_read(struct seq_file *m, void *v)
 {
-	char *buf = page;
-	char *next = buf;
-	unsigned size = count;
 	unsigned long flags;
-	int t, i;
+	int i;
 	u32 tmp_reg;
 	struct fsl_ep *ep = NULL;
 	struct fsl_req *req;
 
 	struct fsl_udc *udc = udc_controller;
-	if (off != 0)
-		return 0;
 
 	spin_lock_irqsave(&udc->lock, flags);
 
 	/* ------basic driver information ---- */
-	t = scnprintf(next, size,
+	seq_printf(m,
 			DRIVER_DESC "\n"
 			"%s version: %s\n"
 			"Gadget driver: %s\n\n",
 			driver_name, DRIVER_VERSION,
 			udc->driver ? udc->driver->driver.name : "(none)");
-	size -= t;
-	next += t;
 
 	/* ------ DR Registers ----- */
 	tmp_reg = fsl_readl(&dr_regs->usbcmd);
-	t = scnprintf(next, size,
+	seq_printf(m,
 			"USBCMD reg:\n"
 			"SetupTW: %d\n"
 			"Run/Stop: %s\n\n",
 			(tmp_reg & USB_CMD_SUTW) ? 1 : 0,
 			(tmp_reg & USB_CMD_RUN_STOP) ? "Run" : "Stop");
-	size -= t;
-	next += t;
 
 	tmp_reg = fsl_readl(&dr_regs->usbsts);
-	t = scnprintf(next, size,
+	seq_printf(m,
 			"USB Status Reg:\n"
 			"Dr Suspend: %d Reset Received: %d System Error: %s "
 			"USB Error Interrupt: %s\n\n",
@@ -2086,11 +2076,9 @@ static int fsl_proc_read(char *page, char **start, off_t off, int count,
 			(tmp_reg & USB_STS_RESET) ? 1 : 0,
 			(tmp_reg & USB_STS_SYS_ERR) ? "Err" : "Normal",
 			(tmp_reg & USB_STS_ERR) ? "Err detected" : "No err");
-	size -= t;
-	next += t;
 
 	tmp_reg = fsl_readl(&dr_regs->usbintr);
-	t = scnprintf(next, size,
+	seq_printf(m,
 			"USB Interrupt Enable Reg:\n"
 			"Sleep Enable: %d SOF Received Enable: %d "
 			"Reset Enable: %d\n"
@@ -2104,33 +2092,25 @@ static int fsl_proc_read(char *page, char **start, off_t off, int count,
 			(tmp_reg & USB_INTR_PTC_DETECT_EN) ? 1 : 0,
 			(tmp_reg & USB_INTR_ERR_INT_EN) ? 1 : 0,
 			(tmp_reg & USB_INTR_INT_EN) ? 1 : 0);
-	size -= t;
-	next += t;
 
 	tmp_reg = fsl_readl(&dr_regs->frindex);
-	t = scnprintf(next, size,
+	seq_printf(m,
 			"USB Frame Index Reg: Frame Number is 0x%x\n\n",
 			(tmp_reg & USB_FRINDEX_MASKS));
-	size -= t;
-	next += t;
 
 	tmp_reg = fsl_readl(&dr_regs->deviceaddr);
-	t = scnprintf(next, size,
+	seq_printf(m,
 			"USB Device Address Reg: Device Addr is 0x%x\n\n",
 			(tmp_reg & USB_DEVICE_ADDRESS_MASK));
-	size -= t;
-	next += t;
 
 	tmp_reg = fsl_readl(&dr_regs->endpointlistaddr);
-	t = scnprintf(next, size,
+	seq_printf(m,
 			"USB Endpoint List Address Reg: "
 			"Device Addr is 0x%x\n\n",
 			(tmp_reg & USB_EP_LIST_ADDRESS_MASK));
-	size -= t;
-	next += t;
 
 	tmp_reg = fsl_readl(&dr_regs->portsc1);
-	t = scnprintf(next, size,
+	seq_printf(m,
 		"USB Port Status&Control Reg:\n"
 		"Port Transceiver Type : %s Port Speed: %s\n"
 		"PHY Low Power Suspend: %s Port Reset: %s "
@@ -2139,7 +2119,7 @@ static int fsl_proc_read(char *page, char **start, off_t off, int count,
 		"Port Enable/Disable Change: %s\n"
 		"Port Enabled/Disabled: %s "
 		"Current Connect Status: %s\n\n", ( {
-			char *s;
+			const char *s;
 			switch (tmp_reg & PORTSCX_PTS_FSLS) {
 			case PORTSCX_PTS_UTMI:
 				s = "UTMI"; break;
@@ -2165,13 +2145,11 @@ static int fsl_proc_read(char *page, char **start, off_t off, int count,
 		"Not correct",
 		(tmp_reg & PORTSCX_CURRENT_CONNECT_STATUS) ?
 		"Attached" : "Not-Att");
-	size -= t;
-	next += t;
 
 	tmp_reg = fsl_readl(&dr_regs->usbmode);
-	t = scnprintf(next, size,
+	seq_printf(m,
 			"USB Mode Reg: Controller Mode is: %s\n\n", ( {
-				char *s;
+				const char *s;
 				switch (tmp_reg & USB_MODE_CTRL_MODE_HOST) {
 				case USB_MODE_CTRL_MODE_IDLE:
 					s = "Idle"; break;
@@ -2184,103 +2162,87 @@ static int fsl_proc_read(char *page, char **start, off_t off, int count,
 				}
 				s;
 			} ));
-	size -= t;
-	next += t;
 
 	tmp_reg = fsl_readl(&dr_regs->endptsetupstat);
-	t = scnprintf(next, size,
+	seq_printf(m,
 			"Endpoint Setup Status Reg: SETUP on ep 0x%x\n\n",
 			(tmp_reg & EP_SETUP_STATUS_MASK));
-	size -= t;
-	next += t;
 
 	for (i = 0; i < udc->max_ep / 2; i++) {
 		tmp_reg = fsl_readl(&dr_regs->endptctrl[i]);
-		t = scnprintf(next, size, "EP Ctrl Reg [0x%x]: = [0x%x]\n",
-				i, tmp_reg);
-		size -= t;
-		next += t;
+		seq_printf(m, "EP Ctrl Reg [0x%x]: = [0x%x]\n", i, tmp_reg);
 	}
 	tmp_reg = fsl_readl(&dr_regs->endpointprime);
-	t = scnprintf(next, size, "EP Prime Reg = [0x%x]\n\n", tmp_reg);
-	size -= t;
-	next += t;
+	seq_printf(m, "EP Prime Reg = [0x%x]\n\n", tmp_reg);
 
 #ifndef CONFIG_ARCH_MXC
 	if (udc->pdata->have_sysif_regs) {
 		tmp_reg = usb_sys_regs->snoop1;
-		t = scnprintf(next, size, "Snoop1 Reg : = [0x%x]\n\n", tmp_reg);
-		size -= t;
-		next += t;
+		seq_printf(m, "Snoop1 Reg : = [0x%x]\n\n", tmp_reg);
 
 		tmp_reg = usb_sys_regs->control;
-		t = scnprintf(next, size, "General Control Reg : = [0x%x]\n\n",
-				tmp_reg);
-		size -= t;
-		next += t;
+		seq_printf(m, "General Control Reg : = [0x%x]\n\n", tmp_reg);
 	}
 #endif
 
 	/* ------fsl_udc, fsl_ep, fsl_request structure information ----- */
 	ep = &udc->eps[0];
-	t = scnprintf(next, size, "For %s Maxpkt is 0x%x index is 0x%x\n",
+	seq_printf(m, "For %s Maxpkt is 0x%x index is 0x%x\n",
 			ep->ep.name, ep_maxpacket(ep), ep_index(ep));
-	size -= t;
-	next += t;
 
 	if (list_empty(&ep->queue)) {
-		t = scnprintf(next, size, "its req queue is empty\n\n");
-		size -= t;
-		next += t;
+		seq_puts(m, "its req queue is empty\n\n");
 	} else {
 		list_for_each_entry(req, &ep->queue, queue) {
-			t = scnprintf(next, size,
+			seq_printf(m,
 				"req %p actual 0x%x length 0x%x buf %p\n",
 				&req->req, req->req.actual,
 				req->req.length, req->req.buf);
-			size -= t;
-			next += t;
 		}
 	}
 	/* other gadget->eplist ep */
 	list_for_each_entry(ep, &udc->gadget.ep_list, ep.ep_list) {
 		if (ep->ep.desc) {
-			t = scnprintf(next, size,
+			seq_printf(m,
 					"\nFor %s Maxpkt is 0x%x "
 					"index is 0x%x\n",
 					ep->ep.name, ep_maxpacket(ep),
 					ep_index(ep));
-			size -= t;
-			next += t;
 
 			if (list_empty(&ep->queue)) {
-				t = scnprintf(next, size,
-						"its req queue is empty\n\n");
-				size -= t;
-				next += t;
+				seq_puts(m, "its req queue is empty\n\n");
 			} else {
 				list_for_each_entry(req, &ep->queue, queue) {
-					t = scnprintf(next, size,
+					seq_printf(m,
 						"req %p actual 0x%x length "
 						"0x%x  buf %p\n",
 						&req->req, req->req.actual,
 						req->req.length, req->req.buf);
-					size -= t;
-					next += t;
-					}	/* end for each_entry of ep req */
-				}	/* end for else */
-			}	/* end for if(ep->queue) */
-		}		/* end (ep->desc) */
+				}	/* end for each_entry of ep req */
+			}	/* end for else */
+		}	/* end for if(ep->queue) */
+	}	/* end (ep->desc) */
 
 	spin_unlock_irqrestore(&udc->lock, flags);
+	return 0;
+}
 
-	*eof = 1;
-	return count - size;
+/*
+ * seq_file wrappers for procfile show routines.
+ */
+static int fsl_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, fsl_proc_read, NULL);
 }
 
-#define create_proc_file()	create_proc_read_entry(proc_filename, \
-				0, NULL, fsl_proc_read, NULL)
+static const struct file_operations fsl_proc_fops = {
+	.open		= fsl_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
 
+#define create_proc_file()	proc_create(proc_filename, 0, NULL, &fsl_proc_fops)
 #define remove_proc_file()	remove_proc_entry(proc_filename, NULL)
 
 #else				/* !CONFIG_USB_GADGET_DEBUG_FILES */

