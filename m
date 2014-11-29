Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbaK2VAY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 16:00:24 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:48894 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbaK2VAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 16:00:19 -0500
From: Alexander Kochetkov <al.kochet@gmail.com>
To: Kevin Hilman <khilman@kernel.org>, Tony Lindgren <tony@atomide.com>,
        Felipe Balbi <balbi@ti.com>, Wolfram Sang <wsa@the-dreams.de>,
        Alexander Kochetkov <al.kochet@gmail.com>
Cc: linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 1/2] i2c: omap: fix buffer overruns during RX/TX data processing
Date: Sun, 30 Nov 2014 01:00:02 +0400
Message-Id: <1417294803-14729-2-git-send-email-al.kochet@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417294803-14729-1-git-send-email-al.kochet@gmail.com>
References: <1417294803-14729-1-git-send-email-al.kochet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit dd74548ddece4b9d68e5528287a272fa552c81d0 ("i2c: omap:
resize fifos before each message") dropped check for dev->buf_len.
As result, data processing loop cause dev->buf overruns for
devices with 16-bit data register (omap2420).

In the dd74548ddece4b9d68 code, for each loop iteration if the
flag OMAP_I2C_FLAG_16BIT_DATA_REG is set (omap2420), dev->buf
is incremented twice, and dev->buf_len decremented twice.

Also buffer overrun could happen (in theory) due to wrong
ISR handling (bug).

The commit fix data processing for omap2420 and add guard checks
in the data processing loops do disallow accesses to the buffer,
when dev->buf_len is zero. Also added warnings to unhide the bug.

Found by code review.

Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
Fixes: dd74548ddece4b9d68e5528287a272fa552c81d0 "i2c: omap: resize fifos before each message"
Reported-by: Tony Lindgren <tony@atomide.com>
---
 drivers/i2c/busses/i2c-omap.c |   36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 4563200..e890295 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -938,20 +938,30 @@ static int errata_omap3_i462(struct omap_i2c_dev *dev)
 static void omap_i2c_receive_data(struct omap_i2c_dev *dev, u8 num_bytes,
 		bool is_rdr)
 {
-	u16		w;
+	u16 w;
+
+	if (unlikely(num_bytes > dev->buf_len)) {
+		dev_err(dev->dev, "%s interrupt can't receive %u byte(s)\n",
+			is_rdr ? "RDR" : "RRDY", (num_bytes - dev->buf_len));
+		num_bytes = dev->buf_len;
+	}
 
-	while (num_bytes--) {
+	while (num_bytes) {
 		w = omap_i2c_read_reg(dev, OMAP_I2C_DATA_REG);
 		*dev->buf++ = w;
 		dev->buf_len--;
+		num_bytes--;
 
 		/*
 		 * Data reg in 2430, omap3 and
 		 * omap4 is 8 bit wide
 		 */
 		if (dev->flags & OMAP_I2C_FLAG_16BIT_DATA_REG) {
-			*dev->buf++ = w >> 8;
-			dev->buf_len--;
+			if (num_bytes) {
+				*dev->buf++ = w >> 8;
+				dev->buf_len--;
+				num_bytes--;
+			}
 		}
 	}
 }
@@ -959,19 +969,29 @@ static void omap_i2c_receive_data(struct omap_i2c_dev *dev, u8 num_bytes,
 static int omap_i2c_transmit_data(struct omap_i2c_dev *dev, u8 num_bytes,
 		bool is_xdr)
 {
-	u16		w;
+	u16 w;
+
+	if (unlikely(num_bytes > dev->buf_len)) {
+		dev_err(dev->dev, "%s interrupt can't transmit %u byte(s)\n",
+			is_xdr ? "XDR" : "XRDY", (num_bytes - dev->buf_len));
+		num_bytes = dev->buf_len;
+	}
 
-	while (num_bytes--) {
+	while (num_bytes) {
 		w = *dev->buf++;
 		dev->buf_len--;
+		num_bytes--;
 
 		/*
 		 * Data reg in 2430, omap3 and
 		 * omap4 is 8 bit wide
 		 */
 		if (dev->flags & OMAP_I2C_FLAG_16BIT_DATA_REG) {
-			w |= *dev->buf++ << 8;
-			dev->buf_len--;
+			if (num_bytes) {
+				w |= *dev->buf++ << 8;
+				dev->buf_len--;
+				num_bytes--;
+			}
 		}
 
 		if (dev->errata & I2C_OMAP_ERRATA_I462) {
-- 
1.7.9.5

