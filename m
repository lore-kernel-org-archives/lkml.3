Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbaKUARN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 19:17:13 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:56640 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756640AbaKUARL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 19:17:11 -0500
From: Alexander Kochetkov <al.kochet@gmail.com>
To: linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, al.kochet@gmail.com
Cc: Wolfram Sang <wsa@the-dreams.de>, Tony Lindgren <tony@atomide.com>,
        Felipe Balbi <balbi@ti.com>, Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [PATCH] i2c: omap: fix i207 errata handling
Date: Fri, 21 Nov 2014 04:16:51 +0400
Message-Id: <1416529011-21803-1-git-send-email-al.kochet@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 6d9939f651419a63e091105663821f9c7d3fec37 (i2c: omap: split out [XR]DR
and [XR]RDY) changed the way how errata i207 (I2C: RDR Flag May Be Incorrectly
Set) get handled. 6d9939f6514 code doesn't correspond to workaround provided by
errata.

According to errata ISR must filter out spurious RDR before data read not after.
ISR must read RXSTAT to get number of bytes available to read. Because RDR
could be set while there could no data in the receive FIFO.

Restored pre 6d9939f6514 way of handling errata.

Found by code review. Real impact haven't seen.
Tested on Beagleboard XM C.

Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
Fixes: 6d9939f651419a63e09110 i2c: omap: split out [XR]DR and [XR]RDY
---
 drivers/i2c/busses/i2c-omap.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 90dcc2e..e7cbcb0 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -958,11 +958,13 @@ omap_i2c_isr_thread(int this_irq, void *dev_id)
 			if (dev->fifo_size)
 				num_bytes = dev->buf_len;
 
-			omap_i2c_receive_data(dev, num_bytes, true);
-
-			if (dev->errata & I2C_OMAP_ERRATA_I207)
+			if (dev->errata & I2C_OMAP_ERRATA_I207) {
 				i2c_omap_errata_i207(dev, stat);
+				num_bytes = (omap_i2c_read_reg(dev,
+					OMAP_I2C_BUFSTAT_REG) >> 8) & 0x3F;
+			}
 
+			omap_i2c_receive_data(dev, num_bytes, true);
 			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_RDR);
 			continue;
 		}
-- 
1.7.9.5

