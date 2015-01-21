Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbbAUQYD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:24:03 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:50478 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbbAUQYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:24:00 -0500
MIME-Version: 1.0
In-Reply-To: <54BFC4D3.6090607@bitmath.org>
References: <1418979967-2134-1-git-send-email-rydberg@bitmath.org>
	<CAN+gG=Gmgk+wKSnHkSAERoWt+1PqAojNSZt6jo=qmzPOqJs+3Q@mail.gmail.com>
	<54BED60C.3030303@bitmath.org>
	<20150121043520.GB17900@jelly.redhat.com>
	<54BFC4D3.6090607@bitmath.org>
Date: Wed, 21 Jan 2015 11:23:59 -0500
Message-ID: <CAN+gG=EUNk8AR4PR3qk8L05stx1jUEn9anA6xi+1Qjob00h_hg@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Update rydberg's addresses
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@bitmath.org>
Cc: Peter Hutterer <peter.hutterer@who-t.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 10:25 AM, Henrik Rydberg <rydberg@bitmath.org> wrote:
> Hi Peter,
>
>> it wasn't the first reaction. it was the third, after we hacked up
>> synaptics [1], then libinput [2], both rather unsatisfactory. Not sure what
>> chromeos does but they'll probably would need similar code. And any other
>> users of the evdev API of course.
>
> So if this approach did not work very well in userland, why would it work any
> better in the kernel?
>

I would have thought that Peter's answer was clear enough:
- there is a fragmentation problem: we would have to fix the bug in
xorg-synaptics (which is slowly waiting for its death), libinput,
ChromeOS, Qt Embedded, Kivy (I think), etc... We can do it, to some
extend, but we will have to explain the following to our users:
- it means that the mt protocol B can not be relied upon, because even
if we state that each touch has its own slot, then it is false in this
case. This was Peter last point.

Also, if you compare the libinput implementation of the handling of
the cursors jumps and the kernel implementation I proposed, there is a
big difference in term of simplicity.

In the kernel, while we are assigning the tracking IDs, we detect that
there is a jump, and we "just" have to generate a new slot and close
the first (done by 1 assignment of -1 to the current tracking ID).

In Libinput, well, you receive a slot, there is a jump, you detect it,
then you have to create a new fake kernel event to stop the current
slot, create a new one, and you then have to rewind the current state
of the buttons, the hysteresis, add special case handling and
hopefully, you did not introduced a bug in all the complex code. So
you need to write unit tests (not an argument, I concede, but this is
extra work), and in the future, someone will not understand what this
is all about because the kernel should guarantee that the slots are
sane.

If I were grumpy (and I can be, ask Peter), I would say that sure, we
can add such a case in the mtdev library, but the point of having the
in-kernel tracking system was to slowly get away from the head over
added by mtdev.

Cheers,
Benjamin
