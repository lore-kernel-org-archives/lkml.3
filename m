Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbaI3Vj3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:39:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32987 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422AbaI3VjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:39:22 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marek Roszko <mark.roszko@gmail.com>, Wolfram Sang <wsa@the-dreams.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 100/103] i2c: at91: add bound checking on SMBus block length bytes
Date: Tue, 30 Sep 2014 14:31:45 -0700
Message-Id: <1412112708-27356-101-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Roszko <mark.roszko@gmail.com>

commit 75b81f339c6af43f6f4a1b3eabe0603321dade65 upstream.

The driver was not bound checking the received length byte to ensure it was within the
the buffer size that is allocated for SMBus blocks. This resulted in buffer overflows
whenever an invalid length byte was received.
It also failed to ensure the length byte was not zero. If it received zero, it would end up
in an infinite loop as the at91_twi_read_next_byte function returned immediately without
allowing RHR to be read to clear the RXRDY interrupt.

Tested agaisnt a SMBus compliant battery.

Signed-off-by: Marek Roszko <mark.roszko@gmail.com>
Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/i2c/busses/i2c-at91.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index ae4cdc0..a10632e 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -101,6 +101,7 @@ struct at91_twi_dev {
 	unsigned twi_cwgr_reg;
 	struct at91_twi_pdata *pdata;
 	bool use_dma;
+	bool recv_len_abort;
 	struct at91_twi_dma dma;
 };
 
@@ -267,12 +268,24 @@ static void at91_twi_read_next_byte(struct at91_twi_dev *dev)
 	*dev->buf = at91_twi_read(dev, AT91_TWI_RHR) & 0xff;
 	--dev->buf_len;
 
+	/* return if aborting, we only needed to read RHR to clear RXRDY*/
+	if (dev->recv_len_abort)
+		return;
+
 	/* handle I2C_SMBUS_BLOCK_DATA */
 	if (unlikely(dev->msg->flags & I2C_M_RECV_LEN)) {
-		dev->msg->flags &= ~I2C_M_RECV_LEN;
-		dev->buf_len += *dev->buf;
-		dev->msg->len = dev->buf_len + 1;
-		dev_dbg(dev->dev, "received block length %d\n", dev->buf_len);
+		/* ensure length byte is a valid value */
+		if (*dev->buf <= I2C_SMBUS_BLOCK_MAX && *dev->buf > 0) {
+			dev->msg->flags &= ~I2C_M_RECV_LEN;
+			dev->buf_len += *dev->buf;
+			dev->msg->len = dev->buf_len + 1;
+			dev_dbg(dev->dev, "received block length %d\n",
+					 dev->buf_len);
+		} else {
+			/* abort and send the stop by reading one more byte */
+			dev->recv_len_abort = true;
+			dev->buf_len = 1;
+		}
 	}
 
 	/* send stop if second but last byte has been read */
@@ -444,6 +457,12 @@ static int at91_do_twi_transfer(struct at91_twi_dev *dev)
 		ret = -EIO;
 		goto error;
 	}
+	if (dev->recv_len_abort) {
+		dev_err(dev->dev, "invalid smbus block length recvd\n");
+		ret = -EPROTO;
+		goto error;
+	}
+
 	dev_dbg(dev->dev, "transfer complete\n");
 
 	return 0;
@@ -500,6 +519,7 @@ static int at91_twi_xfer(struct i2c_adapter *adap, struct i2c_msg *msg, int num)
 	dev->buf_len = m_start->len;
 	dev->buf = m_start->buf;
 	dev->msg = m_start;
+	dev->recv_len_abort = false;
 
 	ret = at91_do_twi_transfer(dev);
 
-- 
1.9.1

