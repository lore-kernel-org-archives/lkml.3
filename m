Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaESHuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 03:50:09 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49027 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752794AbaESHuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 03:50:06 -0400
Date: Mon, 19 May 2014 09:49:59 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Max Schwarz <max.schwarz@online.de>
Cc: Wolfram Sang <wsa@the-dreams.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Subject: Re: [PATCH v3] i2c: add driver for Rockchip RK3xxx SoC I2C adapter
Message-ID: <20140519074959.GB29466@lukather>
References: <5192968.EzcUiXba22@typ>
 <1956748.HoDAyYWJMb@typ>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <1956748.HoDAyYWJMb@typ>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, May 19, 2014 at 02:37:57AM +0200, Max Schwarz wrote:
> Driver for the native I2C adapter found in Rockchip RK3xxx SoCs.
>=20
> Configuration is only possible through devicetree. The driver is
> interrupt driven and supports the I2C_M_IGNORE_NAK mangling bit.
>=20
> Signed-off-by: Max Schwarz <max.schwarz@online.de>
> ---
>=20
> The driver cannot be used without a proper clock driver
> supporting rate calculation, such as Heiko St=FCbner's RK3xxx clock
> driver series [1].
>=20
> Changes since v2:
>   - support for the new GRF syscon mapping by Heiko St=FCbner
>   - probe error handling improvements by Heiko St=FCbner
>   - fixed wrong remove() order found by Heiko St=FCbner
>   - removed unnecessary clk_enable() during probe
>   - removed switch back to old interface during remove
>=20
> Changes since v1:
>   - dt property names "rockchip,*" suggested by Heiko St=FCbner
>   - fixed overly specific RK3188 comment (Heiko St=FCbner)
>=20
> The dts files needed for testing on Radxa Rock are in my tree at
>=20
> https://github.com/xqms/linux.git topic/i2c-rk3x-clean-v3
>=20
> [1]: http://www.spinics.net/lists/arm-kernel/msg329102.html
>=20
>  Documentation/devicetree/bindings/i2c/i2c-rk3x.txt |  38 ++
>  drivers/i2c/busses/Kconfig                         |  10 +
>  drivers/i2c/busses/Makefile                        |   1 +
>  drivers/i2c/busses/i2c-rk3x.c                      | 740 +++++++++++++++=
++++++
>  4 files changed, 789 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/i2c/i2c-rk3x.txt
>  create mode 100644 drivers/i2c/busses/i2c-rk3x.c
>=20
> diff --git a/Documentation/devicetree/bindings/i2c/i2c-rk3x.txt b/Documen=
tation/devicetree/bindings/i2c/i2c-rk3x.txt
> new file mode 100644
> index 0000000..99598f0
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/i2c/i2c-rk3x.txt
> @@ -0,0 +1,38 @@
> +* Rockchip RK3xxx I2C controller
> +
> +This driver interfaces with the native I2C controller present in Rockchip
> +RK3xxx SoCs.
> +
> +Required properties :
> +
> + - reg : Offset and length of the register set for the device
> + - compatible : should be "rockchip,rk3066-i2c", "rockchip,rk3188-i2c" or
> +		"rockchip,rk3288-i2c".
> + - interrupts : interrupt number
> + - clocks : parent clock
> +
> +Required on RK3066, RK3188 :
> +
> + - rockchip,grf : the phandle of the syscon node for the general register
> +		  file (GRF)
> + - rockchip,bus-index : index of the bus in the GRF
> +
> +Optional properties :
> +
> + - clock-frequency : SCL frequency to use (in Hz). If omitted, 100kHz is=
 used.
> +
> +Example:
> +
> +i2c0: i2c@2002d000 {
> +	compatible =3D "rockchip,rk3188-i2c";
> +	reg =3D <0x2002d000 0x1000>;
> +	interrupts =3D <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>;
> +	#address-cells =3D <1>;
> +	#size-cells =3D <0>;
> +
> +	rockchip,grf =3D <&grf>;
> +	rockchip,bus-index =3D <0>;
> +
> +	clock-names =3D "i2c";
> +	clocks =3D <&cru PCLK_I2C0>;
> +};
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
>  obj-$(CONFIG_I2C_QUP)		+=3D i2c-qup.o
>  obj-$(CONFIG_I2C_RIIC)		+=3D i2c-riic.o
>  obj-$(CONFIG_I2C_S3C2410)	+=3D i2c-s3c2410.o
> diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
> new file mode 100644
> index 0000000..4f506f6
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-rk3x.c
> @@ -0,0 +1,740 @@
> +/*
> + * Driver for I2C adapter in Rockchip RK3xxx SoC
> + *
> + * Max Schwarz <max.schwarz@online.de>
> + * based on the patches by Rockchip Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +
> +#include <linux/i2c.h>
> +#include <linux/time.h>
> +#include <linux/interrupt.h>
> +#include <linux/delay.h>
> +#include <linux/errno.h>
> +#include <linux/err.h>
> +#include <linux/platform_device.h>
> +#include <linux/io.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +#include <linux/spinlock.h>
> +#include <linux/clk.h>
> +#include <linux/wait.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/regmap.h>
> +
> +
> +/* Register Map */
> +#define REG_CON        0x00 /* control register */
> +#define REG_CLKDIV     0x04 /* clock divisor register */
> +#define REG_MRXADDR    0x08 /* slave address for REGISTER_TX */
> +#define REG_MRXRADDR   0x0c /* slave register address for REGISTER_TX */
> +#define REG_MTXCNT     0x10 /* number of bytes to be transmitted */
> +#define REG_MRXCNT     0x14 /* number of bytes to be received */
> +#define REG_IEN        0x18 /* interrupt enable */
> +#define REG_IPD        0x1c /* interrupt pending */
> +#define REG_FCNT       0x20 /* finished count */
> +
> +/* Data buffer offsets */
> +#define TXBUFFER_BASE 0x100
> +#define RXBUFFER_BASE 0x200
> +
> +/* REG_CON bits */
> +#define REG_CON_EN        (1 << 0)
> +enum {
> +	REG_CON_MOD_TX =3D 0,      /* transmit data */
> +	REG_CON_MOD_REGISTER_TX, /* select register and restart */
> +	REG_CON_MOD_RX,          /* receive data */
> +	REG_CON_MOD_REGISTER_RX, /* broken: transmits read addr AND writes
> +				  * register addr */
> +};
> +#define REG_CON_MOD(mod)  ((mod) << 1)
> +#define REG_CON_MOD_MASK  (3 << 1)
> +#define REG_CON_START     (1 << 3)
> +#define REG_CON_STOP      (1 << 4)
> +#define REG_CON_LASTACK   (1 << 5) /* 1: do not send ACK after last rece=
ive */
> +#define REG_CON_ACTACK    (1 << 6) /* 1: stop if NACK is received */
> +
> +/* REG_MRXADDR bits */
> +#define REG_MRXADDR_LOW   (1 << 24) /* bits [7:0] of MRX[R]ADDR are vali=
d */
> +#define REG_MRXADDR_MID   (1 << 25) /* bits [15:8] of MRX[R]ADDR are val=
id */
> +#define REG_MRXADDR_HIGH  (1 << 26) /* bits [23:16] of MRX[R]ADDR are va=
lid */
> +
> +/* REG_IEN/REG_IPD bits */
> +#define REG_INT_BTF       (1 << 0) /* a byte was transmitted */
> +#define REG_INT_BRF       (1 << 1) /* a byte was received */
> +#define REG_INT_MBTF      (1 << 2) /* master data transmit finished */
> +#define REG_INT_MBRF      (1 << 3) /* master data receive finished */
> +#define REG_INT_START     (1 << 4) /* START condition generated */
> +#define REG_INT_STOP      (1 << 5) /* STOP condition generated */
> +#define REG_INT_NAKRCV    (1 << 6) /* NACK received */

You should use the BIT() macro here.

> +#define REG_INT_ALL       0x7f
> +
> +/* Constants */
> +#define WAIT_TIMEOUT      200 /* ms */
> +
> +enum rk3x_i2c_state {
> +	STATE_IDLE,
> +	STATE_START,
> +	STATE_READ,
> +	STATE_WRITE,
> +	STATE_STOP
> +};
> +
> +/**
> + * @grf_offset: offset inside the grf regmap for setting the i2c type
> + */
> +struct rk3x_i2c_soc_data {
> +	int grf_offset;
> +};
> +
> +struct rk3x_i2c {
> +	struct i2c_adapter adap;
> +	struct device *dev;
> +	struct rk3x_i2c_soc_data *soc_data;
> +
> +	/* Hardware resources */
> +	void __iomem *regs;
> +	struct regmap *grf;
> +	unsigned int bus_index;
> +	struct clk *clk;
> +	int irq;
> +
> +	/* Settings */
> +	unsigned int scl_frequency;
> +
> +	/* Synchronization & notification */
> +	spinlock_t lock;
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
> +
> +/**
> + * Generate a START condition, which triggers a REG_INT_START interrupt.
> + */
> +static void rk3x_i2c_start(struct rk3x_i2c *i2c)
> +{
> +	u32 val;
> +
> +	rk3x_i2c_clean_ipd(i2c);
> +	i2c_writel(i2c, REG_INT_START, REG_IEN);
> +
> +	/* enable adapter with correct mode, send START condition */
> +	val =3D REG_CON_EN | REG_CON_MOD(i2c->mode) | REG_CON_START;
> +
> +	/* if we want to react to NACK, set ACTACK bit */
> +	if (!(i2c->msg->flags & I2C_M_IGNORE_NAK))
> +		val |=3D REG_CON_ACTACK;
> +
> +	i2c_writel(i2c, val, REG_CON);
> +}
> +
> +/**
> + * Generate a STOP condition, which triggers a REG_INT_STOP interrupt.
> + *
> + * @error: Error code to return in rk3x_i2c_xfer
> + */
> +static void rk3x_i2c_stop(struct rk3x_i2c *i2c, int error)
> +{
> +	unsigned int ctrl;
> +
> +	i2c->processed =3D 0;
> +	i2c->msg =3D 0;
> +	i2c->error =3D error;
> +
> +	/* Enable stop interrupt */
> +	i2c_writel(i2c, REG_INT_STOP, REG_IEN);
> +
> +	i2c->state =3D STATE_STOP;
> +
> +	ctrl =3D i2c_readl(i2c, REG_CON);
> +	ctrl |=3D REG_CON_STOP;
> +	i2c_writel(i2c, ctrl, REG_CON);
> +}
> +
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
> +	if (unlikely(len > 32)) {
> +		len =3D 32;
> +		con &=3D ~REG_CON_LASTACK;
> +	} else
> +		con |=3D REG_CON_LASTACK;

You should have braces around this block here.

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
> +			cnt++;
> +		}
> +
> +		i2c_writel(i2c, val, TXBUFFER_BASE + 4*i);
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
> +		if (i%4 =3D=3D 0)

Spaces around the operator.

> +			val =3D i2c_readl(i2c, RXBUFFER_BASE + (i/4)*4);

Ditto

> +
> +		byte =3D (val >> ((i%4) * 8)) & 0xff;

Ditto

> +		i2c->msg->buf[i2c->processed++] =3D byte;
> +	}
> +
> +	/* are we finished? */
> +	if (i2c->processed =3D=3D i2c->msg->len)
> +		rk3x_i2c_stop(i2c, i2c->error);
> +	else
> +		rk3x_i2c_prepare_read(i2c);
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
> +
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
> +	/* Switch to new interface if the SoC also offers the old one.
> +	 * The control bit is located in the GRF register space. */
> +	if (i2c->soc_data->grf_offset >=3D 0) {
> +		ret =3D of_property_read_u32(pdev->dev.of_node,
> +				    "rockchip,bus-index", &i2c->bus_index);

You probably can use the aliases id for this, instead of providing a
somewhat redundant information here?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTebenAAoJEBx+YmzsjxAgHowP/2gyoVSDtYasXUd2kBzbmRPZ
bTzPiI+1KSo80ZLmUyRmWL9sSV9WvK2ZKPswlCJiqsnB98a5mMu6kkZ70BvFEUdJ
5iaN+ikexnUoG67XPXlDKr5dvTqhpII4pKSsLY6mdxW44hjhyBPx34SMM5drqu/L
Lb4hZWPoKu+pjjvaBxyfvO9Fih3qfviz6Drtd3B1Vw53JB3Rq63Z5+4ICwsXI9s8
F/afvliCEAeUI0GFRMbtyHdOvf9a1hLKVfSurL1lttd3/HFJ9hJYMIvVFtjIFCgI
knrWES4M28AoL/w7N9xgnnpyVgYtFUMl66It/tEacb6eKUdGqQZ4F38iIguVzBHb
7YUqdvUE6E8+NTnfRrxaUROtd/z4zE9kK4L4foETFdGzr+09Qv69C2sAl5AGOC3L
iNI5oNzramgVCq3O7F4+YN/mcBpmKSAwP3HabrDdJM9+1dMR8b/aa+6aS2m+dOUy
M19+szv0wZies+tGUvfPwFtIyCxcVTTofK0s7aXORHtibkJdaXLvYDByOPpOL7/S
srmYuDSEv6hzyRrKxXAOeYft9m9zvfACBpSqg/uOR9+fFVCrPVZDvwMpY3X/MBRt
FaP/aLo8jTrbQw4shV6/K/akCr3fk7ktnJMjZAcgiibMl8xb8gneHUEMzjbukl3N
UMvtYm8NXlo+XD7PuTcs
=zm+f
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
