Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbaDAAub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 20:50:31 -0400
Received: from sauhun.de ([89.238.76.85]:46013 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751277AbaDAAu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 20:50:26 -0400
Date: Tue, 1 Apr 2014 02:50:01 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Mike Looijmans <mike.looijmans@topic.nl>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-i2c@vger.kernel.org,
        Harini Katakam <harinik@xilinx.com>
Subject: Re: [PATCH v3 1/2] i2c: Add driver for Cadence I2C controller
Message-ID: <20140401005001.GA3590@katana>
References: <1394556613-11692-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <1394556613-11692-1-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 11, 2014 at 09:50:12AM -0700, Soren Brinkmann wrote:
> Add a driver for the Cadence I2C controller. This controller is for
> example found in Xilinx Zynq.
>=20
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

=2E..

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

Use '-=3D'

=2E..

> +static int cdns_i2c_process_msg(struct cdns_i2c *id, struct i2c_msg *msg,
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

reinit_completion. And add init_completion in probe.

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

Just return -EAGAIN here...

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

=2E.. and you can skip this block since the core will do the retries.

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
> + * Return: number of msgs processed on success, negative error otherwise
> + *
> + * This function waits for the bus idle condition and updates the timeou=
t if
> + * modified by user. Then initiates the send/recv activity based on the
> + * transfer message received.
> + */
> +static int cdns_i2c_master_xfer(struct i2c_adapter *adap, struct i2c_msg=
 *msgs,
> +				int num)
> +{
> +	struct cdns_i2c *id =3D adap->algo_data;
> +	unsigned long timeout;
> +	int ret, count;
> +	u32 reg;
> +
> +	/* Waiting for bus-ready. If bus not ready, it returns after timeout */
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

Please replace this magic hex value with something readable.

> +			cdns_i2c_master_reset(adap);
> +			return -EIO;
> +		}
> +	}
> +
> +	return num;
> +}
> +

=2E..

> +/**
> + * cdns_i2c_probe - Platform registration call
> + * @pdev:	Handle to the platform device structure
> + *
> + * Return: 0 on success, negative error otherwise
> + *
> + * This function does all the memory allocation and registration for the=
 i2c
> + * device. User can modify the address mode to 10 bit address mode using=
 the
> + * ioctl call with option I2C_TENBIT.
> + */
> +static int cdns_i2c_probe(struct platform_device *pdev)
> +{
> +	struct resource *r_mem;
> +	struct cdns_i2c *id;
> +	int ret;
> +
> +	id =3D devm_kzalloc(&pdev->dev, sizeof(*id), GFP_KERNEL);
> +	if (!id)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, id);
> +
> +	r_mem =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	id->membase =3D devm_ioremap_resource(&pdev->dev, r_mem);
> +	if (IS_ERR(id->membase))
> +		return PTR_ERR(id->membase);
> +
> +	id->irq =3D platform_get_irq(pdev, 0);
> +
> +	id->adap.nr =3D pdev->id;

Drop this line and use i2c_add_adapter() later to let the core handle
the numbering. This will also take aliases into account.

> +	id->adap.dev.of_node =3D pdev->dev.of_node;
> +	id->adap.algo =3D &cdns_i2c_algo;
> +	id->adap.timeout =3D 0x1F;	/* Default timeout value */

This value is in jiffies, so you probably want to use msecs_to_jiffies
or alike.

> +	id->adap.retries =3D 3;		/* Default retry value. */
> +	id->adap.algo_data =3D id;
> +	id->adap.dev.parent =3D &pdev->dev;
> +	snprintf(id->adap.name, sizeof(id->adap.name),
> +		 "Cadence I2C at %08lx", (unsigned long)r_mem->start);
> +
> +	id->cur_timeout =3D id->adap.timeout;
> +	id->clk =3D devm_clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(id->clk)) {
> +		dev_err(&pdev->dev, "input clock not found.\n");
> +		return PTR_ERR(id->clk);
> +	}
> +	ret =3D clk_prepare_enable(id->clk);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Unable to enable clock.\n");
> +		return ret;
> +	}
> +	id->clk_rate_change_nb.notifier_call =3D cdns_i2c_clk_notifier_cb;
> +	if (clk_notifier_register(id->clk, &id->clk_rate_change_nb))
> +		dev_warn(&pdev->dev, "Unable to register clock notifier.\n");
> +	id->input_clk =3D clk_get_rate(id->clk);
> +
> +	ret =3D of_property_read_u32(pdev->dev.of_node, "clock-frequency",
> +			&id->i2c_clk);
> +	if (ret || (id->i2c_clk > CDNS_I2C_SPEED_MAX))
> +		id->i2c_clk =3D CDNS_I2C_SPEED_MAX;
> +
> +	cdns_i2c_writereg(0xE, CDNS_I2C_CR_OFFSET);

Remove magic value. Please check the driver for more, in case I missed
some.

> +	cdns_i2c_writereg(id->adap.timeout, CDNS_I2C_TIME_OUT_OFFSET);
> +
> +	ret =3D cdns_i2c_setclk(id->input_clk, id);
> +	if (ret) {
> +		dev_err(&pdev->dev, "invalid SCL clock: %u Hz\n", id->i2c_clk);
> +		ret =3D -EINVAL;
> +		goto err_clk_dis;
> +	}
> +
> +	ret =3D devm_request_irq(&pdev->dev, id->irq, cdns_i2c_isr, 0,
> +				 DRIVER_NAME, id);
> +	if (ret) {
> +		dev_err(&pdev->dev, "cannot get irq %d\n", id->irq);
> +		goto err_clk_dis;
> +	}
> +
> +	ret =3D i2c_add_numbered_adapter(&id->adap);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "reg adap failed: %d\n", ret);
> +		goto err_clk_dis;
> +	}
> +
> +	dev_info(&pdev->dev, "%u kHz mmio %08lx irq %d\n",
> +		 id->i2c_clk / 1000, (unsigned long)r_mem->start, id->irq);
> +
> +	return 0;
> +
> +err_clk_dis:
> +	clk_disable_unprepare(id->clk);
> +	return ret;
> +}
> +

Thanks,

   Wolfram


--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTOg05AAoJEBQN5MwUoCm2zioQAIvtsNrDx1F7Vrug+iZmtoac
dOTo2QsG2dh5BcrqS+ggtrTnq5a8mh1yIbDRYgyB4sWbCSIE7J0RG94+ae4JUoIo
7Cpfhq2nb2cS54OCLyCOUl0FOIHUOn3/8Bk83f7CI9BmPIybLCzRe6aL/uAj4q9D
R65ZFBF+8SYxUpPpNbjuUVVyAJgJUFA1fbnbWRyDijV4W6w1YmifX6Ka16OK3f3F
oZH33a8pQI4u3cN8CGWTD0qN7+VJjqTIwj2s2Vrp9nFeQuZhnKOJNnECltoTDUnE
a7J2WHJ2xGwJkulBe4F3Zkx6YFwIcSuOtfLR8bCfZgelvZ89XMEo8Ao4v4A4pXDk
wrN45D9JqpGRR7LUMBSi9CmWBaf+EHAN1gmgVo6TXgvvUbuXcv3z1xsTNaKiIVa9
bx09wOgiNbSoAjI9EnHSAeaxOrbnvRckMZLWIkuzjMzlNZeIW+qRggfFSw6AgmMM
pd4NqWALhG5wGw0q4Ie9kwSq2apCHwAIPELsgrlDnKULmR4kS+v1AS2Kp9vcTeBY
GZhb60uty7eEHhA+hPnkB+e230wRatjjFmwQLT6Y8qGQ75LT46nrSomYKA/I5Kbi
E6RidI87TTnEsZRGc/YqLv5UyajwCpsCWw+UK53zIiSmkNJnXkagg2ye6ZVu5JUI
GUoPsp60j8zpdZvt2OiW
=nP/8
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
