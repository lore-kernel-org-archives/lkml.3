Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab3EHORf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:17:35 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:61556 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585Ab3EHORd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:17:33 -0400
Date: Wed, 8 May 2013 16:17:23 +0200
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: Re: [PATCH 3/6] ASoC: ux500: Drop pinctrl sleep support
Message-ID: <20130508141723.GA12155@balto.lan>
References: <1367997261-32048-1-git-send-email-fabio.baltieri@linaro.org>
 <1367997261-32048-4-git-send-email-fabio.baltieri@linaro.org>
 <20130508105124.GA7478@sirena.org.uk>
 <20130508114216.GB29130@balto.lan>
 <20130508123225.GK7478@sirena.org.uk>
 <20130508131020.GA30503@balto.lan>
 <20130508135413.GR7478@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130508135413.GR7478@sirena.org.uk>
X-Operating-System: Linux balto 3.9.0-rc8-00030-g4cbbd1d x86_64 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 02:54:13PM +0100, Mark Brown wrote:
> On Wed, May 08, 2013 at 03:10:20PM +0200, Fabio Baltieri wrote:
> > On Wed, May 08, 2013 at 01:32:25PM +0100, Mark Brown wrote:
> 
> > > I'm saying that if functions like enable_msp() don't work reliably then
> > > removing some but not all of their functionality isn't an obviously good
> > > approach to fixing that.  Why does the other functionality work well but
> > > not this bit?  It sounds like there's some reference counting bug here
> > > is all...
> 
> > Yes, it started as a reference counting bug, due to the actual counter
> > not being shared between ux500-msp-i2s instances.
> 
> > That said, the actual fork of this driver deployed by STE internally
> > does not handle I2S pin sleep state, and I was not able to find any
> > other ASoC driver that does that, which seems reasonable to me as I
> > can't come up with a reason to put those pins in hi-z anyway.
> 
> But why does the rest of the code work well if the reference counting is
> wrong, it's in the middle of a big block of code?  This all smells like
> this change is papering over a specific symptom of some underlying issue
> - if that's not the case then it needs to be clearer why.

Well, the counting by itself is not wrong, it's just that the same pins
are used by both driver instances (ux500-msp-i2s.1 and ux500-msp-i2s.3)
but the actual counter is specific of each instance
(msp->pinctrl_rxtx_ref, if I'm not mistaken msp is different between the
capture and playback interfaces).

Also, right now the pins are only associated with the first instance,
as in:

DB8500_PIN("GPIO33_AF2", out_lo_slpm_nowkup, "ux500-msp-i2s.1"),

which does not seems to be correct as these are used also by
ux500-msp-i2s.3, hence why I sent the patch to set the pin as a hog.

> > If I understood the problem correctly you do that when you want to cut
> > power completely to some peripherals to avoid spurious current paths,
> > and that should not be the case for the audio codec, especially in this
> > case where it's part of a big multifuntion IC.
> 
> Being a MFD should have nothing to do with this?

Ok, what I'm trying to say is that the codec used in this platform
should be able to handle sleep modes without requiring any
reconfiguration of the digital interface on the SoC side.  In support of
this the fact that the STE fork of the driver does not do that, and the
same goes for all other ASoC drivers currently in mainline.

Fabio

-- 
Fabio Baltieri
