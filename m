Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761431AbaJDAti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:49:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44750 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbaJCVci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:32:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marek Roszko <mark.roszko@gmail.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 3.16 046/357] i2c: at91: add bound checking on SMBus block length bytes
Date: Fri,  3 Oct 2014 14:27:12 -0700
Message-Id: <20141003212934.842849636@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-at91.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -101,6 +101,7 @@ struct at91_twi_dev {
 	unsigned twi_cwgr_reg;
 	struct at91_twi_pdata *pdata;
 	bool use_dma;
+	bool recv_len_abort;
 	struct at91_twi_dma dma;
 };
 
@@ -267,12 +268,24 @@ static void at91_twi_read_next_byte(stru
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
@@ -444,6 +457,12 @@ static int at91_do_twi_transfer(struct a
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
@@ -500,6 +519,7 @@ static int at91_twi_xfer(struct i2c_adap
 	dev->buf_len = m_start->len;
 	dev->buf = m_start->buf;
 	dev->msg = m_start;
+	dev->recv_len_abort = false;
 
 	ret = at91_do_twi_transfer(dev);
 


