Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509AbbAILAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 06:00:24 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44492 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756889AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alexander Kochetkov <al.kochet@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 21/78] i2c: omap: fix i207 errata handling
Date: Fri,  9 Jan 2015 11:31:30 +0100
Message-Id: <3fb5d5ea0088b0f9a5bab6a5c565bb105de94588.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Kochetkov <al.kochet@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/i2c/busses/i2c-omap.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 05f5919a7165..8eaaff831d7c 100644
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
2.2.1

