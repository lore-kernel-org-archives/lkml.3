Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbaFBMJD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 08:09:03 -0400
Received: from sauhun.de ([89.238.76.85]:45052 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848AbaFBMJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 08:09:00 -0400
Date: Mon, 2 Jun 2014 14:08:54 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Max Schwarz <max.schwarz@online.de>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH v4] i2c: add driver for Rockchip RK3xxx SoC I2C adapter
Message-ID: <20140602120854.GA2654@katana>
References: <5192968.EzcUiXba22@typ>
 <1956748.HoDAyYWJMb@typ>
 <1547619.upPdAXDT0W@typ>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <1547619.upPdAXDT0W@typ>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Max,

here is the review:

> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index c94db1c..f973632 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -663,6 +663,16 @@ config I2C_PXA_SLAVE
>  	  is necessary for systems where the PXA may be a target on the
>  	  I2C bus.
> =20
> +config I2C_RK3X
> +	tristate "Rockchip RK3xxx I2C adapter"
> +	depends on OF
> +	help
> +	  Say Y here to include support for the I2C adapter in Rockchip RK3xxx
> +	  SoCs.
> +
> +	  This driver can also be built as a module. If so, the module will
> +	  be called i2c-rk3x.
> +

Please keep it sorted!

>  config I2C_QUP
>  	tristate "Qualcomm QUP based I2C controller"
>  	depends on ARCH_QCOM
> diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
> index 18d18ff..39b6851 100644
> --- a/drivers/i2c/busses/Makefile
> +++ b/drivers/i2c/busses/Makefile
> @@ -65,6 +65,7 @@ obj-$(CONFIG_I2C_PNX)		+=3D i2c-pnx.o
>  obj-$(CONFIG_I2C_PUV3)		+=3D i2c-puv3.o
>  obj-$(CONFIG_I2C_PXA)		+=3D i2c-pxa.o
>  obj-$(CONFIG_I2C_PXA_PCI)	+=3D i2c-pxa-pci.o
> +obj-$(CONFIG_I2C_RK3X)		+=3D i2c-rk3x.o

Please keep it sorted!

>  obj-$(CONFIG_I2C_QUP)		+=3D i2c-qup.o
>  obj-$(CONFIG_I2C_RIIC)		+=3D i2c-riic.o
>  obj-$(CONFIG_I2C_S3C2410)	+=3D i2c-s3c2410.o
> diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
> new file mode 100644
> index 0000000..429983b
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-rk3x.c
> @@ -0,0 +1,742 @@
> +/*
> + * Driver for I2C adapter in Rockchip RK3xxx SoC
> + *
> + * Max Schwarz <max.schwarz@online.de>
> + * based on the patches by Rockchip Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.

=2E..

> +struct rk3x_i2c {
> +	struct i2c_adapter adap;
> +	struct device *dev;
> +	struct rk3x_i2c_soc_data *soc_data;
> +
> +	/* Hardware resources */
> +	void __iomem *regs;
> +	struct regmap *grf;

No need to store this one here, it is only used in probe.

> +	struct clk *clk;
> +	int irq;

No need to store this one here, it is only used in probe.

> +
> +	/* Settings */
> +	unsigned int scl_frequency;
> +
> +	/* Synchronization & notification */
> +	spinlock_t lock;

Why the lock? The core has per-adapter locks anyhow.

> +	wait_queue_head_t wait;
> +	bool busy;
> +
> +	/* Current message */
> +	struct i2c_msg *msg;
> +	u8 addr;
> +	unsigned int mode;
> +
> +	/* I2C state machine */
> +	enum rk3x_i2c_state state;
> +	unsigned int processed; /* sent/received bytes */
> +	int error;
> +};
> +
> +static inline void i2c_writel(struct rk3x_i2c *i2c, u32 value,
> +			      unsigned int offset)
> +{
> +	writel(value, i2c->regs + offset);
> +}
> +
> +static inline u32 i2c_readl(struct rk3x_i2c *i2c, unsigned int offset)
> +{
> +	return readl(i2c->regs + offset);
> +}
> +
> +/* Reset all interrupt pending bits */
> +static inline void rk3x_i2c_clean_ipd(struct rk3x_i2c *i2c)
> +{
> +	i2c_writel(i2c, REG_INT_ALL, REG_IPD);
> +}

In my book, such functions are a bit on the superfluous side, yet no
reason to change.

> +/**
> + * Setup a read according to i2c->msg
> + */
> +static void rk3x_i2c_prepare_read(struct rk3x_i2c *i2c)
> +{
> +	unsigned int len =3D i2c->msg->len - i2c->processed;
> +	u32 con;
> +
> +	con =3D i2c_readl(i2c, REG_CON);
> +
> +	/* the hw can read up to 32 bytes at a time. If we need more than one
> +	 * chunk, send an ACK after the last byte of the current chunk. */

Check CodingStyle for multiline comments.

> +	if (unlikely(len > 32)) {
> +		len =3D 32;
> +		con &=3D ~REG_CON_LASTACK;
> +	} else {
> +		con |=3D REG_CON_LASTACK;
> +	}
> +
> +	/* make sure we are in plain RX mode if we read a second chunk */
> +	if (i2c->processed !=3D 0) {
> +		con &=3D ~REG_CON_MOD_MASK;
> +		con |=3D REG_CON_MOD(REG_CON_MOD_RX);
> +	}
> +
> +	i2c_writel(i2c, con, REG_CON);
> +	i2c_writel(i2c, len, REG_MRXCNT);
> +}
> +
> +/**
> + * Fill the transmit buffer with data from i2c->msg
> + */
> +static void rk3x_i2c_fill_transmit_buf(struct rk3x_i2c *i2c)
> +{
> +	unsigned int i, j;
> +	u32 cnt =3D 0;
> +	u32 val;
> +	u8 byte;
> +
> +	for (i =3D 0; i < 8; ++i) {
> +		val =3D 0;
> +		for (j =3D 0; j < 4; ++j) {
> +			if (i2c->processed =3D=3D i2c->msg->len)
> +				break;
> +
> +			if (i2c->processed =3D=3D 0 && cnt =3D=3D 0)
> +				byte =3D (i2c->addr & 0x7f) << 1;
> +			else
> +				byte =3D i2c->msg->buf[i2c->processed++];
> +
> +			val |=3D byte << (j*8);

Space around operators.

> +			cnt++;
> +		}
> +
> +		i2c_writel(i2c, val, TXBUFFER_BASE + 4*i);

Ditto.

> +
> +		if (i2c->processed =3D=3D i2c->msg->len)
> +			break;
> +	}
> +
> +	i2c_writel(i2c, cnt, REG_MTXCNT);
> +}
> +
> +
> +/* IRQ handlers for individual states */
> +
> +static void rk3x_i2c_handle_start(struct rk3x_i2c *i2c, unsigned int ipd)
> +{
> +	if (!(ipd & REG_INT_START)) {
> +		rk3x_i2c_stop(i2c, -ENXIO);
> +		dev_warn(i2c->dev, "unexpected irq in START: 0x%x\n", ipd);
> +		rk3x_i2c_clean_ipd(i2c);
> +		return;
> +	}
> +
> +	/* ack interrupt */
> +	i2c_writel(i2c, REG_INT_START, REG_IPD);
> +
> +	/* disable start bit */
> +	i2c_writel(i2c, i2c_readl(i2c, REG_CON) & ~REG_CON_START, REG_CON);
> +
> +	/* enable appropriate interrupts and transition */
> +	if (i2c->mode =3D=3D REG_CON_MOD_TX) {
> +		i2c_writel(i2c, REG_INT_MBTF | REG_INT_NAKRCV, REG_IEN);
> +		i2c->state =3D STATE_WRITE;
> +		rk3x_i2c_fill_transmit_buf(i2c);
> +	} else {
> +		/* in any other case, we are going to be reading. */
> +		i2c_writel(i2c, REG_INT_MBRF | REG_INT_NAKRCV, REG_IEN);
> +		i2c->state =3D STATE_READ;
> +		rk3x_i2c_prepare_read(i2c);
> +	}
> +}
> +
> +static void rk3x_i2c_handle_write(struct rk3x_i2c *i2c, unsigned int ipd)
> +{
> +	if (!(ipd & REG_INT_MBTF)) {
> +		rk3x_i2c_stop(i2c, -ENXIO);
> +		dev_err(i2c->dev, "unexpected irq in WRITE: 0x%x\n", ipd);
> +		rk3x_i2c_clean_ipd(i2c);
> +		return;
> +	}
> +
> +	/* ack interrupt */
> +	i2c_writel(i2c, REG_INT_MBTF, REG_IPD);
> +
> +	/* are we finished? */
> +	if (i2c->processed =3D=3D i2c->msg->len)
> +		rk3x_i2c_stop(i2c, i2c->error);
> +	else
> +		rk3x_i2c_fill_transmit_buf(i2c);

It looks to me that you STOP after every message? You should use
REPEATED_START inbetween messages and only stop after the last message
of a transfer.

> +}
> +
> +static void rk3x_i2c_handle_read(struct rk3x_i2c *i2c, unsigned int ipd)
> +{
> +	unsigned int i;
> +	unsigned int len =3D i2c->msg->len - i2c->processed;
> +	unsigned int val;
> +	u8 byte;
> +
> +	/* we only care for MBRF here. */
> +	if (!(ipd & REG_INT_MBRF))
> +		return;
> +
> +	/* ack interrupt */
> +	i2c_writel(i2c, REG_INT_MBRF, REG_IPD);
> +
> +	/* read the data from receive buffer */
> +	for (i =3D 0; i < len; ++i) {
> +		if (i % 4 =3D=3D 0)
> +			val =3D i2c_readl(i2c, RXBUFFER_BASE + (i / 4) * 4);
> +
> +		byte =3D (val >> ((i % 4) * 8)) & 0xff;
> +		i2c->msg->buf[i2c->processed++] =3D byte;
> +	}
> +
> +	/* are we finished? */
> +	if (i2c->processed =3D=3D i2c->msg->len)
> +		rk3x_i2c_stop(i2c, i2c->error);
> +	else
> +		rk3x_i2c_prepare_read(i2c);

Ditto.

> +}
> +
> +static void rk3x_i2c_handle_stop(struct rk3x_i2c *i2c, unsigned int ipd)
> +{
> +	unsigned int con;
> +
> +	if (!(ipd & REG_INT_STOP)) {
> +		rk3x_i2c_stop(i2c, -ENXIO);
> +		dev_err(i2c->dev, "unexpected irq in STOP: 0x%x\n", ipd);
> +		rk3x_i2c_clean_ipd(i2c);
> +		return;
> +	}
> +
> +	/* ack interrupt */
> +	i2c_writel(i2c, REG_INT_STOP, REG_IPD);
> +
> +	/* disable STOP bit */
> +	con =3D i2c_readl(i2c, REG_CON);
> +	con &=3D ~REG_CON_STOP;
> +	i2c_writel(i2c, con, REG_CON);
> +
> +	i2c->busy =3D 0;
> +	i2c->state =3D STATE_IDLE;
> +
> +	/* signal rk3x_i2c_xfer that we are finished */
> +	wake_up(&i2c->wait);
> +}
> +
> +static irqreturn_t rk3x_i2c_irq(int irqno, void *dev_id)
> +{
> +	struct rk3x_i2c *i2c =3D dev_id;
> +	unsigned int ipd;
> +
> +	spin_lock(&i2c->lock);
> +
> +	ipd =3D i2c_readl(i2c, REG_IPD);
> +	if (i2c->state =3D=3D STATE_IDLE) {
> +		dev_warn(i2c->dev, "irq in STATE_IDLE, ipd =3D 0x%x\n", ipd);
> +		rk3x_i2c_clean_ipd(i2c);
> +		goto out;
> +	}
> +
> +	dev_dbg(i2c->dev, "IRQ: state %d, ipd: %x\n", i2c->state, ipd);
> +
> +	/* Clean interrupt bits we don't care about */
> +	ipd &=3D ~(REG_INT_BRF | REG_INT_BTF);
> +
> +	if (ipd & REG_INT_NAKRCV) {
> +		/* We got a NACK in the last operation. Depending on whether
> +		 * IGNORE_NAK is set, we have to stop the operation and report
> +		 * an error. */
> +		i2c_writel(i2c, REG_INT_NAKRCV, REG_IPD);
> +
> +		ipd &=3D ~REG_INT_NAKRCV;
> +
> +		if (!(i2c->msg->flags & I2C_M_IGNORE_NAK))
> +			rk3x_i2c_stop(i2c, -EAGAIN);

NACK is -ENXIO. -EAGAIN is arbitration lost. Check
Documentation/i2c/fault-codes (and probably revisit the other error
codes, too. I might have missed some).

> +	}
> +
> +	/* is there anything left to handle? */
> +	if (unlikely(ipd =3D=3D 0))
> +		goto out;
> +
> +	switch (i2c->state) {
> +	case STATE_START:
> +		rk3x_i2c_handle_start(i2c, ipd);
> +		break;
> +	case STATE_WRITE:
> +		rk3x_i2c_handle_write(i2c, ipd);
> +		break;
> +	case STATE_READ:
> +		rk3x_i2c_handle_read(i2c, ipd);
> +		break;
> +	case STATE_STOP:
> +		rk3x_i2c_handle_stop(i2c, ipd);
> +		break;
> +	case STATE_IDLE:
> +		break;
> +	}
> +
> +out:
> +	spin_unlock(&i2c->lock);
> +	return IRQ_HANDLED;
> +}
> +
> +static void rk3x_i2c_set_scl_rate(struct rk3x_i2c *i2c, unsigned long sc=
l_rate)
> +{
> +	unsigned long i2c_rate =3D clk_get_rate(i2c->clk);
> +	unsigned int div;
> +
> +	/* SCL rate =3D (clk rate) / (8 * DIV) */
> +	div =3D DIV_ROUND_UP(i2c_rate, scl_rate * 8);
> +
> +	/* The lower and upper half of the CLKDIV reg describe the length of
> +	 * SCL low & high periods. */
> +	div =3D DIV_ROUND_UP(div, 2);
> +
> +	i2c_writel(i2c, (div << 16) | (div & 0xffff), REG_CLKDIV);
> +}
> +
> +/**
> + * Setup I2C registers for an I2C operation specified by msgs, num.
> + *
> + * Must be called with i2c->lock held.
> + *
> + * @msgs: I2C msgs to process
> + * @num: Number of msgs
> + *
> + * returns: Number of I2C msgs processed or negative in case of error
> + */
> +static int rk3x_i2c_setup(struct rk3x_i2c *i2c, struct i2c_msg *msgs, in=
t num)
> +{
> +	u32 addr =3D (msgs[0].addr & 0x7f) << 1;
> +	int ret =3D 0;
> +
> +	/*
> +	 * The I2C adapter can issue a small (len < 4) write packet before
> +	 * reading. This speeds up SMBus-style register reads.
> +	 * The MRXADDR/MRXRADDR hold the slave address and the slave register
> +	 * address in this case.
> +	 */
> +
> +	if (num >=3D 2 && msgs[0].len < 4
> +	    && !(msgs[0].flags & I2C_M_RD)
> +	    && (msgs[1].flags & I2C_M_RD)) {
> +		u32 reg_addr =3D 0;
> +
> +		dev_dbg(i2c->dev, "Combined write/read from addr 0x%x\n",
> +			addr >> 1);
> +
> +		if (msgs[0].len =3D=3D 0)
> +			return -EINVAL;

Can the controller do SMBUS_QUICK (len =3D=3D 0) in general? For the case it
cannot do it only in this multi-packet mode, then you should fall back
to the "boring" mode.

> +
> +		/* Fill MRXRADDR with the register address(es) */
> +		reg_addr =3D msgs[0].buf[0];
> +		reg_addr |=3D REG_MRXADDR_LOW;
> +
> +		if (msgs[0].len >=3D 2) {
> +			reg_addr |=3D msgs[0].buf[1] << 8;
> +			reg_addr |=3D REG_MRXADDR_MID;
> +
> +			if (msgs[0].len >=3D 3) {
> +				reg_addr |=3D msgs[0].buf[2] << 16;
> +				reg_addr |=3D REG_MRXADDR_HIGH;
> +			}
> +		}
> +
> +		/* msgs[0] is handled by hw. */
> +		i2c->msg =3D &msgs[1];
> +
> +		i2c->mode =3D REG_CON_MOD_REGISTER_TX;
> +
> +		i2c_writel(i2c, addr | REG_MRXADDR_LOW, REG_MRXADDR);
> +		i2c_writel(i2c, reg_addr, REG_MRXRADDR);
> +
> +		ret =3D 2;
> +	} else {
> +		/* We'll have to do it the boring way and process the msgs
> +		 * one-by-one. */
> +
> +		if (msgs[0].flags & I2C_M_RD) {
> +			addr |=3D 1; /* set read bit */
> +
> +			/* We have to transmit the slave addr first. Use
> +			 * MOD_REGISTER_TX for that purpose. */
> +			i2c->mode =3D REG_CON_MOD_REGISTER_TX;
> +			i2c_writel(i2c, addr | REG_MRXADDR_LOW, REG_MRXADDR);
> +			i2c_writel(i2c, 0, REG_MRXRADDR);
> +		} else {
> +			i2c->mode =3D REG_CON_MOD_TX;
> +		}
> +
> +		i2c->msg =3D &msgs[0];
> +
> +		ret =3D 1;
> +	}
> +
> +	i2c->addr =3D msgs[0].addr;
> +	i2c->busy =3D true;
> +	i2c->state =3D STATE_START;
> +	i2c->processed =3D 0;
> +	i2c->error =3D 0;
> +
> +	rk3x_i2c_clean_ipd(i2c);
> +
> +	return ret;
> +}
> +
> +static int rk3x_i2c_xfer(struct i2c_adapter *adap,
> +			 struct i2c_msg *msgs, int num)
> +{
> +	struct rk3x_i2c *i2c =3D (struct rk3x_i2c *)adap->algo_data;
> +	unsigned long timeout, flags;
> +	int ret =3D 0;
> +	int i;
> +
> +	spin_lock_irqsave(&i2c->lock, flags);
> +
> +	clk_enable(i2c->clk);
> +
> +	/* The clock rate might have changed, so setup the divider again */
> +	rk3x_i2c_set_scl_rate(i2c, i2c->scl_frequency);
> +
> +	/* Process msgs. We can handle more than one message at once (see
> +	 * rk3x_i2c_setup()). */
> +	for (i =3D 0; i < num; i +=3D ret) {
> +		ret =3D rk3x_i2c_setup(i2c, msgs + i, num);
> +
> +		if (ret < 0) {
> +			dev_err(i2c->dev, "rk3x_i2c_setup() failed\n");
> +			break;
> +		}
> +
> +		spin_unlock_irqrestore(&i2c->lock, flags);
> +
> +		rk3x_i2c_start(i2c);
> +
> +		timeout =3D wait_event_timeout(i2c->wait, !i2c->busy,
> +					     msecs_to_jiffies(WAIT_TIMEOUT));
> +
> +		spin_lock_irqsave(&i2c->lock, flags);
> +
> +		if (timeout =3D=3D 0) {
> +			dev_err(i2c->dev, "timeout, ipd: 0x%08X",
> +				i2c_readl(i2c, REG_IPD));
> +
> +			/* Force a STOP condition without interrupt */
> +			i2c_writel(i2c, 0, REG_IEN);
> +			i2c_writel(i2c, REG_CON_EN | REG_CON_STOP, REG_CON);
> +
> +			i2c->state =3D STATE_IDLE;
> +
> +			ret =3D -ETIMEDOUT;
> +			break;
> +		}
> +
> +		if (i2c->error) {
> +			ret =3D i2c->error;
> +			break;
> +		}
> +	}
> +
> +	clk_disable(i2c->clk);
> +	spin_unlock_irqrestore(&i2c->lock, flags);
> +
> +	return ret;
> +}
> +
> +static u32 rk3x_i2c_func(struct i2c_adapter *adap)
> +{
> +	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL | I2C_FUNC_PROTOCOL_MANGLING;
> +}
> +
> +static const struct i2c_algorithm rk3x_i2c_algorithm =3D {
> +	.master_xfer		=3D rk3x_i2c_xfer,
> +	.functionality		=3D rk3x_i2c_func,
> +};
> +
> +static const struct of_device_id rk3x_i2c_match[];

? Why don't you move the complete table here?

> +
> +static int rk3x_i2c_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np =3D pdev->dev.of_node;
> +	const struct of_device_id *match;
> +	struct rk3x_i2c *i2c;
> +	struct resource *mem;
> +	int ret =3D 0;
> +	u32 value;
> +
> +	if (!pdev->dev.of_node) {
> +		dev_err(&pdev->dev, "rk3x-i2c needs a devicetree node\n");
> +		return -EINVAL;
> +	}

Is the platform DT only? Then, the above check is superfluous since
probe wouldn't be called without a match.

> +
> +	i2c =3D devm_kzalloc(&pdev->dev, sizeof(struct rk3x_i2c), GFP_KERNEL);
> +	if (!i2c)
> +		return -ENOMEM;
> +
> +	match =3D of_match_node(rk3x_i2c_match, np);
> +	i2c->soc_data =3D (struct rk3x_i2c_soc_data *)match->data;
> +
> +	if (of_property_read_u32(pdev->dev.of_node, "clock-frequency",
> +				 &i2c->scl_frequency)) {
> +		i2c->scl_frequency =3D 100 * 1000;
> +		dev_info(&pdev->dev, "using default SCL frequency: 100kHz\n");
> +	}

Shouldn't there be a sanity check for the value of "clock-frequency"?

> +	strlcpy(i2c->adap.name, "rk3x-i2c", sizeof(i2c->adap.name));
> +	i2c->adap.owner =3D THIS_MODULE;
> +	i2c->adap.algo =3D &rk3x_i2c_algorithm;
> +	i2c->adap.retries =3D 3;
> +	i2c->adap.dev.of_node =3D np;
> +	i2c->adap.algo_data =3D i2c;
> +	i2c->adap.dev.parent =3D &pdev->dev;
> +
> +	i2c->dev =3D &pdev->dev;
> +
> +	spin_lock_init(&i2c->lock);
> +	init_waitqueue_head(&i2c->wait);
> +
> +	i2c->clk =3D devm_clk_get(&pdev->dev, 0);
> +	if (IS_ERR(i2c->clk)) {
> +		dev_err(&pdev->dev, "cannot get clock\n");
> +		return PTR_ERR(i2c->clk);
> +	}
> +
> +	mem =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	i2c->regs =3D devm_ioremap_resource(&pdev->dev, mem);
> +	if (IS_ERR(i2c->regs))
> +		return PTR_ERR(i2c->regs);
> +
> +	/* Try to set the I2C adapter number from dt */
> +	i2c->adap.nr =3D of_alias_get_id(np, "i2c");
> +	if (i2c->adap.nr < 0)
> +		i2c->adap.nr =3D -1; /* request dynamic ID */

The core does alias handling. Just call i2c_add_adapter().
You will probably need the number in a local variable, though

> +
> +	/* Switch to new interface if the SoC also offers the old one.
> +	 * The control bit is located in the GRF register space. */
> +	if (i2c->soc_data->grf_offset >=3D 0) {
> +		i2c->grf =3D syscon_regmap_lookup_by_phandle(np, "rockchip,grf");
> +		if (IS_ERR(i2c->grf)) {
> +			dev_err(&pdev->dev,
> +				"rk3x-i2c needs 'rockchip,grf' property\n");
> +			return PTR_ERR(i2c->grf);
> +		}
> +
> +		if (i2c->adap.nr < 0) {
> +			dev_err(&pdev->dev, "rk3x-i2c needs i2cX alias");
> +			return -EINVAL;
> +		}
> +
> +		/* 27+i: write mask, 11+i: value */
> +		value =3D BIT(27 + i2c->adap.nr) | BIT(11 + i2c->adap.nr);
> +
> +		ret =3D regmap_write(i2c->grf, i2c->soc_data->grf_offset, value);
> +		if (ret !=3D 0) {
> +			dev_err(i2c->dev, "Could not write to GRF: %d\n", ret);
> +			return ret;
> +		}
> +	}
> +
> +	/* IRQ setup */
> +	i2c->irq =3D platform_get_irq(pdev, 0);
> +	if (i2c->irq < 0) {
> +		dev_err(&pdev->dev, "cannot find rk3x IRQ\n");
> +		return i2c->irq;
> +	}
> +
> +	ret =3D devm_request_irq(&pdev->dev, i2c->irq, rk3x_i2c_irq,
> +			       0, dev_name(&pdev->dev), i2c);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "cannot request IRQ\n");
> +		return ret;
> +	}
> +
> +	platform_set_drvdata(pdev, i2c);
> +
> +	ret =3D clk_prepare(i2c->clk);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "Could not prepare clock\n");
> +		return ret;
> +	}
> +
> +	ret =3D i2c_add_numbered_adapter(&i2c->adap);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "Could not register adapter\n");
> +		goto err_clk;
> +	}
> +
> +	dev_info(&pdev->dev, "Initialized RK3xxx I2C bus at 0x%08x\n",
> +		 (unsigned int)i2c->regs);
> +
> +	return 0;
> +
> +err_clk:
> +	clk_unprepare(i2c->clk);
> +	return ret;
> +}

Thanks,

   Wolfram


--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTjGlWAAoJEBQN5MwUoCm27dkP/2kWnGDfS5XxGT13Mb6E4PHp
/6jlF1p7SXOTeRDHnmvegBEZu2M6YxCIOWETA+mszLuuDjQwgXT22u29bo6zM4DS
mH2PTjKo5btJx7pH7RByFdaEz8Ri5w3J0x6cb5MpoPsHzsLg0lPigOxKxeJGVjOz
ix6j9jBaYhbKGrKBL0RDy6aK5AD9ftFFk3dzdrz2Z/jclF+yEbkTgFgLIseDU56S
v+bhHb1pe4gR7N2/9Vf/BA1v4GbbJnCFbQrY0afdPyaPqPddjqTJBClsZZKf3fWs
S/xYJBCQHXFqQpwwUPTjz921RMm8dyPEjaM0ww9Xgw35enR9iFepH9uuC1zRm3+k
AgO/ZIbkK1bz5nROrRiwYEOfS7lACHK90u8cpoplUAElNwIocW8IO2tlsbLyqEEf
zDfrM7m+MwRxBHAW39d/NNMWsIN3O7HJX65KE24vBpchPP6WZVDebABRyY3c8Jf2
aMufKknlYb8kT2eEmQNSI4msNZBmJZmwgvQh06l6aiYdgErLCtuYOii8nNDHZb5D
/sJFohx8sge1NgocGeSCNDe2GOLBVEhlXyLTGWu9sfSyy3wqbwTxiNT+0PDuOdX7
BSSOIJ+bf+5KioBXwn0RFRvg6Swc+qAzGThLA5QnAtVryi6DivqiA5xRhYE0V9bj
Xv/FlUv8tLEJ0YZeUNgT
=KEmt
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
