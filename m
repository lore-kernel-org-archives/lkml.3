Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761343AbaGRKgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:36:52 -0400
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:6442
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755496AbaGRKgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:36:51 -0400
Date: Fri, 18 Jul 2014 18:18:12 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Nicolin Chen <nicoleotsuka@gmail.com>
CC: <broonie@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <alsa-devel@alsa-project.org>,
        <timur@tabi.org>, <Li.Xiubo@freescale.com>, <b02247@freescale.com>,
        <b42378@freescale.com>
Subject: Re: [PATCH 1/2] ASoC: fsl_sai: Reset FIFOs after disabling TE/RE
Message-ID: <20140718101810.GA15150@MrMyself>
References: <cover.1405603108.git.nicoleotsuka@gmail.com>
 <9ef07dc9cc98b19e3f81f8374617605bf0d9faeb.1405603108.git.nicoleotsuka@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9ef07dc9cc98b19e3f81f8374617605bf0d9faeb.1405603108.git.nicoleotsuka@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(51704005)(24454002)(189002)(199002)(43544003)(21056001)(575784001)(86362001)(64706001)(81342001)(97756001)(85852003)(46102001)(74662001)(83072002)(85306003)(102836001)(33656002)(31966008)(97736001)(26826002)(20776003)(80022001)(83506001)(92726001)(92566001)(50986999)(46406003)(74502001)(79102001)(105606002)(107046002)(106466001)(6806004)(1411001)(110136001)(83322001)(68736004)(99396002)(23726002)(87936001)(19580405001)(33716001)(95666004)(54356999)(19580395003)(76482001)(4396001)(104016003)(47776003)(81542001)(84676001)(50466002)(77982001)(44976005)(76176999);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB447;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02760F0D1C
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=guangyu.chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

	Please disregard this single patch. 

On Thu, Jul 17, 2014 at 09:21:37PM +0800, Nicolin Chen wrote:
> SAI will not clear their FIFOs after disabling TE/RE. Therfore, the driver
> should take care the task so as not to let useless data remain in the FIFO.
> 
> Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>
> ---
>  sound/soc/fsl/fsl_sai.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
> index c5a0e8a..b10dbd8 100644
> --- a/sound/soc/fsl/fsl_sai.c
> +++ b/sound/soc/fsl/fsl_sai.c
> @@ -371,10 +371,13 @@ static int fsl_sai_trigger(struct snd_pcm_substream *substream, int cmd,
>  
>  		/* Check if the opposite FRDE is also disabled */
>  		if (!(tx ? rcsr & FSL_SAI_CSR_FRDE : tcsr & FSL_SAI_CSR_FRDE)) {
> +			/* Disable both directions and reset their FIFOs */
>  			regmap_update_bits(sai->regmap, FSL_SAI_TCSR,
> -					   FSL_SAI_CSR_TERE, 0);
> +					   FSL_SAI_CSR_TERE | FSL_SAI_CSR_FR,
> +					   FSL_SAI_CSR_FR);
>  			regmap_update_bits(sai->regmap, FSL_SAI_RCSR,
> -					   FSL_SAI_CSR_TERE, 0);
> +					   FSL_SAI_CSR_TERE | FSL_SAI_CSR_FR,
> +					   FSL_SAI_CSR_FR);


The FR should be set _after_ clear TERE, not at the same time because it
still may have tiny possibility to remain data.

I'll send another version later for this patch.

The other patch for isr() should be still fine.

Thank you,
Nicolin

>  		}
>  		break;
>  	default:
> -- 
> 1.8.4
> 
