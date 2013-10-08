Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756290Ab3JHQM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 12:12:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42145 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab3JHQMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 12:12:23 -0400
Date: Tue, 8 Oct 2013 11:11:41 -0500
From: Felipe Balbi <balbi@ti.com>
To: Andreas Fenkart <afenkart@gmail.com>
CC: Chris Ball <cjb@laptop.org>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>, Felipe Balbi <balbi@ti.com>,
        Balaji T K <balajitk@ti.com>, <zonque@gmail.com>,
        <devicetree-discuss@lists.ozlabs.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-mmc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v3 2/4] mmc: omap_hsmmc: Enable SDIO IRQ.
Message-ID: <20131008161131.GD13128@radagast>
Reply-To: <balbi@ti.com>
References: <1380971830-21492-1-git-send-email-afenkart@gmail.com>
 <1380971830-21492-3-git-send-email-afenkart@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gDGSpKKIBgtShtf+"
Content-Disposition: inline
In-Reply-To: <1380971830-21492-3-git-send-email-afenkart@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--gDGSpKKIBgtShtf+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Oct 05, 2013 at 01:17:08PM +0200, Andreas Fenkart wrote:
> For now, only support SDIO interrupt if we are booted with
> DT. This is because some platforms need special quirks. And
> we don't want to add new legacy mux platform init code
> callbacks any longer as we are moving to DT based booting
> anyways.
>=20
> Broken hardware, missing the swakueup line, should fallback
> to polling, by setting 'ti,quirk-swakup-missing' in the
> device tree. Otherwise pending SDIO IRQ are not detected
> while in suspend. This affects am33xx processors.
>=20
> Signed-off-by: Andreas Fenkart <afenkart@gmail.com>

I still think this patch needs to be splitted, see below.

> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index 94d6dc8..53beac4 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -130,6 +130,7 @@ static void apply_clk_hack(struct device *dev)
>  #define TC_EN			(1 << 1)
>  #define BWR_EN			(1 << 4)
>  #define BRR_EN			(1 << 5)
> +#define CIRQ_EN			(1 << 8)
>  #define ERR_EN			(1 << 15)
>  #define CTO_EN			(1 << 16)
>  #define CCRC_EN			(1 << 17)
> @@ -210,6 +211,10 @@ struct omap_hsmmc_host {
>  	int			reqs_blocked;
>  	int			use_reg;
>  	int			req_in_progress;
> +	int                     flags;
> +#define HSMMC_RUNTIME_SUSPENDED	(1 << 0)        /* Runtime suspended */
> +#define HSMMC_SDIO_IRQ_ENABLED	(1 << 1)        /* SDIO irq enabled */
> +
>  	struct omap_hsmmc_next	next_data;
>  	struct	omap_mmc_platform_data	*pdata;
>  };
> @@ -490,27 +495,40 @@ static void omap_hsmmc_stop_clock(struct omap_hsmmc=
_host *host)
>  static void omap_hsmmc_enable_irq(struct omap_hsmmc_host *host,
>  				  struct mmc_command *cmd)
>  {
> -	unsigned int irq_mask;
> +	u32 irq_mask =3D INT_EN_MASK;
> +	unsigned long flags;
> =20
>  	if (host->use_dma)
> -		irq_mask =3D INT_EN_MASK & ~(BRR_EN | BWR_EN);
> -	else
> -		irq_mask =3D INT_EN_MASK;
> +		irq_mask &=3D ~(BRR_EN | BWR_EN);

is this a bugfix ? should it be sent as a separate patch ?

> =20
>  	/* Disable timeout for erases */
>  	if (cmd->opcode =3D=3D MMC_ERASE)
>  		irq_mask &=3D ~DTO_EN;
> =20
> +	spin_lock_irqsave(&host->irq_lock, flags);

why do you need this new locking here ? register acesses are atomic,
right ? If you really do need the locking, should it be a separate patch
as well ?

>  	OMAP_HSMMC_WRITE(host->base, STAT, STAT_CLEAR);
>  	OMAP_HSMMC_WRITE(host->base, ISE, irq_mask);
> +
> +	/* latch pending CIRQ, but don't signal */
> +	if (host->flags & HSMMC_SDIO_IRQ_ENABLED)
> +		irq_mask |=3D CIRQ_EN;

why do you need this ? Looks like it should be yet another patch.
> =20
>  static void omap_hsmmc_disable_irq(struct omap_hsmmc_host *host)
>  {
> -	OMAP_HSMMC_WRITE(host->base, ISE, 0);
> -	OMAP_HSMMC_WRITE(host->base, IE, 0);
> +	u32 irq_mask =3D 0;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&host->irq_lock, flags);
> +	/* no transfer running, need to signal cirq if */

if... ?

> +	if (host->flags & HSMMC_SDIO_IRQ_ENABLED)
> +		irq_mask |=3D CIRQ_EN;
> +	OMAP_HSMMC_WRITE(host->base, ISE, irq_mask);

the whole fiddling with STAT and ISE registers look very bogus to me
(even on current state before this patch). We shouldn't be clearing
pending IRQ events here, right ? We could miss IRQs due to that.

> @@ -1067,8 +1085,12 @@ static irqreturn_t omap_hsmmc_irq(int irq, void *d=
ev_id)
>  	int status;
> =20
>  	status =3D OMAP_HSMMC_READ(host->base, STAT);
> -	while (status & INT_EN_MASK && host->req_in_progress) {
> -		omap_hsmmc_do_irq(host, status);
> +	while (status & (INT_EN_MASK | CIRQ_EN)) {

why don't enable CIRQ_EN in INT_EN_MASK directly ?

> +		if (host->req_in_progress)
> +			omap_hsmmc_do_irq(host, status);
> +
> +		if (status & CIRQ_EN)
> +			mmc_signal_sdio_irq(host->mmc);
> =20
>  		/* Flush posted write */
>  		status =3D OMAP_HSMMC_READ(host->base, STAT);
> @@ -1583,6 +1605,42 @@ static void omap_hsmmc_init_card(struct mmc_host *=
mmc, struct mmc_card *card)
>  		mmc_slot(host).init_card(card);
>  }
> =20
> +static void omap_hsmmc_enable_sdio_irq(struct mmc_host *mmc, int enable)
> +{
> +	struct omap_hsmmc_host *host =3D mmc_priv(mmc);
> +	u32 irq_mask;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&host->irq_lock, flags);
> +
> +	if (enable)
> +		host->flags |=3D HSMMC_SDIO_IRQ_ENABLED;
> +	else
> +		host->flags &=3D ~HSMMC_SDIO_IRQ_ENABLED;
> +
> +	/* if statement here with followup patch */
> +	{
> +		irq_mask =3D OMAP_HSMMC_READ(host->base, ISE);
> +		if (enable)
> +			irq_mask |=3D CIRQ_EN;
> +		else
> +			irq_mask &=3D ~CIRQ_EN;

perhaps combine this branch with previous one ?

> +		OMAP_HSMMC_WRITE(host->base, IE, irq_mask);
> +
> +		/*
> +		 * if enable, piggy back on current request
> +		 * but always disable
> +		 */
> +		if (!host->req_in_progress || !enable)
> +			OMAP_HSMMC_WRITE(host->base, ISE, irq_mask);
> +
> +		/* flush posted write */
> +		OMAP_HSMMC_READ(host->base, IE);
> +	}
> +
> +	spin_unlock_irqrestore(&host->irq_lock, flags);
> +}
> +
>  static void omap_hsmmc_conf_bus_power(struct omap_hsmmc_host *host)
>  {
>  	u32 hctl, capa, value;
> @@ -1635,7 +1693,7 @@ static const struct mmc_host_ops omap_hsmmc_ops =3D=
 {
>  	.get_cd =3D omap_hsmmc_get_cd,
>  	.get_ro =3D omap_hsmmc_get_ro,
>  	.init_card =3D omap_hsmmc_init_card,
> -	/* NYET -- enable_sdio_irq */
> +	.enable_sdio_irq =3D omap_hsmmc_enable_sdio_irq,
>  };
> =20
>  #ifdef CONFIG_DEBUG_FS
> @@ -1833,6 +1891,7 @@ static int omap_hsmmc_probe(struct platform_device =
*pdev)
>  	host->dma_ch	=3D -1;
>  	host->irq	=3D irq;
>  	host->slot_id	=3D 0;
> +	host->flags	=3D 0;

why do you need to zero-initialize flags here ? another bug ?

> @@ -2023,6 +2082,22 @@ static int omap_hsmmc_probe(struct platform_device=
 *pdev)
>  		dev_warn(&pdev->dev,
>  			"pins are not configured from the driver\n");
> =20
> +	/*
> +	 * For now, only support SDIO interrupt if we are booted with
> +	 * DT. This is because some platforms need special quirks. And
> +	 * we don't want to add new legacy mux platform init code
> +	 * callbacks any longer as we are moving to DT based booting
> +	 * anyways.
> +	 */
> +	if (match) {

isn't if (dev->of.node) a better check here ?

> +		mmc->caps |=3D MMC_CAP_SDIO_IRQ;
> +		if (of_find_property(host->dev->of_node,
> +				     "ti,quirk-swakeup-missing", NULL)) {

looks like a SW configuration to me. Can't you figure this out by
reading the revision register ?

--=20
balbi

--gDGSpKKIBgtShtf+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSVC69AAoJEIaOsuA1yqRE41UQAKZeGqXWVCE6w/jXxSOie7Ao
72qctozT7OgyGC6b7BbhYDR1VVBj/c3HYQ3o8iVDvUi/QCMHHGrif4m7QBWOxjcv
EyydPwHg1IVywuIkzQGsOeMxiNM6+ZhWpFqpOIt0+ZpH+hx5VSzz+KiArC3ubIrS
DsV+pFDe3AlZcuku16tCb9IOsTwsJdUoAZ87IFHpBygnGt6X3BXL4Y8c+TkR+xiX
2L/DAWlSVCnqtnNl7LinfO+jFkGULQqo02NdL6DitH7kfKFx2OzSUWmnasR1OSC3
a6qVyR9zYOQzHR2fUidGRJ6fEZMdgwGEkEsjqtIld0p4bm7G+FeOwwJVH5C3rvQG
kKsTulA5It9aZ+lDTpsQRyHGDohUbx5vpV346VD7DINaa1nOrZ59qzqrvnsfm5VL
KEczzktTWURP8tcuQjAQ7cJ+sVaL4Nj/+Le8zxtVwM5TIazyRR/GgoC1owYwFVqT
KPDcZJxh7ZVJSgwWctPAGStF4eFzb7ujoHXFG6USpOfD6C6Z2T/PgTiKh8UViwZj
KlrvBtPipyY17tIrWdMfGwvUjFJKSTUWbMvfUuSDBVsO1MemiwXrd9J+2G5tsOfS
v3J7Ije4isS8rJZSWisOOJbbJYjUIOxtk6l7j0rQXff9BoTckWsHHZ4cz2cKZlZl
exDJXTDStQjo8AEHpsQA
=VwqB
-----END PGP SIGNATURE-----

--gDGSpKKIBgtShtf+--
