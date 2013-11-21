Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab3KUUB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 15:01:28 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:54126 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab3KUUBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 15:01:24 -0500
From: Conrad Gomes <conrad.s.j.gomes@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Conrad Gomes <conrad.s.j.gomes@gmail.com>
Subject: [PATCH V2 5/7] Staging: comedi: change pr_err to dev_err in __unioxx5_digital_write
Date: Fri, 22 Nov 2013 01:27:56 +0530
Message-Id: <1385063878-10267-6-git-send-email-conrad.s.j.gomes@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385063878-10267-1-git-send-email-conrad.s.j.gomes@gmail.com>
References: <1385063878-10267-1-git-send-email-conrad.s.j.gomes@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch which subsitutes pr_err with the preferred dev_err
for device drivers in __unioxx5_digital_write.

The function definition of __unioxx5_digital_write has been changed
to take the pointer to the struct comedi_subdevice as a parameter
instead of the pointer to struct unioxx5_subd_priv.

The pointers to the stuct device and the struct unioxx5_subd_priv are
obtained through the pointer to the struct comedi_subdevice in this
function.

The function call to __unioxx5_digital_write in unioxx5_subdev_write
has been changed to pass the pointer to the struct comedi_subdevice

Signed-off-by: Conrad Gomes <conrad.s.j.gomes@gmail.com>
---
 drivers/staging/comedi/drivers/unioxx5.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
index 7edbd5e..343ba96 100644
--- a/drivers/staging/comedi/drivers/unioxx5.c
+++ b/drivers/staging/comedi/drivers/unioxx5.c
@@ -205,15 +205,17 @@ static int __unioxx5_analog_read(struct comedi_subdevice *s,
 	return 1;
 }
 
-static int __unioxx5_digital_write(struct unioxx5_subd_priv *usp,
+static int __unioxx5_digital_write(struct comedi_subdevice *s,
 				   unsigned int *data, int channel, int minor)
 {
+	struct unioxx5_subd_priv *usp = s->private;
+	struct device *csdev = s->device->class_dev;
 	int channel_offset, val;
 	int mask = 1 << (channel & 0x07);
 
 	channel_offset = __unioxx5_define_chan_offset(channel);
 	if (channel_offset < 0) {
-		pr_err("comedi%d: undefined channel %d. channel range is 0 .. 23\n",
+		dev_err(csdev, "comedi%d: undefined channel %d. channel range is 0 .. 23\n",
 		       minor, channel);
 		return 0;
 	}
@@ -303,7 +305,7 @@ static int unioxx5_subdev_write(struct comedi_device *dev,
 	type = usp->usp_module_type[channel / 2];
 
 	if (type == MODULE_DIGITAL) {
-		if (!__unioxx5_digital_write(usp, data, channel, dev->minor))
+		if (!__unioxx5_digital_write(subdev, data, channel, dev->minor))
 			return -1;
 	} else {
 		if (!__unioxx5_analog_write(usp, data, channel, dev->minor))
-- 
1.7.9.5

