Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbbAWDKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 22:10:08 -0500
Received: from mail-by2on0135.outbound.protection.outlook.com ([207.46.100.135]:47232
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752974AbbAWDKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 22:10:04 -0500
Date: Fri, 23 Jan 2015 10:55:09 +0800
From: Zidan Wang <b50113@freescale.com>
To: Nicolin Chen <nicoleotsuka@gmail.com>
CC: Zidan Wang <zidan.wang@freescale.com>, <timur@tabi.org>,
        <Xiubo.Lee@gmail.com>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <perex@perex.cz>, <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel][PATCH 2/3] ASoC: fsl_sai: Add support for tdm slots
 operation
Message-ID: <20150123025507.GA2382@b50113>
References: <1421756480-7055-1-git-send-email-zidan.wang@freescale.com>
 <1421756480-7055-3-git-send-email-zidan.wang@freescale.com>
 <20150121180801.GA3361@Alpha> <20150122045515.GA3467@b50113>
 <20150122054409.GA7748@Asurada> <20150122062004.GA7046@b50113>
 <20150122235019.GA3204@Asurada-GSX>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20150122235019.GA3204@Asurada-GSX>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=b50113@freescale.com; vger.kernel.org; dkim=none (message not
 signed) header.d=none;vger.kernel.org; dmarc=permerror action=none
 header.from=freescale.com;
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(24454002)(51704005)(86362001)(33716001)(54356999)(76176999)(50986999)(46102003)(93886004)(62966003)(2950100001)(92566002)(77156002)(85426001)(23726002)(97756001)(77096005)(50466002)(110136001)(46406003)(33656002)(105606002)(1411001)(106466001)(6806004)(104016003)(83506001)(87936001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY1PR0301MB1253;H:tx30smr01.am.freescale.net;FPR:;SPF:None;MLV:sfv;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BY1PR0301MB1253;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY1PR0301MB1253;
X-Forefront-PRVS: 0465429B7F
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1253;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2015 02:54:07.1077
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0301MB1253
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 03:50:20PM -0800, Nicolin Chen wrote:
> On Thu, Jan 22, 2015 at 02:20:06PM +0800, Zidan Wang wrote:
> > > > > > @@ -369,10 +380,25 @@ static int fsl_sai_hw_params(struct snd_pcm_substream *substream,
> > > > > >  	u32 word_width = snd_pcm_format_width(params_format(params));
> > > > > >  	u32 val_cr4 = 0, val_cr5 = 0;
> > > > > >  	int ret;
> > > > > > +	u32 bclk;
> > > > > > +
> > > > > > +	if (channels == 1)
> > > > > > +		channels = 2;
> > > > > > +
> > > > > > +	if (!sai->slots || sai->slots % channels)
> > > > > > +		sai->slots = channels;
> > > > > > +
> > > > > > +	sai->slots = sai->slots / channels;
> > > > > > +
> > > > > > +	if (sai->slot_width < word_width || sai->is_dsp_mode)
> > > > > > +		sai->slot_width = word_width;
> > > > > 
> > > > > Could you pls explain a bit what's this overriding for?
> > > > > Or it might be better to put into a comment.
> > > > >
> > > > In machine driver, we should use snd_soc_dai_set_tdm_slot to set slots
> > > > and slot width. In my opinion, slots in machine driver means the slot
> > > > number of all channels. But in sai driver, the slots means the slot number
> > > > of one channel. So snd_soc_calc_bclk use fs*sample_size*channels*tdm_slots
> > > > to caculate bclk.
> > > 
> > > Could you pls use the standard way as you described for slot number
> > > in machine driver instead of defining some other meanings? That one
> > > is really confusing, not to mention a code without any comment.
> > > 
> > > You can add some extra local variables with extinguished names and
> > > calculate the slot number and channels you want without changing
> > > the original sai->slots and channels in the hw_params(). As you said,
> > > you only need that new slot number and channels for snd_soc_calc_bclk
> > > call. So you may also put this code right before the call -- a normal
> > > routine doesn't need to recalculate the special slots and channels,
> > > right?
> 
> > Actually i don't kown which meaning is the standard way. Because i found
> > in wm8993 and wm8904 codec driver, they also use slots/channels to set 
> > tdm_slots in set_tdm_slot function.
> 
> The slots via machine driver should be total slot number per frame.
> For I2S, we're passing 2 for slots parameter in our machine drivers.
> 
> So why not just following that pattern. You code for calculating slot
> per channel is used to calculate bclk. But keeping slot per frame will
> also allow you to do that, meanwhile you can drop some code to do the
> extra calculation so as to keep it neat.
> 
> I suggest you to take a look at fsl_esai.c and to follow that way:
> Override slots and slot_width if specified from machine driver.
> 
I will follow slot per frame pattern like fsl_esai.c, thanks very mush.

I have another question.

Can a channel have several slots? Or channel just means slot.

> And another problem of your patch is the configurations for FRSZ and
> xMR fields. For monaural case, the channels == 1, the current code
> passes it directly to set them while your code overrides it to 2.
> 
> I'm not sure if you've tested the monaural case and confirmed it works.
> But, apparently, the configurations look pretty different.
>
I have tested the mono case, it works well.

Best Regards,
Zidan
