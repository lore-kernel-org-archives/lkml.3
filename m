Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204AbaG2Keu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 06:34:50 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:61717 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbaG2Kes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 06:34:48 -0400
Date: Tue, 29 Jul 2014 12:34:43 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: bhelgaas@google.com, swarren@wwwdotorg.org, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] PCI: tegra: add missing cleanup in error path and
 teardown_irq
Message-ID: <20140729103442.GE21182@ulmo.nvidia.com>
References: <1406597610-6748-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BZaMRJmqxGScZ8Mx"
Content-Disposition: inline
In-Reply-To: <1406597610-6748-1-git-send-email-jszhang@marvell.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BZaMRJmqxGScZ8Mx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 29, 2014 at 09:33:30AM +0800, Jisheng Zhang wrote:
> We should call tegra_msi_free() to free the MSI bit if
> irq_create_mapping() fails. And we need to dispose the IRQ mapping
> during IRQ teardown.
>=20
> Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> ---
>  drivers/pci/host/pci-tegra.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>=20
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

There seems to be an inconsistency regarding the data type of hwirq. The
irq_data structure uses unsigned long, but irqd_to_hwirq() function
returns irq_hw_number_t. Perhaps it would be best to use this instead:

	irq_hw_number_t hwirq =3D irqd_to_hwirq(d);

But I don't have a strong preference for either way, so with or without
that change:

Reviewed-by: Thierry Reding <treding@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>

--BZaMRJmqxGScZ8Mx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT13jCAAoJEN0jrNd/PrOh5rAP/3VrMEHtf6F2AdCx6bEL/rcU
3NgrrkSVv5V++AysHqU3N1KkS+drGl7PU6wJvNL4FPi4mUGuY8abUSrHWUMzzlod
FwEcIi3e6tO005j1r0yFJ2Wj95/nAW6N7urVuj8eb6dO3AJpQG8uep1Ncv4grfKq
ogiSRp1eFJ9eneWYA73bCYLPm4zM3YuXwPQ93ooTWNr0/C34BgZkHeSn9BacjQ/h
xTGwv0cGU49JK4+TnzAjIQjnPS2JUyoMIloz5EdVxft0ETg1iOKEII79LxJvwh0M
636ZPSZFzZCnV6SJ9m9+g0hdd4NxEH+kDr9fw9J4Ob05iV+++YSpkIiQ3hHf8/7y
dBSFAPS9B+lCxjHZ8fRiupN5Kzr9StXratFV2+WTiWRz97XA40FS0YCtJCxD2cF8
CGMWhIO/tApeh5hWhrIeAoi+L7betcBQrtaSdTvT8dUuPKEnChE6zSPwiKuMSNSG
V3sVvbsdAOqnGt4LtMSqfQAPT4c+kLFem04R07V/Sm5IrvelRveSH/1bdkCkckSW
CF2LUDX0SE/U0ZYBO5c5iibhwQzZVqufi1oaDzyqAsrSqxtsa+ReyOfbAHKqQgPc
LmRP8qvA7n9Fh8/np7vvhgU6GmqAT6UPJXHQSrSIvaGyhb2/9+olCeG3fSZkSbhI
8KmeeGZ397CEs4mgQKag
=59cK
-----END PGP SIGNATURE-----

--BZaMRJmqxGScZ8Mx--
