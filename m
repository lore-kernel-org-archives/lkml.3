Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287AbaHGEfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 00:35:33 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:53703
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756920AbaHGEf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 00:35:29 -0400
Date: Thu, 7 Aug 2014 12:26:27 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Shengjiu Wang <shengjiu.wang@freescale.com>
CC: <broonie@kernel.org>, <lgirdwood@gmail.com>, <timur@tabi.org>,
        <perex@perex.cz>, <tiwai@suse.de>, <nicoleotsuka@gmail.com>,
        <Li.Xiubo@freescale.com>, <shc_work@mail.ru>,
        <fabio.estevam@freescale.com>, <arnd@arndb.de>,
        <alsa-devel@alsa-project.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH V1 1/2] ASoC: fsl: esai: refine esai for tdm
 support
Message-ID: <20140807042626.GA2709@MrMyself>
References: <cover.1407320232.git.shengjiu.wang@freescale.com>
 <e68d8fbaaed7000b13688b0f1757b5b9557889d7.1407320232.git.shengjiu.wang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e68d8fbaaed7000b13688b0f1757b5b9557889d7.1407320232.git.shengjiu.wang@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(24454002)(189002)(51704005)(50986999)(77982001)(110136001)(68736004)(54356999)(33716001)(92566001)(26826002)(76176999)(74662001)(102836001)(74502001)(104016003)(79102001)(81542001)(87936001)(107046002)(21056001)(95666004)(46102001)(31966008)(44976005)(33656002)(81342001)(86362001)(85306004)(97756001)(105606002)(6806004)(106466001)(64706001)(23726002)(19580405001)(85852003)(83506001)(46406003)(76482001)(99396002)(83072002)(47776003)(83322001)(50466002)(92726001)(20776003)(97736001)(80022001)(19580395003)(84676001)(4396001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0614;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 029651C7A1
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=guangyu.chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

About the title, please follow the old pattern:

ASoC: fsl_esai: Refine....

You can get the history from 'git log --oneline sound/soc/fsl/fsl_esai.c'

On Wed, Aug 06, 2014 at 06:23:03PM +0800, Shengjiu Wang wrote:
> Add parameter for slots, and caculate the number of TX/RX pins and bclk with
> slots. Then driver will be compatible with slots > 2 in TDM mode.

Hmm...although I totally understand what the patch's exactly improving,
I suggest to describe more so that other people can get a quick idea
even without looking at the code, like what the original driver lacks
or what's the problem of the original design, how this patch fulfills
this feature and why some change have to be done, those change in the
header file for example.

> Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>
> ---
>  sound/soc/fsl/fsl_esai.c |   10 +++++++---
>  sound/soc/fsl/fsl_esai.h |    8 ++++----
>  2 files changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/sound/soc/fsl/fsl_esai.c b/sound/soc/fsl/fsl_esai.c
> index 72d154e..89aa531 100644
> --- a/sound/soc/fsl/fsl_esai.c
> +++ b/sound/soc/fsl/fsl_esai.c
> @@ -56,6 +56,7 @@ struct fsl_esai {
>  	struct clk *fsysclk;
>  	u32 fifo_depth;
>  	u32 slot_width;
> +	u32 slots;
>  	u32 hck_rate[2];
>  	u32 sck_rate[2];
>  	bool hck_dir[2];

Please append a description for the new member to the existing comments
above the structure define.

> @@ -363,6 +364,7 @@ static int fsl_esai_set_dai_tdm_slot(struct snd_soc_dai *dai, u32 tx_mask,
>  			   ESAI_xSMB_xS_MASK, ESAI_xSMB_xS(rx_mask));
>  
>  	esai_priv->slot_width = slot_width;
> +	esai_priv->slots      = slots;

I prefer not to add indentation here, even thought this doesn't hurt.
Just...If there's going to be a subsequent patch adding a new member
assignment whose name's longer than slot_width, the style'll be broken
as well. For example:
	esai_priv->slot_width = slot_width;
	esai_priv->slots      = slots;
	esai_priv->slot_samplebit = slots;

The indentation for the 'slots' will look abnormal.
	
>  
>  	return 0;
>  }
> @@ -510,10 +512,11 @@ static int fsl_esai_hw_params(struct snd_pcm_substream *substream,
>  	bool tx = substream->stream == SNDRV_PCM_STREAM_PLAYBACK;
>  	u32 width = snd_pcm_format_width(params_format(params));
>  	u32 channels = params_channels(params);
> +	u32 pin = DIV_ROUND_UP(channels, esai_priv->slots);

This may cause a 'Division by zero' here. The 'slots' is only assigned
in set_dai_tdm_slot(). As default, a machine driver who does not call
set_dai_tdm_slot() will get a zero slot. We must give 'slots' a default
value (2 for example) somewhere during initialization.

And another personal suggestion -- using name 'pins' might be better.

Thank you Shengjiu,
Nicolin
