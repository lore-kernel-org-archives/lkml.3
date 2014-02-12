Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbaBLL0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 06:26:42 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35547 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751056AbaBLL0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:26:41 -0500
Date: Wed, 12 Feb 2014 11:26:40 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: broonie@kernel.org, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, dmitry.torokhov@gmail.com,
        lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        cw00.choi@samsung.com, myungjoo.ham@samsung.com
Subject: Re: [alsa-devel] [PATCH] ASoC: dapm: Add locking to
	snd_soc_dapm_xxxx_pin functions
Message-ID: <20140212112640.GE16684@opensource.wolfsonmicro.com>
References: <20140210110536.GB6856@opensource.wolfsonmicro.com> <s5h7g936ru1.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h7g936ru1.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 02:05:26PM +0100, Takashi Iwai wrote:
> At Mon, 10 Feb 2014 11:05:36 +0000,
> Charles Keepax wrote:
> > 
<snip>
> > 
> Actually, this fixes also the double-lock in snd_soc_dapm_sync() call
> in the line below the above.  snd_soc_dapm_sync() itself takes
> mutex_lock_nested().

Yeah spotted that as I was going through will do this in a
seperate patch if this one doesn't go in.

<snip>
> >  static int arizona_haptics_probe(struct platform_device *pdev)
> > diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
> > index dc8ff13..a44b560 100644
> > --- a/sound/soc/soc-dapm.c
> > +++ b/sound/soc/soc-dapm.c
> > @@ -2325,6 +2325,8 @@ static int snd_soc_dapm_set_pin(struct snd_soc_dapm_context *dapm,
> >  {
> >  	struct snd_soc_dapm_widget *w = dapm_find_widget(dapm, pin, true);
> >  
> > +	mutex_lock_nested(&dapm->card->dapm_mutex, SND_SOC_DAPM_CLASS_RUNTIME);
> > +
> >  	if (!w) {
> >  		dev_err(dapm->dev, "ASoC: DAPM unknown pin %s\n", pin);
> >  		return -EINVAL;
> 
> Missing unlock here.

Good spot thanks, I will update for this.

> 
> 
> > @@ -2337,6 +2339,8 @@ static int snd_soc_dapm_set_pin(struct snd_soc_dapm_context *dapm,
> >  	if (status == 0)
> >  		w->force = 0;
> >  
> > +	mutex_unlock(&dapm->card->dapm_mutex);
> > +
> >  	return 0;
> >  }
> >  
> > @@ -3210,15 +3214,11 @@ int snd_soc_dapm_put_pin_switch(struct snd_kcontrol *kcontrol,
> >  	struct snd_soc_card *card = snd_kcontrol_chip(kcontrol);
> >  	const char *pin = (const char *)kcontrol->private_value;
> >  
> > -	mutex_lock_nested(&card->dapm_mutex, SND_SOC_DAPM_CLASS_RUNTIME);
> > -
> >  	if (ucontrol->value.integer.value[0])
> >  		snd_soc_dapm_enable_pin(&card->dapm, pin);
> >  	else
> >  		snd_soc_dapm_disable_pin(&card->dapm, pin);
> >  
> > -	mutex_unlock(&card->dapm_mutex);
> > -
> >  	snd_soc_dapm_sync(&card->dapm);
> >  	return 0;
> >  }
> 
> I guess you forgot patching snd_soc_dapm_force_enable_pin()?
> It's now left unprotected after this patch.

Also a good point, thanks I will update.

> 
> 
> Takashi


Thanks,
Charles
