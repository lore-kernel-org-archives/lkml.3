Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161180Ab3DKN3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:29:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765431Ab3DKN26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:28:58 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 09/26] goku_udc: Don't use create_proc_read_entry() [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        viro@ZenIV.linux.org.uk, Felipe Balbi <balbi@ti.com>
Date: Thu, 11 Apr 2013 14:28:54 +0100
Message-ID: <20130411132854.32763.82834.stgit@warthog.procyon.org.uk>
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
cc: Felipe Balbi <balbi@ti.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: linux-usb@vger.kernel.org
---

 drivers/usb/gadget/goku_udc.c |   89 ++++++++++++++++++-----------------------
 1 file changed, 39 insertions(+), 50 deletions(-)

diff --git a/drivers/usb/gadget/goku_udc.c b/drivers/usb/gadget/goku_udc.c
index 85742d4..57a5470 100644
--- a/drivers/usb/gadget/goku_udc.c
+++ b/drivers/usb/gadget/goku_udc.c
@@ -35,6 +35,7 @@
 #include <linux/list.h>
 #include <linux/interrupt.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/device.h>
 #include <linux/usb/ch9.h>
 #include <linux/usb/gadget.h>
@@ -1008,7 +1009,7 @@ static const struct usb_gadget_ops goku_ops = {
 
 /*-------------------------------------------------------------------------*/
 
-static inline char *dmastr(void)
+static inline const char *dmastr(void)
 {
 	if (use_dma == 0)
 		return "(dma disabled)";
@@ -1025,13 +1026,10 @@ static const char proc_node_name [] = "driver/udc";
 #define FOURBITS "%s%s%s%s"
 #define EIGHTBITS FOURBITS FOURBITS
 
-static void
-dump_intmask(const char *label, u32 mask, char **next, unsigned *size)
+static void dump_intmask(struct seq_file *m, const char *label, u32 mask)
 {
-	int t;
-
 	/* int_status is the same format ... */
-	t = scnprintf(*next, *size,
+	seq_printf(m,
 		"%s %05X =" FOURBITS EIGHTBITS EIGHTBITS "\n",
 		label, mask,
 		(mask & INT_PWRDETECT) ? " power" : "",
@@ -1058,33 +1056,23 @@ dump_intmask(const char *label, u32 mask, char **next, unsigned *size)
 		(mask & INT_ENDPOINT0) ? " ep0" : "",
 		(mask & INT_USBRESET) ? " reset" : "",
 		(mask & INT_SUSPEND) ? " suspend" : "");
-	*size -= t;
-	*next += t;
 }
 
 
-static int
-udc_proc_read(char *buffer, char **start, off_t off, int count,
-		int *eof, void *_dev)
+static int udc_proc_read(struct seq_file *m, void *v)
 {
-	char				*buf = buffer;
-	struct goku_udc			*dev = _dev;
+	struct goku_udc			*dev = m->private;
 	struct goku_udc_regs __iomem	*regs = dev->regs;
-	char				*next = buf;
-	unsigned			size = count;
 	unsigned long			flags;
-	int				i, t, is_usb_connected;
+	int				i, is_usb_connected;
 	u32				tmp;
 
-	if (off != 0)
-		return 0;
-
 	local_irq_save(flags);
 
 	/* basic device status */
 	tmp = readl(&regs->power_detect);
 	is_usb_connected = tmp & PW_DETECT;
-	t = scnprintf(next, size,
+	seq_printf(m,
 		"%s - %s\n"
 		"%s version: %s %s\n"
 		"Gadget driver: %s\n"
@@ -1096,7 +1084,7 @@ udc_proc_read(char *buffer, char **start, off_t off, int count,
 		is_usb_connected
 			? ((tmp & PW_PULLUP) ? "full speed" : "powered")
 			: "disconnected",
-		({char *state;
+		({const char *state;
 		switch(dev->ep0state){
 		case EP0_DISCONNECT:	state = "ep0_disconnect"; break;
 		case EP0_IDLE:		state = "ep0_idle"; break;
@@ -1108,27 +1096,24 @@ udc_proc_read(char *buffer, char **start, off_t off, int count,
 		default:		state = "ep0_?"; break;
 		} state; })
 		);
-	size -= t;
-	next += t;
 
-	dump_intmask("int_status", readl(&regs->int_status), &next, &size);
-	dump_intmask("int_enable", readl(&regs->int_enable), &next, &size);
+	dump_intmask(m, "int_status", readl(&regs->int_status));
+	dump_intmask(m, "int_enable", readl(&regs->int_enable));
 
 	if (!is_usb_connected || !dev->driver || (tmp & PW_PULLUP) == 0)
 		goto done;
 
 	/* registers for (active) device and ep0 */
-	t = scnprintf(next, size, "\nirqs %lu\ndataset %02x "
+	if (seq_printf(m, "\nirqs %lu\ndataset %02x "
 			"single.bcs %02x.%02x state %x addr %u\n",
 			dev->irqs, readl(&regs->DataSet),
 			readl(&regs->EPxSingle), readl(&regs->EPxBCS),
 			readl(&regs->UsbState),
-			readl(&regs->address));
-	size -= t;
-	next += t;
+			readl(&regs->address)) < 0)
+		goto done;
 
 	tmp = readl(&regs->dma_master);
-	t = scnprintf(next, size,
+	if (seq_printf(m,
 		"dma %03X =" EIGHTBITS "%s %s\n", tmp,
 		(tmp & MST_EOPB_DIS) ? " eopb-" : "",
 		(tmp & MST_EOPB_ENA) ? " eopb+" : "",
@@ -1143,9 +1128,8 @@ udc_proc_read(char *buffer, char **start, off_t off, int count,
 		(tmp & MST_WR_ENA) ? " OUT" : "",
 		(tmp & MST_CONNECTION)
 			? "ep1in/ep2out"
-			: "ep1out/ep2in");
-	size -= t;
-	next += t;
+			: "ep1out/ep2in") < 0)
+		goto done;
 
 	/* dump endpoint queues */
 	for (i = 0; i < 4; i++) {
@@ -1156,7 +1140,7 @@ udc_proc_read(char *buffer, char **start, off_t off, int count,
 			continue;
 
 		tmp = readl(ep->reg_status);
-		t = scnprintf(next, size,
+		if (seq_printf(m,
 			"%s %s max %u %s, irqs %lu, "
 			"status %02x (%s) " FOURBITS "\n",
 			ep->ep.name,
@@ -1189,18 +1173,12 @@ udc_proc_read(char *buffer, char **start, off_t off, int count,
 			(tmp & EPxSTATUS_SUSPEND) ? " suspend" : "",
 			(tmp & EPxSTATUS_FIFO_DISABLE) ? " disable" : "",
 			(tmp & EPxSTATUS_STAGE_ERROR) ? " ep0stat" : ""
-			);
-		if (t <= 0 || t > size)
+			) < 0)
 			goto done;
-		size -= t;
-		next += t;
 
 		if (list_empty(&ep->queue)) {
-			t = scnprintf(next, size, "\t(nothing queued)\n");
-			if (t <= 0 || t > size)
+			if (seq_puts(m, "\t(nothing queued)\n") < 0)
 				goto done;
-			size -= t;
-			next += t;
 			continue;
 		}
 		list_for_each_entry(req, &ep->queue, queue) {
@@ -1214,23 +1192,34 @@ udc_proc_read(char *buffer, char **start, off_t off, int count,
 			} else
 				tmp = req->req.actual;
 
-			t = scnprintf(next, size,
+			if (seq_printf(m,
 				"\treq %p len %u/%u buf %p\n",
 				&req->req, tmp, req->req.length,
-				req->req.buf);
-			if (t <= 0 || t > size)
+				req->req.buf) < 0)
 				goto done;
-			size -= t;
-			next += t;
 		}
 	}
 
 done:
 	local_irq_restore(flags);
-	*eof = 1;
-	return count - size;
+	return 0;
+}
+
+/*
+ * seq_file wrappers for procfile show routines.
+ */
+static int udc_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, udc_proc_read, PDE_DATA(file_inode(file)));
 }
 
+static const struct file_operations udc_proc_fops = {
+	.open		= udc_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 #endif	/* CONFIG_USB_GADGET_DEBUG_FILES */
 
 /*-------------------------------------------------------------------------*/
@@ -1807,7 +1796,7 @@ static int goku_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 
 #ifdef CONFIG_USB_GADGET_DEBUG_FILES
-	create_proc_read_entry(proc_node_name, 0, NULL, udc_proc_read, dev);
+	proc_create_data(proc_node_name, 0, NULL, &udc_proc_fops, dev);
 #endif
 
 	retval = device_register(&dev->gadget.dev);

