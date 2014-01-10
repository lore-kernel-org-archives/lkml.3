Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbaAJNom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 08:44:42 -0500
Received: from ring0.de ([91.143.88.219]:45169 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbaAJNog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 08:44:36 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Fri, 10 Jan 2014 14:44:26 +0100
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
Message-ID: <20140110134426.GA7235@earth.universe>
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
 <20140103013640.GB27678@earth.universe>
 <20140109233843.GB19974@amd.pavel.ucw.cz>
 <20140110003231.GA14141@earth.universe>
 <20140110121805.GA21117@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <20140110121805.GA21117@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pavel,

You have missed some things. See inline comments below.

On Fri, Jan 10, 2014 at 01:18:05PM +0100, Pavel Machek wrote:
> diff --git a/drivers/bluetooth/nokia_core.c b/drivers/bluetooth/nokia_cor=
e.c
> index 5c7acad..d6b0701 100644
> --- a/drivers/bluetooth/nokia_core.c
> v+++ b/drivers/bluetooth/nokia_core.c
> @@ -39,6 +39,7 @@
>  #include <linux/gpio.h>
>  #include <linux/timer.h>
>  #include <linux/kthread.h>
> +#include <linux/io.h>
> =20
>  #include <net/bluetooth/bluetooth.h>
>  #include <net/bluetooth/hci_core.h>
> @@ -1079,7 +1080,7 @@ static int hci_h4p_probe(struct platform_device *pd=
ev)
>  	int err;
> =20
>  	dev_info(&pdev->dev, "Registering HCI H4P device\n");
> -	info =3D kzalloc(sizeof(struct hci_h4p_info), GFP_KERNEL);
> +	info =3D devm_kzalloc(&pdev->dev, sizeof(struct hci_h4p_info), GFP_KERN=
EL);
>  	if (!info)
>  		return -ENOMEM;
> =20
> @@ -1092,7 +1093,6 @@ static int hci_h4p_probe(struct platform_device *pd=
ev)
> =20
>  	if (pdev->dev.platform_data =3D=3D NULL) {
>  		dev_err(&pdev->dev, "Could not get Bluetooth config data\n");
> -		kfree(info);
>  		return -ENODATA;
>  	}
> =20
> @@ -1113,67 +1113,59 @@ static int hci_h4p_probe(struct platform_device *=
pdev)
>  	complete_all(&info->test_completion);
> =20
>  	if (!info->reset_gpio_shared) {
> -		err =3D gpio_request(info->reset_gpio, "bt_reset");
> +		err =3D devm_gpio_request_one(&pdev->dev, info->reset_gpio,
> +					    GPIOF_OUT_INIT_LOW, "bt_reset");
>  		if (err < 0) {
>  			dev_err(&pdev->dev, "Cannot get GPIO line %d\n",
>  				info->reset_gpio);
> -			goto cleanup_setup;
> +			return err;
>  		}
>  	}
> =20
> -	err =3D gpio_request(info->bt_wakeup_gpio, "bt_wakeup");
> +	err =3D devm_gpio_request_one(&pdev->dev, info->bt_wakeup_gpio,
> +				    GPIOF_OUT_INIT_LOW, "bt_wakeup");
> +
>  	if (err < 0) {
>  		dev_err(info->dev, "Cannot get GPIO line 0x%d",
>  			info->bt_wakeup_gpio);
> -		if (!info->reset_gpio_shared)
> -			gpio_free(info->reset_gpio);
> -		goto cleanup_setup;
> +		return err;
>  	}
> =20
> -	err =3D gpio_request(info->host_wakeup_gpio, "host_wakeup");
> +	err =3D devm_gpio_request_one(&pdev->dev, info->host_wakeup_gpio,
> +				    GPIOF_DIR_IN, "host_wakeup");
>  	if (err < 0) {
>  		dev_err(info->dev, "Cannot get GPIO line %d",
>  		       info->host_wakeup_gpio);
> -		if (!info->reset_gpio_shared)
> -			gpio_free(info->reset_gpio);
> -		gpio_free(info->bt_wakeup_gpio);
> -		goto cleanup_setup;
> +		return err;
>  	}
> =20
> -	gpio_direction_output(info->reset_gpio, 0);
> -	gpio_direction_output(info->bt_wakeup_gpio, 0);
> -	gpio_direction_input(info->host_wakeup_gpio);
> -
>  	info->irq =3D bt_plat_data->uart_irq;
> -	info->uart_base =3D ioremap(bt_plat_data->uart_base, SZ_2K);
> -	info->uart_iclk =3D clk_get(NULL, bt_plat_data->uart_iclk);
> -	info->uart_fclk =3D clk_get(NULL, bt_plat_data->uart_fclk);
> +	info->uart_base =3D devm_ioremap(&pdev->dev, bt_plat_data->uart_base, S=
Z_2K);
> +	info->uart_iclk =3D devm_clk_get(&pdev->dev, bt_plat_data->uart_iclk);
> +	info->uart_fclk =3D devm_clk_get(&pdev->dev, bt_plat_data->uart_fclk);
> =20
>  	err =3D request_irq(info->irq, hci_h4p_interrupt, IRQF_DISABLED, "hci_h=
4p",
>  			  info);

This one should also use devm_request_irq(). Especially since you
removed the cleanup in the probe function already ;)

>  	if (err < 0) {
>  		dev_err(info->dev, "hci_h4p: unable to get IRQ %d\n", info->irq);
> -		goto cleanup;
> +		return err;
>  	}
> =20
> -	err =3D request_irq(gpio_to_irq(info->host_wakeup_gpio),
> +	err =3D devm_request_irq(&pdev->dev, gpio_to_irq(info->host_wakeup_gpio=
),
>  			  hci_h4p_wakeup_interrupt,  IRQF_TRIGGER_FALLING |
>  			  IRQF_TRIGGER_RISING | IRQF_DISABLED,
>  			  "hci_h4p_wkup", info);
>  	if (err < 0) {
>  		dev_err(info->dev, "hci_h4p: unable to get wakeup IRQ %d\n",
>  			  gpio_to_irq(info->host_wakeup_gpio));
> -		free_irq(info->irq, info);
> -		goto cleanup;
> +		return err;
>  	}
> =20
>  	err =3D irq_set_irq_wake(gpio_to_irq(info->host_wakeup_gpio), 1);
>  	if (err < 0) {
>  		dev_err(info->dev, "hci_h4p: unable to set wakeup for IRQ %d\n",
>  				gpio_to_irq(info->host_wakeup_gpio));
> -		free_irq(info->irq, info);
> -		free_irq(gpio_to_irq(info->host_wakeup_gpio), info);
> -		goto cleanup;
> +		return err;
>  	}
> =20
>  	init_timer_deferrable(&info->lazy_release);
> @@ -1182,7 +1174,7 @@ static int hci_h4p_probe(struct platform_device *pd=
ev)
>  	hci_h4p_set_clk(info, &info->tx_clocks_en, 1);
>  	err =3D hci_h4p_reset_uart(info);
>  	if (err < 0)
> -		goto cleanup_irq;
> +		return err;
>  	gpio_set_value(info->reset_gpio, 0);
>  	hci_h4p_set_clk(info, &info->tx_clocks_en, 0);
> =20
> @@ -1190,23 +1182,10 @@ static int hci_h4p_probe(struct platform_device *=
pdev)
> =20
>  	if (hci_h4p_register_hdev(info) < 0) {
>  		dev_err(info->dev, "failed to register hci_h4p hci device\n");
> -		goto cleanup_irq;
> +		return -EINVAL;
>  	}
> =20
>  	return 0;
> -
> -cleanup_irq:
> -	free_irq(info->irq, (void *)info);
> -	free_irq(gpio_to_irq(info->host_wakeup_gpio), info);
> -cleanup:
> -	gpio_set_value(info->reset_gpio, 0);
> -	if (!info->reset_gpio_shared)
> -		gpio_free(info->reset_gpio);
> -	gpio_free(info->bt_wakeup_gpio);
> -	gpio_free(info->host_wakeup_gpio);
> -cleanup_setup:
> -	kfree(info);
> -	return err;
>  }
> =20
>  static int hci_h4p_remove(struct platform_device *pdev)
> @@ -1217,15 +1196,11 @@ static int hci_h4p_remove(struct platform_device =
*pdev)
> =20
>  	hci_h4p_sysfs_remove_files(info->dev);
>  	hci_h4p_hci_close(info->hdev);
> -	free_irq(gpio_to_irq(info->host_wakeup_gpio), info);
>  	hci_unregister_dev(info->hdev);
>  	hci_free_dev(info->hdev);
> -	if (!info->reset_gpio_shared)
> -		gpio_free(info->reset_gpio);
>  	gpio_free(info->bt_wakeup_gpio);
>  	gpio_free(info->host_wakeup_gpio);

those two gpios are also managed. No need to free them manually.

>  	free_irq(info->irq, (void *) info);

Once this irq is also requested using managed resources you can also
drop this line.

> -	kfree(info);
> =20
>  	return 0;
>  }
> [...]

-- Sebastian

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSz/k6AAoJENju1/PIO/qac6gP/2zP9u9pnyA7tKmQrTBgH7EE
KFj6Z1c9fs7AoS72I5F9ZyBndwO9F4meP8XMEPOuJBVW94uZo+8d74u8ZQTSz4Ih
+eVSwW9G4DyIE/Ht4uhmMD4rH6s1k33iKPTUcMwRZ2dtTkuDELJt3HLtleu3gj4l
jGtCpzaEAx9no40LT9s8qzHYlXgPKzcbRFhDcQLBrRZOsxrD6IiMSVnXhzLPunQ7
TIV7gTy1rioveI4VDIo1DeGs3xQrcyZ6ePAIblmmJPoYBQgMgyLYqpxQWs4HytIe
SCf33pyYVAZGBTszHRpMuIJYKhmzOYBAdZLoD8L77eFeCaC831sh0xOZB8z8gEoF
JWqp36nf5JFHFQgb8HGbqf8iElaSSRLciiEHzC1FGN5Dw9max/jKqDIdx2zQqKVc
+uKXbfH6wA6NANiyze2lvu+cEDhmrIE+CFbxKd0tqgEm0/PLfg/wZteCmJMJ4Sfg
AoStCuaIwSJCSM0fYeDYgg1cuok9MNCm54oWaQUBN1R5uQcu7nSX9cjrZMiLGVx1
oyJvrrHTbz3NF6fWB/DJJwv9ZydmzoaxMWlb3LTxuX0P+1jn32d4bCBMPDfLizFc
grGHsyvK4x3FCCvJ2ca4dcMmuIXYdqY20g7crJ6OA7Z3j40UYSIgDAvQu8ZnLOan
cfh73uCx0Mhigq2HBH4/
=0LTS
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
