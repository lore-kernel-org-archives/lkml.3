Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbaDXJ44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:56:56 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:39480 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbaDXIyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:54:25 -0400
From: Paul Fertser <fercerpav@gmail.com>
To: Li Yang <leoli@freescale.com>, Felipe Balbi <balbi@ti.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH] usb: gadget: fsl: check vbus presence on probe
Date: Thu, 24 Apr 2014 12:54:13 +0400
Message-Id: <1398329653-29968-1-git-send-email-fercerpav@gmail.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If VBUS is already present during the driver initialisation, the
corresponding IRQ never fires, so there is no way the gadget can get
enumerated.

This patch is real-life tested on an i.MX25 board with VBUS constantly
hooked up.

Signed-off-by: Paul Fertser <fercerpav@gmail.com>
---
 drivers/usb/gadget/fsl_udc_core.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index a2f26cd..b4b1516 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -2501,6 +2501,11 @@ static int __init fsl_udc_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_del_udc;
 
+	/* Now let it settle a bit and sense VBUS */
+	msleep_interruptible(1);
+	if (fsl_readl(&dr_regs->otgsc) & OTGSC_STS_B_SESSION_VALID)
+		udc_controller->vbus_active = 1;
+
 	create_proc_file();
 	return 0;
 
-- 
1.7.10

