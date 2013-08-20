Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751315Ab3HTMyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 08:54:07 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:38120 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab3HTMyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 08:54:05 -0400
Message-ID: <521366EA.7080705@monstr.eu>
Date: Tue, 20 Aug 2013 14:54:02 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: James Walmsley <james@fullfat-fs.co.uk>, Chris Ball <cjb@laptop.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org
Subject: Re: SDHCI - Add QUIRK2_BROKEN_WRITE_PROTEXT - Support Xilinx Zynq
 (Linux 3.9.0)
References: <BEDA323D25EF6045A68DAB9FD91A0BF14A5E84DB@AMSPRD0411MB426.eurprd04.prod.outlook.com>
In-Reply-To: <BEDA323D25EF6045A68DAB9FD91A0BF14A5E84DB@AMSPRD0411MB426.eurprd04.prod.outlook.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="BFLC7o6olLGpGQ8su7TkXtE4bEjAuR1PH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--BFLC7o6olLGpGQ8su7TkXtE4bEjAuR1PH
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi James,

isn't it better to implement host->ops->get_ro() function for it?
It seems me better choice than introducing new quirk option.

Chris: What do you think?

Thanks,
Michal


On 08/16/2013 02:14 PM, James Walmsley wrote:
> Hi Michal,
>=20
> I have built a Xilinx Zynq based design which doesn't use the SDHCI Wri=
te-protect line.
> However, we use the MIO_0 pin for configuring a multiplexer and consequ=
ently the
> SDHCI driver thinks that the card is read-only (RO).
>=20
> In the patch below I have proposed a new quirk, similar to the QUIRK_BR=
OKEN_CARD_DETECTION
> flag, which causes the sdhci driver to assume a card with RW access.
>=20
> This patch was made against the latest tree from Xilinx (github.com/Xil=
inx/linux-xlnx), Kernel 3.9.0
> and I have attached it to the LKML to propose the additional quirk whic=
h may be useful on other platforms.
>=20
> Kind regards,
>=20
> James Walmsley
>=20
> ---
>  drivers/mmc/host/sdhci-of-xilinxps.c | 4 ++++
>  drivers/mmc/host/sdhci.c             | 4 ++++
>  include/linux/mmc/sdhci.h            | 1 +
>  3 files changed, 9 insertions(+)
>=20
> diff --git a/drivers/mmc/host/sdhci-of-xilinxps.c b/drivers/mmc/host/sd=
hci-of-xilinxps.c
> index f79e0db..5553bc0 100644
> --- a/drivers/mmc/host/sdhci-of-xilinxps.c
> +++ b/drivers/mmc/host/sdhci-of-xilinxps.c
> @@ -211,6 +211,10 @@ static int sdhci_zynq_probe(struct platform_device=
 *pdev)
>  	if (prop =3D=3D NULL || (!(u32) be32_to_cpup(prop)))
>  		host->quirks |=3D SDHCI_QUIRK_BROKEN_CARD_DETECTION;
> =20
> +	prop =3D of_get_property(np, "xlnx,has-wp", NULL);
> +	if (prop =3D=3D NULL || (!(u32) be32_to_cpup(prop)))
> +		host->quirks2 |=3D SDHCI_QUIRK2_BROKEN_WRITE_PROTECT;
> +
>  	return 0;
> =20
>  clk_notif_unreg:
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index 51bbba4..c40365f 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -1609,6 +1609,10 @@ static int sdhci_do_get_ro(struct sdhci_host *ho=
st)
>  {
>  	int i, ro_count;
> =20
> +	if(host->quirks2 & SDHCI_QUIRK2_BROKEN_WRITE_PROTECT) {
> +		return 0;	// Return zero to assume RW.
> +	}
> +
>  	if (!(host->quirks & SDHCI_QUIRK_UNSTABLE_RO_DETECT))
>  		return sdhci_check_ro(host);
> =20
> diff --git a/include/linux/mmc/sdhci.h b/include/linux/mmc/sdhci.h
> index b838ffc..3eccf12 100644
> --- a/include/linux/mmc/sdhci.h
> +++ b/include/linux/mmc/sdhci.h
> @@ -95,6 +95,7 @@ struct sdhci_host {
>  /* The system physically doesn't support 1.8v, even if the host does *=
/
>  #define SDHCI_QUIRK2_NO_1_8_V				(1<<2)
>  #define SDHCI_QUIRK2_PRESET_VALUE_BROKEN		(1<<3)
> +#define SDHCI_QUIRK2_BROKEN_WRITE_PROTECT		(1<<4)
> =20
>  	int irq;		/* Device IRQ */
>  	void __iomem *ioaddr;	/* Mapped address */
>=20


--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--BFLC7o6olLGpGQ8su7TkXtE4bEjAuR1PH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlITZuoACgkQykllyylKDCES0gCeOXltvLEO/yWTCQYUphIjSweX
SYYAoJEi4G8Kv24NIFSoE4lcvVb1DRhi
=IoS4
-----END PGP SIGNATURE-----

--BFLC7o6olLGpGQ8su7TkXtE4bEjAuR1PH--
