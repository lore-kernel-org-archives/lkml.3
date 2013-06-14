Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305Ab3FNIq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 04:46:57 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:57019 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750889Ab3FNIqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 04:46:54 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/ORMP8/oGiWW50EIiv4KDH
Date: Fri, 14 Jun 2013 01:46:44 -0700
From: Tony Lindgren <tony@atomide.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@nvidia.com>, Kevin Hilman <khilman@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        Mark Brown <broonie@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] drivers: pinctrl: add active state to core
Message-ID: <20130614084644.GD20992@atomide.com>
References: <1370938616-5952-1-git-send-email-linus.walleij@stericsson.com>
 <51B75148.5080701@wwwdotorg.org>
 <CACRpkdYQSO0+9tQkS=df-kpL=XL+DpnY1ijp6_Zeg0MvmFujyw@mail.gmail.com>
 <20130612183345.GU8164@atomide.com>
 <51BA1E06.6020705@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51BA1E06.6020705@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Stephen Warren <swarren@wwwdotorg.org> [130613 12:37]:
> On 06/12/2013 12:33 PM, Tony Lindgren wrote:
> > * Linus Walleij <linus.walleij@linaro.org> [130611 12:59]:
> >> On Tue, Jun 11, 2013 at 6:33 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> >>> On 06/11/2013 02:16 AM, Linus Walleij wrote:
> >>>> From: Linus Walleij <linus.walleij@linaro.org>
> >>>>
> >>>> In addition to the recently introduced pinctrl core
> >>>> control, the PM runtime pin control for the OMAP platforms
> >>>> require a fourth state in addtition to the default, idle and
> >>>> sleep states already handled by the core: an explicit "active"
> >>>> state. Let's introduce this to the core in addition to the
> >>>> other states already defined.
> >>>
> >>> Surely "default" /is/ "active"? That's what it's meant so far.
> >>
> >> I thought so too, until Tony informed us that in the OMAP world
> >> this state is not always the active one.
> >>
> >> But I don't know the exact reasons for.
> >>
> >> I guess that some "default" states on the OMAP may mean these
> >> are configured as decoupled, inactive, until explicitly activated
> >> or something like that.
> > 
> > The main reason is that remuxing all the pins for a device for
> > PM runtime suspend and resume is not necessary. Most pins are
> > static and configured once during the consumer driver probe.
> > And in most cases, remuxing only one pin for the rx line is
> > needed. This is performance critical as it may need to be done
> > constantly while entering and exiting idle, and remuxing all the
> > pins is just a waste of cycles.
> 
> Then isn't the correct solution to optimize the code that switches
> between states, so that it only reprograms the pins/groups necessary?
> Inventing extra states just to work around that issue seems quite wrong.

Hmm how would the pinctrl subsystem know which pins to reprogram and
which ones are static?
 
> So, I think you're relying on:
> 
> default: Set up everything static.
> active: flip just a few pins to active state.
> idle: flip just a few pins to idle state.
> 
> ... and assuming that the default->active or default->idle transitions
> will not affect any pins that are used in default, but not used in
> active/idle.

Yes except the default pins are not touched after probe at all.
 
> However, that very specifically isn't the case; pinctrl drivers are
> allowed to force unused pins back to some default unused state when the
> pinctrl state that's being switched to doesn't mention them, and hence
> this concept won't work in general.

We don't have any default state for pins for omaps at least and pinctrl
single does not not set them to anything when disable is called unless
function-off is specified.

But even if the pinctrl driver does something to the pins in disable,
that should work too. It's just an extra step between toggling between
two named pin states.

> Also, if default uses more pins that active, when you switch to active,
> those pins won't be marked as owned any more, I think, so something else
> could in theory grab them. At least, debugfs wouldn't be entirely
> accurate any more.

I think you're misunderstanding. The default pins are held for as long
as the device is loaded. We're not touching the default pins at all
after probe. Active and idle pins are not subsets of default.

Regards,

Tony
