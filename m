Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab3EHPsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:48:18 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:41139 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599Ab3EHPsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:48:16 -0400
Date: Wed, 8 May 2013 17:48:05 +0200
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: Re: [PATCH 3/6] ASoC: ux500: Drop pinctrl sleep support
Message-ID: <20130508154805.GA12970@balto.lan>
References: <1367997261-32048-1-git-send-email-fabio.baltieri@linaro.org>
 <1367997261-32048-4-git-send-email-fabio.baltieri@linaro.org>
 <20130508105124.GA7478@sirena.org.uk>
 <20130508114216.GB29130@balto.lan>
 <20130508123225.GK7478@sirena.org.uk>
 <20130508131020.GA30503@balto.lan>
 <20130508135413.GR7478@sirena.org.uk>
 <20130508141723.GA12155@balto.lan>
 <20130508142938.GS7478@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130508142938.GS7478@sirena.org.uk>
X-Operating-System: Linux balto 3.9.0-rc8-00030-g4cbbd1d x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 03:29:38PM +0100, Mark Brown wrote:
> On Wed, May 08, 2013 at 04:17:23PM +0200, Fabio Baltieri wrote:
> > On Wed, May 08, 2013 at 02:54:13PM +0100, Mark Brown wrote:
> 
> > > But why does the rest of the code work well if the reference counting is
> > > wrong, it's in the middle of a big block of code?  This all smells like
> > > this change is papering over a specific symptom of some underlying issue
> > > - if that's not the case then it needs to be clearer why.
> 
> > Well, the counting by itself is not wrong, it's just that the same pins
> > are used by both driver instances (ux500-msp-i2s.1 and ux500-msp-i2s.3)
> > but the actual counter is specific of each instance
> > (msp->pinctrl_rxtx_ref, if I'm not mistaken msp is different between the
> > capture and playback interfaces).
> 
> So if these pins are being shared between the instances then surely
> there are other interdependencies that need to be taken care of Is that
> happening?  For example if the clocks are shared then is the code
> currently stopping the interfaces being configured with incompatible
> sample rates or word sizes?

That's an interesting point.  Mixed format, rate and channel counts
seems to work just fine, but that's probably because the supported rate
and format is locked by the codec to 48k + S16_LE.  This is in line with
what is specified on the ab8500 datasheet:

---
The AB8500 audio module exchanges audio data through the two digital
interfaces at a fixed 48 kHz rate in different formats with up to 8
channels per interface.
---

> It seems like the code is definitely buggy here but is this really all
> that's buggy or is it just the symptom you happen to have seen?

For the pinctrl code drop I still think that it should go, but really
I leave the last word to LinusW as suggested.

For the format mix, my guess is that you are probably right and this
thing may just fall apart if used on another codec.

On the other side, I don't think anybody is using the ux500 with
anything else than the ab8500, so I don't even know how would I test and
fix this.

> > Ok, what I'm trying to say is that the codec used in this platform
> > should be able to handle sleep modes without requiring any
> > reconfiguration of the digital interface on the SoC side.  In support of
> > this the fact that the STE fork of the driver does not do that, and the
> > same goes for all other ASoC drivers currently in mainline.
> 
> Well, most things would probably be able to get some small benefit from
> doing this, it's just that we've not had any real support for managing
> pin muxing - one of the goals of adding pinctrl is to make it easier to
> deploy this sort of thing.

Pin muxing is handled transparently.  The real problem is sleep mode
switching, but that's really not needed if the codec has a proper low
power mode.

Fabio

-- 
Fabio Baltieri
