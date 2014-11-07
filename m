Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaKGMMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 07:12:53 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:50287 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751579AbaKGMMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 07:12:46 -0500
Message-ID: <545CB6C4.8010201@arm.com>
Date: Fri, 07 Nov 2014 12:10:44 +0000
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Baruch Siach <baruch@tkos.co.il>, "Du, Wenkai" <wenkai.du@intel.com>,
        Shinya Kuribayashi <skuribay@pobox.com>,
        Romain Baeriswyl <Romain.Baeriswyl@abilis.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
CC: Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH] i2c: designware: prevent early stop on TX FIFO empty
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the Designware core is configured with IC_EMPTYFIFO_HOLD_MASTER_EN
set to zero, allowing the TX FIFO to become empty causes a STOP
condition to be generated on the I2C bus. If the transmit FIFO
threshold is set too high, an erroneous STOP condition can be
generated on long transfers - particularly where the interrupt
latency is extended.

Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
---
 drivers/i2c/busses/i2c-designware-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-core.c b/drivers/i2c/busses/i2c-designware-core.c
index 3c20e4b..e070edd 100644
--- a/drivers/i2c/busses/i2c-designware-core.c
+++ b/drivers/i2c/busses/i2c-designware-core.c
@@ -363,7 +363,7 @@ int i2c_dw_init(struct dw_i2c_dev *dev)
 	}
 
 	/* Configure Tx/Rx FIFO threshold levels */
-	dw_writel(dev, dev->tx_fifo_depth - 1, DW_IC_TX_TL);
+	dw_writel(dev, dev->tx_fifo_depth / 2, DW_IC_TX_TL);
 	dw_writel(dev, 0, DW_IC_RX_TL);
 
 	/* configure the i2c master */
-- 
1.7.1

