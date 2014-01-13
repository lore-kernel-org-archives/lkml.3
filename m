Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbaAMBoQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 20:44:16 -0500
Received: from ozlabs.org ([203.10.76.45]:48845 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbaAMBoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 20:44:00 -0500
Date: Mon, 13 Jan 2014 12:43:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolin Chen <b42378@freescale.com>,
        Nicolin Chen <Guangyu.Chen@freescale.com>
Subject: linux-next: manual merge of the sound-asoc tree with the slave-dma
 tree
Message-Id: <20140113124352.70e2580496aa2ce8aff535a8@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__13_Jan_2014_12_43_52_+1100_CaSqMXvcV=y9v2V4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_Jan_2014_12_43_52_+1100_CaSqMXvcV=y9v2V4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the sound-asoc tree got a conflict in
sound/soc/fsl/fsl_ssi.c between commit 0da9e55e71bc ("ASoC: fsl_ssi: Add
dual fifo mode support") from the slave-dma tree and commit 2b56b5f02029
("ASoC: fsl_ssi: Set default slot number for common cases") from the
sound-asoc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc sound/soc/fsl/fsl_ssi.c
index 2101fc5c5739,7864ec5cf5f9..000000000000
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
@@@ -421,12 -711,17 +712,23 @@@ static int fsl_ssi_setup(struct fsl_ssi
  	if (ssi_private->imx_ac97)
  		fsl_ssi_setup_ac97(ssi_private);
 =20
 +	if (ssi_private->use_dual_fifo) {
 +		write_ssi_mask(&ssi->srcr, 0, CCSR_SSI_SRCR_RFEN1);
 +		write_ssi_mask(&ssi->stcr, 0, CCSR_SSI_STCR_TFEN1);
 +		write_ssi_mask(&ssi->scr, 0, CCSR_SSI_SCR_TCH_EN);
 +	}
 +
+ 	/*
+ 	 * Set a default slot number so that there is no need for those common
+ 	 * cases like I2S mode to call the extra set_tdm_slot() any more.
+ 	 */
+ 	if (!ssi_private->imx_ac97) {
+ 		write_ssi_mask(&ssi->stccr, CCSR_SSI_SxCCR_DC_MASK,
+ 				CCSR_SSI_SxCCR_DC(2));
+ 		write_ssi_mask(&ssi->srccr, CCSR_SSI_SxCCR_DC_MASK,
+ 				CCSR_SSI_SxCCR_DC(2));
+ 	}
+=20
  	return 0;
  }
 =20
@@@ -1170,8 -1343,35 +1359,35 @@@ static int fsl_ssi_probe(struct platfor
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
@@@ -1234,16 -1435,13 +1451,22 @@@
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

--Signature=_Mon__13_Jan_2014_12_43_52_+1100_CaSqMXvcV=y9v2V4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS00TcAAoJEMDTa8Ir7ZwVMSMP/12jYdsATXw4squdULOheAMD
zIuHC4lF0ItfKPa45AOsqsUfXPx2y3h0uTqYhX5sI45TiSXINBbbI0k/1w9gyCs4
jqosXJMqr0VK/a1YkiYcz94ikgzojCjfjxEjIid/gXnuzV6Qh82qNAh6axhuPoT3
inqMM4TcPWyc1p7/vjGqUc5XBEaCejEsEc3LywIdzLiURkm8zB1yv8fUpWSnbEaM
hP4ufMZTKHKLfXIVTfVdr4Ltf95TCTzQE7Ryvh+wKa/F1RB/OvEADnqz9Py7cz4i
i5W1qDMoaGjRGUTSCIb7B8QMGWKQi+dy/GQGVZvbNp9lRt1wUyWXqa4/v8wH0SwN
qVjkwO0aufhHlgk7Y4/9x/bKS+6fStguJ+hScLi3Q3f/oScxcefAFjd+MKA/0Umq
A4F29M5RZegG0J1KEeDx4q/2JEA0ujt4EqWON3HTQo/v98/G/K+mhRe8JTLtQPaU
/6Pcxcy0FcXIHcLutSnEwAqgHGRJX0JKh4gcHmLS22Xcpc3u2MBCMIfiYxiPCLNR
ZFZEFDdpEghBffPquxKCgQO4QNG6VG1Sh85LhGlchl2UMI1AG777PHKQmeU5foyO
XhyyIt0ZSVUMByxuFuk+08v/PUuTlZyT5WKwywu4LzKWzmosScd1d1luCuAfYuaV
mv6N+fDnxxtUzRO89nZh
=cH0e
-----END PGP SIGNATURE-----

--Signature=_Mon__13_Jan_2014_12_43_52_+1100_CaSqMXvcV=y9v2V4--
