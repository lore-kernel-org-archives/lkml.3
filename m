Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab3KUUBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 15:01:33 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:49395 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab3KUUB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 15:01:28 -0500
From: Conrad Gomes <conrad.s.j.gomes@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Conrad Gomes <conrad.s.j.gomes@gmail.com>
Subject: [PATCH V2 6/7] Staging: comedi: change pr_err to dev_err in __unioxx5_analog_write
Date: Fri, 22 Nov 2013 01:27:57 +0530
Message-Id: <1385063878-10267-7-git-send-email-conrad.s.j.gomes@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385063878-10267-1-git-send-email-conrad.s.j.gomes@gmail.com>
References: <1385063878-10267-1-git-send-email-conrad.s.j.gomes@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch which subsitutes pr_err with the preferred dev_err
for device drivers in __unioxx5_analog_write.

The function definition of __unioxx5_analog_write has been changed
to take the pointer to the struct comedi_subdevice as a parameter
instead of the pointer to struct unioxx5_subd_priv.

The pointers to the stuct device and the struct unioxx5_subd_priv are
obtained through the pointer to the struct comedi_subdevice in this
function.

The function call to __unioxx5_analog_write in unioxx5_subdev_write
has been changed to pass the pointer to the struct comedi_subdevice

Signed-off-by: Conrad Gomes <conrad.s.j.gomes@gmail.com>
---
 drivers/staging/comedi/drivers/unioxx5.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
index 343ba96..6bbc934 100644
--- a/drivers/staging/comedi/drivers/unioxx5.c
+++ b/drivers/staging/comedi/drivers/unioxx5.c
@@ -235,9 +235,11 @@ static int __unioxx5_digital_write(struct comedi_subdevice *s,
 	return 1;
 }
 
-static int __unioxx5_analog_write(struct unioxx5_subd_priv *usp,
+static int __unioxx5_analog_write(struct comedi_subdevice *s,
 				  unsigned int *data, int channel, int minor)
 {
+	struct unioxx5_subd_priv *usp = s->private;
+	struct device *csdev = s->device->class_dev;
 	int module, i;
 
 	module = channel / 2;	/* definig module number(0 .. 11) */
@@ -245,7 +247,7 @@ static int __unioxx5_analog_write(struct unioxx5_subd_priv *usp,
 
 	/* defining if given module can work on output */
 	if (!(usp->usp_module_type[module] & MODULE_OUTPUT_MASK)) {
-		pr_err("comedi%d: module in position %d with id 0x%0x is for input only!\n",
+		dev_err(csdev, "comedi%d: module in position %d with id 0x%0x is for input only!\n",
 		       minor, module, usp->usp_module_type[module]);
 		return 0;
 	}
@@ -308,7 +310,7 @@ static int unioxx5_subdev_write(struct comedi_device *dev,
 		if (!__unioxx5_digital_write(subdev, data, channel, dev->minor))
 			return -1;
 	} else {
-		if (!__unioxx5_analog_write(usp, data, channel, dev->minor))
+		if (!__unioxx5_analog_write(subdev, data, channel, dev->minor))
 			return -1;
 	}
 
-- 
1.7.9.5

