Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444Ab3LaBfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 20:35:44 -0500
Received: from mail-by2lp0244.outbound.protection.outlook.com ([207.46.163.244]:53426
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932391Ab3LaBfm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 20:35:42 -0500
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "perex@perex.cz" <perex@perex.cz>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "kuninori.morimoto.gx@renesas.com" <kuninori.morimoto.gx@renesas.com>,
        "Fabio.Estevam@freescale.com" <Fabio.Estevam@freescale.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ASoC: simple-card: cleanup asoc_simple_card_parse_of()
 code
Thread-Topic: [PATCH] ASoC: simple-card: cleanup asoc_simple_card_parse_of()
 code
Thread-Index: AQHPBViOX+iJOlN4DECU2ZJcLzz22JptdpAQ
Date: Tue, 31 Dec 2013 01:35:39 +0000
Message-ID: <73b462c3a3b14a47a95142694ed5c8cc@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1388114078-24517-1-git-send-email-Li.Xiubo@freescale.com>
 <20131230121113.GQ31886@sirena.org.uk>
In-Reply-To: <20131230121113.GQ31886@sirena.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 00770C4423
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(189002)(164054003)(51704005)(199002)(24454002)(85306002)(87936001)(74316001)(80976001)(90146001)(56816005)(74502001)(77982001)(85852003)(79102001)(81686001)(76796001)(33646001)(83072002)(69226001)(31966008)(59766001)(74662001)(63696002)(76786001)(2656002)(81542001)(47446002)(56776001)(76576001)(53806001)(80022001)(51856001)(66066001)(74706001)(76482001)(54316002)(50986001)(46102001)(47736001)(81816001)(87266001)(47976001)(49866001)(4396001)(81342001)(74876001)(54356001)(19580395003)(65816001)(74366001)(83322001)(21314002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB254;H:BY2PR03MB505.namprd03.prod.outlook.com;CLIP:123.151.195.49;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark and all,

Merry Christmas.


> Subject: Re: [PATCH] ASoC: simple-card: cleanup asoc_simple_card_parse_of()
> code
> 
> On Fri, Dec 27, 2013 at 11:14:38AM +0800, Xiubo Li wrote:
> > Since there is only one common format via "simple-audio-card,format"
> > for simple card driver(CPU & CODEC DAI), there is no need to do the
> > INV mask.
> 
> I don't understand this change, how is the fact that the CPU and CODEC
> DAI share a common format related to using the inversion?  The inversion
> specifies the format relative to the spec rather than relative to the
> other end of the link and for any DAI link the two devices should be
> using the same format.

Sorry, sorry for confusion.

>From the "Documentation/devicetree/bindings/sound/simple-card.txt":
------
 Optional properties:
 
 - simple-audio-card,format     : CPU/CODEC common audio format.
                                  "i2s", "right_j", "left_j" , "dsp_a"
                                  "dsp_b", "ac97", "pdm", "msb", "lsb"
------
There is only one common daifmt properties in simple-card parent dt node, and
its bits mask is SND_SOC_DAIFMT_FORMAT_MASK.

And also in the same binding documents:
------
Optional CPU/CODEC subnodes properties:

- format                  : CPU/CODEC specific audio format if needed.
                            see simple-audio-card,format
- frame-master            : bool property. add this if subnode is frame master
- bitclock-master         : bool property. add this if subnode is bitclock master
- bitclock-inversion      : bool property. add this if subnode has clock inversion
- frame-inversion         : bool property. add this if subnode has frame inversion
- clocks / system-clock-frequency
			       : specify subnode's clock if needed.
                            it can be specified via "clocks" if system has
                            clock node (= common clock), or "system-clock-frequency"
                            (if system doens't support common clock)
------

And in "sound/soc/generic/simple-card.c", function : asoc_simple_card_parse_of()
-----
	......

        /* get CPU/CODEC common format via simple-audio-card,format */
        info->daifmt = snd_soc_of_parse_daifmt(node, "simple-audio-card,") &
                (SND_SOC_DAIFMT_FORMAT_MASK | SND_SOC_DAIFMT_INV_MASK);

	......

		ret = asoc_simple_card_sub_parse_of(cpu, ...);

		...

		ret = asoc_simple_card_sub_parse_of(codec, ...);

	......
-----
The SND_SOC_DAIFMT_INV_MASK bits mask should be for "bitclock-master" and
"frame-inversion" in subnodes' daifmt parsing if need, or why shouldn't
SND_SOC_DAIFMT_CLOCK_MASK be here like SND_SOC_DAIFMT_INV_MASK ?

IMO, the SND_SOC_DAIFMT_INV_MASK bits mask here maybe a little confused.

Certainly, these two and other subnode properties can also be common properties
like "[prefix]format" for other drivers.

It's the limitation of snd_soc_of_parse_daifmt() that the simple-card driver must
do the mask(except SND_SOC_DAIFMT_MASTER_MASK, because it default value is not zero)
operation. 

Or should we change "bitclock-master" and "frame-master" as one string property
like "[prefix]master = XXX", and set the default value as zero like others. And then
we can remove all the bits mask operations in simple-card and other drivers.
If need, I will send this patch of this.
         

Thanks,

--
Best Regards,
Xiubo

