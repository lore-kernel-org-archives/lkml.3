Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbaLOOed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:34:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38983 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062AbaLOO3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:29:13 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vishnu Motghare <vishnum@xilinx.com>, Harini Katakam <harinik@xilinx.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 150/168] i2c: cadence: Set the hardware time-out register to maximum value
Date: Mon, 15 Dec 2014 14:26:44 +0000
Message-Id: <1418653622-21105-151-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vishnu Motghare <vishnum@xilinx.com>

commit 681d15a0f527af7ab3a783e1037de86fbcb136ac upstream.

Cadence I2C controller has bug wherein it generates invalid read transactions
after timeout in master receiver mode. This driver does not use the HW
timeout and this interrupt is disabled but the feature itself cannot be
disabled. Hence, this patch writes the maximum value (0xFF) to this register.
This is one of the workarounds to this bug and it will not avoid the issue
completely but reduces the chances of error.

Signed-off-by: Vishnu Motghare <vishnum@xilinx.com>
Signed-off-by: Harini Katakam <harinik@xilinx.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/i2c/busses/i2c-cadence.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
index 63f3f03ecc9b..c604f4c3ac0d 100644
--- a/drivers/i2c/busses/i2c-cadence.c
+++ b/drivers/i2c/busses/i2c-cadence.c
@@ -111,6 +111,8 @@
 #define CDNS_I2C_DIVA_MAX	4
 #define CDNS_I2C_DIVB_MAX	64
 
+#define CDNS_I2C_TIMEOUT_MAX	0xFF
+
 #define cdns_i2c_readreg(offset)       readl_relaxed(id->membase + offset)
 #define cdns_i2c_writereg(val, offset) writel_relaxed(val, id->membase + offset)
 
@@ -852,6 +854,15 @@ static int cdns_i2c_probe(struct platform_device *pdev)
 		goto err_clk_dis;
 	}
 
+	/*
+	 * Cadence I2C controller has a bug wherein it generates
+	 * invalid read transaction after HW timeout in master receiver mode.
+	 * HW timeout is not used by this driver and the interrupt is disabled.
+	 * But the feature itself cannot be disabled. Hence maximum value
+	 * is written to this register to reduce the chances of error.
+	 */
+	cdns_i2c_writereg(CDNS_I2C_TIMEOUT_MAX, CDNS_I2C_TIME_OUT_OFFSET);
+
 	dev_info(&pdev->dev, "%u kHz mmio %08lx irq %d\n",
 		 id->i2c_clk / 1000, (unsigned long)r_mem->start, id->irq);
 
-- 
2.1.3

