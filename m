Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab3EMKwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 06:52:12 -0400
Received: from mga14.intel.com ([143.182.124.37]:6122 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551Ab3EMKwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 06:52:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,662,1363158000"; 
   d="scan'208";a="333185997"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-i2c@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] i2c-designware: always clear interrupts before enabling them
Date: Mon, 13 May 2013 13:54:30 +0300
Message-Id: <1368442471-7582-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the I2C bus is put to a low power state by an ACPI method it might pull
the SDA line low (as its power is removed). Once the bus is put to full
power state again, the SDA line is pulled back to high. This transition
looks like a STOP condition from the controller point-of-view which sets
STOP detected bit in its status register causing the driver to fail
subsequent transfers.

Fix this by always clearing all interrupts before we start a transfer.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/i2c/busses/i2c-designware-core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index 21fbb34..7a89ca5 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -383,7 +383,8 @@ static void i2c_dw_xfer_init(struct dw_i2c_dev *dev)
 	/* Enable the adapter */
 	__i2c_dw_enable(dev, true);
 
-	/* Enable interrupts */
+	/* Clear and enable interrupts */
+	i2c_dw_clear_int(dev);
 	dw_writel(dev, DW_IC_INTR_DEFAULT_MASK, DW_IC_INTR_MASK);
 }
 
-- 
1.7.10.4

