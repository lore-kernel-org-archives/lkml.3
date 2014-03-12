Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063AbaCLDsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 23:48:23 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:30301
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754072AbaCLDsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 23:48:22 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z579eh579fhz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de097hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24ach24d7h2516h2545h255eh25cch25f6h2605h1155h)
Date: Wed, 12 Mar 2014 11:26:58 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
CC: Mark Brown <broonie@kernel.org>, <moinejf@free.fr>,
        <alsa-devel@alsa-project.org>, <kuninori.morimoto.gx@renesas.com>,
        <linux-kernel@vger.kernel.org>, <lgirdwood@gmail.com>,
        <Li.Xiubo@freescale.com>
Subject: Re: [alsa-devel] [PATCH] ASoC: simple-card: overwrite DAIFMT_MASTER
 of	cpu_dai->fmt
Message-ID: <20140312032657.GF1177@MrMyself>
References: <1394542472-16580-1-git-send-email-Guangyu.Chen@freescale.com>
 <8761nkryky.wl%kuninori.morimoto.gx@gmail.com>
 <20140312014927.GK28112@sirena.org.uk>
 <874n34rsul.wl%kuninori.morimoto.gx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <874n34rsul.wl%kuninori.morimoto.gx@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Morimoto-san,

On Tue, Mar 11, 2014 at 08:36:22PM -0700, Kuninori Morimoto wrote:
> 
> Hi Mark
> 
> > > > asoc-simple-card sound-cs42888.12: cpu : 2024000.esai / 4003 / 132000000
> > > > asoc-simple-card sound-cs42888.12: codec : cs42888 / 1003 / 24576000
> > > > asoc-simple-card sound-cs42888.12: cs42888 <-> 2024000.esai mapping ok
> > 
> > > cpu   = 4003 : SND_SOC_DAIFMT_CBS_CFS | SND_SOC_DAIFMT_LEFT_J
> > > codec = 1003 : SND_SOC_DAIFMT_CBM_CFM | SND_SOC_DAIFMT_LEFT_J
> > 
> > > codec is master, cpu is slave...
> > > what is problem ??
> > > Am I misunderstanding ?
> > 
> > The C in those constants stands for CODEC and the values should be
> > identical for both ends of the link.
> 
> Wow ! really ??
> Then, is this settiting wrong ??
> 
> ${LINUX}/arch/arm/mach-shmobile/board-armadillo800eva.c :: fsi_wm8978_info
> 
> static struct asoc_simple_card_info fsi_wm8978_info = {
> 	...
> 	.daifmt		= SND_SOC_DAIFMT_I2S,
> 	.cpu_dai = {
> 		...
> 		.fmt	= SND_SOC_DAIFMT_CBS_CFS | SND_SOC_DAIFMT_IB_NF,
> 	},
> 	.codec_dai = {
> 		...
> 		.fmt	= SND_SOC_DAIFMT_CBM_CFM | SND_SOC_DAIFMT_NB_NF,
> 	},
> };
> 
> It should be like this ?
> 
> static struct asoc_simple_card_info fsi_wm8978_info = {
> 	...
> 	.daifmt		= SND_SOC_DAIFMT_I2S | SND_SOC_DAIFMT_CBM_CFM,
> 	.cpu_dai = {
> 		...
> 		.fmt	= SND_SOC_DAIFMT_IB_NF,
> 	},
> 	.codec_dai = {
> 		...
> 		.fmt	= SND_SOC_DAIFMT_NB_NF,
> 	},
> };

This would be better imo.

And ideally we should also keep the xB_xF identical like Mark said _identical_.
Just some cpu dai drivers might do an incorrect settings for it, like regarding
NB as sampling on rising edge and IF as active low (I'm saying this without a
careful check though), which results people need to re-set bitclock-invert and
frame-invert if they switch the DAI format from left_j to i2s for example.

Thank you,
Nicolin Chen


