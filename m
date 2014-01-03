Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbaACBgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 20:36:39 -0500
Received: from ring0.de ([91.143.88.219]:35912 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbaACBgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 20:36:37 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Fri, 3 Jan 2014 02:36:41 +0100
From: Sebastian Reichel <sre@ring0.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>,
        Ville Tervo <ville.tervo@nokia.com>
Subject: Re: [PATCH v4] Bluetooth: Add hci_h4p driver
Message-ID: <20140103013640.GB27678@earth.universe>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	Marcel Holtmann <marcel@holtmann.org>,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	=?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= <freemangordon@abv.bg>,
	"Gustavo F. Padovan" <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"linux-bluetooth@vger.kernel.org development" <linux-bluetooth@vger.kernel.org>,
	Ville Tervo <ville.tervo@nokia.com>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com>
 <1727897.LBX8128hIo@izba>
 <20140102161824.GA8204@amd.pavel.ucw.cz>
 <A5B72277-42D4-4A24-8A29-9BE18762E8C4@holtmann.org>
 <20140103001753.GA21023@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="pvezYHf7grwyp3Bc"
Content-Disposition: inline
In-Reply-To: <20140103001753.GA21023@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pvezYHf7grwyp3Bc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pavel,

Here are some cleanup suggestions for probe, removal & module
initialization functions.

On Fri, Jan 03, 2014 at 01:17:54AM +0100, Pavel Machek wrote:
> +static int hci_h4p_probe(struct platform_device *pdev)
> +{
> +	struct hci_h4p_platform_data *bt_plat_data;
> +	struct hci_h4p_info *info;
> +	int err;
> +
> +	dev_info(&pdev->dev, "Registering HCI H4P device\n");
> +	info =3D kzalloc(sizeof(struct hci_h4p_info), GFP_KERNEL);

info =3D devm_kzalloc(&pdev->dev, sizeof(struct hci_h4p_info), GFP_KERNEL);

> +	if (!info)
> +		return -ENOMEM;
> +
> +	info->dev =3D &pdev->dev;
> +	info->tx_enabled =3D 1;
> +	info->rx_enabled =3D 1;
> +	spin_lock_init(&info->lock);
> +	spin_lock_init(&info->clocks_lock);
> +	skb_queue_head_init(&info->txq);
> +
> +	if (pdev->dev.platform_data =3D=3D NULL) {
> +		dev_err(&pdev->dev, "Could not get Bluetooth config data\n");
> +		kfree(info);
> +		return -ENODATA;
> +	}
> +
> +	bt_plat_data =3D pdev->dev.platform_data;
> +	info->chip_type =3D bt_plat_data->chip_type;
> +	info->bt_wakeup_gpio =3D bt_plat_data->bt_wakeup_gpio;
> +	info->host_wakeup_gpio =3D bt_plat_data->host_wakeup_gpio;
> +	info->reset_gpio =3D bt_plat_data->reset_gpio;
> +	info->reset_gpio_shared =3D bt_plat_data->reset_gpio_shared;
> +	info->bt_sysclk =3D bt_plat_data->bt_sysclk;
> +
> +	BT_DBG("RESET gpio: %d\n", info->reset_gpio);
> +	BT_DBG("BTWU gpio: %d\n", info->bt_wakeup_gpio);
> +	BT_DBG("HOSTWU gpio: %d\n", info->host_wakeup_gpio);
> +	BT_DBG("sysclk: %d\n", info->bt_sysclk);
> +
> +	init_completion(&info->test_completion);
> +	complete_all(&info->test_completion);
> +
> +	if (!info->reset_gpio_shared) {
> +		err =3D gpio_request(info->reset_gpio, "bt_reset");

err =3D devm_gpio_request_one(&pdev->dev, info->reset_gpio, GPIOF_OUT_INIT_=
LOW, "bt_reset");

> +		if (err < 0) {
> +			dev_err(&pdev->dev, "Cannot get GPIO line %d\n",
> +				info->reset_gpio);
> +			goto cleanup_setup;
> +		}
> +	}
> +
> +	err =3D gpio_request(info->bt_wakeup_gpio, "bt_wakeup");

err =3D devm_gpio_request_one(&pdev->dev, info->bt_wakeup_gpio, GPIOF_OUT_I=
NIT_LOW, "bt_wakeup");

> +	if (err < 0) {
> +		dev_err(info->dev, "Cannot get GPIO line 0x%d",
> +			info->bt_wakeup_gpio);
> +		if (!info->reset_gpio_shared)
> +			gpio_free(info->reset_gpio);
> +		goto cleanup_setup;
> +	}
> +
> +	err =3D gpio_request(info->host_wakeup_gpio, "host_wakeup");

err =3D devm_gpio_request_one(&pdev->dev, info->host_wakeup_gpio, GPIOF_DIR=
_IN, "host_wakeup");

> +	if (err < 0) {
> +		dev_err(info->dev, "Cannot get GPIO line %d",
> +		       info->host_wakeup_gpio);
> +		if (!info->reset_gpio_shared)
> +			gpio_free(info->reset_gpio);
> +		gpio_free(info->bt_wakeup_gpio);
> +		goto cleanup_setup;
> +	}
> +
> +	gpio_direction_output(info->reset_gpio, 0);
> +	gpio_direction_output(info->bt_wakeup_gpio, 0);
> +	gpio_direction_input(info->host_wakeup_gpio);

You can remove these when you use the _request_one gpio_request
methods.

> +	info->irq =3D bt_plat_data->uart_irq;
> +	info->uart_base =3D ioremap(bt_plat_data->uart_base, SZ_2K);

info->uart_base =3D devm_ioremap(&pdev->dev, bt_plat_data->uart_base, SZ_2K=
);

> +	info->uart_iclk =3D clk_get(NULL, bt_plat_data->uart_iclk);
> +	info->uart_fclk =3D clk_get(NULL, bt_plat_data->uart_fclk);

devm_clk_get(...)

> +	err =3D request_irq(info->irq, hci_h4p_interrupt, IRQF_DISABLED, "hci_h=
4p",
> +			  info);

devm_request_irq(...)

> +	if (err < 0) {
> +		dev_err(info->dev, "hci_h4p: unable to get IRQ %d\n", info->irq);
> +		goto cleanup;
> +	}
> +
> +	err =3D request_irq(gpio_to_irq(info->host_wakeup_gpio),
> +			  hci_h4p_wakeup_interrupt,  IRQF_TRIGGER_FALLING |
> +			  IRQF_TRIGGER_RISING | IRQF_DISABLED,
> +			  "hci_h4p_wkup", info);

devm_request_irq(...)

> +	if (err < 0) {
> +		dev_err(info->dev, "hci_h4p: unable to get wakeup IRQ %d\n",
> +			  gpio_to_irq(info->host_wakeup_gpio));
> +		free_irq(info->irq, info);
> +		goto cleanup;
> +	}
> +
> +	err =3D irq_set_irq_wake(gpio_to_irq(info->host_wakeup_gpio), 1);
> +	if (err < 0) {
> +		dev_err(info->dev, "hci_h4p: unable to set wakeup for IRQ %d\n",
> +				gpio_to_irq(info->host_wakeup_gpio));
> +		free_irq(info->irq, info);
> +		free_irq(gpio_to_irq(info->host_wakeup_gpio), info);
> +		goto cleanup;
> +	}
> +
> +	init_timer_deferrable(&info->lazy_release);
> +	info->lazy_release.function =3D hci_h4p_lazy_clock_release;
> +	info->lazy_release.data =3D (unsigned long)info;
> +	hci_h4p_set_clk(info, &info->tx_clocks_en, 1);
> +	err =3D hci_h4p_reset_uart(info);
> +	if (err < 0)
> +		goto cleanup_irq;
> +	gpio_set_value(info->reset_gpio, 0);
> +	hci_h4p_set_clk(info, &info->tx_clocks_en, 0);
> +
> +	platform_set_drvdata(pdev, info);
> +
> +	if (hci_h4p_register_hdev(info) < 0) {
> +		dev_err(info->dev, "failed to register hci_h4p hci device\n");
> +		goto cleanup_irq;
> +	}
> +
> +	return 0;
> +
> +cleanup_irq:
> +	free_irq(info->irq, (void *)info);
> +	free_irq(gpio_to_irq(info->host_wakeup_gpio), info);
> +cleanup:
> +	gpio_set_value(info->reset_gpio, 0);
> +	if (!info->reset_gpio_shared)
> +		gpio_free(info->reset_gpio);
> +	gpio_free(info->bt_wakeup_gpio);
> +	gpio_free(info->host_wakeup_gpio);
> +cleanup_setup:
> +	kfree(info);
> +	return err;
> +}

This can be removed after the conversion to devm_ methods.

> [...]
>=20
> +static int __init hci_h4p_init(void)
> +{
> +	int err =3D 0;
> +
> +	/* Register the driver with LDM */
> +	err =3D platform_driver_register(&hci_h4p_driver);
> +	if (err < 0)
> +		printk(KERN_WARNING "failed to register hci_h4p driver\n");
> +
> +	return err;
> +}
> +
> +static void __exit hci_h4p_exit(void)
> +{
> +	platform_driver_unregister(&hci_h4p_driver);
> +}
>=20
> +module_init(hci_h4p_init);
> +module_exit(hci_h4p_exit);

module_platform_driver(hci_h4p_driver);

-- Sebastian

--pvezYHf7grwyp3Bc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSxhQoAAoJENju1/PIO/qaV/AQAJCevchzqkz1yigFIM2uePdf
rKr7BG17Z78yUAKhnZdFlckvZFfvXvc0eAqrtYHAeX9m/LfjHo87+/4yVDmEs7fb
HwgEV8HM3YLBkrHK9jTpWKe9EUWsSsDnR9HDaQ07qb4BbIn/L9oEUfjjl368KR4K
o6sViT74bVT5noOdS6sr9cxmT5EwDy6htnuFt6VJuLVnZi1iL9B7YPH6ePKHfgCO
4rP6tJNyz7qB9530ouUrXMk/wE6y0d6PslfYiz8I1GV5Gg9RpTXSihsYok53v2SZ
JaW1syuY6yjM1FG6EyinzkcdWoy32dOAPBDWkQPFUOPtWjAr+K29SP8fNKDsbxWY
044PHwn5VxOtD0Ff76btO3jthRO5pfuVLNwFU6mn1f/1+e8XYtM7hpKK5Tp/fw8F
4I+Nukq3WLP+TSy8i/gE8Im+wA8Gr0le0FnFvbWPBxkspyux2mRyLNq4Rw+HWVcM
9KI59Db6mxm18mmpWUt2clDezWKbZWBq5RHdjjMp7nFmSgmDV6tGxy0qgwIrzqEH
mExsbFNAiE4s/M8KKIgsVrgTikcMimaULIthFmTXKY8eZy3cMJXNDYfgPpsQOVWE
qXEXnKvTrAj4Wg2lMYL87YEIINiHxWNMyUSG9I+CUAAtiO7H5wxWaZ93kSMgny+N
VFd5YHHbsLPyEZ78wrkJ
=ssFt
-----END PGP SIGNATURE-----

--pvezYHf7grwyp3Bc--
