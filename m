Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbbAUJYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 04:24:43 -0500
Received: from mail-bn1bn0105.outbound.protection.outlook.com ([157.56.110.105]:38048
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752322AbbAUJYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 04:24:35 -0500
Date: Wed, 21 Jan 2015 17:25:32 +0800
From: Zidan Wang <b50113@freescale.com>
To: Nicolin Chen <nicoleotsuka@gmail.com>
CC: Zidan Wang <zidan.wang@freescale.com>, <timur@tabi.org>,
        <Xiubo.Lee@gmail.com>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <perex@perex.cz>, <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel][PATCH 1/3] SoC: fsl_sai: add sai master mode support
Message-ID: <20150121092529.GA27441@b50113>
References: <1421756480-7055-1-git-send-email-zidan.wang@freescale.com>
 <1421756480-7055-2-git-send-email-zidan.wang@freescale.com>
 <20150121060702.GB3275@Alpha>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20150121060702.GB3275@Alpha>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=B50113@freescale.com; 
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(339900001)(24454002)(199003)(189002)(51704005)(6806004)(50466002)(86362001)(110136001)(105606002)(106466001)(97736003)(83506001)(85426001)(33716001)(23726002)(87936001)(1411001)(50986999)(54356999)(76176999)(68736005)(77096005)(33656002)(46406003)(62966003)(77156002)(97756001)(2950100001)(46102003)(92566002)(64706001)(47776003)(104016003)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB1263;H:tx30smr01.am.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:DM2PR0301MB1263;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:DM2PR0301MB1263;
X-Forefront-PRVS: 04631F8F77
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1263;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2015 09:24:31.5273
 (UTC)
X-MS-Exchange-CrossTenant-Id: 710a03f5-10f6-4d38-9ff4-a80b81da590d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=710a03f5-10f6-4d38-9ff4-a80b81da590d;Ip=[192.88.168.50]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR0301MB1263
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 10:07:03PM -0800, Nicolin Chen wrote:
> On Tue, Jan 20, 2015 at 08:21:18PM +0800, Zidan Wang wrote:
> > +static int fsl_sai_set_bclk(struct snd_soc_dai *dai, bool tx, u32 freq)
> 
> > +	if ((tx && sai->synchronous[TX]) || (!tx && !sai->synchronous[RX])) {
> > +		regmap_update_bits(sai->regmap, FSL_SAI_RCR2,
> > +			FSL_SAI_CR2_MSEL_MASK, FSL_SAI_CR2_MSEL(sai->mclk_id));
> > +		regmap_update_bits(sai->regmap, FSL_SAI_RCR2,
> > +			FSL_SAI_CR2_DIV_MASK, savediv - 1);
> 
> Hmm...the case should be a bit more complicated here IMO.
> 
> "tx && sai->synchronous[TX]" means the playback in synchronous
> mode (TX following RX). What if the recording has been already
> activated with an MSEL setting at this point? Then the playback
> stream, as a secondary stream, will overwrite MSEL of the first
> stream -- Record. Same would happen to the DIV configuration.
> 
When TX following RX(or RX following TX), TX and RX works on same bit
clock and frame clock. They will use same MCLK source, and just need set
the bclk DIV for RX(or TX). The secondary stream will overwrite MSEL and
bclk DIV of the first stream, but it doesn't matter.

For RX(or TX) sync:
fsl_sai_dai.symmetric_rates = 1;
fsl_sai_dai.symmetric_channels = 1;
fsl_sai_dai.symmetric_samplebits = 1;

When TX and RX both works on async mode, TX and RX may works on
different bit clock and frame clock. We need set MCLK source and bclk
DIV for TX and RX. mclk_id just save a MCLK source id, so i need to define
mclk_id[2] for differnet stream.

For TX and RX async:
fsl_sai_dai.symmetric_rates = 0;
fsl_sai_dai.symmetric_channels = 0;
fsl_sai_dai.symmetric_samplebits = 0;

> > @@ -297,6 +368,24 @@ static int fsl_sai_hw_params(struct snd_pcm_substream *substream,
> >  	unsigned int channels = params_channels(params);
> >  	u32 word_width = snd_pcm_format_width(params_format(params));
> >  	u32 val_cr4 = 0, val_cr5 = 0;
> > +	int ret;
> > +
> > +	if (!sai->is_slave_mode) {
> > +		ret = fsl_sai_set_bclk(cpu_dai, tx,
> > +			2 * word_width * params_rate(params));
> > +		if (ret)
> > +			return ret;
> > +
> > +		/* Do not enable the clock if it is already enabled */
> 
> It actually doesn't matter to enable the clock again since it
> purely increaes its count. But we do need a protection for MSEL
> overwritten issue resulted from the fsl_sai_set_bclk() call.
> 
> > @@ -133,10 +135,13 @@ struct fsl_sai {
> >  	struct clk *mclk_clk[FSL_SAI_MCLK_MAX];
> >  
> >  	bool is_lsb_first;
> > +	bool is_slave_mode;
> >  	bool is_dsp_mode;
> >  	bool sai_on_imx;
> >  	bool synchronous[2];
> >  
> > +	unsigned int mclk_id;
> > +	unsigned int mclk_streams;
> 
> Besides, I doubt that only one property of mclk_id can content
> Asynchronous Mode -- TX and RX can fetch their clocks from
> different MCLK sources.
> 
When hw_params failed before mclk enable, hw_free will also decrease 
the clk usecount. So add mclk_streams, when clk successful enabled, 
set corresponding bit of mclk_stream. And clear such bit after clk disabled.
> Nicolin
