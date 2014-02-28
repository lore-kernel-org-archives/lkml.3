Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaB1KkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 05:40:10 -0500
Received: from top.free-electrons.com ([176.31.233.9]:50504 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751083AbaB1KkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 05:40:08 -0500
Date: Fri, 28 Feb 2014 11:36:14 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 4/5] DMA: sun6i: Add driver for the Allwinner A31 DMA
 controller
Message-ID: <20140228103614.GM607@lukather>
References: <1393258967-4843-1-git-send-email-maxime.ripard@free-electrons.com>
 <1393258967-4843-5-git-send-email-maxime.ripard@free-electrons.com>
 <1393327695.28803.25.camel@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BuBclajtnfx5hylj"
Content-Disposition: inline
In-Reply-To: <1393327695.28803.25.camel@smile.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BuBclajtnfx5hylj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andy,

On Tue, Feb 25, 2014 at 01:28:15PM +0200, Andy Shevchenko wrote:
> > +static irqreturn_t sun6i_dma_interrupt(int irq, void *dev_id)
> > +{
> > +	struct sun6i_dma_dev *sdev =3D (struct sun6i_dma_dev *)dev_id;
> > +	struct sun6i_vchan *vchan;
> > +	struct sun6i_pchan *pchan;
> > +	int i, j, ret =3D 0;
> > +	u32 status;
> > +
> > +	for (i =3D 0; i < 2; i++) {
> > +		status =3D readl(sdev->base + DMA_IRQ_STAT(i));
> > +		if (!status) {
> > +			ret |=3D IRQ_NONE;
>=20
> Maybe move this to definition block.
>=20
> > +			continue;
> > +		}
> > +
> > +		dev_dbg(sdev->slave.dev, "DMA irq status %s: 0x%x\n",
> > +			i ? "high" : "low", status);
> > +
> > +		writel(status, sdev->base + DMA_IRQ_STAT(i));
> > +
> > +		for (j =3D 0; (j < 8) && status; j++) {
> > +			if (status & DMA_IRQ_QUEUE) {
> > +				pchan =3D sdev->pchans + j;
> > +				vchan =3D pchan->vchan;
> > +
> > +				if (vchan) {
> > +					unsigned long flags;
> > +
> > +					spin_lock_irqsave(&vchan->vc.lock,
> > +							  flags);
> > +					vchan_cookie_complete(&pchan->desc->vd);
> > +					pchan->done =3D pchan->desc;
> > +					spin_unlock_irqrestore(&vchan->vc.lock,
> > +							       flags);
> > +				}
> > +			}
> > +
> > +			status =3D status >> 4;
> > +		}
> > +
> > +		ret |=3D IRQ_HANDLED;
>=20
> In case one is handled, another is not, what you have to do?

The interrupt status is split across two registers. In the case where
one of the two register reports an interrupt, we still have to handle
our interrupt, we actually did, so we have to return IRQ_HANDLED.

[ ... ]

> > +static int sun6i_dma_probe(struct platform_device *pdev)
> > +{
> > +	struct sun6i_dma_dev *sdc;
> > +	struct resource *res;
> > +	int irq;
> > +	int ret, i;
> > +
> > +	sdc =3D devm_kzalloc(&pdev->dev, sizeof(*sdc), GFP_KERNEL);
> > +	if (!sdc)
> > +		return -ENOMEM;
> > +
> > +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	sdc->base =3D devm_ioremap_resource(&pdev->dev, res);
> > +	if (IS_ERR(sdc->base))
> > +		return PTR_ERR(sdc->base);
> > +
> > +	irq =3D platform_get_irq(pdev, 0);
> > +	ret =3D devm_request_irq(&pdev->dev, irq, sun6i_dma_interrupt, 0,
> > +			       dev_name(&pdev->dev), sdc);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Cannot request IRQ\n");
> > +		return ret;
> > +	}
> > +
> > +	sdc->clk =3D devm_clk_get(&pdev->dev, NULL);
> > +	if (IS_ERR(sdc->clk)) {
> > +		dev_err(&pdev->dev, "No clock specified\n");
> > +		return PTR_ERR(sdc->clk);
> > +	}
> > +
> > +	sdc->rstc =3D devm_reset_control_get(&pdev->dev, NULL);
> > +	if (IS_ERR(sdc->rstc)) {
> > +		dev_err(&pdev->dev, "No reset controller specified\n");
> > +		return PTR_ERR(sdc->rstc);
> > +	}
> > +
> > +	sdc->pool =3D dma_pool_create(dev_name(&pdev->dev), &pdev->dev,
> > +					sizeof(struct sun6i_dma_lli), 4, 0);
>=20
> dmam_pool_create()

Aaah. I looked for a devm_dma_pool_create, but I missed this one.

>=20
> > +	if (!sdc->pool) {
> > +		dev_err(&pdev->dev, "No memory for descriptors dma pool\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	platform_set_drvdata(pdev, sdc);
> > +	INIT_LIST_HEAD(&sdc->pending);
> > +	spin_lock_init(&sdc->lock);
> > +
> > +	dma_cap_set(DMA_PRIVATE, sdc->slave.cap_mask);
> > +	dma_cap_set(DMA_MEMCPY, sdc->slave.cap_mask);
> > +	dma_cap_set(DMA_SLAVE, sdc->slave.cap_mask);
> > +
> > +	INIT_LIST_HEAD(&sdc->slave.channels);
> > +	sdc->slave.device_alloc_chan_resources	=3D sun6i_dma_alloc_chan_resou=
rces;
> > +	sdc->slave.device_free_chan_resources	=3D sun6i_dma_free_chan_resourc=
es;
> > +	sdc->slave.device_tx_status		=3D sun6i_dma_tx_status;
> > +	sdc->slave.device_issue_pending		=3D sun6i_dma_issue_pending;
> > +	sdc->slave.device_prep_slave_sg		=3D sun6i_dma_prep_slave_sg;
> > +	sdc->slave.device_prep_dma_memcpy	=3D sun6i_dma_prep_dma_memcpy;
> > +	sdc->slave.device_control		=3D sun6i_dma_control;
> > +	sdc->slave.chancnt			=3D NR_MAX_VCHANS;
> > +
> > +	sdc->slave.dev =3D &pdev->dev;
> > +
> > +	sdc->pchans =3D devm_kzalloc(&pdev->dev,
> > +				   NR_MAX_CHANNELS * sizeof(struct sun6i_pchan),
> > +				   GFP_KERNEL);
> > +	if (!sdc->pchans) {
> > +		ret =3D -ENOMEM;
> > +		goto err_dma_pool_destroy;
> > +	}
> > +
> > +	sdc->vchans =3D devm_kzalloc(&pdev->dev,
> > +				   NR_MAX_VCHANS * sizeof(struct sun6i_vchan),
> > +				   GFP_KERNEL);
> > +	if (!sdc->vchans) {
> > +		ret =3D -ENOMEM;
> > +		goto err_dma_pool_destroy;
> > +	}
> > +
> > +	tasklet_init(&sdc->task, sun6i_dma_tasklet, (unsigned long)sdc);
> > +
> > +	for (i =3D 0; i < NR_MAX_CHANNELS; i++) {
> > +		struct sun6i_pchan *pchan =3D &sdc->pchans[i];
> > +
> > +		pchan->idx =3D i;
> > +		pchan->base =3D sdc->base + 0x100 + i * 0x40;
> > +	}
> > +
> > +	for (i =3D 0; i < NR_MAX_VCHANS; i++) {
> > +		struct sun6i_vchan *vchan =3D &sdc->vchans[i];
> > +
> > +		INIT_LIST_HEAD(&vchan->node);
> > +		vchan->vc.desc_free =3D sun6i_dma_free_desc;
> > +		vchan_init(&vchan->vc, &sdc->slave);
> > +	}
> > +
> > +	reset_control_deassert(sdc->rstc);
> > +
> > +	clk_prepare_enable(sdc->clk);
>=20
> Would you like to check an return code here?

Yep, right.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--BuBclajtnfx5hylj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTEGaeAAoJEBx+YmzsjxAgnVUQAIe0scCUfqrOv4fLnPB3lMuH
E+SI3TN9V/zCvoFVR5M3Q5vQAgnp2Z11kCNtocpYCn58OHw3JrQk65qkTeL3okkM
nvMLXzWUSV227NJeKpZawoWlMIQK5LzIaITGavT+zG564LkywGf+5zppj4xJ3OUX
CN0YeIo984OBdnd96toRTDGIg5xupQQ32F5NCUmuWlMmxxkBItQgpHK1ZNql5STF
fxodN0tFlIlgJR+yFYMagOLS2hJCjj7iOJC4x3wiiWk1cRm/p61nX68GDsPXr4VH
3HemyZTjtCglCuzZgiN3w5KQ0eoU0QnMb3y7s1YvmmO+fhQkx11PbVGRlqXIhuS2
j4bBf0wenIXYaA/kQcH3PkPlr2H5OiwlKET6lMCiEn4vYNbtKs+szZ9nePWJ/eN4
PghlHJDD48BWxmn8gFyCvk5gN6/iao5qLqQNvSQfu/vWrFFapSXiRxEV5Stmjtxc
S+ItOnNA8dZjm93fAVs6flYuYT/QlcpPkVma0Iitsad1Sp5j2jFcf3cNNtMdp9XO
C2gqFI24IURRpBniot6YoQVMofk34HoC/74IqONlCsoyn7iuoir71pATcF4hMct7
IPP8jnett3PZtfDZj0rzmCSJHOHYx71QpL82rH+2KAcGY9dZrHgVRXvHiN/D9YkT
ai5k03gLAahIibHeOjqC
=kX7D
-----END PGP SIGNATURE-----

--BuBclajtnfx5hylj--
