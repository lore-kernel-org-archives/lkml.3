Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab3GOSiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 14:38:13 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:51082 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613Ab3GOSiM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 14:38:12 -0400
Date: Mon, 15 Jul 2013 20:37:56 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Mark Brown <broonie@kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH] ASoC: kirkwood-i2s: fix a compilation warning
Message-ID: <20130715203756.68abbf10@armhf>
In-Reply-To: <20130715153101.GK11538@sirena.org.uk>
References: <20130715103644.04e57749@armhf>
	<20130715153101.GK11538@sirena.org.uk>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jul 2013 16:31:01 +0100
Mark Brown <broonie@kernel.org> wrote:

> On Mon, Jul 15, 2013 at 10:36:44AM +0200, Jean-Francois Moine wrote:
> > In the function kirkwood_set_rate, when the rate cannot be satisfied
> > by the internal nor by an external clock, the clock source in undefined:
> 
> >  warning: ‘clks_ctrl’ may be used uninitialized in this function
> 
> > As the ALSA subsystem should never gives such a rate, this patch removes
> > the check of the external clock pointer.
> 
> > -	} else if (!IS_ERR(priv->extclk)) {
> > +	} else {
> 
> I'd really like to see an analysis explaining why this can never happen,
> the driver explicitly supports running without extclk being provided.
> Simply asserting that we should never get such a rate isn't really
> enough detail...

Russell explained this in the message below dated Wed, 27 Mar 2013
  (http://www.spinics.net/lists/arm-kernel/msg233819.html)

--------------- Russell's message -----------------
On Wed, Mar 27, 2013 at 08:31:57AM +0100, Jean-Francois Moine wrote:
> On Tue, 26 Mar 2013 21:39:40 +0100
> Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:  
> > I suggest (again) to remove clks_ctrl and move the writel inside
> > if and else-if branch to cure the compiler warning.
> > 
> > Sebastian  
> 
> That's what there was in the original patch from Rabeeh, but maybe it
> is the opportunity to use WARN_ON. Russell?  

Sebastian is correct in that such a path should _never_ be reached
because ALSA will reject anything but 44.1, 48 or 96kHz rates if we
don't have an extclk.

However, I disagree with Sebastian's solution - doing that is likely to
generate more code because gcc tends not to optimise:

	if (foo) {
		writel(some_value, register);
	} else {
		writel(some_other_value, register);
	}

very well.  It will generate two separate writel()s when in fact, it
could just do:

	if (foo) {
		val = some_value;
	} else {
		val = some_other_value;
	}
	writel(val, register);

One solution to this would be to just get rid of "if (!IS_ERR(priv->extclk))"
entirely, so that the "else" clause always assumes that if we hit that,
there will be an external clock.  If it does, the clk API gets to deal
with being passed an error pointer for a clock, and we switch to extclk
mode.  Either that'll cause a nice backtrace from the kernel (which is
good in this case) or audio will just not work.

Remember, though - if there isn't an extclk set, then we should never
get there in the first place.  If it makes people feel happier, also put
a WARN_ON(IS_ERR(priv->extclk)) there to guarantee a backtrace if it
happens.
---------------- end message ---------------

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
