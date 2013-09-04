Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760375Ab3IDKhz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 06:37:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:56427 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757009Ab3IDKhy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 06:37:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1020,1367996400"; 
   d="scan'208";a="398023439"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-spi@vger.kernel.org
Cc: Eric Miao <eric.y.miao@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] spi/pxa2xx: check status register as well to determine if the device is off
Date: Wed,  4 Sep 2013 13:37:43 +0300
Message-Id: <1378291063-5723-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current interrupt handler calls pm_runtime_suspended() to check if the
device is suspended or not. However, runtime PM status of the device is
only set to suspended once all PM runtime suspend hooks have executed.

In case of Intel Lynxpoint we have the device bound to the ACPI power
domain and its runtime suspend hook will put the device to D3hot (or D3cold
if possible). This means that the device is powered off before its state is
set to runtime suspended. While in this state the device might get an
interrupt that is meant for another device (as the interrupt line is
shared), and because the device is powered off accessing its registers will
return 0xffffffff that the driver misinterprets as an invalid state.

When this happens user will see messages like below on the console:

  pxa2xx-spi INT33C0:00: bad message state in interrupt handler

Fix this by checking the status register for ~0 and returning IRQ_NONE in
that case.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/spi/spi-pxa2xx.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index e0fd6f6..2cbab8a 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -546,8 +546,17 @@ static irqreturn_t ssp_int(int irq, void *dev_id)
 	if (pm_runtime_suspended(&drv_data->pdev->dev))
 		return IRQ_NONE;
 
-	sccr1_reg = read_SSCR1(reg);
+	/*
+	 * If the device is not yet in RPM suspended state and we get an
+	 * interrupt that is meant for another device, check if status bits
+	 * are all set to one. That means that the device is already
+	 * powered off.
+	 */
 	status = read_SSSR(reg);
+	if (status == ~0)
+		return IRQ_NONE;
+
+	sccr1_reg = read_SSCR1(reg);
 
 	/* Ignore possible writes if we don't need to write */
 	if (!(sccr1_reg & SSCR1_TIE))
-- 
1.8.4.rc3

