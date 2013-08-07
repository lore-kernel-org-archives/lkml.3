Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab3HGG6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 02:58:04 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:41937 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757173Ab3HGG6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 02:58:02 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19V3jdhESD8soE/n4wd3QPF
Date: Tue, 6 Aug 2013 23:57:55 -0700
From: Tony Lindgren <tony@atomide.com>
To: Christian Daudt <csd_b@daudt.org>
Cc: Jason Cooper <jason@lakedaemon.net>, devicetree@vger.kernel.org,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, Olof Johansson <olof@lixom.net>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] [ARM ATTEND] arch/arm SoC organization
Message-ID: <20130807065754.GJ7656@atomide.com>
References: <20130731141841.GP5882@titan.lakedaemon.net>
 <20130802083346.GC7656@atomide.com>
 <CAGFynZ-V6CUFXh+iC8M7spwHn3gma6gYgRFBaoAXRYtw1fbgHA@mail.gmail.com>
 <20130805062129.GK7656@atomide.com>
 <CAGFynZ-sk7bzZMKujAZ9y1OQJFEQQwqWNY_SZUhz+0xEWiF=_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGFynZ-sk7bzZMKujAZ9y1OQJFEQQwqWNY_SZUhz+0xEWiF=_A@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christian Daudt <csd_b@daudt.org> [130806 16:14]:
> On Sun, Aug 4, 2013 at 11:21 PM, Tony Lindgren <tony@atomide.com> wrote:
> > * Christian Daudt <csd_b@daudt.org> [130802 16:13]:
> >> On Fri, Aug 2, 2013 at 1:33 AM, Tony Lindgren <tony@atomide.com> wrote:
> >> > * Jason Cooper <jason@lakedaemon.net> [130731 07:25]:
> >> >> So, I'd like to propose we discuss some lessons learned and maybe arrive
> >> >> at some best practices.  eg, should we just go with mach-$COMPANY/?  How
> >> >> best to handle config symbols for efficient building?  Deprecation path
> >> >> for legacy (unconverted) boards?
> >> >
> >> > A lot of that problem goes away by initializing everything as late
> >> > as possible, and making things to live under drivers.
> >> One category of items that we haven't found a good place for in this
> >> new multiplatform world is where does dt-driven non-driver code reside
> >> ? e.g. we have a secure monitor access function that only kicks in if
> >> the appropriate dt entry is available . It currently resides in
> >> mach-bcm/bcm_kona_smc.c as it seems like the only location for it at
> >> the moment, but that doesn't seem like the best place because (a)
> >> mach-bcm might end up littered with one-of cases like this and (b)
> >> anything in mach-bcm is not visible to arm64 SoCs, and some of those
> >> in the future will need to share with their arm32 cousins.
> >>  But putting in drivers (e.g. drivers/smc) seems like the wrong thing
> >> to do also because this is not a driver.
> >>  We have a couple of other smallish pieces of IP that just need a bit
> >> of generic init code to keep them happy, which we were discussing
> >> internally where to best land them. At present they are also headed to
> >> mach-bcm.
> >>  Ultimately the question is 'what is allowed to reside in mach-<misc>
> >> ?' And by extension: 'is there a good home for everything else ?''
> >
> > Well I guess the question is how early do you need it?
> >
> > We only need the following things early on that might be SoC specific:
> >
> > 1. Timers for clockevents
> >
> > 2. Interrupt controller
> >
> > If you need the SoC specific code for the two items above, then
> > you probably want to set it up in the SoC specific init_early.
> >
> > Everything else should be possible to do as device drivers with
> > initramfs. If the code has an interrupt handler, chances are it
> > can be a driver :)
> >
> I agree that most anything can be made into a driver. I'm asking if
> that's what we want to do for all arm code that doesn't need to be
> done at the earliest stages. If there's code that doesn't need
> interrupts, doesn't register for fileops, doesn't register for any
> framework, etc... Do we still want to make a driver out of it ?

If we can, then yes I think that's the way to go. Making things into
loadable modules already automatically prevents quite a bit of
potential for nasty hacks and spaghetti code as the interfaces are
standard.

Also, then the related pieces can easily be shared across multiple
SoCs or archs, and we may even have proper maintainers for those
drivers eventually :)

Regards,

Tony
