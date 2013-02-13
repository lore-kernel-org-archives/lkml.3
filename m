Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934113Ab3BMOX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 09:23:56 -0500
Received: from mout.gmx.net ([212.227.15.18]:62420 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934095Ab3BMOXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 09:23:53 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18auH8Cgg8a4C2SWUtx83Fo1DLs+feDrLyJ2bdHzn
	Jnnma53fZs8wrE
From: Peter Huewe <peterhuewe@gmx.de>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH v2] staging/comedi: Fix undefined array subscript
Date: Wed, 13 Feb 2013 15:28:14 +0100
Message-Id: <1360765694-3748-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <20130213140147.GA4606@mwanda>
References: <20130213140147.GA4606@mwanda>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In vmk80xx_do_insn_bits the local variable reg, which is used as an
index to the tx_buf array, can be used uninitialized if
- data[0] == 0
and
- devpriv->model != VMK8061_MODEL
-> we get into the else branch without having reg initialized.

Since the driver usually differentiates between VMK8061_MODEL and
VMK8055_MODEL it's safe to assume that VMK8055_DO_REG was meant as an
initial value.

And to avoid duplication we can move the assignments to the top.

Acked-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/comedi/drivers/vmk80xx.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index ebf2d48..eed46ee 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -675,8 +675,14 @@ static int vmk80xx_do_insn_bits(struct comedi_device *dev,
 	if (data[0])
 		dir |= DIR_OUT;
 
-	if (devpriv->model == VMK8061_MODEL)
+	if (devpriv->model == VMK8061_MODEL) {
 		dir |= DIR_IN;
+		reg = VMK8061_DO_REG;
+		cmd = VMK8061_CMD_DO;
+	} else { /* VMK8055_MODEL */
+		reg = VMK8055_DO_REG;
+		cmd = VMK8055_CMD_WRT_AD;
+	}
 
 	retval = rudimentary_check(devpriv, dir);
 	if (retval)
@@ -688,14 +694,6 @@ static int vmk80xx_do_insn_bits(struct comedi_device *dev,
 	tx_buf = devpriv->usb_tx_buf;
 
 	if (data[0]) {
-		if (devpriv->model == VMK8055_MODEL) {
-			reg = VMK8055_DO_REG;
-			cmd = VMK8055_CMD_WRT_AD;
-		} else { /* VMK8061_MODEL */
-			reg = VMK8061_DO_REG;
-			cmd = VMK8061_CMD_DO;
-		}
-
 		tx_buf[reg] &= ~data[0];
 		tx_buf[reg] |= (data[0] & data[1]);
 
@@ -706,7 +704,6 @@ static int vmk80xx_do_insn_bits(struct comedi_device *dev,
 	}
 
 	if (devpriv->model == VMK8061_MODEL) {
-		reg = VMK8061_DO_REG;
 		tx_buf[0] = VMK8061_CMD_RD_DO;
 
 		retval = vmk80xx_read_packet(devpriv);
-- 
1.7.8.6

