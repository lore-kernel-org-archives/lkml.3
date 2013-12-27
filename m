Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab3L0PX7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 10:23:59 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59331 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab3L0PX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 10:23:57 -0500
Date: Fri, 27 Dec 2013 16:23:55 +0100
From: Pavel Machek <pavel@ucw.cz>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Joe Xue <lgxue@hotmail.com>, "cooloney@gmail.com" <cooloney@gmail.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "rob@landley.net" <rob@landley.net>,
        "milo.kim@ti.com" <milo.kim@ti.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH] Add the LED burst trigger
Message-ID: <20131227152354.GA24152@amd.pavel.ucw.cz>
References: <1387895407-28031-1-git-send-email-lgxue@hotmail.com>
 <20131225230935.GB13593@amd.pavel.ucw.cz>
 <BLU172-W52032BFEF4512123D7516EACC20@phx.gbl>
 <20131227115746.4cbd9523@alan.etchedpixels.co.uk>
 <20131227125725.GA21506@amd.pavel.ucw.cz>
 <20131227141826.3fe406e4@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131227141826.3fe406e4@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2013-12-27 14:18:26, One Thousand Gnomes wrote:
> > At least nokia N900 actually has "hardware acceleration" for LED
> > blinking. (Tiny CPU connected over i2c, able to control 3 LEDs, turing
> > complete with something like 20 _bits_ of storage and 30 program
> > steps). Apparently, it makes more stable patterns (timing is very hard
> > to guarantee from userspace) and better power consumption (no need to
> > wake the CPU to blink the LEDs).
> > 
> > Now, wins from going userspace->kernel will not be too huge. But "If
> > the hardware can accelerate it, kernel should offer it even on
> > hardware that can not do it, for consistency".
> 
> Why ? My x86-64 box can run with 8GB processes, perhaps we should emulate
> 64bit on a 32bit kernel for consistency ?

Umm, you know that we can't really emulate 8GB processes. I believe
this is more like TCP; it could be done in userspace library, but it
is probably better in kernel.

But we already have perfectly good LED trigger system, including
"heartbeat" LED.

> It's another waste of resources - pages of memory that would cumulatively
> be vastly more efficiently used by user space. Yes the N800 might
> want a

Well, this one will be really smaller. And yes, it will make some
memory non-swappable, but I believe with triggers and infrastructure
for N900 (and similar) it will be worth it.

Plus, it will actually save CPU cycles, and thus significant power.

Lets see:

0) on N900, zero CPU wakeups.

1) in kernel: hw timer wakes up cpu, it toggles led, goes back to
sleep. (It might be even optimized not to wake the CPU all the way, as
in zaurus charging case)

2) in user space: hw timer wakes the cpu, switch to userland
application, something like 4 syscalls to write to /sys toggling the
LED (== 8 context switches). On otherwise idle arm system, it might be
factor of 2 in power, and well worth optimizing for.

> little driver but the rest belongs in a library and the library can use
> accelerators (of any kind) if available, or even things like lightbulbs
> via X10 so you can have the big red light in the control room flash if
> the machine dies  8)

Well, I'd prefer my cellphone to signal me "you have a message" by
flashing blue light, not by dimming lights in the control room ;-).

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
