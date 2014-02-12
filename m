Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbaBLLYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 06:24:13 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35531 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751129AbaBLLYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:24:12 -0500
Date: Wed, 12 Feb 2014 11:24:09 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: lgirdwood@gmail.com, dmitry.torokhov@gmail.com, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: dapm: Add locking to snd_soc_dapm_xxxx_pin
	functions
Message-ID: <20140212112409.GD16684@opensource.wolfsonmicro.com>
References: <20140210110536.GB6856@opensource.wolfsonmicro.com> <20140210120803.GS1757@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140210120803.GS1757@sirena.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 12:08:03PM +0000, Mark Brown wrote:
> On Mon, Feb 10, 2014 at 11:05:36AM +0000, Charles Keepax wrote:
> > snd_soc_dapm_disable_pin, snd_soc_dapm_enable_pin and
> > snd_soc_dapm_force_enable_pin all require the dapm_mutex to be held when
> > they are called as they edit the dirty list. There are 385 usages of
> > these functions and only 7 hold the lock whilst calling.
> > 
> > This patch moves the locking into snd_soc_dapm_set_pin and fixes up the
> > places where the lock was held on the caller side. This saves on fixing
> > up all the current users and also is much more consistant with the rest
> > of the DAPM API which all handles the locking internally.
> 
> Unfortunately the fix needs to be in the callers to some extent - there
> are situations where you want to do atomic updates of multiple pins so
> that we don't end up bouncing the power up and down too much, we need
> the unlocked version for things that care.  This means we need to at
> least preserve an unlocked version and translate those callers that
> might care over to it (not sure if any of them are in mainline).

There are indeed none in mainline at the moment, or at least if
there are any they are not holding the lock at the moment so it
is not obviously they require atomic update.

> 
> It should also be safe to call the functions without explicit locking
> during init since we won't run DAPM until we've finished init - it is
> effectively locked even if we don't actually hold the mutex.  There
> shouldn't be a race with marking the widget dirty since every widget
> should start out dirty but I'd have to verify that one.  This will
> account for a very large proportion of the callers so perhaps it's less
> of an issue to add the locking to them than you had thought.

I will have a look I think this would cut the number down to low
10s of places that need fixed up.

How would you feel about adding an extra functions that allows the
caller to hold the lock and adding locking into the DAPM core for
the existing users? Feels like the intention would be more clear
and will allow out of mainline users requiring atomic updates to
still do that.

Thanks,
Charles

