Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbaIHIGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 04:06:34 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:27564
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753026AbaIHIGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 04:06:31 -0400
Date: Mon, 8 Sep 2014 10:06:19 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, <dmaengine@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [RFC PATCH] dma: pl330: add Power Management support
References: <1409929562-29583-1-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1409929562-29583-1-git-send-email-k.kozlowski@samsung.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="wlnQAQITbQqCA8v4WJirsLXuH630HeqtD"
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-20934.003
X-TM-AS-Result: No--9.381-7.0-31-1
X-imss-scan-details: No--9.381-7.0-31-1
Message-ID: <8b73ba80-c055-42c3-a784-96e120482319@BN1BFFO11FD058.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(51704005)(479174003)(377454003)(199003)(164054003)(189002)(24454002)(77982001)(31696002)(87936001)(83506001)(92566001)(92726001)(107046002)(81342001)(106466001)(71186001)(70736001)(76176999)(54356999)(512944002)(86362001)(104016003)(90102001)(33646002)(85306004)(102836001)(64126003)(65956001)(80022001)(65806001)(31966008)(83322001)(19580405001)(44976005)(74502001)(19580395003)(84326002)(4396001)(81542001)(50986999)(99396002)(95666004)(74316001)(1496007)(20776003)(46102001)(6806004)(74662001)(21056001)(568964001)(76482001)(83072002)(85852003)(79102001)(2201001)(107986001)(2101003);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB017;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03283976A6
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--wlnQAQITbQqCA8v4WJirsLXuH630HeqtD
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/05/2014 05:06 PM, Krzysztof Kozlowski wrote:
> This patch adds both normal PM suspend/resume support and runtime PM
> support to pl330 DMA engine driver.
>=20
> The runtime power management for pl330 DMA driver allows gating of AMBA=

> clock (PDMA) in FSYS clock domain, when the device is not processing an=
y
> requests. This is necessary to enter W-AFTR low power mode on Exynos325=
0.
>=20
> The patch is based on previous work of Bartlomiej Zolnierkiewicz
> <b.zolnierkie@samsung.com>.
>=20
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/dma/pl330.c | 78 +++++++++++++++++++++++++++++++++++++++++++++=
+++++---
>  1 file changed, 74 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> index 66e89f04504c..bdc6ff8ee2bf 100644
> --- a/drivers/dma/pl330.c
> +++ b/drivers/dma/pl330.c
> @@ -27,6 +27,7 @@
>  #include <linux/of.h>
>  #include <linux/of_dma.h>
>  #include <linux/err.h>
> +#include <linux/pm_runtime.h>
> =20
>  #include "dmaengine.h"
>  #define PL330_MAX_CHAN		8
> @@ -1966,6 +1967,7 @@ static void pl330_tasklet(unsigned long data)
>  	struct dma_pl330_chan *pch =3D (struct dma_pl330_chan *)data;
>  	struct dma_pl330_desc *desc, *_dt;
>  	unsigned long flags;
> +	bool power_down =3D false;
> =20
>  	spin_lock_irqsave(&pch->lock, flags);
> =20
> @@ -1980,10 +1982,17 @@ static void pl330_tasklet(unsigned long data)
>  	/* Try to submit a req imm. next to the last completed cookie */
>  	fill_queue(pch);
> =20
> -	/* Make sure the PL330 Channel thread is active */
> -	spin_lock(&pch->thread->dmac->lock);
> -	_start(pch->thread);
> -	spin_unlock(&pch->thread->dmac->lock);
> +	if (list_empty(&pch->work_list)) {
> +		spin_lock(&pch->thread->dmac->lock);
> +		_stop(pch->thread);
> +		spin_unlock(&pch->thread->dmac->lock);
> +		power_down =3D true;
> +	} else {
> +		/* Make sure the PL330 Channel thread is active */
> +		spin_lock(&pch->thread->dmac->lock);
> +		_start(pch->thread);
> +		spin_unlock(&pch->thread->dmac->lock);
> +	}
> =20
>  	while (!list_empty(&pch->completed_list)) {
>  		dma_async_tx_callback callback;
> @@ -1998,6 +2007,12 @@ static void pl330_tasklet(unsigned long data)
>  		if (pch->cyclic) {
>  			desc->status =3D PREP;
>  			list_move_tail(&desc->node, &pch->work_list);
> +			if (power_down) {
> +				spin_lock(&pch->thread->dmac->lock);
> +				_start(pch->thread);
> +				spin_unlock(&pch->thread->dmac->lock);
> +				power_down =3D false;
> +			}
>  		} else {
>  			desc->status =3D FREE;
>  			list_move_tail(&desc->node, &pch->dmac->desc_pool);
> @@ -2012,6 +2027,10 @@ static void pl330_tasklet(unsigned long data)
>  		}
>  	}
>  	spin_unlock_irqrestore(&pch->lock, flags);
> +
> +	/* If work list empty, power down */
> +	if (power_down)
> +		pm_runtime_put(pch->dmac->ddma.dev);
>  }
> =20
>  bool pl330_filter(struct dma_chan *chan, void *param)
> @@ -2077,10 +2096,12 @@ static int pl330_control(struct dma_chan *chan,=
 enum dma_ctrl_cmd cmd, unsigned
>  	unsigned long flags;
>  	struct pl330_dmac *pl330 =3D pch->dmac;
>  	struct dma_slave_config *slave_config;
> +	bool power_down =3D false;
>  	LIST_HEAD(list);
> =20
>  	switch (cmd) {
>  	case DMA_TERMINATE_ALL:
> +		pm_runtime_get_sync(pl330->ddma.dev);
>  		spin_lock_irqsave(&pch->lock, flags);
> =20
>  		spin_lock(&pl330->lock);
> @@ -2107,10 +2128,18 @@ static int pl330_control(struct dma_chan *chan,=
 enum dma_ctrl_cmd cmd, unsigned
>  			dma_cookie_complete(&desc->txd);
>  		}
> =20
> +		if (!list_empty(&pch->work_list))
> +			power_down =3D true;
> +
>  		list_splice_tail_init(&pch->submitted_list, &pl330->desc_pool);
>  		list_splice_tail_init(&pch->work_list, &pl330->desc_pool);
>  		list_splice_tail_init(&pch->completed_list, &pl330->desc_pool);
>  		spin_unlock_irqrestore(&pch->lock, flags);
> +		pm_runtime_put(pl330->ddma.dev);
> +
> +		/* If work list empty, power down */
> +		if (power_down)
> +			pm_runtime_put(pl330->ddma.dev);
>  		break;
>  	case DMA_SLAVE_CONFIG:
>  		slave_config =3D (struct dma_slave_config *)arg;
> @@ -2146,6 +2175,7 @@ static void pl330_free_chan_resources(struct dma_=
chan *chan)
> =20
>  	tasklet_kill(&pch->task);
> =20
> +	pm_runtime_get_sync(pch->dmac->ddma.dev);
>  	spin_lock_irqsave(&pch->lock, flags);
> =20
>  	pl330_release_channel(pch->thread);
> @@ -2155,6 +2185,7 @@ static void pl330_free_chan_resources(struct dma_=
chan *chan)
>  		list_splice_tail_init(&pch->work_list, &pch->dmac->desc_pool);
> =20
>  	spin_unlock_irqrestore(&pch->lock, flags);
> +	pm_runtime_put(pch->dmac->ddma.dev);
>  }
> =20
>  static enum dma_status
> @@ -2168,11 +2199,23 @@ static void pl330_issue_pending(struct dma_chan=
 *chan)
>  {
>  	struct dma_pl330_chan *pch =3D to_pchan(chan);
>  	unsigned long flags;
> +	bool power_up;
> =20
>  	spin_lock_irqsave(&pch->lock, flags);
> +	power_up =3D list_empty(&pch->work_list);
>  	list_splice_tail_init(&pch->submitted_list, &pch->work_list);
>  	spin_unlock_irqrestore(&pch->lock, flags);
> =20
> +	if (power_up) {
> +		/*
> +		 * Warn on nothing pending. This may break our pm_runtime
> +		 * usage counter as it is updated on work_list emptiness
> +		 * status.
> +		 */
> +		WARN_ON(list_empty(&pch->work_list));
> +		pm_runtime_get_sync(pch->dmac->ddma.dev);
> +	}
> +
>  	pl330_tasklet((unsigned long)pch);
>  }
> =20
> @@ -2205,6 +2248,7 @@ static dma_cookie_t pl330_tx_submit(struct dma_as=
ync_tx_descriptor *tx)
> =20
>  	cookie =3D dma_cookie_assign(&last->txd);
>  	list_add_tail(&last->node, &pch->submitted_list);
> +

unrelated change.

>  	spin_unlock_irqrestore(&pch->lock, flags);
> =20
>  	return cookie;
> @@ -2593,6 +2637,28 @@ static int pl330_dma_device_slave_caps(struct dm=
a_chan *dchan,
>  	return 0;
>  }
> =20
> +#ifdef CONFIG_PM_SLEEP

remove this line

> +static int pl330_suspend(struct device *dev)

__maybe_unused here

> +{
> +	struct amba_device *pcdev =3D to_amba_device(dev);
> +
> +	if (!pm_runtime_suspended(dev))
> +		amba_pclk_disable(pcdev);
> +	return 0;
> +}
> +
> +static int pl330_resume(struct device *dev)

__maybe_unused here

> +{
> +	struct amba_device *pcdev =3D to_amba_device(dev);
> +
> +	if (!pm_runtime_suspended(dev))
> +		return amba_pclk_enable(pcdev);
> +	return 0;
> +}
> +#endif

remove this line

> +
> +static SIMPLE_DEV_PM_OPS(pl330_pm, pl330_suspend, pl330_resume);

Everything is handle inside this macro and your functions are not calling=

anything what it is not defined for both cases.

Thanks,
Michal


--wlnQAQITbQqCA8v4WJirsLXuH630HeqtD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlQNY3sACgkQykllyylKDCFq6ACfdVEod9HSsGLSFeZoiUYt4PWX
RDkAnRXZ0yfGM3rXxVVH4nC4Gz5UONte
=SenN
-----END PGP SIGNATURE-----

--wlnQAQITbQqCA8v4WJirsLXuH630HeqtD--
