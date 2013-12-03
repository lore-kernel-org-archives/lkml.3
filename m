Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab3LCAjB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 19:39:01 -0500
Received: from ozlabs.org ([203.10.76.45]:33121 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826Ab3LCAjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 19:39:00 -0500
Date: Tue, 3 Dec 2013 11:38:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolin Chen <b42378@freescale.com>
Subject: linux-next: manual merge of the sound-asoc tree with the slave-dma
 tree
Message-Id: <20131203113852.63cc7e97a7a9e05f939f4ac1@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__3_Dec_2013_11_38_52_+1100_mAEfB=qQ4AR.rJmQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__3_Dec_2013_11_38_52_+1100_mAEfB=qQ4AR.rJmQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the sound-asoc tree got a conflict in
sound/soc/fsl/fsl_ssi.c between commit bf02c7cb4314 ("ASoC: fsl_ssi: Add
dual fifo mode support") from the slave-dma tree and commit 2924a9981006
("ASoC: fsl_ssi: Add monaural audio support for non-ac97 interface") from
the sound-asoc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc sound/soc/fsl/fsl_ssi.c
index f43be6d4c549,90ff1071e29c..000000000000
--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@@ -143,7 -143,7 +143,8 @@@ struct fsl_ssi_private=20
  	bool ssi_on_imx;
  	bool imx_ac97;
  	bool use_dma;
 +	bool use_dual_fifo;
+ 	u8 i2s_mode;
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

--Signature=_Tue__3_Dec_2013_11_38_52_+1100_mAEfB=qQ4AR.rJmQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSnSghAAoJEMDTa8Ir7ZwVYgsP/AjW7XeI9xny6DBRSjYyKQ55
CX+OGfkRtTRy8LkI9tFCHK6kC3iMDtiCvuXYGeSND1p7AAwGeJszn6o7yv+FV8Q2
+wTtGm8HE0HSH/Ej3wicxaci1S7x3pdlB7iekLmFiukErnk7VQrM/L6PgTRHogEq
r8CosD1aym2Jx7uMuseUGdUWXhtdN/aCbuKRkOHZSQAni/6EsU09hnBCTJDD2VFo
mSJ7Q2Ti+MN+e+E03kstlJIDlupNavz8OW//1nI2oukCSIVeCvExzkUieQ9NNzYl
nfv/brwAtsxSX04+XaNd+EVokz1OmX4nyioi6e3dgMvhomTOhsK91SV/3KvlktNt
EVahTkWWX4IQPwWFBeTEQj17z+qC2upKwgEpgsJBYgfpxtzVLYdHXovsdf/X/i/e
1W/k6wKC9qKplcxvD9ltC2VEFCb0CJpb2oIgj91oyGegdW06FB02H8XZiqwwPYwS
4fUsOLhjd4tXhr5oJJyaXSKgn1sR60SXxtGZjHM7rZUCOm+9rGIPEhwRi8+bo1sB
9x0iwsHT5X5UVVkHxKFtE6EiAsZ3rBTr57AmVYp9VOUeZuZi3y5c+wmsNUGZb8d6
mn6xhPR84FxQb9Jp9JV1ekovmXUj3ljXDfyAHIzghK0mIhLTBBtPqiqS49kP5aDL
xP2NvneqMGnlJrQGd1CU
=yp9H
-----END PGP SIGNATURE-----

--Signature=_Tue__3_Dec_2013_11_38_52_+1100_mAEfB=qQ4AR.rJmQ--
