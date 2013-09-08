Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab3IHREK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 13:04:10 -0400
Received: from sauhun.de ([89.238.76.85]:49489 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831Ab3IHREI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 13:04:08 -0400
Date: Sun, 8 Sep 2013 19:03:56 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, w.sang@pengutronix.de,
        t.figa@samsung.com, ben-linux@fluff.org, grant.likely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, sjg@chromium.org,
        naveenkrishna.ch@gmail.com, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH] i2c: exynos5: add High Speed I2C controller driver
Message-ID: <20130908170355.GA3154@katana>
References: <1354021236-28596-2-git-send-email-ch.naveen@samsung.com>
 <1377077077-20896-1-git-send-email-ch.naveen@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
In-Reply-To: <1377077077-20896-1-git-send-email-ch.naveen@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


On Wed, Aug 21, 2013 at 02:54:37PM +0530, Naveen Krishna Ch wrote:
> Adds support for High Speed I2C driver found in Exynos5 and
> later SoCs from Samsung.
>=20
> Highspeed mode is a minor change in the i2c protocol.
> Starts with
> 1. start condition,
> 2. 8-bit master ID code (00001xxx)
> 3. followed by a NACK bit
> Once the above conditions are met, the bus is now operates in highspeed m=
ode.
> The rest of the I2C protocol applies the same.

The description is correct, but it is not a change in the protocol. This
is fully specified in the I2C specs.

> Driver only supports Device Tree method.
>=20
> Changes since v1:
> 1. Added FIFO functionality
> 2. Added High speed mode functionality
> 3. Remove SMBUS_QUICK
> 4. Remove the debugfs functionality
> 5. Use devm_* functions where ever possible
> 6. Driver is free from GPIO configs
> 7. Use OF data string "clock-frequency" to get the bus operating frequenc=
ies
> 8. Split the clock divisor calculation function
> 9. Add resets for the failed transacton cases
> 10. Removed retries as core does retries if -EAGAIN is returned
> 11. Removed mode from device tree info (use speed to distinguish
>     the mode of operation)
> 12. Use wait_for_completion_timeout as the interruptible case is not test=
ed well
> 13. few other bug fixes and cosmetic changes
> 14. Removed the untested runtime_pm code
> 15. Removed the retries as core does that
> 16. Use adap.nr instead of alias
> 17. Added spinlocks around the irq code
> 18. Use i2c_add_numbered_adapter() instead of using aliases

Changes since v1 are irrelevant for the patch description.

>=20
> Signed-off-by: Taekgyun Ko <taeggyun.ko@samsung.com>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Reviewed-by: Simon Glass <sjg@google.com>
> Tested-by: Andrew Bresticker <abrestic@google.com>
> Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
> Signed-off-by: Andrew Bresticker <abrestic@google.com>
>=20
> ---
> Wolfram and Thomas Figa thanks for reviewing the code.
>=20
> Changes since v10:
> 1. Remove the incomplete runtime_pm code
> 2. Correct the error checks as suggested by Thomas
> 3. Use i2c_add_numbered_adapter() as suggested
> 4. Modified the irq routine to handle the specific interrupts
> 5. Added spinlocks around the irq code
> 6. Remove the "mode" of operation field from device tree node and use the
>    clock-frequency to decide the mode.
>=20
>  .../devicetree/bindings/i2c/i2c-exynos5.txt        |   44 ++
>  drivers/i2c/busses/Kconfig                         |    7 +
>  drivers/i2c/busses/Makefile                        |    1 +
>  drivers/i2c/busses/i2c-exynos5.c                   |  799 ++++++++++++++=
++++++
>  4 files changed, 851 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
>  create mode 100644 drivers/i2c/busses/i2c-exynos5.c
>=20
> diff --git a/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt b/Docu=
mentation/devicetree/bindings/i2c/i2c-exynos5.txt
> new file mode 100644
> index 0000000..805e018
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
> @@ -0,0 +1,44 @@
> +* Samsung's High Speed I2C controller
> +
> +The Samsung's High Speed I2C controller is used to interface with I2C de=
vices
> +at various speeds ranging from 100khz to 3.4Mhz.
> +
> +Required properties:
> +  - compatible: value should be.
> +      -> "samsung,exynos5-hsi2c", for i2c compatible with exynos5 hsi2c.
> +  - reg: physical base address of the controller and length of memory ma=
pped
> +    region.
> +  - interrupts: interrupt number to the cpu.
> +  - #address-cells: always 1 (for i2c addresses)
> +  - #size-cells: always 0
> +
> +  - Pinctrl:
> +    - pinctrl-0: Pin control group to be used for this controller.
> +    - pinctrl-names: Should contain only one value - "default".
> +
> +Optional properties:
> +  - clock-frequency: Desired operating frequency in Hz of the bus.
> +    -> If not specified, the default value is 100khz in fast-speed mode =
and
> +       1Mhz in high-speed mode.

Description doesn't match the current code.

> +    -> If specified, The bus operates in high-speed mode only if the
> +       clock-frequency is >=3D 1Mhz.

s/The/the/

=2E..

> +/*
> + * exynos5_i2c_init: configures the controller for I2C functionality
> + * Programs I2C controller for Master mode operation
> + */
> +static void exynos5_i2c_init(struct exynos5_i2c *i2c)
> +{
> +	u32 i2c_conf =3D readl(i2c->regs + HSI2C_CONF);
> +	u32 i2c_timeout =3D readl(i2c->regs + HSI2C_TIMEOUT);
> +
> +	/* Disable timeout */
> +	i2c_timeout &=3D ~HSI2C_TIMEOUT_EN;
> +	writel(i2c_timeout, i2c->regs + HSI2C_TIMEOUT);

Just curious: Can't you use HSI2C_TIMEOUT and wait_for_completion
instead of wait_for_completion_timeout? If so, it might save you a
little bit of overhead.

> +
> +	writel((HSI2C_FUNC_MODE_I2C | HSI2C_MASTER),
> +					i2c->regs + HSI2C_CTL);
> +	writel(HSI2C_TRAILING_COUNT, i2c->regs + HSI2C_TRAILIG_CTL);
> +
> +	if (i2c->speed_mode =3D=3D HSI2C_HIGH_SPD) {
> +		writel(HSI2C_MASTER_ID(MASTER_ID(i2c->adap.nr)),
> +					i2c->regs + HSI2C_ADDR);
> +		i2c_conf |=3D HSI2C_HS_MODE;
> +	}
> +
> +	writel(i2c_conf | HSI2C_AUTO_MODE, i2c->regs + HSI2C_CONF);
> +}
> +
> +
> +	if ((i2c->msg->flags & I2C_M_RD) && (int_status &
> +			(HSI2C_INT_TRAILING | HSI2C_INT_RX_ALMOSTFULL))) {
> +		fifo_status =3D readl(i2c->regs + HSI2C_FIFO_STATUS);
> +		fifo_level =3D HSI2C_RX_FIFO_LVL(fifo_status);
> +		len =3D min(fifo_level, i2c->msg->len - i2c->msg_ptr);
> +
> +		while (len > 0) {
> +			byte =3D (unsigned char)
> +				readl(i2c->regs + HSI2C_RX_DATA);
> +			i2c->msg->buf[i2c->msg_ptr++] =3D byte;
> +			len--;
> +		}

With all this copying going on, this should be threaded irq probably.

> +		i2c->state =3D 0;
> +	} else if (int_status & HSI2C_INT_TX_ALMOSTEMPTY) {
> +		fifo_status =3D readl(i2c->regs + HSI2C_FIFO_STATUS);
> +		fifo_level =3D HSI2C_TX_FIFO_LVL(fifo_status);
> +
> +		len =3D HSI2C_FIFO_MAX - fifo_level;
> +		if (len > (i2c->msg->len - i2c->msg_ptr))
> +			len =3D i2c->msg->len - i2c->msg_ptr;
> +
> +		while (len > 0) {
> +			byte =3D i2c->msg->buf[i2c->msg_ptr++];
> +			writel(byte, i2c->regs + HSI2C_TX_DATA);
> +			len--;
> +		}
> +		i2c->state =3D 0;
> +	}
> +
> + stop:
> +	if ((i2c->msg_ptr =3D=3D i2c->msg->len) || (i2c->state < 0)) {
> +		writel(0, i2c->regs + HSI2C_INT_ENABLE);
> +		exynos5_i2c_clr_pend_irq(i2c);
> +		complete(&i2c->msg_complete);
> +	} else {
> +		exynos5_i2c_clr_pend_irq(i2c);
> +	}
> +
> +	spin_unlock_irqrestore(&i2c->lock, flags);
> +
> +	return IRQ_HANDLED;
> +}
> +

=2E..

> +static int exynos5_i2c_xfer_msg(struct exynos5_i2c *i2c,
> +			      struct i2c_msg *msgs, int stop)
> +{
> +	unsigned long timeout;
> +	int ret;
> +
> +	INIT_COMPLETION(i2c->msg_complete);
> +
> +	spin_lock_irq(&i2c->lock);
> +	i2c->msg =3D msgs;
> +	i2c->msg_ptr =3D 0;
> +	i2c->trans_done =3D 0;
> +
> +	exynos5_i2c_message_start(i2c, stop);
> +
> +	spin_unlock_irq(&i2c->lock);
> +	timeout =3D wait_for_completion_timeout(&i2c->msg_complete,
> +					      EXYNOS5_I2C_TIMEOUT);
> +	if (timeout =3D=3D 0)
> +		ret =3D -ETIMEDOUT;
> +	else
> +		ret =3D i2c->state;
> +
> +	if (ret < 0) {
> +		exynos5_i2c_reset(i2c);

Do you really need to reset the core after a failed transaction?

> +		if (ret =3D=3D -ETIMEDOUT) {
> +			dev_warn(i2c->dev, "%s timeout\n",
> +				 (msgs->flags & I2C_M_RD) ? "rx" : "tx");
> +			return ret;
> +		} else if (ret =3D=3D -EAGAIN) {
> +			return ret;
> +		}
> +	}
> +
> +	/*
> +	 * If this is the last message to be transfered (stop =3D=3D 1)
> +	 * Then check if the bus can be brought back to idle.
> +	 *
> +	 * Return -EBUSY if the bus still busy.
> +	 */
> +	if (exynos5_i2c_wait_bus_idle(i2c, stop))
> +		return -EBUSY;

Why do you need this after the transaction?

> +
> +	/* Return the state as in interrupt routine */
> +	return ret;
> +}
> +
> +static int exynos5_i2c_xfer(struct i2c_adapter *adap,
> +			struct i2c_msg *msgs, int num)
> +{
> +	struct exynos5_i2c *i2c =3D (struct exynos5_i2c *)adap->algo_data;
> +	int i =3D 0, ret =3D 0, stop =3D 0;
> +
> +	if (i2c->suspended) {
> +		dev_err(i2c->dev, "HS-I2C is not initialzed.\n");
> +		return -EIO;
> +	}
> +
> +	clk_prepare_enable(i2c->clk);
> +
> +	for (i =3D 0; i < num; i++) {
> +		stop =3D (i =3D=3D num - 1);
> +
> +		if (msgs->len =3D=3D 0) {

Did you need that? It shouldn't happen since you are not advertising
SMBUS_QUICK.

> +			msgs++;
> +			continue;
> +		}
> +
> +		ret =3D exynos5_i2c_xfer_msg(i2c, msgs, stop);
> +		if (!stop)
> +			msgs++;

Probably better put in the for-body (i.e. i++, msgs++).

> +
> +		if (ret < 0)
> +			goto out;
> +	}
> +
> +	if (i =3D=3D num) {
> +		ret =3D num;
> +	} else {
> +		/* Only one message, cannot access the device */
> +		if (i =3D=3D 1)
> +			ret =3D -EREMOTEIO;
> +		else
> +			ret =3D i;
> +
> +		dev_warn(i2c->dev, "xfer message failed\n");
> +	}
> +
> + out:
> +	clk_disable_unprepare(i2c->clk);
> +	return ret;
> +}
> +
> +static u32 exynos5_i2c_func(struct i2c_adapter *adap)
> +{
> +	return I2C_FUNC_I2C | (I2C_FUNC_SMBUS_EMUL & ~I2C_FUNC_SMBUS_QUICK);
> +}
> +
> +static const struct i2c_algorithm exynos5_i2c_algorithm =3D {
> +	.master_xfer		=3D exynos5_i2c_xfer,
> +	.functionality		=3D exynos5_i2c_func,
> +};
> +
> +static int exynos5_i2c_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np =3D pdev->dev.of_node;
> +	struct exynos5_i2c *i2c;
> +	struct resource *mem;
> +	unsigned int op_clock;
> +	int ret;
> +
> +	if (!np) {
> +		dev_err(&pdev->dev, "no device node\n");
> +		return -ENOENT;
> +	}

How should this happen?

> +
> +	i2c =3D devm_kzalloc(&pdev->dev, sizeof(struct exynos5_i2c), GFP_KERNEL=
);
> +	if (!i2c) {
> +		dev_err(&pdev->dev, "no memory for state\n");
> +		return -ENOMEM;
> +	}
> +

=2E..

> +	i2c->adap.nr =3D -1;
> +	ret =3D i2c_add_numbered_adapter(&i2c->adap);

Just use i2c_add_adapter and skip setting nr to -1.

=2E..

> +static const struct dev_pm_ops exynos5_i2c_dev_pm_ops =3D {
> +	.suspend_noirq =3D exynos5_i2c_suspend_noirq,
> +	.resume_noirq	=3D exynos5_i2c_resume_noirq,
> +};
> +
> +#define EXYNOS5_DEV_PM_OPS (&exynos5_i2c_dev_pm_ops)
> +#else
> +#define EXYNOS5_DEV_PM_OPS NULL
> +#endif

Isn't there a macro for this? SIMPLE_DEV_PM_OPS*? Not sure, I always mix
them up...

Regards,

   Wolfram


--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSLK37AAoJEBQN5MwUoCm2DwYQAKTpBWt/A3gu6tRYjE/0p5FJ
MGJzMVqfuAwmcLMXx4cnYRpjffXls5Txd11ZiSbZQmshbFVMijnXTywHTq6lfDNY
gnY0r1KKFiw+Pl8k/kdyzDY5jt1ERAN0M6n6zEG4zqmigSWxAWEBtiwbcJLc9N45
zFWU7FzX9Kz8Z9jzkAuNE6dKUN3QZnm0+xuwQAhCDZ+/wQ5nV9e2BRq3aC95uL4s
n2yoMfpAWVptdyCa1qTgCkrpOIcyU67UvB7bncmNyTMAEBzF2XpXNFyy+e9LYcso
9QCCiWvTSLvPGtdHY+9GhFJ5WViGCZbOlaZxEhOb4QLniOuU2GVrdc5rRvIrq+uO
RNqSiMrY8nTSC+vGqD6bsRK5dImnZb9blqCmlnKw5y/2F4ntluBccvFb7x6h71SP
doXYzej2D9yIn7a0gFKfLYrM0WxtGBUX+WrxF5wJ96Y42xEIaFzjpc9GU5ud6i39
EehAwlvJfqHaIwXfwJ/As0ZW+mvUA2s/Qw/T0LF24BOrVlkrk2cPz4fX9F3YScxa
KPLqFQQIHpmRjjtgYTFnZhIC/k+1iisjE39LFuliI6WOM/7aSg3TROqatWCLHlLi
jpfCZVPeo8LoWE+yRUAY7nNSwna09Iu0Zk9GD9KxiZ96xP92maPs2ePNlXUec8t0
aPmavOpQhL85SgGRC7Fx
=FVcj
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
