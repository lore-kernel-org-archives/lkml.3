Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbaG1Pf6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:35:58 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:63202 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbaG1Pfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:35:55 -0400
Date: Mon, 28 Jul 2014 17:35:50 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: bhelgaas@google.com, swarren@wwwdotorg.org, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] PCI: tegra: add missing cleanup in error path and
 teardown_irq
Message-ID: <20140728153548.GB10126@ulmo.nvidia.com>
References: <1406519142-3018-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Yylu36WmvOXNoKYn"
Content-Disposition: inline
In-Reply-To: <1406519142-3018-1-git-send-email-jszhang@marvell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Yylu36WmvOXNoKYn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2014 at 11:45:42AM +0800, Jisheng Zhang wrote:
> We should call tegra_msi_free() to free the msi bit if
> irq_create_mapping() fails. And we need to dispose the irq mapping
> during irq teardown.

"MSI" and "IRQ" please.

> diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c
> index 083cf37..4ccc418 100644
> --- a/drivers/pci/host/pci-tegra.c
> +++ b/drivers/pci/host/pci-tegra.c
> @@ -1203,8 +1203,10 @@ static int tegra_msi_setup_irq(struct msi_chip *ch=
ip, struct pci_dev *pdev,
>  		return hwirq;
> =20
>  	irq =3D irq_create_mapping(msi->domain, hwirq);
> -	if (!irq)
> +	if (!irq) {
> +		tegra_msi_free(msi, hwirq);
>  		return -EINVAL;
> +	}
> =20
>  	irq_set_msi_desc(irq, desc);
> =20
> @@ -1222,8 +1224,10 @@ static void tegra_msi_teardown_irq(struct msi_chip=
 *chip, unsigned int irq)
>  {
>  	struct tegra_msi *msi =3D to_tegra_msi(chip);
>  	struct irq_data *d =3D irq_get_irq_data(irq);
> +	unsigned long hwirq =3D d->hwirq;

I don't think we need this temporary variable, d->hwirq isn't overly
long.

With both of the above address, this is:

Reviewed-by: Thierry Reding <treding@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>

--Yylu36WmvOXNoKYn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT1m3UAAoJEN0jrNd/PrOhZasQALoR5knIFNMBrM3nd3VDbiBM
whzllsWhurlCryKp0VmgKc6+K6gYhMBIlBjMAcFB19bqEiANnmfHibB6xOSiqPeA
UkmCrj7OYHLIkNlL2OHBtusqbkLkQJHzsspif7sGJn8OB68PaSn/FT3V3mtB7q9O
zUQTZP4NQ+6IwFGpf3+BBAjdht5yDv79QiYClSedfEIlX4GNEw8x0uH74lW+f80d
nO1CDNrHqPLUxjBxoWe5G0gTaNX71xILbJVTLg/536/9SOIQb40GhsrKluJBWleQ
SM35SSiV3Khd+3WTSBe8gEwjJnr4p68WI25KQx2koS6SrwlLJYZms6hqm/wKxbIK
uBhT13zAZ4QFf4BiAQzF5Lfhlupuq+QA/vk7YvYzv8sFta3sgby52xjk9o7lJfJy
kwnP8JsYOlw1fUIOOGmlZlKPOoDpI7NKwkpMoZlGMTUAIbrt39bSvfKIZJMlnx+I
PaYChbeOXQmM/mF6+5u5lIFyyieRK/Iks52UbiClUrvI7Lv5xKzz/uoNPZyQdhea
AYMel5Y56FV/ZV1V67BQ9eA/noAUUICgGiRtLukzPhhUeplOp0fglnUwg+S2M7Em
DOqdwLCl/58PqDNLqMA8tQ6YDGKI8Nz5DOfbAqQhsUKHF36YRROemYSuLpgp+zSo
QJHcvlT+y5+O8/AaBQ+Z
=cEjM
-----END PGP SIGNATURE-----

--Yylu36WmvOXNoKYn--
