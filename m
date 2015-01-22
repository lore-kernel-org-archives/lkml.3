Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbbAVFo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 00:44:27 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:33218 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbbAVFoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 00:44:20 -0500
Date: Wed, 21 Jan 2015 21:44:10 -0800
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: Zidan Wang <b50113@freescale.com>
Cc: Zidan Wang <zidan.wang@freescale.com>, timur@tabi.org, Xiubo.Lee@gmail.com,
        lgirdwood@gmail.com, broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel][PATCH 2/3] ASoC: fsl_sai: Add support for tdm slots
 operation
Message-ID: <20150122054409.GA7748@Asurada>
References: <1421756480-7055-1-git-send-email-zidan.wang@freescale.com>
 <1421756480-7055-3-git-send-email-zidan.wang@freescale.com>
 <20150121180801.GA3361@Alpha>
 <20150122045515.GA3467@b50113>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150122045515.GA3467@b50113>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 12:55:35PM +0800, Zidan Wang wrote:
> On Wed, Jan 21, 2015 at 10:08:03AM -0800, Nicolin Chen wrote:
> > On Tue, Jan 20, 2015 at 08:21:19PM +0800, Zidan Wang wrote:
> > > @@ -369,10 +380,25 @@ static int fsl_sai_hw_params(struct snd_pcm_substream *substream,
> > >  	u32 word_width = snd_pcm_format_width(params_format(params));
> > >  	u32 val_cr4 = 0, val_cr5 = 0;
> > >  	int ret;
> > > +	u32 bclk;
> > > +
> > > +	if (channels == 1)
> > > +		channels = 2;
> > > +
> > > +	if (!sai->slots || sai->slots % channels)
> > > +		sai->slots = channels;
> > > +
> > > +	sai->slots = sai->slots / channels;
> > > +
> > > +	if (sai->slot_width < word_width || sai->is_dsp_mode)
> > > +		sai->slot_width = word_width;
> > 
> > Could you pls explain a bit what's this overriding for?
> > Or it might be better to put into a comment.
> >
> In machine driver, we should use snd_soc_dai_set_tdm_slot to set slots
> and slot width. In my opinion, slots in machine driver means the slot
> number of all channels. But in sai driver, the slots means the slot number
> of one channel. So snd_soc_calc_bclk use fs*sample_size*channels*tdm_slots
> to caculate bclk.

Could you pls use the standard way as you described for slot number
in machine driver instead of defining some other meanings? That one
is really confusing, not to mention a code without any comment.

You can add some extra local variables with extinguished names and
calculate the slot number and channels you want without changing
the original sai->slots and channels in the hw_params(). As you said,
you only need that new slot number and channels for snd_soc_calc_bclk
call. So you may also put this code right before the call -- a normal
routine doesn't need to recalculate the special slots and channels,
right?

Nicolin
