Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbaIHUNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 16:13:32 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:55186 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbaIHUN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 16:13:28 -0400
From: Kevin Hilman <khilman@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>, ulf.hansson@linaro.org,
        Mike Turquette <mturquette@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-sh\@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-omap\@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/2] of/clk: use "clkops-clocks" to specify clocks handled by clock_ops domain
References: <1398334403-26181-1-git-send-email-geert+renesas@glider.be>
	<53D68CC4.1010704@ti.com>
	<CACxGe6uMke5vgzcNC9xUqjr2bHJ4QFHD6YjocSZWq8Ccx8Mm6A@mail.gmail.com>
	<2717555.fiA6A86F65@avalon>
Date: Mon, 08 Sep 2014 13:13:25 -0700
In-Reply-To: <2717555.fiA6A86F65@avalon> (Laurent Pinchart's message of "Wed,
	30 Jul 2014 02:06:59 +0200")
Message-ID: <7hegvlq3a2.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Pinchart <laurent.pinchart@ideasonboard.com> writes:

> Hi Grygorii and Grant,
>
> On Monday 28 July 2014 23:52:34 Grant Likely wrote:
>> On Mon, Jul 28, 2014 at 11:47 AM, Grygorii Strashko wrote:
>> > On 07/28/2014 05:05 PM, Grant Likely wrote:
>> >> On Thu, 12 Jun 2014 19:53:43 +0300, Grygorii Strashko wrote:

[...]

>> 
>> > - Where and when to call of_clk_register_runtime_pm_clocks()?
>> > 
>> >   Bus notifier/ platform core/ device drivers
>> 
>> I would say in device drivers.
>
> I tend to agree with that.
>
> It will help here to take a step back and remember what the problem we're 
> trying to solve is.

[jumping in late, after Grygorii ping'd me about looking at this]

Laurent, thanks for summarizing the problem so well.  It helped me
catchup on the discussion.

> At the root is clock management. Our system comprise many clocks, and they 
> need to be handled. The Common Clock Framework nicely models the clocks, and 
> offers an API for drivers to retrieve device clocks and control them. Drivers 
> can thus implement clock management manually without much pain.
>
> A clock can be managed in roughly three different ways :
>
> - it can be enabled at probe time and disabled at remove time ;
>
> - it can be enabled right before the device leaves its idle state and disabled 
> when the device goes back to idle ; or
>
> - it can be enabled and disabled in a more fine-grained, device-specific 
> manner.
>
> The selected clock management granularity depends on constraints specific to 
> the device and on how aggressive power saving needs to be. Enabling the clocks 
> at probe time and disabling them at remove time is enough for most devices, 
> but leads to a high power consumption. For that reason the second clock 
> management scheme is often desired.
>
> Managing clocks manually in the driver is a valid option. However, when adding 
> runtime PM to the equation, and realizing that the clocks need to be enabled 
> in the runtime PM resume handler and disabled in the suspend handler, the 
> clock management code starts looking very similar in most drivers. We're thus 
> tempted to factorize it away from the drivers into a shared location.
>
> It's important to note at this point that the goal here is only to simplify 
> drivers. Moving clock management code out of the drivers doesn't (unless I'm 
> missing something) open the door to new possibilities, it just serves as a 
> simplification.

I disagree. Actually, it opens up the door to lots of new possibilities
that are crucial for fine-grained PM with QoS.  It is not just
simplification.  There are many good reasons that some SoCs have moved
all the management of PM-related clocks *out* of device drivers.  More
on that below...

> Now, as Grygorii mentioned, differences between how a given IP core is 
> integrated in various SoCs can make clock management SoC-dependent. In the 
> vast majority of cases (which is really what we need to target, given that our 
> target is simplifying drivers) SoC integration can be described as a list of 
> clocks that must be managed. That list can be common to all devices in a given 
> SoC, or can be device-dependent as well.

If we care about fine-grained PM, this is a way-too oversimplified
version of what SoC integragion means.

There are lots of pieces which fall under "SoC integration", for
example: clock domains, power domains, voltage domains, SoC-specific
wakeup capabilities, etc. etc.  Then, for fun throw in QoS constraints,
and things get really exciting.

IOW, if you care about fine-grained PM and QoS, you simply can't reduce
SoC integration down to "a list of clocks to be managed."

QoS makes this interesting as well because a device driver's decision to
gate its own clocks may have serious repercussions on the wakeup latency
of *other* devices in the same power domain.  For example, the clock
gating of the last active device in a powerdomain may cause the
enclosing power-domain to be power gated, having a major impact on the
wakup latency of *all* devices in that power domain.

So if we're going to manage the list of PM-related clocks in the device
driver, we'll also keep track of all the other devices in the same power
domain, whether or not they're active, whether or not they have QoS
constraints, etc. etc.  Hopefully you can see that we're quickly way
outside the scope of the IP block that the device driver is intended to
manage.

All of this is "SoC integration" knowledge, and IMO doen't belong in the
device drivers.  It belongs at the SoC integration level, and in todays
kernel frameworks that means pm_domain/genpd.

> Few locations can be used to express a per-device list of per-SoC clocks. We 
> can have clocks lists in a per-SoC and per-device location, per-device clocks 
> lists in an SoC-specific location, or per-SoC clocks lists in a device-
> specific location.
>
> The first option would require listing clocks to be managed by runtime PM in 
> DT nodes, as proposed by this patch set. I don't think this is the best 
> option, as that information is a mix of hardware description and software 
> policy, with the hardware description part being already present in DT in the 
> clocks property.

I'm not seeing which part you think is software policy here?  Which
clocks are driving which IP blocks is a hardware description.

Which clocks are actually gated, and if/when is software policy and
should be decided by the SoC-specific runtime PM and genpd
implementations, but describing which clocks are wired to which IP
blocks is certainly hardware description IMO.

> The second option calls for storing the lists in SoC code under arch/. As 
> we're trying to minimize the amount of SoC code there (and even remove SoC 
> code completely when possible) I don't think that's a good option.
>
> The third option would require storing the clocks lists in device drivers. I 
> believe this is our best option, as a trade-off between simplicity and 
> versatility. Drivers that use runtime PM already need to enable it explicitly 
> when probing devices. Passing a list of clock names to runtime PM at that 
> point wouldn't complicate drivers much. When the clocks list isn't SoC-
> dependent it could be stored as static information. Otherwise it could be 
> derived from DT (or any other source of hardware description) using C code, 
> offering all the versatility we need.

As is probably clear from above, I don't like this approach at all.

> The only drawback of this solution I can think of right now is that the 
> runtime PM core couldn't manage device clocks before probing the device. 
> Specifically device clocks couldn't be managed if no driver is loaded for that 
> device. I somehow recall that someone raised this as being a problem, but I 
> can't remember why.

The bigger drawback of this approach is that the device-drivers become a
repository for SoC integration details that IMO don't belong in a device
driver for a specific IP block.

Over the last few years, we've created abstractions for this kind of SoC
integration information (pm_domains) as well as frameworks for handling
much of the common parts (genpd) and in doing so, have been able to
remove PM-related clock management from device drivers altogether.

I think managing this stuff back in device drivers would be a major step
backwards.

Kevin
