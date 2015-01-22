Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751743AbbAVGTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 01:19:19 -0500
Received: from mail-by2on0114.outbound.protection.outlook.com ([207.46.100.114]:65456
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750875AbbAVGTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 01:19:10 -0500
Date: Thu, 22 Jan 2015 14:20:06 +0800
From: Zidan Wang <b50113@freescale.com>
To: Nicolin Chen <nicoleotsuka@gmail.com>
CC: Zidan Wang <zidan.wang@freescale.com>, <timur@tabi.org>,
        <Xiubo.Lee@gmail.com>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <perex@perex.cz>, <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel][PATCH 2/3] ASoC: fsl_sai: Add support for tdm slots
 operation
Message-ID: <20150122062004.GA7046@b50113>
References: <1421756480-7055-1-git-send-email-zidan.wang@freescale.com>
 <1421756480-7055-3-git-send-email-zidan.wang@freescale.com>
 <20150121180801.GA3361@Alpha> <20150122045515.GA3467@b50113>
 <20150122054409.GA7748@Asurada>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20150122054409.GA7748@Asurada>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=B50113@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(189002)(51704005)(24454002)(199003)(2950100001)(50466002)(85426001)(77156002)(62966003)(1411001)(23726002)(46102003)(86362001)(33716001)(68736005)(77096005)(93886004)(83506001)(105606002)(97736003)(106466001)(97756001)(92566002)(104016003)(6806004)(87936001)(33656002)(110136001)(54356999)(76176999)(50986999)(46406003)(64706001)(47776003)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB1263;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:DM2PR0301MB1263;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DM2PR0301MB1263;
X-Forefront-PRVS: 0464DBBBC4
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1263;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2015 06:19:06.9288
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR0301MB1263
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 09:44:10PM -0800, Nicolin Chen wrote:
> On Thu, Jan 22, 2015 at 12:55:35PM +0800, Zidan Wang wrote:
> > On Wed, Jan 21, 2015 at 10:08:03AM -0800, Nicolin Chen wrote:
> > > On Tue, Jan 20, 2015 at 08:21:19PM +0800, Zidan Wang wrote:
> > > > @@ -369,10 +380,25 @@ static int fsl_sai_hw_params(struct snd_pcm_substream *substream,
> > > >  	u32 word_width = snd_pcm_format_width(params_format(params));
> > > >  	u32 val_cr4 = 0, val_cr5 = 0;
> > > >  	int ret;
> > > > +	u32 bclk;
> > > > +
> > > > +	if (channels == 1)
> > > > +		channels = 2;
> > > > +
> > > > +	if (!sai->slots || sai->slots % channels)
> > > > +		sai->slots = channels;
> > > > +
> > > > +	sai->slots = sai->slots / channels;
> > > > +
> > > > +	if (sai->slot_width < word_width || sai->is_dsp_mode)
> > > > +		sai->slot_width = word_width;
> > > 
> > > Could you pls explain a bit what's this overriding for?
> > > Or it might be better to put into a comment.
> > >
> > In machine driver, we should use snd_soc_dai_set_tdm_slot to set slots
> > and slot width. In my opinion, slots in machine driver means the slot
> > number of all channels. But in sai driver, the slots means the slot number
> > of one channel. So snd_soc_calc_bclk use fs*sample_size*channels*tdm_slots
> > to caculate bclk.
> 
> Could you pls use the standard way as you described for slot number
> in machine driver instead of defining some other meanings? That one
> is really confusing, not to mention a code without any comment.
> 
> You can add some extra local variables with extinguished names and
> calculate the slot number and channels you want without changing
> the original sai->slots and channels in the hw_params(). As you said,
> you only need that new slot number and channels for snd_soc_calc_bclk
> call. So you may also put this code right before the call -- a normal
> routine doesn't need to recalculate the special slots and channels,
> right?
> 
> Nicolin

Actually i don't kown which meaning is the standard way. Because i found
in wm8993 and wm8904 codec driver, they also use slots/channels to set 
tdm_slots in set_tdm_slot function.


Best Regards,
Zidan
