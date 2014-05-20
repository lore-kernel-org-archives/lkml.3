Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751147AbaETViv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 17:38:51 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:48611 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750815AbaETVit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 17:38:49 -0400
Message-ID: <537BCB63.1020200@logitech.com>
Date: Tue, 20 May 2014 14:38:43 -0700
From: Roland Bosa <rbosa@logitech.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Michal_Mal=FD?= <madcatxster@devoid-pointer.net>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, jkosina@suse.cz, elias.vds@gmail.com,
        anssi.hannula@iki.fi, simon@mungewell.org
Subject: Re: [PATCH v4 01/24] input: Add ff-memless-next module
References: <1398524543-15012-1-git-send-email-madcatxster@devoid-pointer.net> <2965006.XKYHWj9YzJ@sigyn> <537B9FAE.9070602@logitech.com> <10859911.6zyzadbfH9@sigyn>
In-Reply-To: <10859911.6zyzadbfH9@sigyn>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 12:00 PM, Michal Malý wrote:
> Hi,
> 
> "ff-memless-next" was designed with behavior of Logitech devices in mind, 
> however it was always meant as a general replacement for the current "ff-
> memless". After some followup discussion it's unlikely that it will be 
> mainlined in its current form. See the discussion here 
> "http://www.spinics.net/lists/linux-input/msg31426.html" for more details.
> 
> We would however really appreciate some information regarding Logitech devices 
> specifically. Although we have reverse engineered most of things, I believe 
> there are still areas we're not entirely clear about. I realize that you'd 
> probably have to take it up with the legal deparment but if someone at 
> Logitech could at least take a look at what we've found so far at fill in the 
> blanks it'd be most helpful.

I'm your guy, then. Please send any questions my way and I'll dig out
the information you need - with the lawyer's blessings, if need be.

> Please note that we found numerous bugs and DirectInput specs violations in 
> the Windows driver which might have impacted our understading of how the 
> driver works. "ff-memless-next" and "lg4ff" tries to fix or work around these. A 
> link to out-of-tree update to lg4ff which takes full advantage of "ff-memless-
> next" is also provided in this thread.

lg4ff is mostly wheels, from what I saw. We should be able to fold in
the G940 (Flight System) as well as other joysticks into the same
driver. The underlying model driving the forces of our devices is
essentially the same, there are just slight improvements made over the
years to accommodate higher resolutions and more powerful micro processors.

Each device has a unique number (say 2 or 4) of force 'slots' per axis,
which is running a force calculation in firmware. Typically, one of
these slots is allocated by the host driver for a constant force, that's
streamed to the device (and comprises all constant and periodic forces
sent by the 'game' - that's the combined type of your code, as far as I
can tell). The other slot may be used for position-based effects
(springs, centering spring) as well as velocity-based effects (dampers,
friction) - that's the un-combinable type. There's a healthy amount of
code in the Windows driver that you would call 'quirks' which deals with
deciding how to allocate multiple springs and dampers to a single slot.
Sometimes, even the springs and dampers are being streamed in via the
constants force, but that requires (as you pointed out earlier) a fast
update rate and some "smartness" (I'm getting in hot territory with the
lawyers now - let me stop).

One of the key features of the design is the decoupling of the USB
updates from the force feedback IOCTL's from the 'game'. I don't think
this is currently the case with today's drivers. I was able to send
force updates to a gamepad faster than the USB update rate, which led to
some lost packets which in turn left the device in a inconsistent state
- the motors were still rumbling although they should have stopped. If
the 'ff-memless-next' driver offers this decoupling, it is a step in the
right direction, IMO.

I will try to apply the patch mentioned in this thread and see where it
leads me...

Thanks
roland

