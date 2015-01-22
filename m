Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbbAVEyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 23:54:47 -0500
Received: from mail-by2on0117.outbound.protection.outlook.com ([207.46.100.117]:5248
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752230AbbAVEyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 23:54:40 -0500
Date: Thu, 22 Jan 2015 12:55:35 +0800
From: Zidan Wang <b50113@freescale.com>
To: Nicolin Chen <nicoleotsuka@gmail.com>
CC: Zidan Wang <zidan.wang@freescale.com>, <timur@tabi.org>,
        <Xiubo.Lee@gmail.com>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <perex@perex.cz>, <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel][PATCH 2/3] ASoC: fsl_sai: Add support for tdm slots
 operation
Message-ID: <20150122045515.GA3467@b50113>
References: <1421756480-7055-1-git-send-email-zidan.wang@freescale.com>
 <1421756480-7055-3-git-send-email-zidan.wang@freescale.com>
 <20150121180801.GA3361@Alpha>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20150121180801.GA3361@Alpha>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=B50113@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(189002)(51704005)(24454002)(199003)(77096005)(64706001)(46102003)(104016003)(68736005)(77156002)(46406003)(76176999)(50986999)(87936001)(54356999)(47776003)(105606002)(92566002)(85426001)(83506001)(33716001)(2950100001)(575784001)(50466002)(97756001)(110136001)(86362001)(97736003)(6806004)(106466001)(33656002)(23726002)(1411001)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN3PR0301MB1249;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BN3PR0301MB1249;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN3PR0301MB1249;
X-Forefront-PRVS: 0464DBBBC4
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1249;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2015 04:54:35.5317
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR0301MB1249
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 10:08:03AM -0800, Nicolin Chen wrote:
> On Tue, Jan 20, 2015 at 08:21:19PM +0800, Zidan Wang wrote:
> > @@ -369,10 +380,25 @@ static int fsl_sai_hw_params(struct snd_pcm_substream *substream,
> >  	u32 word_width = snd_pcm_format_width(params_format(params));
> >  	u32 val_cr4 = 0, val_cr5 = 0;
> >  	int ret;
> > +	u32 bclk;
> > +
> > +	if (channels == 1)
> > +		channels = 2;
> > +
> > +	if (!sai->slots || sai->slots % channels)
> > +		sai->slots = channels;
> > +
> > +	sai->slots = sai->slots / channels;
> > +
> > +	if (sai->slot_width < word_width || sai->is_dsp_mode)
> > +		sai->slot_width = word_width;
> 
> Could you pls explain a bit what's this overriding for?
> Or it might be better to put into a comment.
>
In machine driver, we should use snd_soc_dai_set_tdm_slot to set slots
and slot width. In my opinion, slots in machine driver means the slot
number of all channels. But in sai driver, the slots means the slot number
of one channel. So snd_soc_calc_bclk use fs*sample_size*channels*tdm_slots
to caculate bclk.

So i use "sai->slots = sai->slots / channels" to calculate slots per channel. 
If we missing set slots, use channel number to set slots and get one slot per 
channel. If we missing set slot width, set default slot width to word width. 

If slot width is 32 and wrod width is 16, for 2 channels and one slot
per channel, it will be 64 bit clock for one frame.

val_cr5 |= FSL_SAI_CR5_WNW(sai->slot_width).
val_cr5 |= FSL_SAI_CR5_W0W(sai->slot_width);

So sai word length is 32, it will trans 32 bit data per channel. But dma only
trans 16 bit data to fifo, the continues 16 bit will be 0. So for 16 bit data 
formate, it will just one channel has data. When it is dsp mode, let slot
width equal to word width can fix the issue.


> Nicolin
