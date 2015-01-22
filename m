Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753781AbbAVEVh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 23:21:37 -0500
Received: from leo.clearchain.com ([199.73.29.74]:29621 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbbAVEVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 23:21:30 -0500
Date: Thu, 22 Jan 2015 14:21:23 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: Henrik Rydberg <rydberg@bitmath.org>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Fixing touch point jumps in the kernel (was Re: [PATCH] MAINTAINERS:
 Update rydberg's addresses)
Message-ID: <20150122042123.GC23132@jelly.redhat.com>
References: <1418979967-2134-1-git-send-email-rydberg@bitmath.org>
 <CAN+gG=Gmgk+wKSnHkSAERoWt+1PqAojNSZt6jo=qmzPOqJs+3Q@mail.gmail.com>
 <54BED60C.3030303@bitmath.org>
 <20150121043520.GB17900@jelly.redhat.com>
 <54BFC4D3.6090607@bitmath.org>
 <CAN+gG=EUNk8AR4PR3qk8L05stx1jUEn9anA6xi+1Qjob00h_hg@mail.gmail.com>
 <54C00046.1000305@bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C00046.1000305@bitmath.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (mail.clearchain.com [127.0.0.1]); Thu, 22 Jan 2015 14:51:28 +1030 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

changed the subject so it'll be easier to find in the archives.

On Wed, Jan 21, 2015 at 08:38:46PM +0100, Henrik Rydberg wrote:
> Hi Benjamin,
> 
> > - there is a fragmentation problem: we would have to fix the bug in
> > xorg-synaptics (which is slowly waiting for its death), libinput,
> > ChromeOS, Qt Embedded, Kivy (I think), etc...
> 
> Indeed, this is the problem I wanted to highlight. As the fragmentation problem
> grows (graphics, input, compositors, toolkits), the need for a common
> denominator grows as well. However, I do not think the kernel should be the
> single common denominator for all the world's problems. Rather, the purpose of
> the kernel is to convey hardware information and control as accurately,
> effectively and generically as possible.
> 
> > - it means that the mt protocol B can not be relied upon, because even
> > if we state that each touch has its own slot, then it is false in this
> > case.
> 
> The case we are talking about is due to information missing in the hardware. At
> low enough sampling frequencies, there is no way to distinguish between a moving
> finger and a lift-and-press action. We could flag this hardware deficiency
> somehow, but making shit up in order to maintain the statue that we do have
> enough information is just asking for trouble.
> 
> I agree that this point is valid: we cannot always trust the interpretation of
> touchpoints for certain hardware. However, there is nothing we can do about
> that, except flag for it.
> 
> > Also, if you compare the libinput implementation of the handling of
> > the cursors jumps and the kernel implementation I proposed, there is a
> > big difference in term of simplicity.
> 
> No, this is wrong.
>
> > In the kernel, while we are assigning the tracking IDs, we detect that
> > there is a jump, and we "just" have to generate a new slot and close
> > the first (done by 1 assignment of -1 to the current tracking ID).
> 
> The kernel case would have to be accompanied by parameters, under the control of
> some user process, where adjustments are made to accomodate different usecases
> such as painting, gaming, air guitar playing, flick gestures, multi-user
> tablets, etc, etc. That is complex and unwanted.

from the testing I've done, you cannot trigger this except by lifting a
finger and raising a finger. There is no per-use-case requirement, it's a
hardware deficiency that the hardware simply cannot detect this specific
case of finger change.

Also, note that the patch series has an explicit "In order not to penalize
better sensors, this parameter is not automatically enabled, but each driver
has to manually set it to a reasonable value." so far we have only seen this
on synaptics touchpads which has its own driver. so this wouldn't affect any
device that doesn't need this anyway.

so yes, we could implement a better gesture recognition like you explain
below but it's also unneded on all but a few devices - which, in userspace,
we cannot identify easily.
 
> > In Libinput, well, you receive a slot, there is a jump, you detect it,
> > then you have to create a new fake kernel event to stop the current
> > slot, create a new one, and you then have to rewind the current state
> > of the buttons, the hysteresis, add special case handling and
> > hopefully, you did not introduced a bug in all the complex code. So
> > you need to write unit tests (not an argument, I concede, but this is
> > extra work), and in the future, someone will not understand what this
> > is all about because the kernel should guarantee that the slots are
> > sane.
> 
> You do not need to do any of this (except the test cases, which would be needed
> anyway given the context-dependent interpretation of scarse data) if you
> intercept the touch points as they come in from the kernel, before the contact
> dynamics is fully trusted. Last time I checked that was mtdev or the touch frame
> layer or Xinput.

mtdev is only used for protocol A devices these days so it doesn't apply on
the synaptics pads.

I was thinking of adding this to libevdev so at least _I_ only have to
implement this once. except that for every touchpoint that I fix up in
libevdev I then also have to maintain a correct tracking_id mapping since
now the kernel and the userspace tracking IDs are out of sync.

that leaves synaptics which for historical reasons can handle a device state
but is bad at transitions. Injecting events requires a rewrite of much of
the code. evdev - not as bad but similar. Since this only affects synaptics
pads so far at least we don't have to worry about other drivers (in xorg at
least).

> > If I were grumpy (and I can be, ask Peter), I would say that sure, we
> > can add such a case in the mtdev library, but the point of having the
> > in-kernel tracking system was to slowly get away from the head over
> > added by mtdev.
> 
> No, this was not the reason. The tree main reasons were actually latency and
> power and code reduction. The mtdev layer still provides the functional bridge
> needed. However, the latency and number of cpu cycles involved in transferring
> the data to userland before throwing most of it away were much reduced by adding
> the in-kernel tracking. Collecting the diversity of solutions for older hardware
> was a maintainability bonus.
> 
> Regarding the practical problem at hand, that double taps sometimes get
> misinterpreted as a "flash move", perhaps the problem really is in how we define
> a double tap.
> 
> When I was writing a certain gesture engine, I realized I got issues with
> multi-finger taps. In my case the problem was not due to misinterpreted finger
> data, but simply because pressing four fingers simultaneously is not easy, and
> really not needed in order to define the gesture per se. So in order to
> correctly interpret gestures, I had to involve time in various ways; checking
> for overlaps between fingers over a short time span, looking for the maximum
> number of fingers within a certain timespan, etc. Not to mention palm detection;
> in this context, the individual touch points really lose some meaning.
> 
> The double tap is no different in this regard. Nor is a flash move. But we would
> not want a real flash move to be interpreted as double tap, would we?
> 
> My point is that the gesture context is where the ultimate decision can best be
> made - where there is enough information to best approximate what the imperfect
> hardware is trying to tell us. If the time between touch down and a fast
> movement to a nearby point is consistent with a tap, then maybe it is a tap.

again, you cannot trigger this by moving. or at least if you do your
pointer would be in the bottom right corner anyway because you have to move
the finger so insanely fast that pointer control is clearly not in the
picture anymore. but you can trigger it 1 out of 3 times by lifting your
finger from the touchpad while trying to click a button with your thumb.
right now this means that those touchpads are virtually unsuable (this is a
common interaction method).

and, again: this is a solution for one specific set of devices.

Cheers,
   Peter
