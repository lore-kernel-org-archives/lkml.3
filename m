Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934760Ab3FSM5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 08:57:49 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:35349 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933796Ab3FSM5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 08:57:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Simon Horman <horms@verge.net.au>
Cc: Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>, john stultz <johnstul@us.ibm.com>,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] clocksource: sh_cmt: 32-bit control register support
Date: Wed, 19 Jun 2013 14:58:01 +0200
Message-ID: <5467150.8XmYprs6xq@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <20130619123122.GF32292@verge.net.au>
References: <20130617064052.3573.68839.sendpatchset@w520> <CANqRtoSqFPcwq0Wt7fj13izay14X_bi+UyUQe=4OGaNThsQt6Q@mail.gmail.com> <20130619123122.GF32292@verge.net.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

On Wednesday 19 June 2013 21:31:23 Simon Horman wrote:
> On Tue, Jun 18, 2013 at 10:27:44PM +0900, Magnus Damm wrote:
> > On Tue, Jun 18, 2013 at 9:30 PM, Laurent Pinchart wrote:
> > > On Tuesday 18 June 2013 20:54:47 Magnus Damm wrote:
> > >> On Tue, Jun 18, 2013 at 7:35 PM, Laurent Pinchart wrote:
> > >> > On Tuesday 18 June 2013 14:39:38 Magnus Damm wrote:
> > >> >> On Tue, Jun 18, 2013 at 3:37 AM, Laurent Pinchart wrote:
> > >> >> > On Monday 17 June 2013 15:40:52 Magnus Damm wrote:
> > >> >> >> From: Magnus Damm <damm@opensource.se>
> > >> >> >> 
> > >> >> >> Add support for CMT hardware with 32-bit control and counter
> > >> >> >> registers, as found on r8a73a4 and r8a7790. To use the CMT
> > >> >> >> with 32-bit hardware a second I/O memory resource needs to
> > >> >> >> point out the CMSTR register and it needs to be 32 bit wide.
> > >> >> > 
> > >> >> > Is a memory second resource required ? Can't we use a single
> > >> >> > resource that will contain all the registers ?
> > >> >> 
> > >> >> The CMT hardware block comes with a shared timer start stop register
> > >> >> that historically has been left out of the resource. The location of
> > >> >> this register has so far been pointed out by the "channel offset"
> > >> >> platform data member, together with information about which bit that
> > >> >> happens to be assigned to the timer channel. This start stop
> > >> >> register has happened to be kept in the same page of I/O memory as
> > >> >> the main timer channel resource, so at this point we're sort of
> > >> >> "lucky" that a single ioremap() has covered all cases.
> > >> >> 
> > >> >> With this patch it becomes optional to instead of platform data use
> > >> >> a second resource to point out the timer start/stop register. While
> > >> >> we do that we can also use the size of that resource to determine
> > >> >> the I/O access width, which happens to be something that is needed
> > >> >> to enable the driver on certain SoCs.
> > >> > 
> > >> > OK, I get it now. I've had a quick look at the documentation, and I'm
> > >> > wondering whether we shouldn't register a single platform device that
> > >> > span all the channels contained in the CMT, instead of registering
> > >> > one platform device per channel.
> > >> 
> > >> I both agree with you and disagree because of the current state of
> > >> timers in the linux kernel. I would have liked a single platform
> > >> device with all channles if this would be a generic timer driver that
> > >> from user space could be configured to associate channels with various
> > >> subsystems like PWM, clocksource, clockevent.
> > >> 
> > >> At this point the driver is doing clockevent and clocksource only, and
> > >> no sane user wants 84 channels of equivalent hardware blocks for those
> > >> two.
> > > 
> > > Of course, but we could always select which channels to register
> > > clockevents and clocksources for in platform data. That won't fix the
> > > overall problem, but it's one step forward.
> > 
> > But that's pretty much what we're doing, but only listing timer
> > channels that will be used. Of course, moving around things can be
> > done but I can't see why we want to do that if we have no selection of
> > drivers for the actual timer channels. Also, each timer channel may
> > have it's own unique set of possible parent clocks. That's something
> > we want to tie in to DT together with CCF. Solving those things
> > together makes sense IMO.

If you want to solve this along with the CCF implementation, please go ahead 
:-) I'm not too familiar with timers so I don't know what the best approach 
would be API-wise, but from a DT point of view we should have one node per 
timer. If we can't get there in a single step moving first to one platform 
device per CMT and then adding an API to select timers would be acceptable to 
me.

> > >> So based on that I'd rather do it like today and let people write
> > >> custom drivers for whatever applications they may use the other
> > >> channels for.
> > >> 
> > >> So if you're in hacking mode, why don't you figure out some way timers
> > >> can be configured from user space? =)
> > > 
> > > I don't have *that* much free time at the moment I'm afraid, and I'm
> > > sure you know why :-)
> > 
> > Yes I do, and that's why I asked. =)
> > 
> > >> If so then we can use DT to describe the actual hardware and let the
> > >> software policy be decided via some configuration mechanism.
> > > 
> > > Don't we also need timers during early boot, when userspace isn't
> > > available yet ?
> > 
> > It depends on the rest of the system. It is possible to boot to user
> > space without a timer, but I don't recommend it. =)
> 
> Hi,
> 
> I am holding off on this patch until some consensus is reached.

I don't think there's a need to hold off, this patch doesn't worsen the 
situation, cleanups would go on top.

-- 
Regards,

Laurent Pinchart

