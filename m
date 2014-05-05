Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbaEEUal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:30:41 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41246 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbaEEUaj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:30:39 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Ding, Garrett" <g-ding@ti.com>, "Nori, Sekhar" <nsekhar@ti.com>,
        "Kevin Hilman" <khilman@deeprootsystems.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Subject: RE: [PATCH] i2c: davinci: Add block read functionality for IPMI
Thread-Topic: [PATCH] i2c: davinci: Add block read functionality for IPMI
Thread-Index: AQHPZW4hWXzwPqzlrk2ZK9CHGja/FZsydsIg
Date: Mon, 5 May 2014 20:30:34 +0000
Message-ID: <3E54258959B69E4282D79E01AB1F32B70472F6AC@DFLE11.ent.ti.com>
References: <1398970186-12204-1-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1398970186-12204-1-git-send-email-m-karicheri2@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Karicheri, Muralidharan
>Sent: Thursday, May 01, 2014 2:50 PM
>To: davinci-linux-open-source@linux.davincidsp.com; linux-i2c@vger.kernel.org; linux-
>kernel@vger.kernel.org
>Cc: Karicheri, Muralidharan; Ding, Garrett; Nori, Sekhar; Kevin Hilman; Wolfram Sang;
>Shilimkar, Santosh
>Subject: [PATCH] i2c: davinci: Add block read functionality for IPMI
>
>Intelligent Plaform Management Interface (IPMI) requires I2C driver to support block read,
>where the first byte received from slave is the length of following data:-  Added length
>check if the read type is block read (I2C_M_RECV_LEN)  Send NACK/STOP bits before last
>byte is received
>
>Signed-off-by: Garrett Ding <g-ding@ti.com>
>Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
>Tested-by: Garrett Ding <g-ding@ti.com>
>CC: Sekhar Nori <nsekhar@ti.com>
>CC: Kevin Hilman <khilman@deeprootsystems.com>
>CC: Wolfram Sang <wsa@the-dreams.de>
>CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
>---
> Tested on a customer board based on K2HK SoC
> drivers/i2c/busses/i2c-davinci.c |   42 +++++++++++++++++++++++++++++++++-
>----
> 1 file changed, 37 insertions(+), 5 deletions(-)
>
>diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
>index 389bc68..cd97920 100644
>--- a/drivers/i2c/busses/i2c-davinci.c
>+++ b/drivers/i2c/busses/i2c-davinci.c
>@@ -97,6 +97,10 @@
> #define DAVINCI_I2C_IMR_NACK	BIT(1)
> #define DAVINCI_I2C_IMR_AL	BIT(0)
>
>+/* capabilities */
>+#define I2C_CAPABILITIES	(I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL | \
>+				 I2C_FUNC_SMBUS_READ_BLOCK_DATA)
>+
> struct davinci_i2c_dev {
> 	struct device           *dev;
> 	void __iomem		*base;
>@@ -318,7 +322,13 @@ i2c_davinci_xfer_msg(struct i2c_adapter *adap, struct i2c_msg
>*msg, int stop)
> 	davinci_i2c_write_reg(dev, DAVINCI_I2C_SAR_REG, msg->addr);
>
> 	dev->buf = msg->buf;
>-	dev->buf_len = msg->len;
>+
>+	 /* if first received byte is length, set buf_len = 0xffff as flag */
>+	if (msg->flags & I2C_M_RECV_LEN)
>+		dev->buf_len = 0xffff;
>+	else
>+		dev->buf_len = msg->len;
>+
> 	dev->stop = stop;
>
> 	davinci_i2c_write_reg(dev, DAVINCI_I2C_CNT_REG, dev->buf_len); @@ -456,7
>+466,7 @@ i2c_davinci_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
>
> static u32 i2c_davinci_func(struct i2c_adapter *adap)  {
>-	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
>+	return I2C_CAPABILITIES;
> }
>
> static void terminate_read(struct davinci_i2c_dev *dev) @@ -528,10 +538,32 @@ static
>irqreturn_t i2c_davinci_isr(int this_irq, void *dev_id)
>
> 		case DAVINCI_I2C_IVR_RDR:
> 			if (dev->buf_len) {
>-				*dev->buf++ =
>-				    davinci_i2c_read_reg(dev,
>-							 DAVINCI_I2C_DRR_REG);
>+				*dev->buf++ = davinci_i2c_read_reg(dev,
>+							DAVINCI_I2C_DRR_REG);
>+				/*
>+				 * check if the first received byte is message
>+				 * length, i.e, I2C_M_RECV_LEN
>+				 */
>+				if (dev->buf_len == 0xffff)
>+					dev->buf_len = *(dev->buf - 1) + 1;
>+
> 				dev->buf_len--;
>+				/*
>+				 * send NACK/STOP bits BEFORE last byte is
>+				 * received
>+				 */
>+				if (dev->buf_len == 1) {
>+					w = davinci_i2c_read_reg(dev,
>+							DAVINCI_I2C_MDR_REG);
>+					w |= DAVINCI_I2C_MDR_NACK;
>+					davinci_i2c_write_reg(dev,
>+							DAVINCI_I2C_MDR_REG, w);
>+
>+					w |= DAVINCI_I2C_MDR_STP;
>+					davinci_i2c_write_reg(dev,
>+							DAVINCI_I2C_MDR_REG, w);
>+				}
>+
> 				if (dev->buf_len)
> 					continue;
>
>--
>1.7.9.5
All,

Please review this when you get a chance.
Murali

