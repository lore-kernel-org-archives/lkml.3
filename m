Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140AbaJHNsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 09:48:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756440AbaJHNrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 09:47:13 -0400
Date: Wed, 8 Oct 2014 06:46:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Doug Anderson <dianders@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mark Brown <broonie@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Chris Zhong <zyw@rock-chips.com>, Heiko Stuebner <heiko@sntech.de>,
        Sonny Rao <sonnyrao@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] drivers/pinctrl: Add the concept of an "init" state
Message-ID: <20141008134615.GA6586@kroah.com>
References: <1412713696-13343-1-git-send-email-dianders@chromium.org>
 <CACRpkda2O+LWQovekrxNDa27O7OK4GRRz6ugA=Yzh4qZ3JSc7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkda2O+LWQovekrxNDa27O7OK4GRRz6ugA=Yzh4qZ3JSc7Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 11:00:11AM +0200, Linus Walleij wrote:
> On Tue, Oct 7, 2014 at 10:28 PM, Doug Anderson <dianders@chromium.org> wrote:
> 
> > For pinctrl the "default" state is applied to pins before the driver's
> > probe function is called.  This is normally a sensible thing to do,
> > but in some cases can cause problems.  That's because the pins will
> > change state before the driver is given a chance to program how those
> > pins should behave.
> >
> > As an example you might have a regulator that is controlled by a PWM
> > (output high = high voltage, output low = low voltage).  The firmware
> > might leave this pin as driven high.  If we allow the driver core to
> > reconfigure this pin as a PWM pin before the PWM's probe function runs
> > then you might end up running at too low of a voltage while we probe.
> >
> > Let's introudce a new "init" state.  If this is defined we'll set
> > pinctrl to this state before probe and then "default" after probe
> > (unless the driver explicitly changed states already).
> >
> > An alternative idea that was thought of was to use the pre-existing
> > "sleep" or "idle" states and add a boolean property that we should
> > start in that mode.  This was not done because the "init" state is
> > needed for correctness and those other states are only present (and
> > only transitioned in to and out of) when (optional) power management
> > is enabled.
> >
> > Signed-off-by: Doug Anderson <dianders@chromium.org>
> 
> I *like* this approach. A lot.
> 
> It will come with DT bindings for free as it's just strings.
> 
> > +++ b/drivers/base/dd.c
> > @@ -308,6 +308,8 @@ static int really_probe(struct device *dev, struct device_driver *drv)
> >                         goto probe_failed;
> >         }
> >
> > +       pinctrl_init_done(dev);
> 
> We will need Greg's ACK for this oneliner.

As much as I hate subsystem-specific code in the driver core, I guess I
let this happen before, so I can't object here :)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
