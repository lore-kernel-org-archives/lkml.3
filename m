Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219Ab3KLUsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 15:48:53 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:65157 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756743Ab3KLUrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 15:47:04 -0500
MIME-Version: 1.0
In-Reply-To: <CANqRtoQJYqBmDh1e-kA9_3ea-pp0J1Cx9Pr87HieYYfr7y435A@mail.gmail.com>
References: <20131106110508.6806.48070.sendpatchset@w520>
	<20131106110518.6806.79333.sendpatchset@w520>
	<527B790B.4040200@linaro.org>
	<CANqRtoSn7=NeY2bSpacCXn6tKatn1S+CP3r-+mka91b0neJ4kw@mail.gmail.com>
	<527D2EA0.7060605@linaro.org>
	<CANqRtoQJYqBmDh1e-kA9_3ea-pp0J1Cx9Pr87HieYYfr7y435A@mail.gmail.com>
Date: Tue, 12 Nov 2013 12:47:03 -0800
Message-ID: <CALAqxLVZdAs0V9ghA43VdP02+Rn=t4COZw_PRkZnWC=Q=OWLWA@mail.gmail.com>
Subject: Re: [PATCH v2 01/03] clocksource: Add Kconfig entries for CMT, MTU2,
 TMU and STI
From: John Stultz <john.stultz@linaro.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        SH-Linux <linux-sh@vger.kernel.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Olof Johansson <olof@lixom.net>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 4:26 AM, Magnus Damm <magnus.damm@gmail.com> wrote:
> On Sat, Nov 9, 2013 at 3:34 AM, John Stultz <john.stultz@linaro.org> wrote:
>> I know for some SoC maintainers, there's a desire to have config options
>> be this abstract "buckets of parts", which folks can put together some
>> random configuration and out will pop a kernel that supports some new
>> board wihtout any code change. And while I think this is easier to
>> manage from a developers point of view, I see it as really painful to
>> the folks trying to build kernels.
>
> I can somehow imagine that people may do that, but that's not really
> what I'm trying to here. I too would like a single defconfig that will
> work across a wide range of SoCs and their boards. At the same time I
> want to give people the ability to chose what they want to enable.

And your case may be one of those outstanding cases, which is fine. I
just want to make sure the policy is clear and enforced so we don't
just start adding config options for everything.

>> The vast majority of clocksource/clockevent hardware are architecture
>> specific, and this is why I originally objected to moving all the
>> clocksources (and then clockevents) out of arch/arm and into into
>> drivers/clocksource. And what I'd really like to avoid is having
>> something like the drivers/rtc directory, where it approaches something
>> like a collection of rtc-<sha1>.c files, and the kernel builder has to
>> go through a menu page of configuration options where almost none of
>> them apply to the architecture they're using.
>
> Regarding making timers into something that is really difficult for
> kernel builders, I too would like to avoid that. But having a
> reasonable defconfig will solve that, no?

I've had enough bad experiences with defconfigs that I don't trust
them.  And really, I see defconfigs as a really poor solution to the
problem. We have this expressive language in Kconfig to state
dependencies between configs and provide help documentation for each
option. But since folks tend to not to look at the bigger picture and
use those dependencies, they just add options for their code and call
it a day. So then folks start to rely on uncommented defconfigs to
provide those implicit dependencies.

To me It seems like the same rational could be made for providing a
directory of patches that users apply to the kernel tree depending on
which board they have. :) Why bother with configs and ifdefs at all!?

Hyperbole aside, I do get that for many cases, encoding the full
config dependency logic explicitly is really hard and would make for
very ugly Kconfigs. And I also understand defconfigs are a much easier
way to get by while things aren't perfect.  But at least for the
clocksource/clockevent directory, I'd push that we try to be better
and push to have patch submitters really put the effort in to do the
right thing.


> My experience is that many kinds of timer hardware is far from
> architecture specific. Most of the Renesas timer drivers can be used
> on both SH and ARM. I've seen similar things between 68k and PPC. I
> suspect that the x86 PIT is used pretty much everywhere. Those are all
> rather simple timers, when it comes to local timers for SMP then it of
> course starts getting more complicated.. In such case you probably
> want in in the arch directory, yes..

So for drivers that are *actually* shared between architectures, I
have less of a problem. That's why there was a generic
drivers/clocksource directory in the first place. The issue is that
folks are adding things that maybe-theoretically could be shared, but
actually aren't.

But again, even if the hardware is shared between arches, unless there
really is a compelling reason to make the user select an option, I
think it should be automatically selected by a platform config. (for
example, the ACPI PM timer is i368, x86_64, ia64..  but users
shouldn't have to chose it if they have already chosen to enable ACPI
on those arches - so no config option is needed).

>> So while I've given up sub-maintainership of the drivers/clocksource
>> directory to Daniel, I tried to impress that there should really be an
>> *outstanding* reason for any user-selectable clocksource/clockevent
>> configuration options that pop up under the drivers directory.
>
> I see. So I don't mind that much either way, I was asked to
> consolidate the kconfig and that's what I'm doing. I felt it was kind
> of natural to share the Kconfig entries for SH and ARM since the same
> drivers are used.

Again, no problem with the Kconfig entries being shared. I just want
to make sure users don't have to select what are in effect redundant
options. This can be done via platform configs selecting appropriate
clocksource/clockevent options, or by the clocksource/clockevent
options having clear dependencies and defaulting to y w/o a user
prompt.

> One thing that I mind is that I'd like the timer configuration to be
> consistent. I'd like to know what should be selected by the SoC and
> what is optional.
>
> Let me get back to the kernel configuration. Of course, it would be
> really nice if the kernel configuration was 100% fool proof, but what
> happens if the user doesn't compile-in certain parts? That hardware
> won't be used. What happens if wrong console device is passed on the
> kernel command line? The friendly answer is usually "don't do that".
>
> So in case of the serial console, no driver - no output. You can still
> use the network. If you have no timer then there won't be any timer
> ticks. You can still get to user space though, but don't try to rely
> on the timer. This CONFIG_TIMER=y/n case is pretty clear, but isn't
> there a grey zone too?

And on every new board, I have to fumble around with exactly those
sorts of no-serial output issues. Its never something I consider a
great use of my time :)

And your example is a little flawed have no timer ticks, you're not
getting to userspace. The system won't boot.

I'll admit there may be cases where there are gray zones w/ timers.
Much there are by far more black and white cases, so I want to policy
to be clear for those cases so the driver writers who best know the
black/white division can make the right call, and we don't end up with
a bunch of drivers that just seem to be in the grey zone because folks
didn't think about it.

Black and white case:
* hardware won't boot without the clocksource/clockevent driver, and
your hardware has a platform level config option
* Platform might boot w/ jiffies clocksource, but there is a highres
capable clocksource in the cpu design that every user would obviously
want.

Grey cases:
* Hardware supports clocksource/clockevent hardware from a PCI card or
other optional bus.

* Hardware has multiple clocksources, that run at vastly different
frequencies and wrap fairly quickly. Thus to extend low-power idle
times, the slow clocksource should be used, but if fine grained timing
is needed the faster clocksource should be used.

But even that grey case, I suspect having both drivers built in is the
right approach, allowing userspace to select the right clocksource for
the needs without having to rebuild a kernel.


> Regarding this grey timer area, for example have a look at the flag
> CLOCK_EVT_FEAT_C3STOP. The arch timer driver sets this flag, which
> means that with only arch timer the system can function as expected
> for most of the time. But if we try to use the high resolution timer
> with cyclictest then we get the error "WARNING: High resolution timers
> not available" unless another timer is installed as well. So for some
> parts of the kernel we need more than one timer. Where do you draw the
> line with select?

Well, my understanding is C3STOP means you have to have a secondary
broadcast timer to handle wakeups when you hit deep idle. So on that
platform you need to build two timers to get what I consider expected
behavior.

In general, It seems that enabling all the hardware on the system
(within reason) would be best if you weren't concerned with code size
issues (and that can be a reasonable concern), and most clockevent
drivers are fairly small.  But I think code size issues would be a
grey area where an option could make sense, but it needs to be clearly
explained that that is the reason and the code size delta is X kb and
obviously worth it.


> Also, like I mentioned before, some shared timers can already be
> controlled via the kernel configuration today. For instance, it is
> possible to control arch timer and TWD via the kernel configuration.
> How about them? I'd like to be able to control them via the kernel
> configuration since this makes it possible to test all parts of the
> system.

Testing is probably one of the arguments I don't have a good response
to. Arnd brought this up as well, since he wants to be able to do test
builds of all the ARM clocksource drivers from an x86 config (TEST ALL
OF THE BUCKETS OF PARTS!!! ;). Non-user prompt-able options could
effectively hide build issues, making it hard for folks who are doing
their testing on a limited set of systems to be able to catch compile
issues they might create on other arches.  Here we have to weigh the
cost to the new user against the utility to the all-yes-config testing
developer. Better cross tools, the zero-day build robot and other
approaches also help here. And maybe there can be some special Kconfig
option that lets the module be built without requiring a Kconfig user
prompt?


>>> Changing SH and ARM single/multi to select via the architecture
>>> Kconfig seems like a functional regression for single platforms to me.
>>
>> Not sure I understand how this is a regression. Could you expand on this?
>
> On SH we have platform devices pointing out several different timer
> channels using different drivers. Basically different timer channels
> that may be used are listed for each SoC. Zero or more of these timer
> drivers can be selected via kernel configuration. If you prefer low
> power operation then select a timer that operates on a 32Khz timer. If
> not, go with a MHz-range timer. How can this be selected without the
> kernel configuration?

This may be one of the few grey areas.

Some questions to help sort this out:
1) Is this best selected at build time? Would boot-time or even
runtime switching (as we can do w/ clocksources) be a better choice?
What is the actual cost of building the reasonable options together?

2) Is the power vs accuracy decision something that is shared between
all users of the driver, or just particular hardware?

3) Is the decision best made by a user under the Drivers -> Timers (or
whatever) submenu? Or closer to the platform selection?


>> So if there is a SoC with multiple timers, and there isn't a obviously
>> preferred one (which can be selected either statically or via the
>> ratings values), then I think it may be reasonable to have a
>> user-selected config, but I'd much prefer that config to live in the
>> architecture Kconfig, close to the other SoC specific options, where the
>> tradeoffs of the choice can be properly documented so the user has maybe
>> a chance to be able to make the right choice for their needs (rather
>> then telling them to dig through nested driver config menus and having
>> them select the right one of seven poorly documented options, where
>> really only 2 actually apply to the board).
>
> I think one underlying problem why we're not expressing all
> dependencies in Kconfig lingo is that it would be too verbose and
> heavy to point out in detail exactly which config options that apply
> on each platform. Now if there was some kind of tool available that
> could generate the kernel configuration based on one or more DT
> files.. Or generate dependencies for Kconfig based on DT.

I agree its not always easy to sort out the best solution with
Kconfig. But I think always handing users buckets of parts for them to
assemble because we couldn't be bothered to think about it a bit isn't
the right solution either. In many ways this mirrors the discussion
about userspace policy. Its easy to reflexively punt to userspace to
choose what to do, but quite often the kernel could pick a better sane
default. We just have to push for people to think about it a bit.

And there will always be exceptional cases where config options are
just the only reasonable way to support all that folks want to do. But
I want to make sure we don't just default to the "give the user the
option" case, when the option could logically conflict with other
choices already made.


> If I understand you correctly then your preferred choice here would be
> for us to move in the direction of using select for timers in case on
> ARM mach-shmobile. I think being standard is important, so following
> common practise in case of ARM makes sense.

Yea. And to some extent its a standard for clocksources/clockevent
drivers, since they are usually non-optional functionality.

>> This is starting to sound like a rant, and its all my personal opinion,
>> and I'm no longer maintining the directory, so I should probably stop
>> here. :)
>
> Well, without opinions we can't find a sensible direction, can we?
>
>> But am I making any sense? Maybe there's a more clear way to express the
>> goal of the policy?
>
> I think all your goals make sense, and I would like to reach the same
> place from a usability point of view. I would however like to allow
> existing power users to select whatever they want enabled on their
> platform. Ideally I also would like to share Kconfig bits between
> multiple architectures where appropriate, but it's just a few lines of
> code so I don't care that much.

And as long as the options for the power-users actually make sense,
that all sounds fine. But I want to make sure we aren't needlessly
causing pain to folks building kernels all to save a few lines of
Kconfig logic.

And again, this is just my pet peeve, I'm not the directory
submaintainer any more, so Daniel and Thomas are the ones to convince.
:)

thanks
-john
