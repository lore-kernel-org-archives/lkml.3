Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbaLNUua (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:50:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52893 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbaLNUVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:21:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Kochetkov <al.kochet@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 3.10 05/24] i2c: omap: fix i207 errata handling
Date: Sun, 14 Dec 2014 12:20:25 -0800
Message-Id: <20141214201800.793582608@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201800.613573495@linuxfoundation.org>
References: <20141214201800.613573495@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-omap.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -958,11 +958,13 @@ omap_i2c_isr_thread(int this_irq, void *
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


