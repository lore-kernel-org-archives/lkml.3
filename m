Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbaKJS7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:59:22 -0500
Received: from smtprelay0045.hostedemail.com ([216.40.44.45]:51569 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751590AbaKJS7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:59:18 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::,RULES_HIT:1:41:69:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1605:1730:1747:1777:1792:1801:2194:2199:2393:2559:2562:2636:2693:2896:2898:3138:3139:3140:3141:3142:3308:3865:3866:3870:3871:3872:4321:4605:5007:6119:6261:7875:7904:8603:9038:9592:10004:10848:11026:11473:11657:11658:11914:12043:12048:12291:12296:12438:12517:12519:12555:12681:12683:13972:14096:14110:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: act08_8a721205a321e
X-Filterd-Recvd-Size: 11202
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Wim Van Sebroeck <wim@iguana.be>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Petr Mladek <pmladek@suse.cz>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH -next 1/2] seq_puts: Convert to return void and convert uses too.
Date: Mon, 10 Nov 2014 10:58:56 -0800
Message-Id: <c8249a5c6504275a0e22704dda83b34002a89eac.1415645476.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <cover.1415645476.git.joe@perches.com>
References: <cover.1415645476.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the return value of seq_puts is error-prone, so
make it return void instead.

Use seq_has_overflowed where appropriate instead of the
old return value.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/parisc/ccio-dma.c         |  7 ++--
 drivers/regulator/dbx500-prcmu.c  | 21 ++++------
 drivers/usb/gadget/udc/goku_udc.c | 81 ++++++++++++++++++++-------------------
 drivers/watchdog/bcm_kona_wdt.c   | 43 ++++++++++++---------
 fs/seq_file.c                     | 15 ++++----
 include/linux/seq_file.h          |  2 +-
 ipc/util.c                        |  6 ++-
 7 files changed, 89 insertions(+), 86 deletions(-)

diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index 8b490d7..c40cc98 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -1101,7 +1101,6 @@ static const struct file_operations ccio_proc_info_fops = {
 
 static int ccio_proc_bitmap_info(struct seq_file *m, void *p)
 {
-	int len = 0;
 	struct ioc *ioc = ioc_list;
 
 	while (ioc != NULL) {
@@ -1110,11 +1109,11 @@ static int ccio_proc_bitmap_info(struct seq_file *m, void *p)
 
 		for (j = 0; j < (ioc->res_size / sizeof(u32)); j++) {
 			if ((j & 7) == 0)
-				len += seq_puts(m, "\n   ");
-			len += seq_printf(m, "%08x", *res_ptr);
+				seq_puts(m, "\n   ");
+			seq_printf(m, "%08x", *res_ptr);
 			res_ptr++;
 		}
-		len += seq_puts(m, "\n\n");
+		seq_puts(m, "\n\n");
 		ioc = ioc->next;
 		break; /* XXX - remove me */
 	}
diff --git a/drivers/regulator/dbx500-prcmu.c b/drivers/regulator/dbx500-prcmu.c
index 2d16b9f..b778ca9 100644
--- a/drivers/regulator/dbx500-prcmu.c
+++ b/drivers/regulator/dbx500-prcmu.c
@@ -129,14 +129,8 @@ static int ux500_regulator_status_print(struct seq_file *s, void *p)
 	int i;
 
 	/* print dump header */
-	err = seq_puts(s, "ux500-regulator status:\n");
-	if (err < 0)
-		dev_err(dev, "seq_puts overflow\n");
-
-	err = seq_printf(s, "%31s : %8s : %8s\n", "current",
-		"before", "after");
-	if (err < 0)
-		dev_err(dev, "seq_printf overflow\n");
+	seq_puts(s, "ux500-regulator status:\n");
+	seq_printf(s, "%31s : %8s : %8s\n", "current", "before", "after");
 
 	for (i = 0; i < rdebug.num_regulators; i++) {
 		struct dbx500_regulator_info *info;
@@ -144,12 +138,11 @@ static int ux500_regulator_status_print(struct seq_file *s, void *p)
 		info = &rdebug.regulator_array[i];
 
 		/* print status */
-		err = seq_printf(s, "%20s : %8s : %8s : %8s\n", info->desc.name,
-			info->is_enabled ? "enabled" : "disabled",
-			rdebug.state_before_suspend[i] ? "enabled" : "disabled",
-			rdebug.state_after_suspend[i] ? "enabled" : "disabled");
-		if (err < 0)
-			dev_err(dev, "seq_printf overflow\n");
+		seq_printf(s, "%20s : %8s : %8s : %8s\n",
+			   info->desc.name,
+			   info->is_enabled ? "enabled" : "disabled",
+			   rdebug.state_before_suspend[i] ? "enabled" : "disabled",
+			   rdebug.state_after_suspend[i] ? "enabled" : "disabled");
 	}
 
 	return 0;
diff --git a/drivers/usb/gadget/udc/goku_udc.c b/drivers/usb/gadget/udc/goku_udc.c
index 5b9176e..c16b4d9 100644
--- a/drivers/usb/gadget/udc/goku_udc.c
+++ b/drivers/usb/gadget/udc/goku_udc.c
@@ -1135,44 +1135,47 @@ static int udc_proc_read(struct seq_file *m, void *v)
 			continue;
 
 		tmp = readl(ep->reg_status);
-		if (seq_printf(m,
-			"%s %s max %u %s, irqs %lu, "
-			"status %02x (%s) " FOURBITS "\n",
-			ep->ep.name,
-			ep->is_in ? "in" : "out",
-			ep->ep.maxpacket,
-			ep->dma ? "dma" : "pio",
-			ep->irqs,
-			tmp, ({ char *s;
-			switch (tmp & EPxSTATUS_EP_MASK) {
-			case EPxSTATUS_EP_READY:
-				s = "ready"; break;
-			case EPxSTATUS_EP_DATAIN:
-				s = "packet"; break;
-			case EPxSTATUS_EP_FULL:
-				s = "full"; break;
-			case EPxSTATUS_EP_TX_ERR:	// host will retry
-				s = "tx_err"; break;
-			case EPxSTATUS_EP_RX_ERR:
-				s = "rx_err"; break;
-			case EPxSTATUS_EP_BUSY:		/* ep0 only */
-				s = "busy"; break;
-			case EPxSTATUS_EP_STALL:
-				s = "stall"; break;
-			case EPxSTATUS_EP_INVALID:	// these "can't happen"
-				s = "invalid"; break;
-			default:
-				s = "?"; break;
-			} s; }),
-			(tmp & EPxSTATUS_TOGGLE) ? "data1" : "data0",
-			(tmp & EPxSTATUS_SUSPEND) ? " suspend" : "",
-			(tmp & EPxSTATUS_FIFO_DISABLE) ? " disable" : "",
-			(tmp & EPxSTATUS_STAGE_ERROR) ? " ep0stat" : ""
-			) < 0)
+		seq_printf(m, "%s %s max %u %s, irqs %lu, status %02x (%s) " FOURBITS "\n",
+			   ep->ep.name,
+			   ep->is_in ? "in" : "out",
+			   ep->ep.maxpacket,
+			   ep->dma ? "dma" : "pio",
+			   ep->irqs,
+			   tmp,
+			   ({
+				char *s;
+				switch (tmp & EPxSTATUS_EP_MASK) {
+				case EPxSTATUS_EP_READY:
+					s = "ready"; break;
+				case EPxSTATUS_EP_DATAIN:
+					s = "packet"; break;
+				case EPxSTATUS_EP_FULL:
+					s = "full"; break;
+				case EPxSTATUS_EP_TX_ERR:  /* host will retry */
+					s = "tx_err"; break;
+				case EPxSTATUS_EP_RX_ERR:
+					s = "rx_err"; break;
+				case EPxSTATUS_EP_BUSY:    /* ep0 only */
+					s = "busy"; break;
+				case EPxSTATUS_EP_STALL:
+					s = "stall"; break;
+				case EPxSTATUS_EP_INVALID: /* "can't happen" */
+					s = "invalid"; break;
+				default:
+					s = "?"; break;
+				}
+				s;
+			   }),
+			   (tmp & EPxSTATUS_TOGGLE) ? "data1" : "data0",
+			   (tmp & EPxSTATUS_SUSPEND) ? " suspend" : "",
+			   (tmp & EPxSTATUS_FIFO_DISABLE) ? " disable" : "",
+			   (tmp & EPxSTATUS_STAGE_ERROR) ? " ep0stat" : "");
+		if (seq_has_overflowed(m) < 0)
 			goto done;
 
 		if (list_empty(&ep->queue)) {
-			if (seq_puts(m, "\t(nothing queued)\n") < 0)
+			seq_puts(m, "\t(nothing queued)\n");
+			if (seq_has_overflowed(m))
 				goto done;
 			continue;
 		}
@@ -1187,10 +1190,10 @@ static int udc_proc_read(struct seq_file *m, void *v)
 			} else
 				tmp = req->req.actual;
 
-			if (seq_printf(m,
-				"\treq %p len %u/%u buf %p\n",
-				&req->req, tmp, req->req.length,
-				req->req.buf) < 0)
+			seq_printf(m, "\treq %p len %u/%u buf %p\n",
+				   &req->req, tmp, req->req.length,
+				   req->req.buf);
+			if (seq_has_overflowed(m))
 				goto done;
 		}
 	}
diff --git a/drivers/watchdog/bcm_kona_wdt.c b/drivers/watchdog/bcm_kona_wdt.c
index 4e37db3..0e5ec3c 100644
--- a/drivers/watchdog/bcm_kona_wdt.c
+++ b/drivers/watchdog/bcm_kona_wdt.c
@@ -102,34 +102,39 @@ static int bcm_kona_wdt_dbg_show(struct seq_file *s, void *data)
 	int ctl_val, cur_val, ret;
 	unsigned long flags;
 	struct bcm_kona_wdt *wdt = s->private;
+	int ctl, cur, ctl_sec, cur_sec, res;
 
-	if (!wdt)
-		return seq_puts(s, "No device pointer\n");
-
+	if (!wdt) {
+		seq_puts(s, "No device pointer\n");
+		return 0;
+	}
 	spin_lock_irqsave(&wdt->lock, flags);
 	ctl_val = secure_register_read(wdt, SECWDOG_CTRL_REG);
 	cur_val = secure_register_read(wdt, SECWDOG_COUNT_REG);
 	spin_unlock_irqrestore(&wdt->lock, flags);
 
 	if (ctl_val < 0 || cur_val < 0) {
-		ret = seq_puts(s, "Error accessing hardware\n");
-	} else {
-		int ctl, cur, ctl_sec, cur_sec, res;
-
-		ctl = ctl_val & SECWDOG_COUNT_MASK;
-		res = (ctl_val & SECWDOG_RES_MASK) >> SECWDOG_CLKS_SHIFT;
-		cur = cur_val & SECWDOG_COUNT_MASK;
-		ctl_sec = TICKS_TO_SECS(ctl, wdt);
-		cur_sec = TICKS_TO_SECS(cur, wdt);
-		ret = seq_printf(s, "Resolution: %d / %d\n"
-				"Control: %d s / %d (%#x) ticks\n"
-				"Current: %d s / %d (%#x) ticks\n"
-				"Busy count: %lu\n", res,
-				wdt->resolution, ctl_sec, ctl, ctl, cur_sec,
-				cur, cur, wdt->busy_count);
+		seq_puts(s, "Error accessing hardware\n");
+		return 0;
 	}
 
-	return ret;
+	ctl = ctl_val & SECWDOG_COUNT_MASK;
+	res = (ctl_val & SECWDOG_RES_MASK) >> SECWDOG_CLKS_SHIFT;
+	cur = cur_val & SECWDOG_COUNT_MASK;
+	ctl_sec = TICKS_TO_SECS(ctl, wdt);
+	cur_sec = TICKS_TO_SECS(cur, wdt);
+	seq_printf(s,
+		   "Resolution: %d / %d\n"
+		   "Control: %d s / %d (%#x) ticks\n"
+		   "Current: %d s / %d (%#x) ticks\n"
+		   "Busy count: %lu\n",
+		   res, wdt->resolution,
+		   ctl_sec, ctl, ctl,
+		   cur_sec, cur, cur,
+		   wdt->busy_count);
+	}
+
+	return 0;
 }
 
 static int bcm_kona_dbg_open(struct inode *inode, struct file *file)
diff --git a/fs/seq_file.c b/fs/seq_file.c
index 353948b..e6be05a 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -683,16 +683,17 @@ int seq_putc(struct seq_file *m, char c)
 }
 EXPORT_SYMBOL(seq_putc);
 
-int seq_puts(struct seq_file *m, const char *s)
+void seq_puts(struct seq_file *m, const char *s)
 {
 	int len = strlen(s);
-	if (m->count + len < m->size) {
-		memcpy(m->buf + m->count, s, len);
-		m->count += len;
-		return 0;
+
+	if (m->count + len >= m->size) {
+		seq_set_overflow(m);
+		return;
 	}
-	seq_set_overflow(m);
-	return -1;
+
+	memcpy(m->buf + m->count, s, len);
+	m->count += len;
 }
 EXPORT_SYMBOL(seq_puts);
 
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index cf6a9da..9b02cb6 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -116,7 +116,7 @@ loff_t seq_lseek(struct file *, loff_t, int);
 int seq_release(struct inode *, struct file *);
 int seq_escape(struct seq_file *, const char *, const char *);
 int seq_putc(struct seq_file *m, char c);
-int seq_puts(struct seq_file *m, const char *s);
+void seq_puts(struct seq_file *m, const char *s);
 int seq_write(struct seq_file *seq, const void *data, size_t len);
 
 __printf(2, 3) int seq_printf(struct seq_file *, const char *, ...);
diff --git a/ipc/util.c b/ipc/util.c
index 106bed0..4f726b7 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -837,8 +837,10 @@ static int sysvipc_proc_show(struct seq_file *s, void *it)
 	struct ipc_proc_iter *iter = s->private;
 	struct ipc_proc_iface *iface = iter->iface;
 
-	if (it == SEQ_START_TOKEN)
-		return seq_puts(s, iface->header);
+	if (it == SEQ_START_TOKEN) {
+		seq_puts(s, iface->header);
+		return seq_has_overflowed(s);
+	}
 
 	return iface->show(s, it);
 }
-- 
2.1.2

