Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287AbaLOObp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:31:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39061 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaLOO3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:29:25 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexander Kochetkov <al.kochet@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 164/168] i2c: omap: fix i207 errata handling
Date: Mon, 15 Dec 2014 14:26:58 +0000
Message-Id: <1418653622-21105-165-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Kochetkov <al.kochet@gmail.com>

commit ccfc866356674cb3a61829d239c685af6e85f197 upstream.

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
Tested-by: Felipe Balbi <balbi@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/i2c/busses/i2c-omap.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 4ba4c2c7bc79..5a8c15e52ede 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -956,11 +956,13 @@ omap_i2c_isr_thread(int this_irq, void *dev_id)
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
2.1.3

