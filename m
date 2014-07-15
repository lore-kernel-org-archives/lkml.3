Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027AbaGOHAd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 03:00:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47539 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757819AbaGOHA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 03:00:28 -0400
Message-ID: <53C4D17E.60206@redhat.com>
Date: Tue, 15 Jul 2014 09:00:14 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [BISECTED 3.16-rc REGREGRESSION] backlight control stopped working
References: <87pph8kse7.fsf@nemi.mork.no>	<53C3D7C3.7090505@redhat.com> <CA+55aFxYYKApOC+1TQkoxSzi-zTSB8OmkU=ypvNb_Gc2+K6Hmw@mail.gmail.com>
In-Reply-To: <CA+55aFxYYKApOC+1TQkoxSzi-zTSB8OmkU=ypvNb_Gc2+K6Hmw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/14/2014 06:24 PM, Linus Torvalds wrote:
> On Mon, Jul 14, 2014 at 6:14 AM, Hans de Goede <hdegoede@redhat.com> wrote:
>>
>> This *not* a regression, it is an intended behavior change [..]
> 
> That counts as a regression.
> 
> If things used to work, and they don't work, it's a regression. If
> it's intentional, that just makes it worse.

The problem is that our previous default behavior turns out to be
wrong for many users.

So as answered later in the thread Bjørn is using a custom setup with
acpid and WindowMaker. So in order to keep his exotic (and very simple
to fix) setup working we are keeping thing broken on what are probably
a 100 thousand Linux installs or more.

> 
>> Yes this may break existing configurations for some users, most likely
>> users running some custom setup, who thus should be able to fix things
>> by adding one more customization to there setup.
> 
> .. and apparently this whole paragraph is completely bogus. It *does*
> break things, and for normal people.

It breaks things on exotic setups, running a non standard desktop
environment or no desktop environment at all. Note that this is
about laptops most people will be using one of gnome / kde / unity /
xfce on a desktop, and for all of these the old default behavior is
bad.

> That's what the bug report is all about. So don't waffle about it.
> 
> Bjørn, what's your setup?
> Is this perhaps solvable some other way?

I see that further down the thread you've send a patch to fix
this by waiting sometime for userspace to react and if it does
not then do the change in the kernel as it used to be.

FWIW I don't think this is a good idea. This is inherently racy, so
we will still sometimes see the backlight taking 2 steps leading to
hard to debug problems.

It has made me think about doing something to keep both setups
like Bjørn's working, and get rid of the 2 steps problem. I think
adding an auto setting for brightness_switch_enabled and making that
the default is a good idea. But instead of using a timeout, I suggest
to make -1 / auto behave the same as 1 / on until userspace sets the
brightness. Once userspace has written to the brightness attribute
we start interpreting auto as 0 / off.

Rafael would you be willing to take a patch doing this ?

>> TL;DR: This change really is for the better and is here to stay.
> 
> Wrong. We don't break existing setups, and your attitude needs fixing.
> 
> Rafael, please get it reverted, or I will have to revert it. We have
> *long* had a rule that we don't break things "in order to improve
> things for others", and quite frankly, power management and ACPI in
> particular was exactly *why* that rule was introduced, because the
> whole "one step back, two steps forward" model does not work.
> 
> The problem needs to be solved some other way, and developers need to
> f*cking stop with the "we can break peoples setups" mentality./
> 
> Hans, seriously. You have the wrong mental model. Fix it.

Linus, normally I agree 101% with your no regressions policy. but I'm
also a big fan of the it just works philosophy. The problem here is
that when this switch got introduced a long time ago it got (in hindsight)
the wrong default. In order to make things just work it needs to get
fixed, but maybe we can come up with a solution to both have our cake
and eat it.

Regards,

Hans
