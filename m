Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbaDABq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 21:46:27 -0400
Received: from mail-bl2lp0203.outbound.protection.outlook.com ([207.46.163.203]:3447
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751156AbaDABqZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 21:46:25 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "guangyu.chen@freescale.com" <guangyu.chen@freescale.com>,
        "broonie@kernel.org" <broonie@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "timur@tabi.org" <timur@tabi.org>
Subject: RE: [PATCH] ASoC: fsl_sai: Fix buggy configurations in trigger()
Thread-Topic: [PATCH] ASoC: fsl_sai: Fix buggy configurations in trigger()
Thread-Index: AQHPTNWw3T/hmETuX0WzuaJ+Mk0NeZr7/XwA
Date: Tue, 1 Apr 2014 01:46:03 +0000
Message-ID: <85f93f0cf3b943408e3fb221b30a2ece@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1396265962-19343-1-git-send-email-Guangyu.Chen@freescale.com>
In-Reply-To: <1396265962-19343-1-git-send-email-Guangyu.Chen@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 016885DD9B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(189002)(164054003)(199002)(69226001)(98676001)(66066001)(87266001)(97186001)(93136001)(81342001)(81542001)(63696002)(54316002)(56776001)(93516002)(53806001)(97336001)(85852003)(76796001)(59766001)(77982001)(65816001)(94316002)(79102001)(94946001)(76482001)(87936001)(80022001)(95666003)(92566001)(20776003)(54356001)(33646001)(74316001)(74876001)(95416001)(86362001)(83072002)(74502001)(50986001)(47736001)(81816001)(4396001)(49866001)(47446002)(46102001)(74662001)(74366001)(80976001)(56816005)(31966008)(90146001)(47976001)(85306002)(51856001)(76576001)(19580405001)(575784001)(83322001)(74706001)(2656002)(19580395003)(99286001)(81686001)(76786001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB444;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:EC34F65B.1CF2F531.78EA17B7.8617DA00.204E3;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: [PATCH] ASoC: fsl_sai: Fix buggy configurations in trigger()
> 
> The current trigger() has two crucial problems:
> 1) The DMA request enabling operations (FSL_SAI_CSR_FRDE) for Tx and Rx are
>    now totally exclusive: It would fail to run simultaneous Tx-Rx cases.
> 2) The TERE disabling operation depends on an incorrect condition -- active
>    reference count that only gets increased in snd_pcm_open() and decreased
>    in snd_pcm_close(): The TERE would never get cleared.
> 
> So this patch overwrites the trigger function by following these rules:
> A) We continue to support tx-async-while-rx-sync-to-tx case alone, which's
>    originally limited by this fsl_sai driver, but we make the code easy to
>    modify for the further support of the opposite case.
> B) We enable both TE and RE for PLAYBACK stream or CAPTURE stream but only
>    enabling the DMA request bit (FSL_SAI_CSR_FRDE) of the current direction
>    due to the requirement of SAI -- For tx-async-while-rx-sync-to-tx case,
>    the receiver is enabled only when both the transmitter and receiver are
>    enabled.
> C) We only enable one side interrupt for each stream since over/underrun
>    on the opposite stream would be resulted from what we've done in rule B:
>    enabling TERE but remaining FRDE disabled, even though the xrun on the
>    opposite direction will not break the current stream.
> 
> Tested cases:
> a) aplay test.wav -d5
> b) arecord -r44100 -c2 -fS16_LE test.wav -d5
> c) arecord -r44100 -c2 -fS16_LE -d5 | aplay
> d) (aplay test2.wav &); sleep 1; arecord -r44100 -c2 -fS16_LE test.wav -d1
> e) (arecord -r44100 -c2 -fS16_LE test.wav -d5 &); sleep 1; aplay test.wav -d1
> 
> Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
> ---

I have test it on my Vybird board.

Acked-by: Xiubo Li <Li.Xiubo@freescale.com>

Thanks,

BRs
Xiubo



>  sound/soc/fsl/fsl_sai.c | 43 +++++++++++++++++++++++--------------------
>  sound/soc/fsl/fsl_sai.h | 11 +++++++++++
>  2 files changed, 34 insertions(+), 20 deletions(-)
> 
> diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
> index f088545..d64c33f 100644
> --- a/sound/soc/fsl/fsl_sai.c
> +++ b/sound/soc/fsl/fsl_sai.c
> @@ -365,6 +365,7 @@ static int fsl_sai_trigger(struct snd_pcm_substream
> *substream, int cmd,
>  		struct snd_soc_dai *cpu_dai)
>  {
>  	struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
> +	bool tx = substream->stream == SNDRV_PCM_STREAM_PLAYBACK;
>  	u32 tcsr, rcsr;
> 
>  	/*
> @@ -379,14 +380,6 @@ static int fsl_sai_trigger(struct snd_pcm_substream
> *substream, int cmd,
>  	regmap_read(sai->regmap, FSL_SAI_TCSR, &tcsr);
>  	regmap_read(sai->regmap, FSL_SAI_RCSR, &rcsr);
> 
> -	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
> -		tcsr |= FSL_SAI_CSR_FRDE;
> -		rcsr &= ~FSL_SAI_CSR_FRDE;
> -	} else {
> -		rcsr |= FSL_SAI_CSR_FRDE;
> -		tcsr &= ~FSL_SAI_CSR_FRDE;
> -	}
> -
>  	/*
>  	 * It is recommended that the transmitter is the last enabled
>  	 * and the first disabled.
> @@ -395,22 +388,32 @@ static int fsl_sai_trigger(struct snd_pcm_substream
> *substream, int cmd,
>  	case SNDRV_PCM_TRIGGER_START:
>  	case SNDRV_PCM_TRIGGER_RESUME:
>  	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
> -		tcsr |= FSL_SAI_CSR_TERE;
> -		rcsr |= FSL_SAI_CSR_TERE;
> +		if (!(tcsr & FSL_SAI_CSR_FRDE || rcsr & FSL_SAI_CSR_FRDE)) {
> +			regmap_update_bits(sai->regmap, FSL_SAI_RCSR,
> +					   FSL_SAI_CSR_TERE, FSL_SAI_CSR_TERE);
> +			regmap_update_bits(sai->regmap, FSL_SAI_TCSR,
> +					   FSL_SAI_CSR_TERE, FSL_SAI_CSR_TERE);
> +		}
> 
> -		regmap_write(sai->regmap, FSL_SAI_RCSR, rcsr);
> -		regmap_write(sai->regmap, FSL_SAI_TCSR, tcsr);
> +		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx),
> +				   FSL_SAI_CSR_xIE_MASK, FSL_SAI_FLAGS);
> +		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx),
> +				   FSL_SAI_CSR_FRDE, FSL_SAI_CSR_FRDE);
>  		break;
>  	case SNDRV_PCM_TRIGGER_STOP:
>  	case SNDRV_PCM_TRIGGER_SUSPEND:
>  	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
> -		if (!(cpu_dai->playback_active || cpu_dai->capture_active)) {
> -			tcsr &= ~FSL_SAI_CSR_TERE;
> -			rcsr &= ~FSL_SAI_CSR_TERE;
> +		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx),
> +				   FSL_SAI_CSR_FRDE, 0);
> +		regmap_update_bits(sai->regmap, FSL_SAI_xCSR(tx),
> +				   FSL_SAI_CSR_xIE_MASK, 0);
> +
> +		if (!(tcsr & FSL_SAI_CSR_FRDE || rcsr & FSL_SAI_CSR_FRDE)) {
> +			regmap_update_bits(sai->regmap, FSL_SAI_TCSR,
> +					   FSL_SAI_CSR_TERE, 0);
> +			regmap_update_bits(sai->regmap, FSL_SAI_RCSR,
> +					   FSL_SAI_CSR_TERE, 0);
>  		}
> -
> -		regmap_write(sai->regmap, FSL_SAI_TCSR, tcsr);
> -		regmap_write(sai->regmap, FSL_SAI_RCSR, rcsr);
>  		break;
>  	default:
>  		return -EINVAL;
> @@ -464,8 +467,8 @@ static int fsl_sai_dai_probe(struct snd_soc_dai *cpu_dai)
>  {
>  	struct fsl_sai *sai = dev_get_drvdata(cpu_dai->dev);
> 
> -	regmap_update_bits(sai->regmap, FSL_SAI_TCSR, 0xffffffff,
> FSL_SAI_FLAGS);
> -	regmap_update_bits(sai->regmap, FSL_SAI_RCSR, 0xffffffff,
> FSL_SAI_FLAGS);
> +	regmap_update_bits(sai->regmap, FSL_SAI_TCSR, 0xffffffff, 0x0);
> +	regmap_update_bits(sai->regmap, FSL_SAI_RCSR, 0xffffffff, 0x0);
>  	regmap_update_bits(sai->regmap, FSL_SAI_TCR1, FSL_SAI_CR1_RFW_MASK,
>  			   FSL_SAI_MAXBURST_TX * 2);
>  	regmap_update_bits(sai->regmap, FSL_SAI_RCR1, FSL_SAI_CR1_RFW_MASK,
> diff --git a/sound/soc/fsl/fsl_sai.h b/sound/soc/fsl/fsl_sai.h
> index a264185..be26d46 100644
> --- a/sound/soc/fsl/fsl_sai.h
> +++ b/sound/soc/fsl/fsl_sai.h
> @@ -35,6 +35,16 @@
>  #define FSL_SAI_RFR	0xc0 /* SAI Receive FIFO */
>  #define FSL_SAI_RMR	0xe0 /* SAI Receive Mask */
> 
> +#define FSL_SAI_xCSR(tx)	(tx ? FSL_SAI_TCSR : FSL_SAI_RCSR)
> +#define FSL_SAI_xCR1(tx)	(tx ? FSL_SAI_TCR1 : FSL_SAI_RCR1)
> +#define FSL_SAI_xCR2(tx)	(tx ? FSL_SAI_TCR2 : FSL_SAI_RCR2)
> +#define FSL_SAI_xCR3(tx)	(tx ? FSL_SAI_TCR3 : FSL_SAI_RCR3)
> +#define FSL_SAI_xCR4(tx)	(tx ? FSL_SAI_TCR4 : FSL_SAI_RCR4)
> +#define FSL_SAI_xCR5(tx)	(tx ? FSL_SAI_TCR5 : FSL_SAI_RCR5)
> +#define FSL_SAI_xDR(tx)		(tx ? FSL_SAI_TDR : FSL_SAI_RDR)
> +#define FSL_SAI_xFR(tx)		(tx ? FSL_SAI_TFR : FSL_SAI_RFR)
> +#define FSL_SAI_xMR(tx)		(tx ? FSL_SAI_TMR : FSL_SAI_RMR)
> +
>  /* SAI Transmit/Recieve Control Register */
>  #define FSL_SAI_CSR_TERE	BIT(31)
>  #define FSL_SAI_CSR_FR		BIT(25)
> @@ -48,6 +58,7 @@
>  #define FSL_SAI_CSR_FWF		BIT(17)
>  #define FSL_SAI_CSR_FRF		BIT(16)
>  #define FSL_SAI_CSR_xIE_SHIFT	8
> +#define FSL_SAI_CSR_xIE_MASK	(0x1f << FSL_SAI_CSR_xIE_SHIFT)
>  #define FSL_SAI_CSR_WSIE	BIT(12)
>  #define FSL_SAI_CSR_SEIE	BIT(11)
>  #define FSL_SAI_CSR_FEIE	BIT(10)
> --
> 1.8.4
> 

