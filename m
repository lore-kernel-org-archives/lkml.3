Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbaLIDJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 22:09:11 -0500
Received: from ozlabs.org ([103.22.144.67]:49430 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756529AbaLIDJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 22:09:09 -0500
Date: Tue, 9 Dec 2014 14:09:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vinod Koul <vinod.koul@intel.com>, Russell King <linux@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: linux-next: manual merge of the slave-dma tree with the arm tree
Message-ID: <20141209140901.685bb382@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/6ikfhJXbzw=p7A0cSeU/l9Q"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/6ikfhJXbzw=p7A0cSeU/l9Q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

Today's linux-next merge of the slave-dma tree got a conflict in
drivers/dma/pl330.c between commits ae43b3289186 ("ARM: 8202/1:
dmaengine: pl330: Add runtime Power Management support v12") and
b816ccc5c01f ("ARM: 8206/1: dmaengine: pl330: Add PM sleep support")
from the arm tree and commits 86e15941d3f5 ("dmaengine: pl330: Split
device_control") and c9a09dacf851 ("dmaengine: pl330: Declare slave
capabilities for the generic code") from the slave-dma tree.

I fixed it up (hopefully - see below) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/dma/pl330.c
index ca1566045ca4,b84222270c11..000000000000
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@@ -2092,71 -2092,38 +2116,44 @@@ static int pl330_terminate_all(struct d
  	struct dma_pl330_desc *desc;
  	unsigned long flags;
  	struct pl330_dmac *pl330 =3D pch->dmac;
- 	struct dma_slave_config *slave_config;
  	LIST_HEAD(list);
 =20
- 	switch (cmd) {
- 	case DMA_TERMINATE_ALL:
- 		pm_runtime_get_sync(pl330->ddma.dev);
- 		spin_lock_irqsave(&pch->lock, flags);
++	pm_runtime_get_sync(pl330->ddma.dev);
+ 	spin_lock_irqsave(&pch->lock, flags);
 =20
- 		spin_lock(&pl330->lock);
- 		_stop(pch->thread);
- 		spin_unlock(&pl330->lock);
+ 	spin_lock(&pl330->lock);
+ 	_stop(pch->thread);
+ 	spin_unlock(&pl330->lock);
 =20
- 		pch->thread->req[0].desc =3D NULL;
- 		pch->thread->req[1].desc =3D NULL;
- 		pch->thread->req_running =3D -1;
+ 	pch->thread->req[0].desc =3D NULL;
+ 	pch->thread->req[1].desc =3D NULL;
+ 	pch->thread->req_running =3D -1;
 =20
- 		/* Mark all desc done */
- 		list_for_each_entry(desc, &pch->submitted_list, node) {
- 			desc->status =3D FREE;
- 			dma_cookie_complete(&desc->txd);
- 		}
+ 	/* Mark all desc done */
+ 	list_for_each_entry(desc, &pch->submitted_list, node) {
+ 		desc->status =3D FREE;
+ 		dma_cookie_complete(&desc->txd);
+ 	}
 =20
- 		list_for_each_entry(desc, &pch->work_list , node) {
- 			desc->status =3D FREE;
- 			dma_cookie_complete(&desc->txd);
- 		}
+ 	list_for_each_entry(desc, &pch->work_list , node) {
+ 		desc->status =3D FREE;
+ 		dma_cookie_complete(&desc->txd);
+ 	}
 =20
- 		list_for_each_entry(desc, &pch->completed_list , node) {
- 			desc->status =3D FREE;
- 			dma_cookie_complete(&desc->txd);
- 		}
+ 	list_for_each_entry(desc, &pch->completed_list , node) {
+ 		desc->status =3D FREE;
+ 		dma_cookie_complete(&desc->txd);
+ 	}
 =20
- 		if (!list_empty(&pch->work_list))
- 			pm_runtime_put(pl330->ddma.dev);
++	if (!list_empty(&pch->work_list))
++		pm_runtime_put(pl330->ddma.dev);
 +
- 		list_splice_tail_init(&pch->submitted_list, &pl330->desc_pool);
- 		list_splice_tail_init(&pch->work_list, &pl330->desc_pool);
- 		list_splice_tail_init(&pch->completed_list, &pl330->desc_pool);
- 		spin_unlock_irqrestore(&pch->lock, flags);
- 		pm_runtime_mark_last_busy(pl330->ddma.dev);
- 		pm_runtime_put_autosuspend(pl330->ddma.dev);
- 		break;
- 	case DMA_SLAVE_CONFIG:
- 		slave_config =3D (struct dma_slave_config *)arg;
-=20
- 		if (slave_config->direction =3D=3D DMA_MEM_TO_DEV) {
- 			if (slave_config->dst_addr)
- 				pch->fifo_addr =3D slave_config->dst_addr;
- 			if (slave_config->dst_addr_width)
- 				pch->burst_sz =3D __ffs(slave_config->dst_addr_width);
- 			if (slave_config->dst_maxburst)
- 				pch->burst_len =3D slave_config->dst_maxburst;
- 		} else if (slave_config->direction =3D=3D DMA_DEV_TO_MEM) {
- 			if (slave_config->src_addr)
- 				pch->fifo_addr =3D slave_config->src_addr;
- 			if (slave_config->src_addr_width)
- 				pch->burst_sz =3D __ffs(slave_config->src_addr_width);
- 			if (slave_config->src_maxburst)
- 				pch->burst_len =3D slave_config->src_maxburst;
- 		}
- 		break;
- 	default:
- 		dev_err(pch->dmac->ddma.dev, "Not supported command.\n");
- 		return -ENXIO;
- 	}
+ 	list_splice_tail_init(&pch->submitted_list, &pl330->desc_pool);
+ 	list_splice_tail_init(&pch->work_list, &pl330->desc_pool);
+ 	list_splice_tail_init(&pch->completed_list, &pl330->desc_pool);
+ 	spin_unlock_irqrestore(&pch->lock, flags);
++	pm_runtime_mark_last_busy(pl330->ddma.dev);
++	pm_runtime_put_autosuspend(pl330->ddma.dev);1
 =20
  	return 0;
  }
@@@ -2623,59 -2578,6 +2620,46 @@@ static irqreturn_t pl330_irq_handler(in
  	BIT(DMA_SLAVE_BUSWIDTH_4_BYTES) | \
  	BIT(DMA_SLAVE_BUSWIDTH_8_BYTES)
 =20
- static int pl330_dma_device_slave_caps(struct dma_chan *dchan,
- 	struct dma_slave_caps *caps)
- {
- 	caps->src_addr_widths =3D PL330_DMA_BUSWIDTHS;
- 	caps->dstn_addr_widths =3D PL330_DMA_BUSWIDTHS;
- 	caps->directions =3D BIT(DMA_DEV_TO_MEM) | BIT(DMA_MEM_TO_DEV);
- 	caps->cmd_pause =3D false;
- 	caps->cmd_terminate =3D true;
- 	caps->residue_granularity =3D DMA_RESIDUE_GRANULARITY_DESCRIPTOR;
-=20
- 	return 0;
- }
-=20
 +/*
 + * Runtime PM callbacks are provided by amba/bus.c driver.
 + *
 + * It is assumed here that IRQ safe runtime PM is chosen in probe and amba
 + * bus driver will only disable/enable the clock in runtime PM callbacks.
 + */
 +static int __maybe_unused pl330_suspend(struct device *dev)
 +{
 +	struct amba_device *pcdev =3D to_amba_device(dev);
 +
 +	pm_runtime_disable(dev);
 +
 +	if (!pm_runtime_status_suspended(dev)) {
 +		/* amba did not disable the clock */
 +		amba_pclk_disable(pcdev);
 +	}
 +	amba_pclk_unprepare(pcdev);
 +
 +	return 0;
 +}
 +
 +static int __maybe_unused pl330_resume(struct device *dev)
 +{
 +	struct amba_device *pcdev =3D to_amba_device(dev);
 +	int ret;
 +
 +	ret =3D amba_pclk_prepare(pcdev);
 +	if (ret)
 +		return ret;
 +
 +	if (!pm_runtime_status_suspended(dev))
 +		ret =3D amba_pclk_enable(pcdev);
 +
 +	pm_runtime_enable(dev);
 +
 +	return ret;
 +}
 +
 +static SIMPLE_DEV_PM_OPS(pl330_pm, pl330_suspend, pl330_resume);
 +
  static int
  pl330_probe(struct amba_device *adev, const struct amba_id *id)
  {

--Sig_/6ikfhJXbzw=p7A0cSeU/l9Q
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUhmfTAAoJEMDTa8Ir7ZwVqUIP/RIadY7/dOteOFFrYa356mse
VIyegGAXd9piJu/vRd1mUNwteRxCqEHHXouAwTjWKfG8FArCgerfSbhrq3/ysGR9
XqikTkwhsFviGyDrdvM8HmJW1PRnNqjJOaKEqosjALtWSfPxdS+HS4rhdEsp5NXW
Ryq+z4x4AWbTzfvSzLbiSWuoQVd3FFCIAarxTgtuQm20sV8o/b5mCkowQ8wwFN5u
4pkWIO4NJcpMoiBS2BvOB3HaNVTvRE9oZ1WkPpTHTrebmo3zxCA3JH8yGuX+61iF
mGTZMIdC3mX3JwtbUTioz3SXCV83sbGqQCx6+iqk8J33ll+4MPEcuV7o2AyfMRba
a2dkpmUom7aHEVo2ualRhD99azlNENFaXJE1g6dnsH+BI6tFRnhpX+AJzzNraKb9
VRnkGO5nNhQQYJb2ZmaFPpmE3MzIpHBUKIR57+SAavQvWusQAbr71LZEcxnwvibM
5slAxkpWB0zFKAY109DPfzSfx+iHk1/IhgpR3emahgPu4DJG3iyPiGCNZDWQTxXm
GXdpvERLrcTIuLWemckoqkxAggSaMk53uD2iZbJ3HD0g+3YXtd1lvs/9/AJKdxoq
S2E+0z61Ow6ZD6NM8tkeJ8XgyBLKFgDwgQjIcVqdoc2zuGJvBZoyTSKmxn4HGIPA
ht76NRPUru8h3YMqX/0M
=zcA8
-----END PGP SIGNATURE-----

--Sig_/6ikfhJXbzw=p7A0cSeU/l9Q--
