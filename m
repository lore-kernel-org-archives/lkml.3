Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbaKRQFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:05:04 -0500
Received: from sauhun.de ([89.238.76.85]:46113 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755257AbaKRQDw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:03:52 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean Delvare <jdelvare@suse.de>
Subject: [PATCH 3/3] i2c: rcar: add slave support
Date: Tue, 18 Nov 2014 17:04:55 +0100
Message-Id: <1416326695-13083-4-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416326695-13083-1-git-send-email-wsa@the-dreams.de>
References: <1416326695-13083-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

The first I2C slave provider using the new generic interface.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---

Changes since RFC:
* no runtime_pm for slaves
* don't use NULL in i2c_slave_event

 drivers/i2c/busses/i2c-rcar.c | 125 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 116 insertions(+), 9 deletions(-)

diff --git a/drivers/i2c/busses/i2c-rcar.c b/drivers/i2c/busses/i2c-rcar.c
index d826e82dd997..369ef747fb81 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -48,6 +48,12 @@
 #define ICMAR	0x20	/* master address */
 #define ICRXTX	0x24	/* data port */
 
+/* ICSCR */
+#define SDBS	(1 << 3)	/* slave data buffer select */
+#define SIE	(1 << 2)	/* slave interface enable */
+#define GCAE	(1 << 1)	/* general call address enable */
+#define FNA	(1 << 0)	/* forced non acknowledgement */
+
 /* ICMCR */
 #define MDBS	(1 << 7)	/* non-fifo mode switch */
 #define FSCL	(1 << 6)	/* override SCL pin */
@@ -58,6 +64,15 @@
 #define FSB	(1 << 1)	/* force stop bit */
 #define ESG	(1 << 0)	/* en startbit gen */
 
+/* ICSSR (also for ICSIER) */
+#define GCAR	(1 << 6)	/* general call received */
+#define STM	(1 << 5)	/* slave transmit mode */
+#define SSR	(1 << 4)	/* stop received */
+#define SDE	(1 << 3)	/* slave data empty */
+#define SDT	(1 << 2)	/* slave data transmitted */
+#define SDR	(1 << 1)	/* slave data received */
+#define SAR	(1 << 0)	/* slave addr received */
+
 /* ICMSR (also for ICMIE) */
 #define MNR	(1 << 6)	/* nack received */
 #define MAL	(1 << 5)	/* arbitration lost */
@@ -103,6 +118,7 @@ struct rcar_i2c_priv {
 	u32 icccr;
 	u32 flags;
 	enum rcar_i2c_type devtype;
+	struct i2c_client *slave;
 };
 
 #define rcar_i2c_priv_to_dev(p)		((p)->adap.dev.parent)
@@ -126,15 +142,6 @@ static u32 rcar_i2c_read(struct rcar_i2c_priv *priv, int reg)
 
 static void rcar_i2c_init(struct rcar_i2c_priv *priv)
 {
-	/*
-	 * reset slave mode.
-	 * slave mode is not used on this driver
-	 */
-	rcar_i2c_write(priv, ICSIER, 0);
-	rcar_i2c_write(priv, ICSAR, 0);
-	rcar_i2c_write(priv, ICSCR, 0);
-	rcar_i2c_write(priv, ICSSR, 0);
-
 	/* reset master mode */
 	rcar_i2c_write(priv, ICMIER, 0);
 	rcar_i2c_write(priv, ICMCR, 0);
@@ -360,6 +367,63 @@ static int rcar_i2c_irq_recv(struct rcar_i2c_priv *priv, u32 msr)
 	return 0;
 }
 
+static bool rcar_i2c_slave_irq(struct rcar_i2c_priv *priv)
+{
+	u32 ssr_raw, ssr_filtered;
+	u8 value;
+
+	ssr_raw = rcar_i2c_read(priv, ICSSR) & 0xff;
+	ssr_filtered = ssr_raw & rcar_i2c_read(priv, ICSIER);
+
+	if (!ssr_filtered)
+		return false;
+
+	/* address detected */
+	if (ssr_filtered & SAR) {
+		/* read or write request */
+		if (ssr_raw & STM) {
+			i2c_slave_event(priv->slave, I2C_SLAVE_REQ_READ_START, &value);
+			rcar_i2c_write(priv, ICRXTX, value);
+			rcar_i2c_write(priv, ICSIER, SDE | SSR | SAR);
+		} else {
+			i2c_slave_event(priv->slave, I2C_SLAVE_REQ_WRITE_START, &value);
+			rcar_i2c_read(priv, ICRXTX);	/* dummy read */
+			rcar_i2c_write(priv, ICSIER, SDR | SSR | SAR);
+		}
+
+		rcar_i2c_write(priv, ICSSR, ~SAR & 0xff);
+	}
+
+	/* master sent stop */
+	if (ssr_filtered & SSR) {
+		i2c_slave_event(priv->slave, I2C_SLAVE_STOP, &value);
+		rcar_i2c_write(priv, ICSIER, SAR | SSR);
+		rcar_i2c_write(priv, ICSSR, ~SSR & 0xff);
+	}
+
+	/* master wants to write to us */
+	if (ssr_filtered & SDR) {
+		int ret;
+
+		value = rcar_i2c_read(priv, ICRXTX);
+		ret = i2c_slave_event(priv->slave, I2C_SLAVE_REQ_WRITE_END, &value);
+		/* Send NACK in case of error */
+		rcar_i2c_write(priv, ICSCR, SIE | SDBS | (ret < 0 ? FNA : 0));
+		i2c_slave_event(priv->slave, I2C_SLAVE_REQ_WRITE_START, &value);
+		rcar_i2c_write(priv, ICSSR, ~SDR & 0xff);
+	}
+
+	/* master wants to read from us */
+	if (ssr_filtered & SDE) {
+		i2c_slave_event(priv->slave, I2C_SLAVE_REQ_READ_END, &value);
+		i2c_slave_event(priv->slave, I2C_SLAVE_REQ_READ_START, &value);
+		rcar_i2c_write(priv, ICRXTX, value);
+		rcar_i2c_write(priv, ICSSR, ~SDE & 0xff);
+	}
+
+	return true;
+}
+
 static irqreturn_t rcar_i2c_irq(int irq, void *ptr)
 {
 	struct rcar_i2c_priv *priv = ptr;
@@ -369,6 +433,9 @@ static irqreturn_t rcar_i2c_irq(int irq, void *ptr)
 	/*-------------- spin lock -----------------*/
 	spin_lock(&priv->lock);
 
+	if (rcar_i2c_slave_irq(priv))
+		goto exit;
+
 	msr = rcar_i2c_read(priv, ICMSR);
 
 	/* Only handle interrupts that are currently enabled */
@@ -499,6 +566,44 @@ out:
 	return ret;
 }
 
+
+static int rcar_reg_slave(struct i2c_client *slave)
+{
+	struct rcar_i2c_priv *priv = i2c_get_adapdata(slave->adapter);
+
+	if (priv->slave)
+		return -EBUSY;
+
+	if (slave->flags & I2C_CLIENT_TEN)
+		return -EAFNOSUPPORT;
+
+	pm_runtime_forbid(rcar_i2c_priv_to_dev(priv));
+
+	priv->slave = slave;
+	rcar_i2c_write(priv, ICSAR, slave->addr);
+	rcar_i2c_write(priv, ICSSR, 0);
+	rcar_i2c_write(priv, ICSIER, SAR | SSR);
+	rcar_i2c_write(priv, ICSCR, SIE | SDBS);
+
+	return 0;
+}
+
+static int rcar_unreg_slave(struct i2c_client *slave)
+{
+	struct rcar_i2c_priv *priv = i2c_get_adapdata(slave->adapter);
+
+	WARN_ON(!priv->slave);
+
+	rcar_i2c_write(priv, ICSIER, 0);
+	rcar_i2c_write(priv, ICSCR, 0);
+
+	priv->slave = NULL;
+
+	pm_runtime_allow(rcar_i2c_priv_to_dev(priv));
+
+	return 0;
+}
+
 static u32 rcar_i2c_func(struct i2c_adapter *adap)
 {
 	/* This HW can't do SMBUS_QUICK and NOSTART */
@@ -508,6 +613,8 @@ static u32 rcar_i2c_func(struct i2c_adapter *adap)
 static const struct i2c_algorithm rcar_i2c_algo = {
 	.master_xfer	= rcar_i2c_master_xfer,
 	.functionality	= rcar_i2c_func,
+	.reg_slave	= rcar_reg_slave,
+	.unreg_slave	= rcar_unreg_slave,
 };
 
 static const struct of_device_id rcar_i2c_dt_ids[] = {
-- 
2.1.1

