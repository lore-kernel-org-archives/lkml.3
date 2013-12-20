Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932249Ab3LTCO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 21:14:58 -0500
Received: from ozlabs.org ([203.10.76.45]:47932 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932227Ab3LTCO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 21:14:56 -0500
Date: Fri, 20 Dec 2013 13:14:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolin Chen <b42378@freescale.com>
Subject: linux-next: manual merge of the sound-asoc tree with the slave-dma
 tree
Message-Id: <20131220131449.02952cb7b89ab5fc555475e6@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__20_Dec_2013_13_14_49_+1100_DcvkBrWe4Dv18mO1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__20_Dec_2013_13_14_49_+1100_DcvkBrWe4Dv18mO1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the sound-asoc tree got a conflict in
sound/soc/fsl/fsl_ssi.c between commit 0da9e55e71bc ("ASoC: fsl_ssi: Add
dual fifo mode support") from the slave-dma tree and commits 2924a9981006
("ASoC: fsl_ssi: Add monaural audio support for non-ac97 interface") and
aafa85e71a75 ("ASoC: fsl_ssi: Add DAI master mode support for SSI on i.MX
series") from the sound-asoc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc sound/soc/fsl/fsl_ssi.c
index f43be6d4c549,b2ebaf811599..000000000000
--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@@ -143,7 -140,10 +140,11 @@@ struct fsl_ssi_private=20
  	bool ssi_on_imx;
  	bool imx_ac97;
  	bool use_dma;
 +	bool use_dual_fifo;
+ 	bool baudclk_locked;
+ 	u8 i2s_mode;
+ 	spinlock_t baudclk_lock;
+ 	struct clk *baudclk;
  	struct clk *clk;
  	struct snd_dmaengine_dai_dma_data dma_params_tx;
  	struct snd_dmaengine_dai_dma_data dma_params_rx;
@@@ -388,38 -417,9 +418,15 @@@ static int fsl_ssi_setup(struct fsl_ssi
  	 * because it is also running without an active substream. Normally SSI
  	 * is only enabled when there is a substream.
  	 */
- 	if (ssi_private->imx_ac97) {
- 		/*
- 		 * Setup the clock control register
- 		 */
- 		write_ssi(CCSR_SSI_SxCCR_WL(17) | CCSR_SSI_SxCCR_DC(13),
- 				&ssi->stccr);
- 		write_ssi(CCSR_SSI_SxCCR_WL(17) | CCSR_SSI_SxCCR_DC(13),
- 				&ssi->srccr);
-=20
- 		/*
- 		 * Enable AC97 mode and startup the SSI
- 		 */
- 		write_ssi(CCSR_SSI_SACNT_AC97EN | CCSR_SSI_SACNT_FV,
- 				&ssi->sacnt);
- 		write_ssi(0xff, &ssi->saccdis);
- 		write_ssi(0x300, &ssi->saccen);
-=20
- 		/*
- 		 * Enable SSI, Transmit and Receive
- 		 */
- 		write_ssi_mask(&ssi->scr, 0, CCSR_SSI_SCR_SSIEN |
- 				CCSR_SSI_SCR_TE | CCSR_SSI_SCR_RE);
-=20
- 		write_ssi(CCSR_SSI_SOR_WAIT(3), &ssi->sor);
- 	}
+ 	if (ssi_private->imx_ac97)
+ 		fsl_ssi_setup_ac97(ssi_private);
 =20
 +	if (ssi_private->use_dual_fifo) {
 +		write_ssi_mask(&ssi->srcr, 0, CCSR_SSI_SRCR_RFEN1);
 +		write_ssi_mask(&ssi->stcr, 0, CCSR_SSI_STCR_TFEN1);
 +		write_ssi_mask(&ssi->scr, 0, CCSR_SSI_SCR_TCH_EN);
 +	}
 +
  	return 0;
  }
 =20
@@@ -438,64 -438,19 +445,28 @@@ static int fsl_ssi_startup(struct snd_p
  	struct snd_soc_pcm_runtime *rtd =3D substream->private_data;
  	struct fsl_ssi_private *ssi_private =3D
  		snd_soc_dai_get_drvdata(rtd->cpu_dai);
- 	int synchronous =3D ssi_private->cpu_dai_drv.symmetric_rates;
+ 	unsigned long flags;
 =20
- 	/*
- 	 * If this is the first stream opened, then request the IRQ
- 	 * and initialize the SSI registers.
+ 	/* First, we only do fsl_ssi_setup() when SSI is going to be active.
+ 	 * Second, fsl_ssi_setup was already called by ac97_init earlier if
+ 	 * the driver is in ac97 mode.
  	 */
- 	if (!ssi_private->first_stream) {
- 		ssi_private->first_stream =3D substream;
-=20
- 		/*
- 		 * fsl_ssi_setup was already called by ac97_init earlier if
- 		 * the driver is in ac97 mode.
- 		 */
- 		if (!ssi_private->imx_ac97)
- 			fsl_ssi_setup(ssi_private);
- 	} else {
- 		if (synchronous) {
- 			struct snd_pcm_runtime *first_runtime =3D
- 				ssi_private->first_stream->runtime;
- 			/*
- 			 * This is the second stream open, and we're in
- 			 * synchronous mode, so we need to impose sample
- 			 * sample size constraints. This is because STCCR is
- 			 * used for playback and capture in synchronous mode,
- 			 * so there's no way to specify different word
- 			 * lengths.
- 			 *
- 			 * Note that this can cause a race condition if the
- 			 * second stream is opened before the first stream is
- 			 * fully initialized.  We provide some protection by
- 			 * checking to make sure the first stream is
- 			 * initialized, but it's not perfect.  ALSA sometimes
- 			 * re-initializes the driver with a different sample
- 			 * rate or size.  If the second stream is opened
- 			 * before the first stream has received its final
- 			 * parameters, then the second stream may be
- 			 * constrained to the wrong sample rate or size.
- 			 */
- 			if (first_runtime->sample_bits) {
- 				snd_pcm_hw_constraint_minmax(substream->runtime,
- 						SNDRV_PCM_HW_PARAM_SAMPLE_BITS,
- 				first_runtime->sample_bits,
- 				first_runtime->sample_bits);
- 			}
- 		}
-=20
- 		ssi_private->second_stream =3D substream;
+ 	if (!dai->active && !ssi_private->imx_ac97) {
+ 		fsl_ssi_setup(ssi_private);
+ 		spin_lock_irqsave(&ssi_private->baudclk_lock, flags);
+ 		ssi_private->baudclk_locked =3D false;
+ 		spin_unlock_irqrestore(&ssi_private->baudclk_lock, flags);
  	}
 =20
 +	/* When using dual fifo mode, it is safer to ensure an even period
 +	 * size. If appearing to an odd number while DMA always starts its
 +	 * task from fifo0, fifo1 would be neglected at the end of each
 +	 * period. But SSI would still access fifo1 with an invalid data.
 +	 */
 +	if (ssi_private->use_dual_fifo)
 +		snd_pcm_hw_constraint_step(substream->runtime, 0,
 +				SNDRV_PCM_HW_PARAM_PERIOD_SIZE, 2);
 +
  	return 0;
  }
 =20
@@@ -962,8 -1151,11 +1167,11 @@@ static int fsl_ssi_probe(struct platfor
                  /* Older 8610 DTs didn't have the fifo-depth property */
  		ssi_private->fifo_depth =3D 8;
 =20
+ 	ssi_private->baudclk_locked =3D false;
+ 	spin_lock_init(&ssi_private->baudclk_lock);
+=20
  	if (of_device_is_compatible(pdev->dev.of_node, "fsl,imx21-ssi")) {
 -		u32 dma_events[2];
 +		u32 dma_events[2], dmas[4];
  		ssi_private->ssi_on_imx =3D true;
 =20
  		ssi_private->clk =3D devm_clk_get(&pdev->dev, NULL);

--Signature=_Fri__20_Dec_2013_13_14_49_+1100_DcvkBrWe4Dv18mO1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSs6geAAoJEMDTa8Ir7ZwVaVoP/3EaLI4RXpeusnB1QTGGF7us
pqy6BaKebjEipp6lbDTQPQtBCXSrIeqJqBQMbjbS+2BUSRTDpgpHxpobe23GLrF+
3bafLrnxh8SYizXWhCSxQCByYhyrt4jPqL8alH9FNKblHZb4X/2NOUAbnzfgNmiZ
0qFjdQk9ipnYpJtyxL9N+HoBDrAPakUqmFCn+Wgwxbw3otTPuB6CSoCM4EoqlXju
DPQ4SmCKWclcTBxB9lD0xYG20hn0FlMwlplBvKA7OK3wv61s9N2ju7eJ71LfNO/k
nwjH9bSNUHBenpknetyT/AOyY/WmERKrTzS50nkHUdR9257sRncW7Klof0WfjUUp
czfdRpwS8vW940ycXzfrlrfjbYbO6bFO/DGz7hmTRCgLD/MxqQCsnWBaCw0muc7Z
yMCCryA25jKN5G1bIwJJtPfffK9UPhx8Q4FhHXbh5Ey5Fx2dIEMdHvJkE/scEIB0
dYPiwkmb853kmC8oH0jTwQmxkxnGekFrbBhvytJIFdKD7sZmZzrrXlQVXcemR009
WVVgJPYnCDYju3HIqjzmDnUQErsqoWDVdy4CqNmn0eweehJvpjsaXqs/n6D5Atws
Sv2Ld8UWQpXF7mqYwJv9eQlXI2RD9F1CJ7/O7pp1csLyw6PxYT+MaKRQ05dQnLF+
Np4HNd//oZIacJxdezl3
=HNjf
-----END PGP SIGNATURE-----

--Signature=_Fri__20_Dec_2013_13_14_49_+1100_DcvkBrWe4Dv18mO1--
