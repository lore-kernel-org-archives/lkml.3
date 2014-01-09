Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbaAIDiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 22:38:09 -0500
Received: from ozlabs.org ([203.10.76.45]:59484 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbaAIDiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 22:38:04 -0500
Date: Thu, 9 Jan 2014 14:37:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolin Chen <b42378@freescale.com>,
        Markus Pargmann <mpa@pengutronix.de>
Subject: linux-next: manual merge of the sound-asoc tree with the  tree
Message-Id: <20140109143754.a318c00504063ca93f311624@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__9_Jan_2014_14_37_54_+1100_nRgFtH=+BK7f+GIK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__9_Jan_2014_14_37_54_+1100_nRgFtH=+BK7f+GIK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the sound-asoc tree got a conflict in
sound/soc/fsl/fsl_ssi.c between commit 0da9e55e71bc ("ASoC: fsl_ssi: Add
dual fifo mode support") from the slave-dma tree and commit c1953bfe1329
("ASoC: fsl-ssi: Add imx51-ssi and of_device_id matching") and
0888efd166fa ("ASoC: fsl-ssi: Fix interrupt stats for imx") from the
sound-asoc tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc sound/soc/fsl/fsl_ssi.c
index 2101fc5c5739,94dedcb0868d..000000000000
--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@@ -140,8 -162,9 +162,10 @@@ struct fsl_ssi_private=20
  	bool ssi_on_imx;
  	bool imx_ac97;
  	bool use_dma;
 +	bool use_dual_fifo;
  	bool baudclk_locked;
+ 	bool irq_stats;
+ 	bool offline_config;
  	u8 i2s_mode;
  	spinlock_t baudclk_lock;
  	struct clk *baudclk;
@@@ -1170,8 -1332,35 +1348,35 @@@ static int fsl_ssi_probe(struct platfor
  	ssi_private->baudclk_locked =3D false;
  	spin_lock_init(&ssi_private->baudclk_lock);
 =20
- 	if (of_device_is_compatible(pdev->dev.of_node, "fsl,imx21-ssi")) {
+ 	/*
+ 	 * imx51 and later SoCs have a slightly different IP that allows the
+ 	 * SSI configuration while the SSI unit is running.
+ 	 *
+ 	 * More important, it is necessary on those SoCs to configure the
+ 	 * sperate TX/RX DMA bits just before starting the stream
+ 	 * (fsl_ssi_trigger). The SDMA unit has to be configured before fsl_ssi
+ 	 * sends any DMA requests to the SDMA unit, otherwise it is not defined
+ 	 * how the SDMA unit handles the DMA request.
+ 	 *
+ 	 * SDMA units are present on devices starting at imx35 but the imx35
+ 	 * reference manual states that the DMA bits should not be changed
+ 	 * while the SSI unit is running (SSIEN). So we support the necessary
+ 	 * online configuration of fsl-ssi starting at imx51.
+ 	 */
+ 	switch (hw_type) {
+ 	case FSL_SSI_MCP8610:
+ 	case FSL_SSI_MX21:
+ 	case FSL_SSI_MX35:
+ 		ssi_private->offline_config =3D true;
+ 		break;
+ 	case FSL_SSI_MX51:
+ 		ssi_private->offline_config =3D false;
+ 		break;
+ 	}
+=20
+ 	if (hw_type =3D=3D FSL_SSI_MX21 || hw_type =3D=3D FSL_SSI_MX51 ||
+ 			hw_type =3D=3D FSL_SSI_MX35) {
 -		u32 dma_events[2];
 +		u32 dma_events[2], dmas[4];
  		ssi_private->ssi_on_imx =3D true;
 =20
  		ssi_private->clk =3D devm_clk_get(&pdev->dev, NULL);
@@@ -1234,16 -1424,13 +1440,22 @@@
  			dma_events[0], shared ? IMX_DMATYPE_SSI_SP : IMX_DMATYPE_SSI);
  		imx_pcm_dma_params_init_data(&ssi_private->filter_data_rx,
  			dma_events[1], shared ? IMX_DMATYPE_SSI_SP : IMX_DMATYPE_SSI);
 +		if (!of_property_read_u32_array(pdev->dev.of_node, "dmas", dmas, 4)
 +				&& dmas[2] =3D=3D IMX_DMATYPE_SSI_DUAL) {
 +			ssi_private->use_dual_fifo =3D true;
 +			/* When using dual fifo mode, we need to keep watermark
 +			 * as even numbers due to dma script limitation.
 +			 */
 +			ssi_private->dma_params_tx.maxburst &=3D ~0x1;
 +			ssi_private->dma_params_rx.maxburst &=3D ~0x1;
 +		}
- 	} else if (ssi_private->use_dma) {
+ 	}
+=20
+ 	/*
+ 	 * Enable interrupts only for MCP8610 and MX51. The other MXs have
+ 	 * different writeable interrupt status registers.
+ 	 */
+ 	if (ssi_private->use_dma) {
  		/* The 'name' should not have any slashes in it. */
  		ret =3D devm_request_irq(&pdev->dev, ssi_private->irq,
  					fsl_ssi_isr, 0, ssi_private->name,

--Signature=_Thu__9_Jan_2014_14_37_54_+1100_nRgFtH=+BK7f+GIK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSzhmYAAoJEMDTa8Ir7ZwVvgIQAIdlkfRv0AX9Elc1xicSfjfM
gD3Yl0Wrd+mSgDdEs3/4BMRKjoBmdrg01nA/6utHVmKoS3CVpWXzavaohydRa2k/
FAcUO6+ETVbCRiGklHlh/fYdWSrR0ob3slIaorJ6fcx4L/H1p85mQVJWarzDXDtt
YcWfdC9CS1e4JQSACWwIVJgIhYPXZwZ5tqmBD34IoFjWodrtC1SNvdAaVAtA1Pin
9ET6VYLf2Hfd7gWGOD4H9k84CN+LrzHp8FzGrWHQQYZ9Fq5NI4qMK2SY/IzlslUp
FbpjcEZm0CKSbAUsxvVg7/3K7iMVlTeh7ajkstQg7aMxq2pq5KKDzuvCZ66P3lx2
92hxNntfpUL86S7J9W/9/vPUkD8YyicNbdHrrfJx4QyRM4d6d4jQPUcWF8Tl7WYJ
3EktBgZNzD+BGIr8DfoSdIKM5nLOj22N/Xudg7iD4HStAKFle7AQ6mg8NUxs1t69
PgLAv05d/8gzzaSgiRrd4CYcIcSTJYCheCv6x2ZQ3MqOUO15TWqG8IenezGJwdjS
y2FgcvHPPjqkHyUwDGhPSuaeOp80DL9Xml+ka1wd9Mxbh2/YKqDu0E6EClH1ou9G
b0wyBtW1C0O7X/My2dEEF35qmVwgP0xLGgR6Q35mjlNCvnJ8J4CnVJm2fx25j7bF
huqAdTaWYymiCqHWN0Ac
=5oUd
-----END PGP SIGNATURE-----

--Signature=_Thu__9_Jan_2014_14_37_54_+1100_nRgFtH=+BK7f+GIK--
