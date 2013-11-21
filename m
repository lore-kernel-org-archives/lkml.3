Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab3KUUBT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 15:01:19 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:35963 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab3KUUBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 15:01:16 -0500
From: Conrad Gomes <conrad.s.j.gomes@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Conrad Gomes <conrad.s.j.gomes@gmail.com>
Subject: [PATCH V2 3/7] Staging: comedi: change printk to dev_err/dev_dbg in unioxx5.c
Date: Fri, 22 Nov 2013 01:27:54 +0530
Message-Id: <1385063878-10267-4-git-send-email-conrad.s.j.gomes@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385063878-10267-1-git-send-email-conrad.s.j.gomes@gmail.com>
References: <1385063878-10267-1-git-send-email-conrad.s.j.gomes@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch which fixes coding style issues due to printk usage in
unioxx5.c found by checkpatch.pl in the following functions:
1) __unioxx5_digital_read
2) __unioxx5_analog_read
3) __unioxx5_digital_config

To subsitute printk with dev_err/dev_dbg, access to the struct device is
required. The function definitions of the above functions have been changed
to take the pointer to the struct comedi_subdevice as a parameter instead
of the pointer to struct unioxx5_subd_priv.

The pointers to the stuct device and the struct unioxx5_subd_priv are
obtained through the pointer to the struct comedi_subdevice in these functions.

The function calls of __unioxx5_digital_read and __unioxx5_analog_read in
unioxx5_subdev_read have been changed to pass the pointer to the struct
comedi_subdevice.

Signed-off-by: Conrad Gomes <conrad.s.j.gomes@gmail.com>
---
 drivers/staging/comedi/drivers/unioxx5.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
index 2b1ece8..31736ed 100644
--- a/drivers/staging/comedi/drivers/unioxx5.c
+++ b/drivers/staging/comedi/drivers/unioxx5.c
@@ -91,12 +91,14 @@ static int __unioxx5_define_chan_offset(int chan_num)
 }
 
 #if 0				/* not used? */
-static void __unioxx5_digital_config(struct unioxx5_subd_priv *usp, int mode)
+static void __unioxx5_digital_config(struct comedi_subdevice *s, int mode)
 {
+	struct unioxx5_subd_priv *usp = s->private;
+	struct device *csdev = s->device->class_dev;
 	int i, mask;
 
 	mask = (mode == ALL_2_OUTPUT) ? 0xFF : 0x00;
-	printk("COMEDI: mode = %d\n", mask);
+	dev_dbg(csdev, "mode = %d\n", mask);
 
 	outb(1, usp->usp_iobase + 0);
 
@@ -135,15 +137,18 @@ static void __unioxx5_analog_config(struct unioxx5_subd_priv *usp, int channel)
 	usp->usp_prev_cn_val[channel_offset - 1] = conf;
 }
 
-static int __unioxx5_digital_read(struct unioxx5_subd_priv *usp,
+static int __unioxx5_digital_read(struct comedi_subdevice *s,
 				  unsigned int *data, int channel, int minor)
 {
+	struct unioxx5_subd_priv *usp = s->private;
+	struct device *csdev = s->device->class_dev;
 	int channel_offset, mask = 1 << (channel & 0x07);
 
 	channel_offset = __unioxx5_define_chan_offset(channel);
 	if (channel_offset < 0) {
-		pr_err("comedi%d: undefined channel %d. channel range is 0 .. 23\n",
-		       minor, channel);
+		dev_err(csdev,
+			"comedi%d: undefined channel %d. channel range is 0 .. 23\n",
+			minor, channel);
 		return 0;
 	}
 
@@ -157,9 +162,11 @@ static int __unioxx5_digital_read(struct unioxx5_subd_priv *usp,
 	return 1;
 }
 
-static int __unioxx5_analog_read(struct unioxx5_subd_priv *usp,
+static int __unioxx5_analog_read(struct comedi_subdevice *s,
 				 unsigned int *data, int channel, int minor)
 {
+	struct unioxx5_subd_priv *usp = s->private;
+	struct device *csdev = s->device->class_dev;
 	int module_no, read_ch;
 	char control;
 
@@ -185,7 +192,8 @@ static int __unioxx5_analog_read(struct unioxx5_subd_priv *usp,
 
 	/* if four bytes readding error occurs - return 0(false) */
 	if ((control & Rx4CA_ERR_MASK)) {
-		printk("COMEDI: 4 bytes error\n");
+		dev_err(csdev,
+			"comedi%d: 4 bytes error\n", minor);
 		return 0;
 	}
 
@@ -273,10 +281,10 @@ static int unioxx5_subdev_read(struct comedi_device *dev,
 	type = usp->usp_module_type[channel / 2];
 
 	if (type == MODULE_DIGITAL) {
-		if (!__unioxx5_digital_read(usp, data, channel, dev->minor))
+		if (!__unioxx5_digital_read(subdev, data, channel, dev->minor))
 			return -1;
 	} else {
-		if (!__unioxx5_analog_read(usp, data, channel, dev->minor))
+		if (!__unioxx5_analog_read(subdev, data, channel, dev->minor))
 			return -1;
 	}
 
-- 
1.7.9.5

