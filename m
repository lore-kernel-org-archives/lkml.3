Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbaFGRg1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 13:36:27 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:49928 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbaFGRgY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 13:36:24 -0400
From: Max Schwarz <max.schwarz@online.de>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v5] i2c: add driver for Rockchip RK3xxx SoC I2C adapter
Date: Sat, 07 Jun 2014 19:36:19 +0200
Message-ID: <10794912.fZysmMBNIZ@typ>
User-Agent: KMail/4.13 (Linux/3.13.0-29-generic; KDE/4.13.0; x86_64; ; )
In-Reply-To: <1956748.HoDAyYWJMb@typ>
References: <5192968.EzcUiXba22@typ> <1956748.HoDAyYWJMb@typ>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
X-Provags-ID: V02:K0:1klJ09fGBiTEQDORdLikvthctswv9HmDZCgN5ouATWM
 pYx5Klb1w6ksR8uVFufi+RUOgb8jqm7YZnQMttwD+4vmZjefdh
 gzVWZwQP5KBSkD0nfb1h+6lwxN9+SDvr5peq6u5fDieR39gE4d
 KRNRc4ZR6Hk1AxynwSsgqO6bLXaiXJ2QQj0hAVnZGLXSNSGhR7
 BUIi3Xj+IoQBUC6PaN6QwNz9deY/CQ6j/Da+eLRMzSFj5OsWYg
 ThfEOMupMKE6i3HHc00lbPEJ8EJJNZQFFHU8VkFvRtGe+ZImE4
 H+CPvsr4TiX1C5b/vMAS1Xs7TJ/7EltMt8MzFoshGyzRqIjtg=
 =
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver for the native I2C adapter found in Rockchip RK3xxx SoCs.

Configuration is only possible through devicetree. The driver is
interrupt driven and supports the I2C_M_IGNORE_NAK mangling bit.

Signed-off-by: Max Schwarz <max.schwarz@online.de>
---

The driver cannot be used without a proper clock driver
supporting rate calculation, such as Heiko Stübner's RK3xxx clock
driver series [1].

Changes since v4:
  - fixed a bug in message counting in rk3x_i2c_xfer()
  - Found/suggested by Wolfram Sang:
    * fixed style issues
    * fixed sorting in Kconfig, Makefile
    * removed unneeded fields from struct rk3x_i2c
    * REPEATED_START between msgs of one transfer
    * fixed wrong error code on NAK
    * support for SMB_QUICK (len == 0)
    * removed unneeded DT check & alias handling
    * sanity check for clock-frequency

Changes since v3:
  - fixed style issues found by Maxime Ripard
  - use dt alias id to calculate the bit offset in GRF,
    as suggested by Maxime Ripard
  - also use dt alias id for i2c_add_numbered_adapter()

Changes since v2:
  - support for the new GRF syscon mapping by Heiko Stübner
  - probe error handling improvements by Heiko Stübner
  - fixed wrong remove() order found by Heiko Stübner
  - removed unnecessary clk_enable() during probe
  - removed switch back to old interface during remove

Changes since v1:
  - dt property names "rockchip,*" suggested by Heiko Stübner
  - fixed overly specific RK3188 comment (Heiko Stübner)

The dts files needed for testing on Radxa Rock are in my tree at

https://github.com/xqms/linux.git topic/i2c-rk3x-clean-v4

[1]: http://www.spinics.net/lists/arm-kernel/msg329102.html

 Documentation/devicetree/bindings/i2c/i2c-rk3x.txt |  42 ++
 drivers/i2c/busses/Kconfig                         |  10 +
 drivers/i2c/busses/Makefile                        |   1 +
 drivers/i2c/busses/i2c-rk3x.c                      | 769 +++++++++++++++++++++
 4 files changed, 822 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/i2c/i2c-rk3x.txt
 create mode 100644 drivers/i2c/busses/i2c-rk3x.c

diff --git a/Documentation/devicetree/bindings/i2c/i2c-rk3x.txt b/Documentation/devicetree/bindings/i2c/i2c-rk3x.txt
new file mode 100644
index 0000000..dde6c22
--- /dev/null
+++ b/Documentation/devicetree/bindings/i2c/i2c-rk3x.txt
@@ -0,0 +1,42 @@
+* Rockchip RK3xxx I2C controller
+
+This driver interfaces with the native I2C controller present in Rockchip
+RK3xxx SoCs.
+
+Required properties :
+
+ - reg : Offset and length of the register set for the device
+ - compatible : should be "rockchip,rk3066-i2c", "rockchip,rk3188-i2c" or
+		"rockchip,rk3288-i2c".
+ - interrupts : interrupt number
+ - clocks : parent clock
+
+Required on RK3066, RK3188 :
+
+ - rockchip,grf : the phandle of the syscon node for the general register
+		  file (GRF)
+ - on those SoCs an alias with the correct I2C bus ID (bit offset in the GRF)
+   is also required.
+
+Optional properties :
+
+ - clock-frequency : SCL frequency to use (in Hz). If omitted, 100kHz is used.
+
+Example:
+
+aliases {
+	i2c0 = &i2c0;
+}
+
+i2c0: i2c@2002d000 {
+	compatible = "rockchip,rk3188-i2c";
+	reg = <0x2002d000 0x1000>;
+	interrupts = <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>;
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	rockchip,grf = <&grf>;
+
+	clock-names = "i2c";
+	clocks = <&cru PCLK_I2C0>;
+};
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 7ccc51e..39307d0 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -676,6 +676,16 @@ config I2C_RIIC
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-riic.
 
+config I2C_RK3X
+	tristate "Rockchip RK3xxx I2C adapter"
+	depends on OF
+	help
+	  Say Y here to include support for the I2C adapter in Rockchip RK3xxx
+	  SoCs.
+
+	  This driver can also be built as a module. If so, the module will
+	  be called i2c-rk3x.
+
 config HAVE_S3C2410_I2C
 	bool
 	help
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index 413d062..5582cf9 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -66,6 +66,7 @@ obj-$(CONFIG_I2C_PXA)		+= i2c-pxa.o
 obj-$(CONFIG_I2C_PXA_PCI)	+= i2c-pxa-pci.o
 obj-$(CONFIG_I2C_QUP)		+= i2c-qup.o
 obj-$(CONFIG_I2C_RIIC)		+= i2c-riic.o
+obj-$(CONFIG_I2C_RK3X)		+= i2c-rk3x.o
 obj-$(CONFIG_I2C_S3C2410)	+= i2c-s3c2410.o
 obj-$(CONFIG_I2C_S6000)		+= i2c-s6000.o
 obj-$(CONFIG_I2C_SH7760)	+= i2c-sh7760.o
diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
new file mode 100644
index 0000000..7a430f4
--- /dev/null
+++ b/drivers/i2c/busses/i2c-rk3x.c
@@ -0,0 +1,769 @@
+/*
+ * Driver for I2C adapter in Rockchip RK3xxx SoC
+ *
+ * Max Schwarz <max.schwarz@online.de>
+ * based on the patches by Rockchip Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include <linux/i2c.h>
+#include <linux/time.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/of_address.h>
+#include <linux/of_irq.h>
+#include <linux/spinlock.h>
+#include <linux/clk.h>
+#include <linux/wait.h>
+#include <linux/mfd/syscon.h>
+#include <linux/regmap.h>
+
+
+/* Register Map */
+#define REG_CON        0x00 /* control register */
+#define REG_CLKDIV     0x04 /* clock divisor register */
+#define REG_MRXADDR    0x08 /* slave address for REGISTER_TX */
+#define REG_MRXRADDR   0x0c /* slave register address for REGISTER_TX */
+#define REG_MTXCNT     0x10 /* number of bytes to be transmitted */
+#define REG_MRXCNT     0x14 /* number of bytes to be received */
+#define REG_IEN        0x18 /* interrupt enable */
+#define REG_IPD        0x1c /* interrupt pending */
+#define REG_FCNT       0x20 /* finished count */
+
+/* Data buffer offsets */
+#define TXBUFFER_BASE 0x100
+#define RXBUFFER_BASE 0x200
+
+/* REG_CON bits */
+#define REG_CON_EN        BIT(0)
+enum {
+	REG_CON_MOD_TX = 0,      /* transmit data */
+	REG_CON_MOD_REGISTER_TX, /* select register and restart */
+	REG_CON_MOD_RX,          /* receive data */
+	REG_CON_MOD_REGISTER_RX, /* broken: transmits read addr AND writes
+				  * register addr */
+};
+#define REG_CON_MOD(mod)  ((mod) << 1)
+#define REG_CON_MOD_MASK  (BIT(1) | BIT(2))
+#define REG_CON_START     BIT(3)
+#define REG_CON_STOP      BIT(4)
+#define REG_CON_LASTACK   BIT(5) /* 1: do not send ACK after last receive */
+#define REG_CON_ACTACK    BIT(6) /* 1: stop if NACK is received */
+
+/* REG_MRXADDR bits */
+#define REG_MRXADDR_VALID(x) BIT(24 + (x)) /* [x*8+7:x*8] of MRX[R]ADDR valid */
+
+/* REG_IEN/REG_IPD bits */
+#define REG_INT_BTF       BIT(0) /* a byte was transmitted */
+#define REG_INT_BRF       BIT(1) /* a byte was received */
+#define REG_INT_MBTF      BIT(2) /* master data transmit finished */
+#define REG_INT_MBRF      BIT(3) /* master data receive finished */
+#define REG_INT_START     BIT(4) /* START condition generated */
+#define REG_INT_STOP      BIT(5) /* STOP condition generated */
+#define REG_INT_NAKRCV    BIT(6) /* NACK received */
+#define REG_INT_ALL       0x7f
+
+/* Constants */
+#define WAIT_TIMEOUT      200 /* ms */
+#define DEFAULT_SCL_RATE  (100 * 1000) /* Hz */
+
+enum rk3x_i2c_state {
+	STATE_IDLE,
+	STATE_START,
+	STATE_READ,
+	STATE_WRITE,
+	STATE_STOP
+};
+
+/**
+ * @grf_offset: offset inside the grf regmap for setting the i2c type
+ */
+struct rk3x_i2c_soc_data {
+	int grf_offset;
+};
+
+struct rk3x_i2c {
+	struct i2c_adapter adap;
+	struct device *dev;
+	struct rk3x_i2c_soc_data *soc_data;
+
+	/* Hardware resources */
+	void __iomem *regs;
+	struct clk *clk;
+
+	/* Settings */
+	unsigned int scl_frequency;
+
+	/* Synchronization & notification */
+	spinlock_t lock;
+	wait_queue_head_t wait;
+	bool busy;
+
+	/* Current message */
+	struct i2c_msg *msg;
+	u8 addr;
+	unsigned int mode;
+	bool is_last_msg;
+
+	/* I2C state machine */
+	enum rk3x_i2c_state state;
+	unsigned int processed; /* sent/received bytes */
+	int error;
+};
+
+static inline void i2c_writel(struct rk3x_i2c *i2c, u32 value,
+			      unsigned int offset)
+{
+	writel(value, i2c->regs + offset);
+}
+
+static inline u32 i2c_readl(struct rk3x_i2c *i2c, unsigned int offset)
+{
+	return readl(i2c->regs + offset);
+}
+
+/* Reset all interrupt pending bits */
+static inline void rk3x_i2c_clean_ipd(struct rk3x_i2c *i2c)
+{
+	i2c_writel(i2c, REG_INT_ALL, REG_IPD);
+}
+
+/**
+ * Generate a START condition, which triggers a REG_INT_START interrupt.
+ */
+static void rk3x_i2c_start(struct rk3x_i2c *i2c)
+{
+	u32 val;
+
+	dev_dbg(i2c->dev, "start\n");
+
+	rk3x_i2c_clean_ipd(i2c);
+	i2c_writel(i2c, REG_INT_START, REG_IEN);
+
+	/* enable adapter with correct mode, send START condition */
+	val = REG_CON_EN | REG_CON_MOD(i2c->mode) | REG_CON_START;
+
+	/* if we want to react to NACK, set ACTACK bit */
+	if (!(i2c->msg->flags & I2C_M_IGNORE_NAK))
+		val |= REG_CON_ACTACK;
+
+	i2c_writel(i2c, val, REG_CON);
+}
+
+/**
+ * Generate a STOP condition, which triggers a REG_INT_STOP interrupt.
+ *
+ * @error: Error code to return in rk3x_i2c_xfer
+ */
+static void rk3x_i2c_stop(struct rk3x_i2c *i2c, int error)
+{
+	unsigned int ctrl;
+
+	i2c->processed = 0;
+	i2c->msg = 0;
+	i2c->error = error;
+
+	if (i2c->is_last_msg) {
+		/* Enable stop interrupt */
+		i2c_writel(i2c, REG_INT_STOP, REG_IEN);
+
+		i2c->state = STATE_STOP;
+
+		ctrl = i2c_readl(i2c, REG_CON);
+		ctrl |= REG_CON_STOP;
+		i2c_writel(i2c, ctrl, REG_CON);
+	} else {
+		/* Signal rk3x_i2c_xfer to start the next message. */
+		i2c->busy = 0;
+		i2c->state = STATE_IDLE;
+
+		/*
+		 * The HW is actually not capable of REPEATED START. But we can
+		 * get the intended effect by resetting its internal state
+		 * and issuing an ordinary START.
+		 */
+		i2c_writel(i2c, 0, REG_CON);
+
+		/* signal that we are finished with the current msg */
+		wake_up(&i2c->wait);
+	}
+}
+
+/**
+ * Setup a read according to i2c->msg
+ */
+static void rk3x_i2c_prepare_read(struct rk3x_i2c *i2c)
+{
+	unsigned int len = i2c->msg->len - i2c->processed;
+	u32 con;
+
+	con = i2c_readl(i2c, REG_CON);
+
+	/*
+	 * The hw can read up to 32 bytes at a time. If we need more than one
+	 * chunk, send an ACK after the last byte of the current chunk.
+	 */
+	if (unlikely(len > 32)) {
+		len = 32;
+		con &= ~REG_CON_LASTACK;
+	} else {
+		con |= REG_CON_LASTACK;
+	}
+
+	/* make sure we are in plain RX mode if we read a second chunk */
+	if (i2c->processed != 0) {
+		con &= ~REG_CON_MOD_MASK;
+		con |= REG_CON_MOD(REG_CON_MOD_RX);
+	}
+
+	i2c_writel(i2c, con, REG_CON);
+	i2c_writel(i2c, len, REG_MRXCNT);
+}
+
+/**
+ * Fill the transmit buffer with data from i2c->msg
+ */
+static void rk3x_i2c_fill_transmit_buf(struct rk3x_i2c *i2c)
+{
+	unsigned int i, j;
+	u32 cnt = 0;
+	u32 val;
+	u8 byte;
+
+	for (i = 0; i < 8; ++i) {
+		val = 0;
+		for (j = 0; j < 4; ++j) {
+			if (i2c->processed == i2c->msg->len)
+				break;
+
+			if (i2c->processed == 0 && cnt == 0)
+				byte = (i2c->addr & 0x7f) << 1;
+			else
+				byte = i2c->msg->buf[i2c->processed++];
+
+			val |= byte << (j * 8);
+			cnt++;
+		}
+
+		i2c_writel(i2c, val, TXBUFFER_BASE + 4 * i);
+
+		if (i2c->processed == i2c->msg->len)
+			break;
+	}
+
+	i2c_writel(i2c, cnt, REG_MTXCNT);
+}
+
+
+/* IRQ handlers for individual states */
+
+static void rk3x_i2c_handle_start(struct rk3x_i2c *i2c, unsigned int ipd)
+{
+	if (!(ipd & REG_INT_START)) {
+		rk3x_i2c_stop(i2c, -EIO);
+		dev_warn(i2c->dev, "unexpected irq in START: 0x%x\n", ipd);
+		rk3x_i2c_clean_ipd(i2c);
+		return;
+	}
+
+	/* ack interrupt */
+	i2c_writel(i2c, REG_INT_START, REG_IPD);
+
+	/* disable start bit */
+	i2c_writel(i2c, i2c_readl(i2c, REG_CON) & ~REG_CON_START, REG_CON);
+
+	/* enable appropriate interrupts and transition */
+	if (i2c->mode == REG_CON_MOD_TX) {
+		i2c_writel(i2c, REG_INT_MBTF | REG_INT_NAKRCV, REG_IEN);
+		i2c->state = STATE_WRITE;
+		rk3x_i2c_fill_transmit_buf(i2c);
+	} else {
+		/* in any other case, we are going to be reading. */
+		i2c_writel(i2c, REG_INT_MBRF | REG_INT_NAKRCV, REG_IEN);
+		i2c->state = STATE_READ;
+		rk3x_i2c_prepare_read(i2c);
+	}
+}
+
+static void rk3x_i2c_handle_write(struct rk3x_i2c *i2c, unsigned int ipd)
+{
+	if (!(ipd & REG_INT_MBTF)) {
+		rk3x_i2c_stop(i2c, -EIO);
+		dev_err(i2c->dev, "unexpected irq in WRITE: 0x%x\n", ipd);
+		rk3x_i2c_clean_ipd(i2c);
+		return;
+	}
+
+	/* ack interrupt */
+	i2c_writel(i2c, REG_INT_MBTF, REG_IPD);
+
+	/* are we finished? */
+	if (i2c->processed == i2c->msg->len)
+		rk3x_i2c_stop(i2c, i2c->error);
+	else
+		rk3x_i2c_fill_transmit_buf(i2c);
+}
+
+static void rk3x_i2c_handle_read(struct rk3x_i2c *i2c, unsigned int ipd)
+{
+	unsigned int i;
+	unsigned int len = i2c->msg->len - i2c->processed;
+	unsigned int val;
+	u8 byte;
+
+	/* we only care for MBRF here. */
+	if (!(ipd & REG_INT_MBRF))
+		return;
+
+	/* ack interrupt */
+	i2c_writel(i2c, REG_INT_MBRF, REG_IPD);
+
+	/* read the data from receive buffer */
+	for (i = 0; i < len; ++i) {
+		if (i % 4 == 0)
+			val = i2c_readl(i2c, RXBUFFER_BASE + (i / 4) * 4);
+
+		byte = (val >> ((i % 4) * 8)) & 0xff;
+		i2c->msg->buf[i2c->processed++] = byte;
+	}
+
+	/* are we finished? */
+	if (i2c->processed == i2c->msg->len)
+		rk3x_i2c_stop(i2c, i2c->error);
+	else
+		rk3x_i2c_prepare_read(i2c);
+}
+
+static void rk3x_i2c_handle_stop(struct rk3x_i2c *i2c, unsigned int ipd)
+{
+	unsigned int con;
+
+	if (!(ipd & REG_INT_STOP)) {
+		rk3x_i2c_stop(i2c, -EIO);
+		dev_err(i2c->dev, "unexpected irq in STOP: 0x%x\n", ipd);
+		rk3x_i2c_clean_ipd(i2c);
+		return;
+	}
+
+	/* ack interrupt */
+	i2c_writel(i2c, REG_INT_STOP, REG_IPD);
+
+	/* disable STOP bit */
+	con = i2c_readl(i2c, REG_CON);
+	con &= ~REG_CON_STOP;
+	i2c_writel(i2c, con, REG_CON);
+
+	i2c->busy = 0;
+	i2c->state = STATE_IDLE;
+
+	/* signal rk3x_i2c_xfer that we are finished */
+	wake_up(&i2c->wait);
+}
+
+static irqreturn_t rk3x_i2c_irq(int irqno, void *dev_id)
+{
+	struct rk3x_i2c *i2c = dev_id;
+	unsigned int ipd;
+
+	spin_lock(&i2c->lock);
+
+	ipd = i2c_readl(i2c, REG_IPD);
+	if (i2c->state == STATE_IDLE) {
+		dev_warn(i2c->dev, "irq in STATE_IDLE, ipd = 0x%x\n", ipd);
+		rk3x_i2c_clean_ipd(i2c);
+		goto out;
+	}
+
+	dev_dbg(i2c->dev, "IRQ: state %d, ipd: %x\n", i2c->state, ipd);
+
+	/* Clean interrupt bits we don't care about */
+	ipd &= ~(REG_INT_BRF | REG_INT_BTF);
+
+	if (ipd & REG_INT_NAKRCV) {
+		/*
+		 * We got a NACK in the last operation. Depending on whether
+		 * IGNORE_NAK is set, we have to stop the operation and report
+		 * an error.
+		 */
+		i2c_writel(i2c, REG_INT_NAKRCV, REG_IPD);
+
+		ipd &= ~REG_INT_NAKRCV;
+
+		if (!(i2c->msg->flags & I2C_M_IGNORE_NAK))
+			rk3x_i2c_stop(i2c, -ENXIO);
+	}
+
+	/* is there anything left to handle? */
+	if (unlikely(ipd == 0))
+		goto out;
+
+	switch (i2c->state) {
+	case STATE_START:
+		rk3x_i2c_handle_start(i2c, ipd);
+		break;
+	case STATE_WRITE:
+		rk3x_i2c_handle_write(i2c, ipd);
+		break;
+	case STATE_READ:
+		rk3x_i2c_handle_read(i2c, ipd);
+		break;
+	case STATE_STOP:
+		rk3x_i2c_handle_stop(i2c, ipd);
+		break;
+	case STATE_IDLE:
+		break;
+	}
+
+out:
+	spin_unlock(&i2c->lock);
+	return IRQ_HANDLED;
+}
+
+static void rk3x_i2c_set_scl_rate(struct rk3x_i2c *i2c, unsigned long scl_rate)
+{
+	unsigned long i2c_rate = clk_get_rate(i2c->clk);
+	unsigned int div;
+
+	/* SCL rate = (clk rate) / (8 * DIV) */
+	div = DIV_ROUND_UP(i2c_rate, scl_rate * 8);
+
+	/* The lower and upper half of the CLKDIV reg describe the length of
+	 * SCL low & high periods. */
+	div = DIV_ROUND_UP(div, 2);
+
+	i2c_writel(i2c, (div << 16) | (div & 0xffff), REG_CLKDIV);
+}
+
+/**
+ * Setup I2C registers for an I2C operation specified by msgs, num.
+ *
+ * Must be called with i2c->lock held.
+ *
+ * @msgs: I2C msgs to process
+ * @num: Number of msgs
+ *
+ * returns: Number of I2C msgs processed or negative in case of error
+ */
+static int rk3x_i2c_setup(struct rk3x_i2c *i2c, struct i2c_msg *msgs, int num)
+{
+	u32 addr = (msgs[0].addr & 0x7f) << 1;
+	int ret = 0;
+
+	/*
+	 * The I2C adapter can issue a small (len < 4) write packet before
+	 * reading. This speeds up SMBus-style register reads.
+	 * The MRXADDR/MRXRADDR hold the slave address and the slave register
+	 * address in this case.
+	 */
+
+	if (num >= 2 && msgs[0].len < 4
+	    && !(msgs[0].flags & I2C_M_RD)
+	    && (msgs[1].flags & I2C_M_RD)) {
+		u32 reg_addr = 0;
+		int i;
+
+		dev_dbg(i2c->dev, "Combined write/read from addr 0x%x\n",
+			addr >> 1);
+
+		/* Fill MRXRADDR with the register address(es) */
+		for (i = 0; i < msgs[0].len; ++i) {
+			reg_addr |= msgs[0].buf[i] << (i * 8);
+			reg_addr |= REG_MRXADDR_VALID(i);
+		}
+
+		/* msgs[0] is handled by hw. */
+		i2c->msg = &msgs[1];
+
+		i2c->mode = REG_CON_MOD_REGISTER_TX;
+
+		i2c_writel(i2c, addr | REG_MRXADDR_VALID(0), REG_MRXADDR);
+		i2c_writel(i2c, reg_addr, REG_MRXRADDR);
+
+		ret = 2;
+	} else {
+		/*
+		 * We'll have to do it the boring way and process the msgs
+		 * one-by-one.
+		 */
+
+		if (msgs[0].flags & I2C_M_RD) {
+			addr |= 1; /* set read bit */
+
+			/*
+			 * We have to transmit the slave addr first. Use
+			 * MOD_REGISTER_TX for that purpose.
+			 */
+			i2c->mode = REG_CON_MOD_REGISTER_TX;
+			i2c_writel(i2c, addr | REG_MRXADDR_VALID(0),
+				   REG_MRXADDR);
+			i2c_writel(i2c, 0, REG_MRXRADDR);
+		} else {
+			i2c->mode = REG_CON_MOD_TX;
+		}
+
+		i2c->msg = &msgs[0];
+
+		ret = 1;
+	}
+
+	i2c->addr = msgs[0].addr;
+	i2c->busy = true;
+	i2c->state = STATE_START;
+	i2c->processed = 0;
+	i2c->error = 0;
+
+	rk3x_i2c_clean_ipd(i2c);
+
+	return ret;
+}
+
+static int rk3x_i2c_xfer(struct i2c_adapter *adap,
+			 struct i2c_msg *msgs, int num)
+{
+	struct rk3x_i2c *i2c = (struct rk3x_i2c *)adap->algo_data;
+	unsigned long timeout, flags;
+	int ret = 0;
+	int i;
+
+	spin_lock_irqsave(&i2c->lock, flags);
+
+	clk_enable(i2c->clk);
+
+	/* The clock rate might have changed, so setup the divider again */
+	rk3x_i2c_set_scl_rate(i2c, i2c->scl_frequency);
+
+	i2c->is_last_msg = false;
+
+	/*
+	 * Process msgs. We can handle more than one message at once (see
+	 * rk3x_i2c_setup()).
+	 */
+	for (i = 0; i < num; i += ret) {
+		ret = rk3x_i2c_setup(i2c, msgs + i, num - i);
+
+		if (ret < 0) {
+			dev_err(i2c->dev, "rk3x_i2c_setup() failed\n");
+			break;
+		}
+
+		if (i + ret >= num)
+			i2c->is_last_msg = true;
+
+		spin_unlock_irqrestore(&i2c->lock, flags);
+
+		rk3x_i2c_start(i2c);
+
+		timeout = wait_event_timeout(i2c->wait, !i2c->busy,
+					     msecs_to_jiffies(WAIT_TIMEOUT));
+
+		spin_lock_irqsave(&i2c->lock, flags);
+
+		if (timeout == 0) {
+			dev_err(i2c->dev, "timeout, ipd: 0x%02x, state: %d\n",
+				i2c_readl(i2c, REG_IPD), i2c->state);
+
+			/* Force a STOP condition without interrupt */
+			i2c_writel(i2c, 0, REG_IEN);
+			i2c_writel(i2c, REG_CON_EN | REG_CON_STOP, REG_CON);
+
+			i2c->state = STATE_IDLE;
+
+			ret = -ETIMEDOUT;
+			break;
+		}
+
+		if (i2c->error) {
+			ret = i2c->error;
+			break;
+		}
+	}
+
+	clk_disable(i2c->clk);
+	spin_unlock_irqrestore(&i2c->lock, flags);
+
+	return ret;
+}
+
+static u32 rk3x_i2c_func(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL | I2C_FUNC_PROTOCOL_MANGLING;
+}
+
+static const struct i2c_algorithm rk3x_i2c_algorithm = {
+	.master_xfer		= rk3x_i2c_xfer,
+	.functionality		= rk3x_i2c_func,
+};
+
+static struct rk3x_i2c_soc_data soc_data[3] = {
+	{ .grf_offset = 0x154 }, /* rk3066 */
+	{ .grf_offset = 0x0a4 }, /* rk3188 */
+	{ .grf_offset = -1 },    /* no I2C switching needed */
+};
+
+static const struct of_device_id rk3x_i2c_match[] = {
+	{ .compatible = "rockchip,rk3066-i2c", .data = (void *)&soc_data[0] },
+	{ .compatible = "rockchip,rk3188-i2c", .data = (void *)&soc_data[1] },
+	{ .compatible = "rockchip,rk3288-i2c", .data = (void *)&soc_data[2] },
+};
+
+static int rk3x_i2c_probe(struct platform_device *pdev)
+{
+	struct device_node *np = pdev->dev.of_node;
+	const struct of_device_id *match;
+	struct rk3x_i2c *i2c;
+	struct resource *mem;
+	int ret = 0;
+	int bus_nr;
+	u32 value;
+	int irq;
+
+	i2c = devm_kzalloc(&pdev->dev, sizeof(struct rk3x_i2c), GFP_KERNEL);
+	if (!i2c)
+		return -ENOMEM;
+
+	match = of_match_node(rk3x_i2c_match, np);
+	i2c->soc_data = (struct rk3x_i2c_soc_data *)match->data;
+
+	if (of_property_read_u32(pdev->dev.of_node, "clock-frequency",
+				 &i2c->scl_frequency)) {
+		dev_info(&pdev->dev, "using default SCL frequency: %d\n",
+			 DEFAULT_SCL_RATE);
+		i2c->scl_frequency = DEFAULT_SCL_RATE;
+	}
+
+	if (i2c->scl_frequency == 0 || i2c->scl_frequency > 400 * 1000) {
+		dev_warn(&pdev->dev, "invalid SCL frequency specified.\n");
+		dev_warn(&pdev->dev, "using default SCL frequency: %d\n",
+			 DEFAULT_SCL_RATE);
+		i2c->scl_frequency = DEFAULT_SCL_RATE;
+	}
+
+	strlcpy(i2c->adap.name, "rk3x-i2c", sizeof(i2c->adap.name));
+	i2c->adap.owner = THIS_MODULE;
+	i2c->adap.algo = &rk3x_i2c_algorithm;
+	i2c->adap.retries = 3;
+	i2c->adap.dev.of_node = np;
+	i2c->adap.algo_data = i2c;
+	i2c->adap.dev.parent = &pdev->dev;
+
+	i2c->dev = &pdev->dev;
+
+	spin_lock_init(&i2c->lock);
+	init_waitqueue_head(&i2c->wait);
+
+	i2c->clk = devm_clk_get(&pdev->dev, 0);
+	if (IS_ERR(i2c->clk)) {
+		dev_err(&pdev->dev, "cannot get clock\n");
+		return PTR_ERR(i2c->clk);
+	}
+
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	i2c->regs = devm_ioremap_resource(&pdev->dev, mem);
+	if (IS_ERR(i2c->regs))
+		return PTR_ERR(i2c->regs);
+
+	/* Try to set the I2C adapter number from dt */
+	bus_nr = of_alias_get_id(np, "i2c");
+
+	/*
+	 * Switch to new interface if the SoC also offers the old one.
+	 * The control bit is located in the GRF register space.
+	 */
+	if (i2c->soc_data->grf_offset >= 0) {
+		struct regmap *grf;
+
+		grf = syscon_regmap_lookup_by_phandle(np, "rockchip,grf");
+		if (IS_ERR(grf)) {
+			dev_err(&pdev->dev,
+				"rk3x-i2c needs 'rockchip,grf' property\n");
+			return PTR_ERR(grf);
+		}
+
+		if (bus_nr < 0) {
+			dev_err(&pdev->dev, "rk3x-i2c needs i2cX alias");
+			return -EINVAL;
+		}
+
+		/* 27+i: write mask, 11+i: value */
+		value = BIT(27 + bus_nr) | BIT(11 + bus_nr);
+
+		ret = regmap_write(grf, i2c->soc_data->grf_offset, value);
+		if (ret != 0) {
+			dev_err(i2c->dev, "Could not write to GRF: %d\n", ret);
+			return ret;
+		}
+	}
+
+	/* IRQ setup */
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0) {
+		dev_err(&pdev->dev, "cannot find rk3x IRQ\n");
+		return irq;
+	}
+
+	ret = devm_request_irq(&pdev->dev, irq, rk3x_i2c_irq,
+			       0, dev_name(&pdev->dev), i2c);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "cannot request IRQ\n");
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, i2c);
+
+	ret = clk_prepare(i2c->clk);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Could not prepare clock\n");
+		return ret;
+	}
+
+	ret = i2c_add_adapter(&i2c->adap);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Could not register adapter\n");
+		goto err_clk;
+	}
+
+	dev_info(&pdev->dev, "Initialized RK3xxx I2C bus at 0x%08x\n",
+		 (unsigned int)i2c->regs);
+
+	return 0;
+
+err_clk:
+	clk_unprepare(i2c->clk);
+	return ret;
+}
+
+static int rk3x_i2c_remove(struct platform_device *pdev)
+{
+	struct rk3x_i2c *i2c = platform_get_drvdata(pdev);
+
+	i2c_del_adapter(&i2c->adap);
+	clk_unprepare(i2c->clk);
+
+	return 0;
+}
+
+static struct platform_driver rk3x_i2c_driver = {
+	.probe   = rk3x_i2c_probe,
+	.remove  = rk3x_i2c_remove,
+	.driver  = {
+		.owner = THIS_MODULE,
+		.name  = "rk3x-i2c",
+		.of_match_table = rk3x_i2c_match,
+	},
+};
+
+module_platform_driver(rk3x_i2c_driver);
+
+MODULE_DESCRIPTION("Rockchip RK3xxx I2C Bus driver");
+MODULE_AUTHOR("Max Schwarz <max.schwarz@online.de>");
+MODULE_LICENSE("GPL v2");
-- 
1.9.1


