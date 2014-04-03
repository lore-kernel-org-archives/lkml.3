Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162449AbaDCHWE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 03:22:04 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17457 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162380AbaDCHV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 03:21:59 -0400
Date: Thu, 3 Apr 2014 10:21:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>, Sricharan R <r.sricharan@ti.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] irqchip/irq-crossbar: not allocating enough memory
Message-ID: <20140403072134.GA14286@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are allocating the size of a pointer and not the size of the data.
This will lead to memory corruption.

There isn't actually a "cb_device" struct, btw.  The code is only able
to compile because GCC knows that all pointers are the same size.

Fixes: 96ca848ef7ea ('DRIVERS: IRQCHIP: CROSSBAR: Add support for Crossbar IP')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
index fc817d2..3d15d16 100644
--- a/drivers/irqchip/irq-crossbar.c
+++ b/drivers/irqchip/irq-crossbar.c
@@ -107,7 +107,7 @@ static int __init crossbar_of_init(struct device_node *node)
 	int i, size, max, reserved = 0, entry;
 	const __be32 *irqsr;
 
-	cb = kzalloc(sizeof(struct cb_device *), GFP_KERNEL);
+	cb = kzalloc(sizeof(*cb), GFP_KERNEL);
 
 	if (!cb)
 		return -ENOMEM;
