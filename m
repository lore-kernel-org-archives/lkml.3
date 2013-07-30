Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929Ab3G3U7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 16:59:30 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:49511 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756991Ab3G3U72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 16:59:28 -0400
MIME-Version: 1.0
In-Reply-To: <3453253.oZLO1ChPbL@vostro.rjw.lan>
References: <1375125658-1223-1-git-send-email-felipe.contreras@gmail.com>
	<51F7546C.9030901@gmail.com>
	<51F755E3.8040706@gmail.com>
	<3453253.oZLO1ChPbL@vostro.rjw.lan>
Date: Tue, 30 Jul 2013 15:59:26 -0500
Message-ID: <CAMP44s02V_FO1BPJZqo6MB9RMknXYdV7AXDqbJzYHpgK1GUuJw@mail.gmail.com>
Subject: Re: [REGRESSION/PATCH] acpi: blacklist win8 OSI for ASUS Zenbok Prime UX31A
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Aaron Lu <aaron.lwe@gmail.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 8:42 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, July 30, 2013 01:57:55 PM Aaron Lu wrote:
>> On 07/30/2013 01:51 PM, Aaron Lu wrote:
>> > On 07/30/2013 11:44 AM, Felipe Contreras wrote:
>> >> On Mon, Jul 29, 2013 at 10:11 PM, Aaron Lu <aaron.lwe@gmail.com> wrote:
>> >>> On 07/30/2013 03:20 AM, Felipe Contreras wrote:
>> >>>> Since v3.7 the acpi backlight driver doesn't work at all on this machine
>> >>>> because presumably the ACPI code contains stub code when Windows 8 OSI is
>> >>>> reported.
>> >>>>
>> >>>> The commit ea45ea7 (in v3.11-rc2) tried to fix this problem by using the intel
>> >>>> backlight driver, however, on this machine it turns the backlight completely
>> >>>> off when it reaches level 0%, after which the user might have a lot trouble
>> >>>> trying to bring it back.
>> >>>
>> >>> What do you mean by a lot of trouble? If you press hotkey to increase
>> >>> backlight brightness level, does it work?
>> >>
>> >> I guess so, *if* there is indeed a user-space power manager handling
>> >> that, *and* the keyboard has such keys, *or* the user has set custom
>> >> hotkeys.
>> >
>> > Right, for a GUI environment this may not be a big problem(user uses Fn
>> > key to decrease brightness level and then hit the black screen, it's
>> > natural he will use Fn key to increase brightness level).
>> >
>> >>
>> >>> If so, the screen should not
>> >>> be black any more, it's not that user has to blindly enter some command
>> >>> to get out of the black screen.
>> >>>
>> >>> And I'm not sure if this is a bug of intel_backlight(setting a low level
>> >>> makes the screen almost off), I see different models with different
>> >>> vendors having this behavior.
>> >>
>> >> I mean, the screen is completely off, I cannot see absolutely
>> >> anything. I don't see this behavior with the ACPI backlight driver,
>> >> nor do I see that in Windows 7.
>> >>
>> >>> If this is deemed a bug, then I'm afraid
>> >>> intel_backlight interface is useless for a lot of systems...perhaps we
>> >>> can only say, intel_backlight's interpretation of low levels are
>> >>> different with ACPI video's, and that's probably why its type is named
>> >>> as raw :-)
>> >>
>> >> Well, a bug is defined as unexpected behavior -- as a user, if I'm
>> >> changing the brightness of the screen, I certainly don't expect the
>> >> screen to turn off, and I think that's the expectation from most
>> >> people. It's the first time I see something like that.
>> >
>> > I agree this is kind of un-expected. At the same time, this seems to be
>> > the normal behavior for intel_backlight. I don't know what the correct
>> > thing to do here if this is something we want to avoid - modify intel
>> > backlight handling code not to set too low value or change the user
>> > space tool not to set a too low value if they are interacting with a
>> > raw type interface. Neither of them sounds cool... Or, users may get
>> > used to it, I for example, don't find this to be very annoying, but
>> > maybe I'm already used to it.
>>
>> BTW, for the complete screen off problem, I don't see there is anything
>> wrong with it from code's point of view. It's not that there is an error
>> in code or this is a broken hardware that caused the screen off when
>> setting a very low or 0 brightness level, it is simply the expected
>> behavior of what this interface can provide. It can really set the
>> brightness level to minimum(zero) or maximum. Don't get me wrong, I
>> didn't mean this is a good user experience, I don't know that. I just
>> don't think this is a program bug, and I don't know if this should be
>> fixed or not - obviously this interface did what it is asked to do,
>> correctly.
>
> Precisely, user space asks for 0 and the kernel delivers.
>
> And there are reasons why 0 should be "screen off", like power management
> (when you have a policy to dim the screen completely after a period of
> inactivity, for example).

There is another interface the turn the screen off.

If 0 turns the screen off with the intel driver, 0 should turn the
screen off with the ACPI driver, having inconsistent behavior
depending on which driver is used is a bug.

If 0 did not turn off the screen in v3.10, 0 should not turn off the
screen in v3.11, to do so would be a *regression*.

> So in my opinion, if that's a problem for anyone, it has to be addressed in
> user space and if there are any vendors who try to address *that* in their ACPI
> tables, that's one more reason to avoid using ACPI for backlight control.

If you think it's the user-space responsibility to deal with kernel
bugs, I think it's only a matter of time before you receive one of
these [1].

"If a change results in user programs breaking, it's a bug in the
kernel. We never EVER blame the user programs. How hard can this be to
understand?"

"WE DO NOT BREAK USERSPACE!"

[1] https://lkml.org/lkml/2012/12/23/75

-- 
Felipe Contreras
