Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162293AbaDCGBH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 02:01:07 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:32864 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964791AbaDCGBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 02:01:03 -0400
Message-ID: <533CF913.4020308@monstr.eu>
Date: Thu, 03 Apr 2014 08:00:51 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Grant Likely <grant.likely@linaro.org>,
        Mike Looijmans <mike.looijmans@topic.nl>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-i2c@vger.kernel.org,
        Harini Katakam <harinik@xilinx.com>
Subject: Re: [PATCH v3 1/2] i2c: Add driver for Cadence I2C controller
References: <1394556613-11692-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1394556613-11692-1-git-send-email-soren.brinkmann@xilinx.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="qn36qP4Ku7kvU8CvM9e57OC4KN9mfnfOb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qn36qP4Ku7kvU8CvM9e57OC4KN9mfnfOb
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Soren,

On 03/11/2014 05:50 PM, Soren Brinkmann wrote:
> Add a driver for the Cadence I2C controller. This controller is for
> example found in Xilinx Zynq.
>=20
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> v3:
>  - incorporate signal handling changes from Mike Looijmans
>    <mike.looijmans@topic.nl> (https://lkml.org/lkml/2014/3/11/64)
> v2:
>  - make driver depend on COMMON_CLK instead of ARCH_ZYNQ
> ---
>  .../devicetree/bindings/i2c/i2c-cadence.txt        |  21 +
>  MAINTAINERS                                        |   1 +
>  drivers/i2c/busses/Kconfig                         |   7 +
>  drivers/i2c/busses/Makefile                        |   1 +
>  drivers/i2c/busses/i2c-cadence.c                   | 898 +++++++++++++=
++++++++
>  5 files changed, 928 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/i2c/i2c-cadence.t=
xt
>  create mode 100644 drivers/i2c/busses/i2c-cadence.c
>=20
> diff --git a/Documentation/devicetree/bindings/i2c/i2c-cadence.txt b/Do=
cumentation/devicetree/bindings/i2c/i2c-cadence.txt
> new file mode 100644
> index 000000000000..685adf513111
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/i2c/i2c-cadence.txt
> @@ -0,0 +1,21 @@
> +Binding for the Cadence I2C controller
> +
> +Required properties:
> +  compatible: Compatibility string. Must be 'cdns,i2c-r1p10'.
> +  clocks: From common clock bindings. Phandle to input clock.
> +
> +Optional properties:
> +  clock-frequency: Desired operating frequency, in Hz, of the bus (act=
ual may
> +		   be lower). Defaults to 400000 if not specified.
> +
> +Example:
> +
> +	i2c@e0004000 {
> +		compatible =3D "cdns,i2c-r1p10";
> +		clocks =3D <&clkc 38>;
> +		interrupts =3D <0 25 4>;
> +		reg =3D <0xE0004000 0x1000>;
> +		clock-frequency =3D <400000>;
> +		#address-cells =3D <1>;
> +		#size-cells =3D <0>;
> +	};
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1ecfde109667..58b6bb1892d0 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1403,6 +1403,7 @@ F:	drivers/cpuidle/cpuidle-zynq.c
>  N:	zynq
>  N:	xilinx
>  F:	drivers/clocksource/cadence_ttc_timer.c
> +F:	drivers/i2c/busses/i2c-cadence.c
>  F:	drivers/mmc/host/sdhci-of-arasan.c
> =20
>  ARM SMMU DRIVER
> diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
> index f5ed03164d86..6754d2ed04b3 100644
> --- a/drivers/i2c/busses/Kconfig
> +++ b/drivers/i2c/busses/Kconfig
> @@ -375,6 +375,13 @@ config I2C_BLACKFIN_TWI_CLK_KHZ
>  	help
>  	  The unit of the TWI clock is kHz.
> =20
> +config I2C_CADENCE
> +	tristate "Cadence I2C Controller"
> +	depends on COMMON_CLK
> +	help
> +	  Say yes here to select Cadence I2C Host Controller. This controller=
 is
> +	  e.g. used by Xilinx Zynq.
> +
>  config I2C_CBUS_GPIO
>  	tristate "CBUS I2C driver"
>  	depends on GPIOLIB
> diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
> index a08931fe73e1..f9ebb8c6cdc1 100644
> --- a/drivers/i2c/busses/Makefile
> +++ b/drivers/i2c/busses/Makefile
> @@ -33,6 +33,7 @@ obj-$(CONFIG_I2C_AT91)		+=3D i2c-at91.o
>  obj-$(CONFIG_I2C_AU1550)	+=3D i2c-au1550.o
>  obj-$(CONFIG_I2C_BCM2835)	+=3D i2c-bcm2835.o
>  obj-$(CONFIG_I2C_BLACKFIN_TWI)	+=3D i2c-bfin-twi.o
> +obj-$(CONFIG_I2C_CADENCE)	+=3D i2c-cadence.o
>  obj-$(CONFIG_I2C_CBUS_GPIO)	+=3D i2c-cbus-gpio.o
>  obj-$(CONFIG_I2C_CPM)		+=3D i2c-cpm.o
>  obj-$(CONFIG_I2C_DAVINCI)	+=3D i2c-davinci.o
> diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-=
cadence.c
> new file mode 100644
> index 000000000000..bcc5eda3337b
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-cadence.c
> @@ -0,0 +1,898 @@
> +/*
> + * I2C bus driver for the Cadence I2C controller.
> + *
> + * Copyright (C) 2009 - 2014 Xilinx, Inc.
> + *
> + * This program is free software; you can redistribute it
> + * and/or modify it under the terms of the GNU General Public
> + * License as published by the Free Software Foundation;
> + * either version 2 of the License, or (at your option) any
> + * later version.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/i2c.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +
> +/* Register offsets for the I2C device. */
> +#define CDNS_I2C_CR_OFFSET	0x00 /* Control Register, RW */
> +#define CDNS_I2C_SR_OFFSET	0x04 /* Status Register, RO */
> +#define CDNS_I2C_ADDR_OFFSET	0x08 /* I2C Address Register, RW */
> +#define CDNS_I2C_DATA_OFFSET	0x0C /* I2C Data Register, RW */
> +#define CDNS_I2C_ISR_OFFSET	0x10 /* Interrupt Status Register, RW */
> +#define CDNS_I2C_XFER_SIZE_OFFSET	0x14 /* Transfer Size Register, RW *=
/
> +#define CDNS_I2C_TIME_OUT_OFFSET	0x1C /* Time Out Register, RW */
> +#define CDNS_I2C_IER_OFFSET	0x24 /* Interrupt Enable Register, WO */
> +#define CDNS_I2C_IDR_OFFSET	0x28 /* Interrupt Disable Register, WO */
> +
> +/* Control Register Bit mask definitions */
> +#define CDNS_I2C_CR_HOLD		BIT(4) /* Hold Bus bit */
> +#define CDNS_I2C_CR_NEA			BIT(2)
> +/* Read or Write Master transfer 0 =3D Transmitter, 1 =3D Receiver */
> +#define CDNS_I2C_CR_RW			BIT(0)
> +/* 1 =3D Auto init FIFO to zeroes */
> +#define CDNS_I2C_CR_CLR_FIFO		BIT(6)
> +#define CDNS_I2C_CR_DIVA_SHIFT		14
> +#define CDNS_I2C_CR_DIVA_MASK		(3 << CDNS_I2C_CR_DIVA_SHIFT)
> +#define CDNS_I2C_CR_DIVB_SHIFT		8
> +#define CDNS_I2C_CR_DIVB_MASK		(0x3f << CDNS_I2C_CR_DIVB_SHIFT)
> +
> +/* Status Register Bit mask definitions */
> +#define CDNS_I2C_SR_BA		BIT(8)
> +#define CDNS_I2C_SR_RXDV	BIT(5)
> +
> +#define CDNS_I2C_TIME_OUT_TO_MASK	0xff
> +
> +/*
> + * I2C Address Register Bit mask definitions
> + * Normal addressing mode uses [6:0] bits. Extended addressing mode us=
es [9:0]
> + * bits. A write access to this register always initiates a transfer i=
f the I2C
> + * is in master mode.
> + */
> +#define CDNS_I2C_ADDR_MASK	0x000003FF /* I2C Address Mask */
> +
> +/*
> + * I2C Interrupt Registers Bit mask definitions
> + * All the four interrupt registers (Status/Mask/Enable/Disable) have =
the same
> + * bit definitions.
> + */
> +#define CDNS_I2C_IXR_ALL_INTR_MASK	0x000002FF /* All ISR Mask */
> +#define CDNS_I2C_IXR_ERR_INTR_MASK	0x000002EC
> +#define CDNS_I2C_IXR_ARB_LOST		BIT(9)
> +#define CDNS_I2C_IXR_NACK		BIT(2)
> +#define CDNS_I2C_IXR_DATA		BIT(1)
> +#define CDNS_I2C_IXR_COMP		BIT(0)
> +
> +#define CDNS_I2C_FIFO_DEPTH	16		/* FIFO Depth */
> +#define CDNS_I2C_TIMEOUT	(2 * HZ)	/* Timeout for bus busy check */
> +#define CDNS_I2C_ENABLED_INTR	0x2EF		/* Enabled Interrupts */
> +
> +/* FIFO depth at which the DATA interrupt occurs */
> +#define CDNS_I2C_DATA_INTR_DEPTH	(CDNS_I2C_FIFO_DEPTH - 2)
> +#define CDNS_I2C_MAX_TRANSFER_SIZE	255 /* Max transfer size */
> +/* Transfer size in multiples of data interrupt depth */
> +#define CDNS_I2C_TRANSFER_SIZE	(CDNS_I2C_MAX_TRANSFER_SIZE - 3)
> +
> +#define DRIVER_NAME		"cdns-i2c"
> +
> +#define CDNS_I2C_SPEED_MAX	400000
> +
> +#define CDNS_I2C_DIVA_MAX	4
> +#define CDNS_I2C_DIVB_MAX	64
> +
> +#define cdns_i2c_readreg(offset)	__raw_readl(id->membase + offset)
> +#define cdns_i2c_writereg(val, offset)	__raw_writel(val, id->membase +=
 offset)
> +
> +/**
> + * struct cdns_i2c - I2C device private data structure
> + * @membase:		Base address of the I2C device
> + * @adap:		I2C adapter instance
> + * @p_msg:		Message pointer
> + * @err_status:		Error status in Interrupt Status Register
> + * @xfer_done:		Transfer complete status
> + * @p_send_buf:		Pointer to transmit buffer
> + * @p_recv_buf:		Pointer to receive buffer
> + * @suspended:		Flag holding the device's PM status
> + * @send_count:		Number of bytes still expected to send
> + * @recv_count:		Number of bytes still expected to receive
> + * @irq:		IRQ number
> + * @cur_timeout:	The current timeout value used by the device
> + * @input_clk:		Input clock to I2C controller
> + * @i2c_clk:		Maximum I2C clock speed
> + * @bus_hold_flag:	Flag used in repeated start for clearing HOLD bit
> + * @clk:		Pointer to struct clk
> + * @clk_rate_change_nb:	Notifier block for clock rate changes
> + */
> +struct cdns_i2c {
> +	void __iomem *membase;
> +	struct i2c_adapter adap;
> +	struct i2c_msg *p_msg;
> +	int err_status;
> +	struct completion xfer_done;
> +	unsigned char *p_send_buf;
> +	unsigned char *p_recv_buf;
> +	u8 suspended;
> +	unsigned int send_count;
> +	unsigned int recv_count;
> +	int irq;
> +	int cur_timeout;
> +	unsigned long input_clk;
> +	unsigned int i2c_clk;
> +	unsigned int bus_hold_flag;
> +	struct clk *clk;
> +	struct notifier_block clk_rate_change_nb;
> +};
> +
> +#define to_cdns_i2c(_nb)	container_of(_nb, struct cdns_i2c, \
> +					     clk_rate_change_nb)
> +
> +/**
> + * cdns_i2c_clear_bus_hold() - Clar bus hold bit
> + * @id:	Pointer to driver data struct
> + *
> + * Helper to clear the controller's bus hold bit.
> + */
> +static void cdns_i2c_clear_bus_hold(struct cdns_i2c *id)
> +{
> +	u32 reg =3D cdns_i2c_readreg(CDNS_I2C_CR_OFFSET);
> +	if (reg & CDNS_I2C_CR_HOLD)
> +		cdns_i2c_writereg(reg & ~CDNS_I2C_CR_HOLD, CDNS_I2C_CR_OFFSET);
> +}
> +
> +/**
> + * cdns_i2c_isr - Interrupt handler for the I2C device
> + * @irq:	irq number for the I2C device
> + * @ptr:	void pointer to cdns_i2c structure
> + *
> + * Return: IRQ_HANDLED always
> + *
> + * This function handles the data interrupt, transfer complete interru=
pt and
> + * the error interrupts of the I2C device.
> + */
> +static irqreturn_t cdns_i2c_isr(int irq, void *ptr)
> +{
> +	unsigned int isr_status, avail_bytes;
> +	unsigned int bytes_to_recv, bytes_to_send;
> +	struct cdns_i2c *id =3D ptr;
> +	/* Signal completion only after everything is updated */
> +	int done_flag =3D 0;
> +
> +	isr_status =3D cdns_i2c_readreg(CDNS_I2C_ISR_OFFSET);
> +
> +	/* Handling nack and arbitration lost interrupt */
> +	if (isr_status & (CDNS_I2C_IXR_NACK | CDNS_I2C_IXR_ARB_LOST))
> +		done_flag =3D 1;
> +
> +	/* Handling Data interrupt */
> +	if ((isr_status & CDNS_I2C_IXR_DATA) &&
> +			(id->recv_count >=3D CDNS_I2C_DATA_INTR_DEPTH)) {
> +		/* Always read data interrupt threshold bytes */
> +		bytes_to_recv =3D CDNS_I2C_DATA_INTR_DEPTH;
> +		id->recv_count =3D id->recv_count - CDNS_I2C_DATA_INTR_DEPTH;
> +		avail_bytes =3D cdns_i2c_readreg(CDNS_I2C_XFER_SIZE_OFFSET);
> +
> +		/*
> +		 * if the tranfer size register value is zero, then
> +		 * check for the remaining bytes and update the
> +		 * transfer size register.
> +		 */
> +		if (!avail_bytes) {
> +			if (id->recv_count > CDNS_I2C_TRANSFER_SIZE)
> +				cdns_i2c_writereg(CDNS_I2C_TRANSFER_SIZE,
> +						CDNS_I2C_XFER_SIZE_OFFSET);
> +			else
> +				cdns_i2c_writereg(id->recv_count,
> +						CDNS_I2C_XFER_SIZE_OFFSET);
> +		}
> +
> +		/* Process the data received */
> +		while (bytes_to_recv--)
> +			*(id->p_recv_buf)++ =3D
> +				cdns_i2c_readreg(CDNS_I2C_DATA_OFFSET);
> +
> +		if (!id->bus_hold_flag &&
> +				(id->recv_count <=3D CDNS_I2C_FIFO_DEPTH))
> +			cdns_i2c_clear_bus_hold(id);
> +	}
> +
> +	/* Handling Transfer Complete interrupt */
> +	if (isr_status & CDNS_I2C_IXR_COMP) {
> +		if (!id->p_recv_buf) {
> +			/*
> +			 * If the device is sending data If there is further
> +			 * data to be sent. Calculate the available space
> +			 * in FIFO and fill the FIFO with that many bytes.
> +			 */
> +			if (id->send_count) {
> +				avail_bytes =3D CDNS_I2C_FIFO_DEPTH -
> +				    cdns_i2c_readreg(CDNS_I2C_XFER_SIZE_OFFSET);
> +				if (id->send_count > avail_bytes)
> +					bytes_to_send =3D avail_bytes;
> +				else
> +					bytes_to_send =3D id->send_count;
> +
> +				while (bytes_to_send--) {
> +					cdns_i2c_writereg(
> +						(*(id->p_send_buf)++),
> +						 CDNS_I2C_DATA_OFFSET);
> +					id->send_count--;
> +				}
> +			} else {
> +				/*
> +				 * Signal the completion of transaction and
> +				 * clear the hold bus bit if there are no
> +				 * further messages to be processed.
> +				 */
> +				done_flag =3D 1;
> +			}
> +			if (!id->send_count && !id->bus_hold_flag)
> +				cdns_i2c_clear_bus_hold(id);
> +		} else {
> +			if (!id->bus_hold_flag)
> +				cdns_i2c_clear_bus_hold(id);
> +			/*
> +			 * If the device is receiving data, then signal
> +			 * the completion of transaction and read the data
> +			 * present in the FIFO. Signal the completion of
> +			 * transaction.
> +			 */
> +			while (cdns_i2c_readreg(CDNS_I2C_SR_OFFSET) &
> +					CDNS_I2C_SR_RXDV) {
> +				*(id->p_recv_buf)++ =3D
> +					cdns_i2c_readreg(CDNS_I2C_DATA_OFFSET);
> +				id->recv_count--;
> +			}
> +			done_flag =3D 1;
> +		}
> +	}
> +
> +	/* Update the status for errors */
> +	id->err_status =3D isr_status & CDNS_I2C_IXR_ERR_INTR_MASK;
> +	cdns_i2c_writereg(isr_status, CDNS_I2C_ISR_OFFSET);
> +
> +	if (done_flag)
> +		complete(&id->xfer_done);
> +	return IRQ_HANDLED;
> +}
> +
> +/**
> + * cdns_i2c_mrecv - Prepare and start a master receive operation
> + * @id:		pointer to the i2c device structure
> + */
> +static void cdns_i2c_mrecv(struct cdns_i2c *id)
> +{
> +	unsigned int ctrl_reg;
> +	unsigned int isr_status;
> +
> +	id->p_recv_buf =3D id->p_msg->buf;
> +	id->recv_count =3D id->p_msg->len;
> +
> +	/* Put the controller in master receive mode and clear the FIFO */
> +	ctrl_reg =3D cdns_i2c_readreg(CDNS_I2C_CR_OFFSET);
> +	ctrl_reg |=3D CDNS_I2C_CR_RW | CDNS_I2C_CR_CLR_FIFO;
> +
> +	if ((id->p_msg->flags & I2C_M_RECV_LEN) =3D=3D I2C_M_RECV_LEN)
> +		id->recv_count =3D I2C_SMBUS_BLOCK_MAX + 1;
> +
> +	/*
> +	 * Check for the message size against FIFO depth and set the
> +	 * 'hold bus' bit if it is greater than FIFO depth.
> +	 */
> +	if (id->recv_count > CDNS_I2C_FIFO_DEPTH)
> +		ctrl_reg |=3D CDNS_I2C_CR_HOLD;
> +
> +	cdns_i2c_writereg(ctrl_reg, CDNS_I2C_CR_OFFSET);
> +
> +	/* Clear the interrupts in interrupt status register */
> +	isr_status =3D cdns_i2c_readreg(CDNS_I2C_ISR_OFFSET);
> +	cdns_i2c_writereg(isr_status, CDNS_I2C_ISR_OFFSET);
> +
> +	/*
> +	 * The no. of bytes to receive is checked against the limit of
> +	 * max transfer size. Set transfer size register with no of bytes
> +	 * receive if it is less than transfer size and transfer size if
> +	 * it is more. Enable the interrupts.
> +	 */
> +	if (id->recv_count > CDNS_I2C_TRANSFER_SIZE)
> +		cdns_i2c_writereg(CDNS_I2C_TRANSFER_SIZE,
> +				  CDNS_I2C_XFER_SIZE_OFFSET);
> +	else
> +		cdns_i2c_writereg(id->recv_count, CDNS_I2C_XFER_SIZE_OFFSET);
> +	/* Clear the bus hold flag if bytes to receive is less than FIFO size=
 */
> +	if (!id->bus_hold_flag &&
> +		((id->p_msg->flags & I2C_M_RECV_LEN) !=3D I2C_M_RECV_LEN) &&
> +		(id->recv_count <=3D CDNS_I2C_FIFO_DEPTH))
> +			cdns_i2c_clear_bus_hold(id);
> +	/* Set the slave address in address register - triggers operation */
> +	cdns_i2c_writereg(id->p_msg->addr & CDNS_I2C_ADDR_MASK,
> +						CDNS_I2C_ADDR_OFFSET);
> +	cdns_i2c_writereg(CDNS_I2C_ENABLED_INTR, CDNS_I2C_IER_OFFSET);
> +}
> +
> +/**
> + * cdns_i2c_msend - Prepare and start a master send operation
> + * @id:		pointer to the i2c device
> + */
> +static void cdns_i2c_msend(struct cdns_i2c *id)
> +{
> +	unsigned int avail_bytes;
> +	unsigned int bytes_to_send;
> +	unsigned int ctrl_reg;
> +	unsigned int isr_status;
> +
> +	id->p_recv_buf =3D NULL;
> +	id->p_send_buf =3D id->p_msg->buf;
> +	id->send_count =3D id->p_msg->len;
> +
> +	/* Set the controller in Master transmit mode and clear the FIFO. */
> +	ctrl_reg =3D cdns_i2c_readreg(CDNS_I2C_CR_OFFSET);
> +	ctrl_reg &=3D ~CDNS_I2C_CR_RW;
> +	ctrl_reg |=3D CDNS_I2C_CR_CLR_FIFO;
> +
> +	/*
> +	 * Check for the message size against FIFO depth and set the
> +	 * 'hold bus' bit if it is greater than FIFO depth.
> +	 */
> +	if (id->send_count > CDNS_I2C_FIFO_DEPTH)
> +		ctrl_reg |=3D CDNS_I2C_CR_HOLD;
> +	cdns_i2c_writereg(ctrl_reg, CDNS_I2C_CR_OFFSET);
> +
> +	/* Clear the interrupts in interrupt status register. */
> +	isr_status =3D cdns_i2c_readreg(CDNS_I2C_ISR_OFFSET);
> +	cdns_i2c_writereg(isr_status, CDNS_I2C_ISR_OFFSET);
> +
> +	/*
> +	 * Calculate the space available in FIFO. Check the message length
> +	 * against the space available, and fill the FIFO accordingly.
> +	 * Enable the interrupts.
> +	 */
> +	avail_bytes =3D CDNS_I2C_FIFO_DEPTH -
> +				cdns_i2c_readreg(CDNS_I2C_XFER_SIZE_OFFSET);
> +
> +	if (id->send_count > avail_bytes)
> +		bytes_to_send =3D avail_bytes;
> +	else
> +		bytes_to_send =3D id->send_count;
> +
> +	while (bytes_to_send--) {
> +		cdns_i2c_writereg((*(id->p_send_buf)++), CDNS_I2C_DATA_OFFSET);
> +		id->send_count--;
> +	}
> +
> +	/*
> +	 * Clear the bus hold flag if there is no more data
> +	 * and if it is the last message.
> +	 */
> +	if (!id->bus_hold_flag && !id->send_count)
> +		cdns_i2c_clear_bus_hold(id);
> +	/* Set the slave address in address register - triggers operation. */=

> +	cdns_i2c_writereg(id->p_msg->addr & CDNS_I2C_ADDR_MASK,
> +						CDNS_I2C_ADDR_OFFSET);
> +
> +	cdns_i2c_writereg(CDNS_I2C_ENABLED_INTR, CDNS_I2C_IER_OFFSET);
> +}
> +
> +/**
> + * cdns_i2c_master_reset - Reset the interface
> + * @adap:	pointer to the i2c adapter driver instance
> + *
> + * This function cleanup the fifos, clear the hold bit and status
> + * and disable the interrupts.
> + */
> +static void cdns_i2c_master_reset(struct i2c_adapter *adap)
> +{
> +	struct cdns_i2c *id =3D adap->algo_data;
> +	u32 regval;
> +
> +	/* Disable the interrupts */
> +	cdns_i2c_writereg(CDNS_I2C_IXR_ALL_INTR_MASK, CDNS_I2C_IDR_OFFSET);
> +	/* Clear the hold bit and fifos */
> +	regval =3D cdns_i2c_readreg(CDNS_I2C_CR_OFFSET);
> +	regval &=3D ~CDNS_I2C_CR_HOLD;
> +	regval |=3D CDNS_I2C_CR_CLR_FIFO;
> +	cdns_i2c_writereg(regval, CDNS_I2C_CR_OFFSET);
> +	/* Update the transfercount register to zero */
> +	cdns_i2c_writereg(0, CDNS_I2C_XFER_SIZE_OFFSET);
> +	/* Clear the interupt status register */
> +	regval =3D cdns_i2c_readreg(CDNS_I2C_ISR_OFFSET);
> +	cdns_i2c_writereg(regval, CDNS_I2C_ISR_OFFSET);
> +	/* Clear the status register */
> +	regval =3D cdns_i2c_readreg(CDNS_I2C_SR_OFFSET);
> +	cdns_i2c_writereg(regval, CDNS_I2C_SR_OFFSET);
> +}
> +
> +static int cdns_i2c_process_msg(struct cdns_i2c *id, struct i2c_msg *m=
sg,
> +		struct i2c_adapter *adap)
> +{
> +	int ret;
> +	u32 reg;
> +	bool retry =3D false;
> +	unsigned retries =3D adap->retries;
> +
> +	id->p_msg =3D msg;
> +	do {
> +		id->err_status =3D 0;
> +		init_completion(&id->xfer_done);
> +
> +		/* Check for the TEN Bit mode on each msg */
> +		reg =3D cdns_i2c_readreg(CDNS_I2C_CR_OFFSET);
> +		if (msg->flags & I2C_M_TEN) {
> +			if (reg & CDNS_I2C_CR_NEA)
> +				cdns_i2c_writereg(reg & ~CDNS_I2C_CR_NEA,
> +						CDNS_I2C_CR_OFFSET);
> +		} else {
> +			if (!(reg & CDNS_I2C_CR_NEA))
> +				cdns_i2c_writereg(reg | CDNS_I2C_CR_NEA,
> +						CDNS_I2C_CR_OFFSET);
> +		}
> +
> +		/* Check for the R/W flag on each msg */
> +		if (msg->flags & I2C_M_RD)
> +			cdns_i2c_mrecv(id);
> +		else
> +			cdns_i2c_msend(id);
> +
> +		/* Wait for the signal of completion */
> +		ret =3D wait_for_completion_timeout(&id->xfer_done, HZ);
> +		if (!ret) {
> +			cdns_i2c_master_reset(adap);
> +			dev_err(id->adap.dev.parent,
> +					"timeout waiting on completion\n");
> +			return -ETIMEDOUT;
> +		}
> +
> +		cdns_i2c_writereg(CDNS_I2C_IXR_ALL_INTR_MASK,
> +				  CDNS_I2C_IDR_OFFSET);
> +
> +		/* If it is bus arbitration error, try again */
> +		if (id->err_status & CDNS_I2C_IXR_ARB_LOST) {
> +			dev_dbg(id->adap.dev.parent,
> +				 "Lost ownership on bus, trying again\n");
> +			if (retries--) {
> +				mdelay(2);
> +				retry =3D true;
> +			} else {
> +				dev_err(id->adap.dev.parent,
> +					 "Retries completed, exit\n");
> +				return -EREMOTEIO;
> +			}
> +		}
> +	} while (retry);
> +
> +	return 0;
> +}
> +
> +/**
> + * cdns_i2c_master_xfer - The main i2c transfer function
> + * @adap:	pointer to the i2c adapter driver instance
> + * @msgs:	pointer to the i2c message structure
> + * @num:	the number of messages to transfer
> + *
> + * Return: number of msgs processed on success, negative error otherwi=
se
> + *
> + * This function waits for the bus idle condition and updates the time=
out if
> + * modified by user. Then initiates the send/recv activity based on th=
e
> + * transfer message received.
> + */
> +static int cdns_i2c_master_xfer(struct i2c_adapter *adap, struct i2c_m=
sg *msgs,
> +				int num)
> +{
> +	struct cdns_i2c *id =3D adap->algo_data;
> +	unsigned long timeout;
> +	int ret, count;
> +	u32 reg;
> +
> +	/* Waiting for bus-ready. If bus not ready, it returns after timeout =
*/
> +	timeout =3D jiffies + CDNS_I2C_TIMEOUT;
> +	while (cdns_i2c_readreg(CDNS_I2C_SR_OFFSET) & CDNS_I2C_SR_BA) {
> +		if (time_after(jiffies, timeout)) {
> +			dev_warn(id->adap.dev.parent,
> +					"timedout waiting for bus ready\n");
> +			cdns_i2c_master_reset(adap);
> +			return -ETIMEDOUT;
> +		}
> +		schedule_timeout(1);
> +	}
> +
> +	/* The bus is free. Set the new timeout value if updated */
> +	if (id->adap.timeout !=3D id->cur_timeout) {
> +		cdns_i2c_writereg(id->adap.timeout & CDNS_I2C_TIME_OUT_TO_MASK,
> +					CDNS_I2C_TIME_OUT_OFFSET);
> +		id->cur_timeout =3D id->adap.timeout;
> +	}
> +
> +	/*
> +	 * Set the flag to one when multiple messages are to be
> +	 * processed with a repeated start.
> +	 */
> +	if (num > 1) {
> +		id->bus_hold_flag =3D 1;
> +		reg =3D cdns_i2c_readreg(CDNS_I2C_CR_OFFSET);
> +		reg |=3D CDNS_I2C_CR_HOLD;
> +		cdns_i2c_writereg(reg, CDNS_I2C_CR_OFFSET);
> +	} else {
> +		id->bus_hold_flag =3D 0;
> +	}
> +
> +	/* Process the msg one by one */
> +	for (count =3D 0; count < num; count++, msgs++) {
> +		if (count =3D=3D (num - 1))
> +			id->bus_hold_flag =3D 0;
> +
> +		ret =3D cdns_i2c_process_msg(id, msgs, adap);
> +		if (ret)
> +			return ret;
> +
> +		/* Report the other error interrupts to application as EIO */
> +		if (id->err_status & 0xE4) {
> +			cdns_i2c_master_reset(adap);
> +			return -EIO;
> +		}
> +	}
> +
> +	return num;
> +}
> +
> +/**
> + * cdns_i2c_func - Returns the supported features of the I2C driver
> + * @adap:	pointer to the i2c adapter structure
> + *
> + * Return: 32 bit value, each bit corresponding to a feature
> + */
> +static u32 cdns_i2c_func(struct i2c_adapter *adap)
> +{
> +	return I2C_FUNC_I2C | I2C_FUNC_10BIT_ADDR |
> +		(I2C_FUNC_SMBUS_EMUL & ~I2C_FUNC_SMBUS_QUICK) |
> +		I2C_FUNC_SMBUS_BLOCK_DATA;
> +}
> +
> +static const struct i2c_algorithm cdns_i2c_algo =3D {
> +	.master_xfer	=3D cdns_i2c_master_xfer,
> +	.functionality	=3D cdns_i2c_func,
> +};
> +
> +/**
> + * cdns_i2c_calc_divs - Calculate clock dividers
> + * @f:		I2C clock frequency
> + * @input_clk:	Input clock frequency
> + * @a:		First divider (return value)
> + * @b:		Second divider (return value)
> + *
> + * Return: 0 on success, negative errno otherwise.
> + *
> + * f is used as input and output variable. As input it is used as targ=
et I2C
> + * frequency. On function exit f holds the actually resulting I2C freq=
uency.
> + */
> +static int cdns_i2c_calc_divs(unsigned long *f, unsigned long input_cl=
k,
> +		unsigned int *a, unsigned int *b)
> +{
> +	unsigned long fscl =3D *f, best_fscl =3D *f, actual_fscl, temp;
> +	unsigned int div_a, div_b, calc_div_a =3D 0, calc_div_b =3D 0;
> +	unsigned int last_error, current_error;
> +
> +	/* calculate (divisor_a+1) x (divisor_b+1) */
> +	temp =3D input_clk / (22 * fscl);
> +
> +	/*
> +	 * If the calculated value is negative or 0, the fscl input is out of=

> +	 * range. Return error.
> +	 */
> +	if (!temp || (temp > (CDNS_I2C_DIVA_MAX * CDNS_I2C_DIVB_MAX)))
> +		return -EINVAL;
> +
> +	last_error =3D -1;
> +	for (div_a =3D 0; div_a < CDNS_I2C_DIVA_MAX; div_a++) {
> +		div_b =3D DIV_ROUND_UP(input_clk, 22 * fscl * (div_a + 1));
> +
> +		if ((div_b < 1) || (div_b > CDNS_I2C_DIVB_MAX))
> +			continue;
> +		div_b--;
> +
> +		actual_fscl =3D input_clk / (22 * (div_a + 1) * (div_b + 1));
> +
> +		if (actual_fscl > fscl)
> +			continue;
> +
> +		current_error =3D ((actual_fscl > fscl) ? (actual_fscl - fscl) :
> +							(fscl - actual_fscl));
> +
> +		if (last_error > current_error) {
> +			calc_div_a =3D div_a;
> +			calc_div_b =3D div_b;
> +			best_fscl =3D actual_fscl;
> +			last_error =3D current_error;
> +		}
> +	}
> +
> +	*a =3D calc_div_a;
> +	*b =3D calc_div_b;
> +	*f =3D best_fscl;
> +
> +	return 0;
> +}
> +
> +/**
> + * cdns_i2c_setclk - This function sets the serial clock rate for the =
I2C device
> + * @clk_in:	I2C clock input frequency in Hz
> + * @id:		Pointer to the I2C device structure
> + *
> + * Return: 0 on success, negative error otherwise
> + *
> + * The device must be idle rather than busy transferring data before s=
etting
> + * these device options.
> + * The data rate is set by values in the control register.
> + * The formula for determining the correct register values is
> + *	Fscl =3D Fpclk/(22 x (divisor_a+1) x (divisor_b+1))
> + * See the hardware data sheet for a full explanation of setting the s=
erial
> + * clock rate. The clock can not be faster than the input clock divide=
 by 22.
> + * The two most common clock rates are 100KHz and 400KHz.
> + */
> +static int cdns_i2c_setclk(unsigned long clk_in, struct cdns_i2c *id)
> +{
> +	unsigned int div_a, div_b;
> +	unsigned int ctrl_reg;
> +	int ret =3D 0;
> +	unsigned long fscl =3D id->i2c_clk;
> +
> +	ret =3D cdns_i2c_calc_divs(&fscl, clk_in, &div_a, &div_b);
> +	if (ret)
> +		return ret;
> +
> +	ctrl_reg =3D cdns_i2c_readreg(CDNS_I2C_CR_OFFSET);
> +	ctrl_reg &=3D ~(CDNS_I2C_CR_DIVA_MASK | CDNS_I2C_CR_DIVB_MASK);
> +	ctrl_reg |=3D ((div_a << CDNS_I2C_CR_DIVA_SHIFT) |
> +			(div_b << CDNS_I2C_CR_DIVB_SHIFT));
> +	cdns_i2c_writereg(ctrl_reg, CDNS_I2C_CR_OFFSET);
> +
> +	return 0;
> +}
> +
> +/**
> + * cdns_i2c_clk_notifier_cb - Clock rate change callback
> + * @nb:		Pointer to notifier block
> + * @event:	Notification reason
> + * @data:	Pointer to notification data object
> + * Return:	NOTIFY_STOP if the rate change should be aborted, NOTIFY_OK=

> + *		to acknowedge the change, NOTIFY_DONE if the notification is
> + *		considered irrelevant.
> + *
> + * This function is called when the cdns_i2c input clock frequency cha=
nges.
> + * The callback checks whether a valid bus frequency can be generated =
after the
> + * change. If so, the change is acknowledged, otherwise the change is =
aborted.
> + * New dividers are written to the HW in the pre- or post change notif=
ication
> + * depending on the scaling direction.
> + */
> +static int cdns_i2c_clk_notifier_cb(struct notifier_block *nb, unsigne=
d long
> +		event, void *data)
> +{
> +	struct clk_notifier_data *ndata =3D data;
> +	struct cdns_i2c *id =3D to_cdns_i2c(nb);
> +
> +	if (id->suspended)
> +		return NOTIFY_OK;
> +
> +	switch (event) {
> +	case PRE_RATE_CHANGE:
> +	{
> +		unsigned long input_clk =3D ndata->new_rate;
> +		unsigned long fscl =3D id->i2c_clk;
> +		unsigned int div_a, div_b;
> +		int ret;
> +
> +		ret =3D cdns_i2c_calc_divs(&fscl, input_clk, &div_a, &div_b);
> +		if (ret) {
> +			dev_warn(id->adap.dev.parent,
> +					"clock rate change rejected\n");
> +			return NOTIFY_STOP;
> +		}
> +
> +		/* scale up */
> +		if (ndata->new_rate > ndata->old_rate)
> +			cdns_i2c_setclk(ndata->new_rate, id);
> +
> +		return NOTIFY_OK;
> +	}
> +	case POST_RATE_CHANGE:
> +		id->input_clk =3D ndata->new_rate;
> +		/* scale down */
> +		if (ndata->new_rate < ndata->old_rate)
> +			cdns_i2c_setclk(ndata->new_rate, id);
> +		return NOTIFY_OK;
> +	case ABORT_RATE_CHANGE:
> +		/* scale up */
> +		if (ndata->new_rate > ndata->old_rate)
> +			cdns_i2c_setclk(ndata->old_rate, id);
> +		return NOTIFY_OK;
> +	default:
> +		return NOTIFY_DONE;
> +	}
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +/**
> + * cdns_i2c_suspend - Suspend method for the driver
> + * @_dev:	Address of the platform_device structure
> + * Return: 0 always
> + *
> + * Put the driver into low power mode.
> + */
> +static int cdns_i2c_suspend(struct device *_dev)
> +{
> +	struct platform_device *pdev =3D container_of(_dev,
> +			struct platform_device, dev);
> +	struct cdns_i2c *xi2c =3D platform_get_drvdata(pdev);
> +
> +	clk_disable(xi2c->clk);
> +	xi2c->suspended =3D 1;
> +
> +	return 0;
> +}
> +
> +/**
> + * cdns_i2c_resume - Resume from suspend
> + * @_dev:	Address of the platform_device structure
> + * Return: 0 on success and error value on error
> + *
> + * Resume operation after suspend.
> + */
> +static int cdns_i2c_resume(struct device *_dev)
> +{
> +	struct platform_device *pdev =3D container_of(_dev,
> +			struct platform_device, dev);
> +	struct cdns_i2c *xi2c =3D platform_get_drvdata(pdev);
> +	int ret;
> +
> +	ret =3D clk_enable(xi2c->clk);
> +	if (ret) {
> +		dev_err(_dev, "Cannot enable clock.\n");
> +		return ret;
> +	}
> +
> +	xi2c->suspended =3D 0;
> +
> +	return 0;
> +}
> +#endif

Can you also please remove this #ifdef and use __maybe_used
instead? Better not to have any ifdef in the code.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--qn36qP4Ku7kvU8CvM9e57OC4KN9mfnfOb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlM8+RQACgkQykllyylKDCFGfACcDpIaTcsNEdPAVeexueVbIETL
9aMAniZXMfogv5hPxAVeECbPO4VOvGSc
=kUdm
-----END PGP SIGNATURE-----

--qn36qP4Ku7kvU8CvM9e57OC4KN9mfnfOb--
