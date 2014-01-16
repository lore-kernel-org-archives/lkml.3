Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaAPDsG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 22:48:06 -0500
Received: from mail-bn1lp0158.outbound.protection.outlook.com ([207.46.163.158]:34402
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973AbaAPDsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 22:48:04 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Jean-Francois Moine <moinejf@free.fr>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Problems with simple-card
Thread-Topic: Problems with simple-card
Thread-Index: AQHPEh5JfNZzFIpXg0+wzFuEj1ZSy5qGlpyg
Date: Thu, 16 Jan 2014 03:47:58 +0000
Message-ID: <81eea230fdfa45bfa6d1f9d2b941221e@BY2PR03MB505.namprd03.prod.outlook.com>
References: <20140115191831.5965d17e@armhf>
In-Reply-To: <20140115191831.5965d17e@armhf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 0093C80C01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(779001)(679001)(689001)(51704005)(199002)(189002)(164054003)(87936001)(81342001)(47446002)(80022001)(31966008)(4396001)(81686001)(76576001)(74662001)(74876001)(74316001)(83072002)(74502001)(74366001)(93516002)(90146001)(81542001)(74706001)(85852003)(56816005)(87266001)(77982001)(85306002)(69226001)(2656002)(65816001)(47976001)(63696002)(66066001)(76796001)(51856001)(80976001)(47736001)(83322001)(46102001)(53806001)(54356001)(79102001)(49866001)(50986001)(54316002)(92566001)(76786001)(56776001)(76482001)(59766001)(33646001)(93136001)(81816001)(21314002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB508;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0G3mcD3015164

Hi,

> I did a mistake in the v1 of my 'ASoC: simple-card: simplify code': I
> did not initialize the pointer to the asoc_simple_card_dai_init()
> function when DT. Then, I fixed that, and the simple card does not work
> for me.
> 
> First, without any 'format' in the DT, I get a fmt for each CPU / CODEC
> DAI: SND_SOC_DAIFMT_CBS_CFS is always set. Well, some code is executed
> for nothing, but this is not critical.
> 

This is the old issue that I have raised before, which is one limitation
of snd_soc_of_parse_daifmt(). As descript above, if without any fmt in the
DT node, and just using snd_soc_of_parse_daifmt() for each CPU/CODEC DAI fmt
the SND_SOC_DAIFMT_CBS_CFS (none zero) is always set.

@Mark and Morimoto-san, there has two ways to deal with this in my mind:
Fist, in the snd_soc_of_parse_daifmt(), modifying the
boolen : "[prefix]bitclock-master"
boolen : "[prefix]frame-master"
	==> 
[prefix]master = "XXX" and "XXX" is :
"cbm-cfm" --> SND_SOC_DAIFMT_CBM_CFM          
"cbs-cfm" --> SND_SOC_DAIFMT_CBS_CFM          
"cbm-cfs" --> SND_SOC_DAIFMT_CBM_CFS          
"cbs-cfs" --> SND_SOC_DAIFMT_CBS_CFS         

And the default value will be zero...

If this method is applied, and there is no need any masks for
snd_soc_of_parse_daifmt(), like in simple card driver:

/* get CPU/CODEC common format via simple-audio-card,format */
info->daifmt = snd_soc_of_parse_daifmt(node, "simple-audio-card,") &
           (SND_SOC_DAIFMT_FORMAT_MASK | SND_SOC_DAIFMT_INV_MASK);

Second, if there hasn't any DAI fmts in DT node and at the same time the CPU
and CODEC DAI devices don't need to care about of them, and set_dai() pointer
could be set to be NULL, and then snd_soc_dai_set_fmt() just returned -ENOTSUPP.


Thanks,

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
