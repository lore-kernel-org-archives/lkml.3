Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab3KHSeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 13:34:13 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:51117 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161Ab3KHSeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 13:34:12 -0500
Message-ID: <527D2EA0.7060605@linaro.org>
Date: Fri, 08 Nov 2013 10:34:08 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        SH-Linux <linux-sh@vger.kernel.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Olof Johansson <olof@lixom.net>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 01/03] clocksource: Add Kconfig entries for CMT, MTU2,
 TMU and STI
References: <20131106110508.6806.48070.sendpatchset@w520>	<20131106110518.6806.79333.sendpatchset@w520>	<527B790B.4040200@linaro.org> <CANqRtoSn7=NeY2bSpacCXn6tKatn1S+CP3r-+mka91b0neJ4kw@mail.gmail.com>
In-Reply-To: <CANqRtoSn7=NeY2bSpacCXn6tKatn1S+CP3r-+mka91b0neJ4kw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2013 12:23 AM, Magnus Damm wrote:
> On Thu, Nov 7, 2013 at 8:27 PM, Daniel Lezcano
> <daniel.lezcano@linaro.org> wrote:
>> On 11/06/2013 12:05 PM, Magnus Damm wrote:
>>> From: Magnus Damm <damm@opensource.se>
>>>
>>> Add Kconfig entries for CMT, MTU2, TMU and STI to
>>> drivers/clocksource/Kconfig. This will allow us to
>>> get rid of duplicated entires in architecture code
>>> such as arch/sh and arch/arm/mach-shmobile.
>>>
>>> Signed-off-by: Magnus Damm <damm@opensource.se>
>>
>> Hi Magnus,
>>
>> we are preventing to have selectable timer from this Kconfig.
>>
>> You should select the timers from the arch Kconfig option.
> Thanks for your reply. In the case of ARM multiplatform this sounds
> like a good match, but I wonder what to do in the case of single
> platform ARM and the SH architecture. It would be nice to share the
> same Kconfig entries for both SH and all ARM variants.
>
> As you can see, in this series the Kconfig is shared between SH and
> ARM mach-shmobile. Actually, on those platforms we don't treat the
> timers any differently than any other device driver and traditionally
> we have been allowing the user to select which timer to use as system
> timer via the kernel configuration. What is the reason behind your
> suggestion with the arch Kconfig selection? It seems to me that timers
> are being treated differently than any other device driver, but I'm
> not sure why that is the case.

So to me clocksources/clockevents are different from any other device
driver, because they are *almost* always baked into the system, rather
then being like pci or usb devices, which cannot be assumed to exist. In
almost all cases the kernel builder has to enable some sort of board
specific config option which implies which clocksource/clockevent driver
should be enabled, so having a secondary config option (somewhere deeply
nested in the drivers menus, that really just frustrates folks trying to
get a board running) is unnecessary.

I know for some SoC maintainers, there's a desire to have config options
be this abstract "buckets of parts", which folks can put together some
random configuration and out will pop a kernel that supports some new
board wihtout any code change. And while I think this is easier to
manage from a developers point of view, I see it as really painful to
the folks trying to build kernels.

The vast majority of clocksource/clockevent hardware are architecture
specific, and this is why I originally objected to moving all the
clocksources (and then clockevents) out of arch/arm and into into
drivers/clocksource. And what I'd really like to avoid is having
something like the drivers/rtc directory, where it approaches something
like a collection of rtc-<sha1>.c files, and the kernel builder has to
go through a menu page of configuration options where almost none of
them apply to the architecture they're using.

So while I've given up sub-maintainership of the drivers/clocksource
directory to Daniel, I tried to impress that there should really be an
*outstanding* reason for any user-selectable clocksource/clockevent
configuration options that pop up under the drivers directory.


> Changing SH and ARM single/multi to select via the architecture
> Kconfig seems like a functional regression for single platforms to me.

Not sure I understand how this is a regression. Could you expand on this?

> It is also not really in line with TWD and architected timers that are
> today selectable via the ARM Kconfig. Say that I would like to develop
> code for a certain timer on a SoC with multiple timers, how can I make
> sure the right timer is used? Perhaps you propose relying on the
> clocksource and clockevent ratings?

So if there is a SoC with multiple timers, and there isn't a obviously
preferred one (which can be selected either statically or via the
ratings values), then I think it may be reasonable to have a
user-selected config, but I'd much prefer that config to live in the
architecture Kconfig, close to the other SoC specific options, where the
tradeoffs of the choice can be properly documented so the user has maybe
a chance to be able to make the right choice for their needs (rather
then telling them to dig through nested driver config menus and having
them select the right one of seven poorly documented options, where
really only 2 actually apply to the board).

This is starting to sound like a rant, and its all my personal opinion,
and I'm no longer maintining the directory, so I should probably stop
here. :)

But am I making any sense? Maybe there's a more clear way to express the
goal of the policy?

thanks
-john


