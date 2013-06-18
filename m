Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342Ab3FRN1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 09:27:48 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:33312 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995Ab3FRN1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 09:27:46 -0400
MIME-Version: 1.0
In-Reply-To: <6180605.R3OXnJCA3O@avalon>
References: <20130617064052.3573.68839.sendpatchset@w520>
	<1531456.g1EpKAjrma@avalon>
	<CANqRtoTRcpEH13GY4jvmX5POFEZf2B6+vu0-ZGCMCk+sAeF7Ww@mail.gmail.com>
	<6180605.R3OXnJCA3O@avalon>
Date: Tue, 18 Jun 2013 22:27:44 +0900
Message-ID: <CANqRtoSqFPcwq0Wt7fj13izay14X_bi+UyUQe=4OGaNThsQt6Q@mail.gmail.com>
Subject: Re: [PATCH] clocksource: sh_cmt: 32-bit control register support
From: Magnus Damm <magnus.damm@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>, john stultz <johnstul@us.ibm.com>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Tue, Jun 18, 2013 at 9:30 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Magnus,
>
> On Tuesday 18 June 2013 20:54:47 Magnus Damm wrote:
>> On Tue, Jun 18, 2013 at 7:35 PM, Laurent Pinchart wrote:
>> > On Tuesday 18 June 2013 14:39:38 Magnus Damm wrote:
>> >> On Tue, Jun 18, 2013 at 3:37 AM, Laurent Pinchart wrote:
>> >> > On Monday 17 June 2013 15:40:52 Magnus Damm wrote:
>> >> >> From: Magnus Damm <damm@opensource.se>
>> >> >>
>> >> >> Add support for CMT hardware with 32-bit control and counter
>> >> >> registers, as found on r8a73a4 and r8a7790. To use the CMT
>> >> >> with 32-bit hardware a second I/O memory resource needs to
>> >> >> point out the CMSTR register and it needs to be 32 bit wide.
>> >> >
>> >> > Is a memory second resource required ? Can't we use a single resource
>> >> > that will contain all the registers ?
>> >>
>> >> The CMT hardware block comes with a shared timer start stop register
>> >> that historically has been left out of the resource. The location of
>> >> this register has so far been pointed out by the "channel offset"
>> >> platform data member, together with information about which bit that
>> >> happens to be assigned to the timer channel. This start stop register
>> >> has happened to be kept in the same page of I/O memory as the main
>> >> timer channel resource, so at this point we're sort of "lucky" that a
>> >> single ioremap() has covered all cases.
>> >>
>> >> With this patch it becomes optional to instead of platform data use a
>> >> second resource to point out the timer start/stop register. While we
>> >> do that we can also use the size of that resource to determine the I/O
>> >> access width, which happens to be something that is needed to enable
>> >> the driver on certain SoCs.
>> >
>> > OK, I get it now. I've had a quick look at the documentation, and I'm
>> > wondering whether we shouldn't register a single platform device that span
>> > all the channels contained in the CMT, instead of registering one
>> > platform device per channel.
>>
>> I both agree with you and disagree because of the current state of timers in
>> the linux kernel. I would have liked a single platform device with all
>> channles if this would be a generic timer driver that from user space could
>> be configured to associate channels with various subsystems like PWM,
>> clocksource, clockevent.
>>
>> At this point the driver is doing clockevent and clocksource only, and no
>> sane user wants 84 channels of equivalent hardware blocks for those two.
>
> Of course, but we could always select which channels to register clockevents
> and clocksources for in platform data. That won't fix the overall problem, but
> it's one step forward.

But that's pretty much what we're doing, but only listing timer
channels that will be used. Of course, moving around things can be
done but I can't see why we want to do that if we have no selection of
drivers for the actual timer channels. Also, each timer channel may
have it's own unique set of possible parent clocks. That's something
we want to tie in to DT together with CCF. Solving those things
together makes sense IMO.

>> So based on that I'd rather do it like today and let people write custom
>> drivers for whatever applications they may use the other channels for.
>>
>> So if you're in hacking mode, why don't you figure out some way timers can
>> be configured from user space? =)
>
> I don't have *that* much free time at the moment I'm afraid, and I'm sure you
> know why :-)

Yes I do, and that's why I asked. =)

>> If so then we can use DT to describe the actual hardware and let the
>> software policy be decided via some configuration mechanism.
>
> Don't we also need timers during early boot, when userspace isn't available
> yet ?

It depends on the rest of the system. It is possible to boot to user
space without a timer, but I don't recommend it. =)

Cheers,

/ magnus
