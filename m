Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752378AbaAJSnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 13:43:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:60164 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbaAJSnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 13:43:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,639,1384329600"; 
   d="scan'208";a="437039553"
Message-ID: <1389379389.2293.114.camel@loki>
Subject: Re: [alsa-devel] [PATCH] ASoC: dpcm: don't do hw_param when BE has
 done	hw_param
From: Liam Girdwood <liam.r.girdwood@linux.intel.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nenghua Cao <nhcao@marvell.com>
Date: Fri, 10 Jan 2014 18:43:09 +0000
In-Reply-To: <s5hd2k0x833.wl%tiwai@suse.de>
References: <1389332195-15900-1-git-send-email-nhcao@marvell.com>
	 <s5htxdcxg0q.wl%tiwai@suse.de> <52CFD7BE.5030907@marvell.com>
	 <1389354435.2293.32.camel@loki> <52CFE0AE.1030606@marvell.com>
	 <s5hk3e8xcz2.wl%tiwai@suse.de> <1389356948.2293.55.camel@loki>
	 <s5hd2k0x833.wl%tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-10 at 14:46 +0100, Takashi Iwai wrote:
> At Fri, 10 Jan 2014 12:29:08 +0000,
> Liam Girdwood wrote:
> > 
> > On Fri, 2014-01-10 at 13:01 +0100, Takashi Iwai wrote:
> > > At Fri, 10 Jan 2014 19:59:42 +0800,
> > > Nenghua Cao wrote:
> > > > 
> > > > On 01/10/2014 07:47 PM, Liam Girdwood wrote:
> > > > > On Fri, 2014-01-10 at 19:21 +0800, Nenghua Cao wrote:
> > > > >> On 01/10/2014 06:55 PM, Takashi Iwai wrote:
> > > > >>> [Corrected mail addresses of both Mark and Liam]
> > > > >>>
> > > > >> Hi, Takashi:
> > > > >> Thanks for correcting my mistake.
> > > > >>> At Fri, 10 Jan 2014 13:36:35 +0800,
> > > > >>> Nenghua Cao wrote:
> > > > >>>>
> > > > >>>> From: Nenghua Cao <nhcao@marvell.com>
> > > > >>>>
> > > > >>>>     It fixes the following case:
> > > > >>>>     Two FEs connects the same BE; FE1 & BE path has been opened and hw_paramed.
> > > > >>>> At this momment, FE2 & BE path is being opened and hw_paramed. The BE
> > > > >>>> dai will do hw_param again even if it has done hw_param. It is not
> > > > >>>> reasonable.
> > > > >>>> FE1------------>BE
> > > > >>>> FE2-------------^
> > > > >>>
> > > > >>> What happens if FE2 tries to set up an incompatible hw_params?
> > > > >>> (Through a quick glance, it won't work properly well, too, though...)
> > > > >>>
> > > > > 
> > > > > The intention in this case would be for the DSP FE driver to determine
> > > > > if it can perform format conversion or SRC to the running BE. If the DSP
> > > > > cant do the conversion then it should fail.
> > > > > 
> > > > >> If FE2 uses an incompatible param, it will make FE1 doesn't work. Maybe
> > > > >> FE2 works well.
> > > > >> If FE2 uses the same param, BE hw_param function will be called twice
> > > > >> (This is the most happening case).
> > > > >> So we can't get benefits from it.
> > > > > 
> > > > > We shouldn't be calling the hw_params() on the BE when it's already
> > > > > configured in this case. So this seems like a bug. However :-
> > > > > 
> > > > > /* only allow hw_params() if no connected FEs are running */
> > > > > 		if (!snd_soc_dpcm_can_be_params(fe, be, stream))
> > > > > 			continue;
> > > > > 
> > > > > 		if ((be->dpcm[stream].state != SND_SOC_DPCM_STATE_OPEN) &&
> > > > > 		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_HW_PARAMS) &&
> > > > > 		    (be->dpcm[stream].state != SND_SOC_DPCM_STATE_HW_FREE))
> > > > > 			continue;
> > > > > 
> > > > > We do do a test to check if any connected FEs are running (i.e.
> > > > > triggered) prior to calling hw_params() on the BE. Can you confirm if
> > > > > the FE was running in your case ?
> > > > > 
> > > > Hi, Liam:
> > > >    I am so glad to hear from you. In my case, FE1 has called hw_param,
> > > > and before FE1 calls prepare/trigger function, the scheduler switches to
> > > > do FE2 open, hw_param. So hw_param is called twice.
> > > 
> > > So basically the current implementation is racy about this.
> > > 
> > 
> > This is a valid use case from the userspace perspective too. The BE in
> > this case is a shared resource (whether userspace is aware or not) and
> > I'd expect it to take the the last configured hw_params (in this case
> > FE2 hw_params) before it is triggered.
> 
> Yes, it's how the current code works.  But, what if FE1 didn't know
> that it's shared? (Actually how it can be informed explicitly?)

It cant atm, although this is not a problem on Android. It can be fixed
when we export the graph to userspace though.

> FE1 will still try to feed data in wrong formats/rates/etc, won't it?
> 

No, FE1 wont change it's params in this state. It will be up to the DSP
driver to perform the conversion to then new formats or fail if the new
format cannot be supported.

> At best, it should return an error when an incompatible hw_params
> setup is done by FE2, IMO.  The re-setup by FE1 should be available
> freely.  So, BE needs to remember who has set it up, then allows only
> the further re-setup by that FE, for example.
> 
> > Fwiw, a similar topic came up the conference this year wrt compressed
> > streams. The question was about configuring the BE format and rate
> > directly from userspace. This should be possible without too much effort
> > since the BE is essentially a PCM. e.g. from userspace
> > 
> > 1) configure FE1 hw_params
> > 
> > 2) configure FE2 hw_params
> > 
> > 3) optional - configure BE1 hw_params
> > 
> > If step 3 is not performed then the values from step2 are used.
> 
> I forgot about this discussion -- so how was the proposal to allow
> BE's hw_params?  A new API, or a flag in hw_params?

The intention was to use the existing alsa-lib/tinyalsa PCM hw_params
APIs. The BE would just export itself to usespace as a PCM (but without
the capability for direct playback/capture - just format, rate setting)

Thanks

Liam

