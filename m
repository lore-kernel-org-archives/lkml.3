Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbaCYPGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 11:06:49 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:57375 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752360AbaCYPGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 11:06:47 -0400
X-Forefront-Antispam-Report: CIP:193.138.13.20;KIP:(null);UIP:(null);IPV:NLI;H:oce-exbhcs03b.oce.net;RD:smtp02.oce.com;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h2148h1ee6h1ce5h1fdah201ch2073h2146h1202h1fd0h1e76h2189h1d1ah1cabh1d2ah21bch1fc6hzz1de098h8275bh1de097hz31h87h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h15a8h162dh1631h1758h17eeh1898h18e1h1946h19b5h1b0ah224fh1c0dh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h226dh24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h268bh129fi1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Kaushal Butala <kaushalkernelmailinglist@gmail.com>
To: Shawn Guo <shawn.guo@freescale.com>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Kaushal Butala <kaushal.butala@gmail.com>,
        Kaushal Butala <kaushalkernelmailinglist@gmail.com>
Subject: [RFC PATCH] imx-i2c: Add smbus block read support to imx i2c bus
Date: Tue, 25 Mar 2014 16:06:22 +0100
Message-ID: <1395759982-18559-1-git-send-email-kaushalkernelmailinglist@gmail.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 25 Mar 2014 15:06:43.0583 (UTC) FILETIME=[D54BF8F0:01CF483B]
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: oce.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kaushal Butala <kaushal.butala@gmail.com>

The smbus block read is not currently supported for imx i2c devices.
This patchset adds the support to imx i2c bus so that blocks of data
can be read using SMbus block reads.(using i2c_smbus_read_block_data()
function from the i2c_core.c.). Tested with 3.10.9 kernel.

Signed-off-by: Kaushal Butala <kaushalkernelmailinglist@gmail.com>
---
 drivers/i2c/busses/i2c-imx.c |   31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index db895fb..b6c2c3c 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -462,6 +462,7 @@ static int i2c_imx_read(struct imx_i2c_struct *i2c_imx, struct i2c_msg *msgs)
 {
 	int i, result;
 	unsigned int temp;
+	int block_data = msgs->flags & I2C_M_RECV_LEN;
 
 	dev_dbg(&i2c_imx->adapter.dev,
 		"<%s> write slave address: addr=0x%x\n",
@@ -481,7 +482,12 @@ static int i2c_imx_read(struct imx_i2c_struct *i2c_imx, struct i2c_msg *msgs)
 	/* setup bus to read data */
 	temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2CR);
 	temp &= ~I2CR_MTX;
-	if (msgs->len - 1)
+
+	/*
+	 * Reset the I2CR_TXAK flag initially for SMbus block read since the
+	 * length is unknown
+	 */
+	if ((msgs->len - 1) || (block_data))
 		temp &= ~I2CR_TXAK;
 	imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
 	imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR); /* dummy read */
@@ -490,9 +496,24 @@ static int i2c_imx_read(struct imx_i2c_struct *i2c_imx, struct i2c_msg *msgs)
 
 	/* read data */
 	for (i = 0; i < msgs->len; i++) {
+		u8 len = 0;
 		result = i2c_imx_trx_complete(i2c_imx);
 		if (result)
 			return result;
+		/*
+		 * First byte is the length of remaining packet
+		 * in the SMBus block data read. Add it to
+		 * msgs->len.
+		 */
+		if ((!i) && (block_data)) {
+			len = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
+			if ((len == 0) || (len > I2C_SMBUS_BLOCK_MAX))
+				return -EPROTO;
+			dev_dbg(&i2c_imx->adapter.dev,
+				"<%s> read length: 0x%X\n",
+				__func__, len);
+			msgs->len += len;
+		}
 		if (i == (msgs->len - 1)) {
 			/* It must generate STOP before read I2DR to prevent
 			   controller from generating another clock cycle */
@@ -510,7 +531,10 @@ static int i2c_imx_read(struct imx_i2c_struct *i2c_imx, struct i2c_msg *msgs)
 			temp |= I2CR_TXAK;
 			imx_i2c_write_reg(temp, i2c_imx, IMX_I2C_I2CR);
 		}
-		msgs->buf[i] = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
+		if ((!i) && (block_data))
+			msgs->buf[0] = len;
+		else
+			msgs->buf[i] =  imx_i2c_read_reg(i2c_imx, IMX_I2C_I2DR);
 		dev_dbg(&i2c_imx->adapter.dev,
 			"<%s> read byte: B%d=0x%X\n",
 			__func__, i, msgs->buf[i]);
@@ -583,7 +607,8 @@ fail0:
 
 static u32 i2c_imx_func(struct i2c_adapter *adapter)
 {
-	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL
+		| I2C_FUNC_SMBUS_READ_BLOCK_DATA;
 }
 
 static struct i2c_algorithm i2c_imx_algo = {
-- 
1.7.9.5


