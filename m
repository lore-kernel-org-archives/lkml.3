Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468AbaHOTpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 15:45:52 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:5610 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaHOTpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 15:45:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 15 Aug 2014 12:36:28 -0700
Date: Fri, 15 Aug 2014 22:45:46 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Mikko Perttunen <mperttunen@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c: i2c-tegra: Move clk_prepare/clk_set_rate to probe
Message-ID: <20140815194546.GI1626@tbergstrom-lnx.Nvidia.com>
References: <1408096034-17270-1-git-send-email-mperttunen@nvidia.com>
 <53EE32C7.6000500@wwwdotorg.org>
 <20140815180218.GH1626@tbergstrom-lnx.Nvidia.com>
 <53EE4C45.5080805@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <53EE4C45.5080805@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 08:07:01PM +0200, Stephen Warren wrote:
> >> However, the new code sets the clock rate after the clock is prepared. I
> >> think the rate should be set first, then the clock prepared. While this
> >> likely doesn't apply to the Tegra clock controller, prepare() is allowed
> >> to enable the clock if enable() can't be implemented in an atomic
> >> fashion (in which case enable/disable would be no-ops), and we should
> >> make sure that the driver correctly configures the clock before
> >> potentially enabling it.
> >>
> >> I'm not sure if a similar change to our SPI drivers is possible; after
> >> all, the SPI transfer rate can vary per message, so if clk_set_rate()
> >> acquires a lock, it seems there's no way to avoid the issue there.
> >
> > Even for i2c this could be the case I think if you use the highspeed (3.4Mhz)
> > mode? From what I remember, a highspeed i2c transaction starts with a lower
> > speed preamble to make sure non highspeed slaves don't get confused? Which
> > means you could change the bus speed depending on the slave you're addressing.
> 
> Since there's no separate chip-select for I2C, I believe all I2C devices 
> need to be able to understand the entire transaction, so the I2C bus 
> speed is fixed.
> 

Does it? I would assume the slave only needs to check if the address matches
its own address after a START condition and if not can just wait until the
STOP condition appears on the bus?

> At least, that's my understanding between 100KHz and 400KHz I2C. I don't 
> know if 3.4MHz I2C introduced something new, although considering that 
> slower I2C never had anything about being compatible with fast stuff in 
> the spec AFAIK, and such speed-switching would only be useful for 
> backwards-compatibility, I don't see how that would work.
> 

Looking at http://www.i2c-bus.org/highspeed/ they at least claim some form
of backwards compatibility ('High-speed IC devices are downward compatible
allowing for mixed bus systems. ')

> >> Luckily, we don't have any SPI-based chips that do anything related to
> >> clocks on any of our current boards...
> >
> > And we don't use SPI to talk to the PMIC, which is the usecase were actually
> > run into problems with the locking.
> 
> IIRC, the I2C-based clock provider (or consumer?) issue was something 
> mentioned (later on?) in the email thread linked by the patch description.

Yes, that's another usecase, but we don't have that on Tegra. I was refering
to Tegra usecases here.

Cheers,

Peter.
