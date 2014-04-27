Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbaD0UWu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 16:22:50 -0400
Received: from gloria.sntech.de ([95.129.55.99]:53874 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbaD0UWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 16:22:48 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Max Schwarz <max.schwarz@online.de>
Cc: Wolfram Sang <wsa@the-dreams.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] i2c: add driver for Rockchip RK3xxx SoC I2C adapter
Date: Sun, 27 Apr 2014 22:23:13 +0200
Message-ID: <2533407.kJCGHuX10p@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1840959.yqLj3D6H4q@typ>
References: <1840959.yqLj3D6H4q@typ>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Max,

first of all, thanks for working on this :-)

I saw some general things inlined below, but I guess Wolfram is the better 
person to check the i2c-specifics.

Am Sonntag, 27. April 2014, 21:38:49 schrieb Max Schwarz:
> Driver for the native I2C adapter found in Rockchip RK3xxx SoCs.

[...]

> diff --git a/Documentation/devicetree/bindings/i2c/i2c-rk3x.txt
> b/Documentation/devicetree/bindings/i2c/i2c-rk3x.txt new file mode 100644
> index 0000000..6778985
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/i2c/i2c-rk3x.txt
> @@ -0,0 +1,33 @@
> +* Rockchip RK3xxx I2C controller
> +
> +This driver interfaces with the native I2C controller present in Rockchip
> +RK3xxx SoCs.
> +
> +Required properties :
> +
> + - reg : Offset and length of the register set for the device
> + - compatible : should be "rockchip,rk3x-i2c"
> + - interrupts : interrupt number
> + - clocks : parent clock
> + - grf : the phandle of the syscon node for the general register file (GRF)
> + - bus-idx : index of the bus in the GRF

both the grf as well as the bus-idx are rockchip specific, so they should be 
prefixed (rockchip,grf, etc) and from my personal taste I would hope we could 
invest in an "n" and "e", to make it a full bus-index ;-)


> +
> +Optional properties :
> +
> + - frequency : SCL frequency to use (in Hz). If omitted, 100kHz is used.

the convention seems to be "clock-frequency" for the desired bus speed 
(checked i2c-sirf, i2c-exynos, i2c-at91and i2c-qup).


> +
> +Example:
> +
> +i2c0: i2c@2002d000 {
> +	compatible = "rockchip,rk3x-i2c";
> +	reg = <0x2002d000 0x1000>;
> +	interrupts = <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>;
> +	#address-cells = <1>;
> +	#size-cells = <0>;
> +
> +	grf = <&grf>;
> +	bus-idx = <0>;
> +
> +	clock-names = "i2c";
> +	clocks = <&cru PCLK_I2C0>;
> +};
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index c94db1c..f973632 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -663,6 +663,16 @@ config I2C_PXA_SLAVE
>  	  is necessary for systems where the PXA may be a target on the
>  	  I2C bus.
> 
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
> @@ -65,6 +65,7 @@ obj-$(CONFIG_I2C_PNX)		+= i2c-pnx.o
>  obj-$(CONFIG_I2C_PUV3)		+= i2c-puv3.o
>  obj-$(CONFIG_I2C_PXA)		+= i2c-pxa.o
>  obj-$(CONFIG_I2C_PXA_PCI)	+= i2c-pxa-pci.o
> +obj-$(CONFIG_I2C_RK3X)		+= i2c-rk3x.o
>  obj-$(CONFIG_I2C_QUP)		+= i2c-qup.o
>  obj-$(CONFIG_I2C_RIIC)		+= i2c-riic.o
>  obj-$(CONFIG_I2C_S3C2410)	+= i2c-s3c2410.o
> diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
> new file mode 100644
> index 0000000..00491b0
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-rk3x.c
> @@ -0,0 +1,728 @@
> +/*
> + * Driver for I2C unit in Rockchip RK3188 SoC

RK3188 -> RK3xxx?

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
> +	REG_CON_MOD_TX = 0,      /* transmit data */
> +	REG_CON_MOD_REGISTER_TX, /* select register and restart */
> +	REG_CON_MOD_RX,          /* receive data */
> +	REG_CON_MOD_REGISTER_RX, /* broken: transmits read addr AND writes
> +				  * register addr */
> +};
> +#define REG_CON_MOD(mod)  ((mod) << 1)
> +#define REG_CON_MOD_MASK  (3 << 1)
> +#define REG_CON_START     (1 << 3)
> +#define REG_CON_STOP      (1 << 4)
> +#define REG_CON_LASTACK   (1 << 5) /* 1: do not send ACK after last receive
> */ +#define REG_CON_ACTACK    (1 << 6) /* 1: stop if NACK is received */ +
> +/* REG_MRXADDR bits */
> +#define REG_MRXADDR_LOW   (1 << 24) /* bits [7:0] of MRX[R]ADDR are valid
> */ +#define REG_MRXADDR_MID   (1 << 25) /* bits [15:8] of MRX[R]ADDR are
> valid */ +#define REG_MRXADDR_HIGH  (1 << 26) /* bits [23:16] of MRX[R]ADDR
> are valid */ +
> +/* REG_IEN/REG_IPD bits */
> +#define REG_INT_BTF       (1 << 0) /* a byte was transmitted */
> +#define REG_INT_BRF       (1 << 1) /* a byte was received */
> +#define REG_INT_MBTF      (1 << 2) /* master data transmit finished */
> +#define REG_INT_MBRF      (1 << 3) /* master data receive finished */
> +#define REG_INT_START     (1 << 4) /* START condition generated */
> +#define REG_INT_STOP      (1 << 5) /* STOP condition generated */
> +#define REG_INT_NAKRCV    (1 << 6) /* NACK received */
> +#define REG_INT_ALL       0x7f
> +
> +/* Registers in the GRF (General Register File) */
> +#define GRF_SOC_CON1      4
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
> +struct rk3x_i2c {
> +	struct i2c_adapter adap;
> +	struct device *dev;
> +
> +	/* Hardware resources */
> +	void __iomem *regs;
> +	struct regmap *grf;
> +	unsigned int bus_idx;
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

I'm not sure what the policy here is, but is this indirection really necessary 
when it's only doing a normal readl/writel?


Heiko
