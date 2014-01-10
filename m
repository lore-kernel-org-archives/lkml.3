Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358AbaAJLrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 06:47:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:6495 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbaAJLrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 06:47:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,638,1384329600"; 
   d="scan'208";a="463127928"
Message-ID: <1389354435.2293.32.camel@loki>
Subject: Re: [alsa-devel] [PATCH] ASoC: dpcm: don't do hw_param when BE has
 done	hw_param
From: Liam Girdwood <liam.r.girdwood@linux.intel.com>
To: Nenghua Cao <nhcao@marvell.com>
Cc: Takashi Iwai <tiwai@suse.de>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 10 Jan 2014 11:47:15 +0000
In-Reply-To: <52CFD7BE.5030907@marvell.com>
References: <1389332195-15900-1-git-send-email-nhcao@marvell.com>
	 <s5htxdcxg0q.wl%tiwai@suse.de> <52CFD7BE.5030907@marvell.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-10 at 19:21 +0800, Nenghua Cao wrote:
> On 01/10/2014 06:55 PM, Takashi Iwai wrote:
> > [Corrected mail addresses of both Mark and Liam]
> > 
> Hi, Takashi:
> Thanks for correcting my mistake.
> > At Fri, 10 Jan 2014 13:36:35 +0800,
> > Nenghua Cao wrote:
> >>
> >> From: Nenghua Cao <nhcao@marvell.com>
> >>
> >>     It fixes the following case:
> >>     Two FEs connects the same BE; FE1 & BE path has been opened and hw_paramed.
> >> At this momment, FE2 & BE path is being opened and hw_paramed. The BE
> >> dai will do hw_param again even if it has done hw_param. It is not
> >> reasonable.
> >> FE1------------>BE
> >> FE2-------------^
> > 
> > What happens if FE2 tries to set up an incompatible hw_params?
> > (Through a quick glance, it won't work properly well, too, though...)
> > 

The intention in this case would be for the DSP FE driver to determine
if it can perform format conversion or SRC to the running BE. If the DSP
cant do the conversion then it should fail.

> If FE2 uses an incompatible param, it will make FE1 doesn't work. Maybe
> FE2 works well.
> If FE2 uses the same param, BE hw_param function will be called twice
> (This is the most happening case).
> So we can't get benefits from it.

We shouldn't be calling the hw_params() on the BE when it's already
configured in this case. So this seems like a bug. However :-

/* only allow hw_params() if no connected FEs are running */
		if (!snd_soc_dpcm_can_be_params(fe, be, stream))
			continue;

		if ((be->dpcm[stream].state != SND_SOC_DPCM_STATE_OPEN) &&
		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_HW_PARAMS) &&
		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_HW_FREE))
			continue;

We do do a test to check if any connected FEs are running (i.e.
triggered) prior to calling hw_params() on the BE. Can you confirm if
the FE was running in your case ?

Thanks

Liam

> > 
> > Takashi
> > 
> >>
> >> Signed-off-by: Nenghua Cao <nhcao@marvell.com>
> >> ---
> >>  sound/soc/soc-pcm.c |    1 -
> >>  1 files changed, 0 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/sound/soc/soc-pcm.c b/sound/soc/soc-pcm.c
> >> index 891b9a9..ec07e37 100644
> >> --- a/sound/soc/soc-pcm.c
> >> +++ b/sound/soc/soc-pcm.c
> >> @@ -1339,7 +1339,6 @@ static int dpcm_be_dai_hw_params(struct snd_soc_pcm_runtime *fe, int stream)
> >>  			continue;
> >>  
> >>  		if ((be->dpcm[stream].state != SND_SOC_DPCM_STATE_OPEN) &&
> >> -		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_HW_PARAMS) &&
> >>  		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_HW_FREE))
> >>  			continue;
> >>  
> >> -- 
> >> 1.7.0.4
> >>
> >> _______________________________________________
> >> Alsa-devel mailing list
> >> Alsa-devel@alsa-project.org
> >> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
> >>
> 



