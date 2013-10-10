Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721Ab3JJQPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 12:15:54 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:19326 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757323Ab3JJQPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 12:15:48 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/E6j4B9rIS/mFZAasbUOHg
Date: Thu, 10 Oct 2013 09:15:42 -0700
From: Tony Lindgren <tony@atomide.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Roger Quadros <rogerq@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Prakash Manjunathappa <prakash.pm@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        Linux-OMAP <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 4/6] pinctrl: single: Add support for wake-up interrupts
Message-ID: <20131010161542.GB29913@atomide.com>
References: <20131003054104.8941.88857.stgit@localhost>
 <20131003054221.8941.87801.stgit@localhost>
 <5256AA7F.8030005@ti.com>
 <CACRpkdZx5+OCcQytkpjd7_nz4hw6VXoXOS0LByKgJ8_cQjbA4g@mail.gmail.com>
 <5256BB27.6010107@ti.com>
 <CACRpkdY6NSR7gSc6=_nEr_BdTiEM0Mt9t4GoBSoP26ceVphDhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdY6NSR7gSc6=_nEr_BdTiEM0Mt9t4GoBSoP26ceVphDhA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Walleij <linus.walleij@linaro.org> [131010 08:40]:
> On Thu, Oct 10, 2013 at 4:35 PM, Roger Quadros <rogerq@ti.com> wrote:
> > On 10/10/2013 05:04 PM, Linus Walleij wrote:
> 
> >> As an innocent bystander who has no clue what the _reconfigure_io_chain()
> >> is about can you tell me what this is all about?
> >
> > The OMAP SoC has a mechanism to monitor and wakeup from a low power state by creating
> > an IO ring of all the pads. But there is one bit in one of the control registers that
> > needs to be toggled each time the pad configuration is changed to re-arm the IO ring.
> > This is exactly what _reconfigure_io_chain() does.
> 
> OK I get it, I checked the function in the machone.
> 
> >> Is this another one of the OMAP forked paths where you must call back into
> >> the machine with a special callback from each and every driver?
> >
> > _reconfigure_io_chain() is not available for public use and is not called by any driver yet.
> > However, it somehow needs to be called from this pinctrl-single driver each time the
> > wakeup configuration for any pad is changed.
> 
> Actually this is one of those things where the complexity of the platform
> seems to start to leak into the nice picture of one-register-per-pin.
> 
> If this was *not* pinctrl-single but pinctrl-omap.c, it would make sense to
> move this _reconfigure_io code and the PRM registers it is touching down
> into the pinctrl driver, because it seems like absolutely no-one else
> is using it.
> 
> Both the other occurences seem to be in omap_hwmod.c, and seems
> to be related to pin muxing, which is now supposed to be handled by
> the pin control driver, right?

Right, that's for the legacy muxing code. With the legacy code we know
the device using the pins and it's interrupt in the hwmod code, so
transparent handling of the runtime PM wake-up events is easy. But that
is at the cost of huge data tables for every SoC variant, which is what
we're trying to avoid here.
 
> I think the real solution to this would be something like:
> 
> - Add the compatible strings "pinctrl-single-omap3" and
> "pinctrl-single-omap4" to drivers/pinctrl/pinctrl-single.c,
> 
> - Pass an additional <&ampersand> resource for the prm
>  thing to the single driver in the OMAP platform.
> 
> - Move this _reconfigure_io code out of the mach-omap2
>   machines and hwmod and down into the pinctrl-single driver,
>   it can be #ifdef ARCH_OMAP with stubs or whatever, the
>   important thing is that it lives with the pinctrl driver.
> 
> This does the right thing and let the pinctrl driver handle the io ring,
> instead of artificially trying to hide that in the mach-omap2 directory
> which is only creating a mess of things.
> 
> I know this is sort of breaking the promise of pinctrl-single.c only
> handling single registers but we just need to accept the fact that
> if this idea is not perfect, trying to hide the facts of life isn't any
> good either.
> 
> What do you say about this Tony? Good/bad/Linus is a moron? ;-)

Yes once we have made omap3 to be DT only, a lot of the legacy mux stuff
will clear out. And at that point we can start moving things into PRCM
drivers to handle the single shared wake-up interrupt that PRM and also
pinctrl-single is using.

However, the reconfigure_io_chain() registers are in the PRM module, so
it still should be the PRM driver managing it rather than pinctrl-single
that's in the SCM module as they can at least in theory live a separate
power state lifes. But in any case, things will get simpler once the
dependencies to the legacy code are cut.

Regards,

Tony
