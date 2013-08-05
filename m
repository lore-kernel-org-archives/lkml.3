Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab3HEGoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 02:44:05 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:54700 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754318Ab3HEGoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 02:44:04 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1980elrWRG4wT2jk+2zr/0f
Date: Sun, 4 Aug 2013 23:43:56 -0700
From: Tony Lindgren <tony@atomide.com>
To: Olof Johansson <olof@lixom.net>
Cc: Matt Sealey <neko@bakuhatsu.net>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ATTEND] [ARM ATTEND] kernel data bloat
 and how to avoid it
Message-ID: <20130805064356.GN7656@atomide.com>
References: <20130731073802.GT7656@atomide.com>
 <20130731152131.GW2296@suse.de>
 <20130802081315.GA7656@atomide.com>
 <CAHCPf3v75tJyUGzxcrPfWW7V+bVxPCJupnDV4UbDQsrsXBXTrQ@mail.gmail.com>
 <CAOesGMgASk8yH0Og4sEREkwxcZLx11gtj4buSEXxoJHDEV9F8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMgASk8yH0Og4sEREkwxcZLx11gtj4buSEXxoJHDEV9F8g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Olof Johansson <olof@lixom.net> [130802 22:37]:
> On Fri, Aug 2, 2013 at 2:31 PM, Matt Sealey <neko@bakuhatsu.net> wrote:
> > On Fri, Aug 2, 2013 at 3:13 AM, Tony Lindgren <tony@atomide.com> wrote:
> >> * Mel Gorman <mgorman@suse.de> [130731 08:28]:
> >>> On Wed, Jul 31, 2013 at 12:38:03AM -0700, Tony Lindgren wrote:
> >>> > Hi all,
> >>> >
> >>> > Probably the biggest kernel data bloat issue is in the ARM land, but
> >>> > it also seems that it's becoming a Linux generic issue too, so I
> >>> > guess it could be discussed in either context.
> >>> >
> >>>
> >>> Would scripts/bloat-o-meter highlight where the growth problems are?
> >>
> >> Well to some extent yes, the board/SoC/driver specific options are
> >> often behind Kconfig options. So if you want to limit the set of
> >> supported SoCs and drivers for the kernel you can optimize it out.
> >>
> >> The bloat-o-meter won't help for things like checking that a device
> >> tree binding really describes the hardware, and is not just pointing
> >> to a table of defined registers in the device driver.
> >
> > Specifically naming and shaming, like arch/arm/mach-imx/clk-*.c kind
> 
> [...]
> 
> TL;DR. Some friendly advice is to reduce the verbosity of your emails.
> I lost patience a couple of paragraphs in.
> 
> 
> I think we could come a long way on this if we could sort out probe
> and init order enough that we could modularize some of this data (and
> init code). I.e. if you could load some of these tables and drivers as
> modules a lot of the bloat would no longer be an issue.
> 
> The problem, of course, is that things like clock, pinmux, etc tables
> (and drivers) tend to be needed very early during boot and thus can
> definitely not wait to the point where we usually run ramdisk
> contents.

I think there's no need for that any longer. We've pretty much sorted
out all the issues so not much is needed early on.

Sure some clocks might be needed for the SoC specific clockevent.
But if those can be defined in the .dts files only those need to
be initialized early on.

For the pinmux, bootloader already must set up pins for SDRAM so
not much should be needed early on. But if some pins are needed, those
should be defined in the .dts files and the rest can be initialized
later on based on .dts, loadable modules, or /lib/firmware.
 
> We could mandate that whatever drivers are needed on top also be
> modules, which would take care of some of the dependency chain, but we
> don't have a great way today to describe the needed probe/load order
> of said modules. So it'd still need some new and additional
> functionality to work well.

Hmm I think we're just missing a concept of initializing the SoC
specific things in stages as most of it can be done at module init
time as long as the needed pieces can be initialized early.
 
> Pushing everything out into modules will also add some complexity for
> embedded platforms who rather avoid ramdisks, and it will likely add
> boot time which matters a lot to some users. On the other hand, it's
> less likely to matter to the users who at the same time care about the
> bloat of a multiplatform kernel, i.e. you tend to ether optimize for
> boot time on particular well-defined hardware, or you care more about
> having something that boots on most hardware but possibly with some
> overhead in boot performance.

The Linux generic frameworks should support initializing things
in multiple stages. Some of them do, but not all of them. Then
depending on the use case, SoC specific things can be initialized
with a suitable combination of .dts entries, loadable modules and
data from /lib/firmware.

Regards,

Tony
