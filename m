Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934603AbaGPQOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 12:14:43 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:64700 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965325AbaGPQOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 12:14:41 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1407161006260.1028-100000@iolanthe.rowland.org>
References: <20140716013206.GA13409@google.com>
	<Pine.LNX.4.44L0.1407161006260.1028-100000@iolanthe.rowland.org>
Date: Wed, 16 Jul 2014 09:14:40 -0700
Message-ID: <CAE_wzQ82xsuDQrw8Q6auoG9fowr4VZkcUgciPXe2s9PTAmJ=RA@mail.gmail.com>
Subject: Re: Power-managing devices that are not of interest at some point in time
From: Dmitry Torokhov <dtor@google.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Patrik Fimml <patrikf@chromium.org>, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Benson Leung <bleung@google.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Wed, Jul 16, 2014 at 7:17 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 15 Jul 2014, Patrik Fimml wrote:
>
>> (Re-sending with correct mailing list addresses.)
>>
>> Hi,
>>
>> When the lid of a laptop is closed, certain devices can no longer
>> provide interesting input or will even produce bogus input, such as:
>>
>> - input devices: touchscreen, touchpad, keyboard
>
> Just to be clear: The laptop's internal keyboard can't be used, but
> external keyboards can.  The same goes for touchscreens and touchpads.

Right, we are talking about internal keyboards here, although there
are other scenarios where userspace may want to inhibit certain
devices. I think the common pattern with phones is to disable
touchscreen while phone is held close to your ear to avoid accidental
gestures.

>
>> - sensors: ambient light sensor, accelerometer, magnetometer
>
> Why can't the accelerometer or magnetometer be used when the lid is
> closed?

It may or it may not, it depends on the application.

>
>> - a video camera mounted on the lid
>> - display backlight
>
> I can think of one possible use for a video camera mounted inside the
> lid.  It's the modern analog of the age-old question: Does the
> refrigerator light go out when the door is closed?  Using the video
> camera, users will be able to check whether the display backlight goes
> out when the lid is closed.  :-)

;) The most common case though is not to use such device (or not
present it to user/upper layers). When you are about to start video
chat you do not want to have your integrated camera be first in the
list of devices to be used when your lid is closed.

>
>> Various workarounds cover some of these cases, and we have some ugly
>> hacks in ChromeOS to make things work. It would be nice if a userspace
>> power management daemon could listen to the lid-close event, and then
>> have a way to temporarily power off these devices, potentially through
>> sysfs.
>
> Isn't it common for laptops to go into system suspend when the lid is
> closed?

Not necessarily, depends on user/policy and that is what we want
userspace to be able to define. I'd say we expect laptop to go to
system suspend when you close lid while undocked. If laptop is docked
then I just want to shut off screen and make my external monitor
primary one.

>
>> I've been discussing this with Dmitry and Benson (cc'd), and we've been
>> wondering whether we could come up with a generic solution that could
>> benefit multiple device classes.
>>
>> There's some overlap with runtime PM here. The action to be taken in
>> such a situation would probably be similar to a runtime suspend. The
>> match is not perfect though, since devices with more than two power
>> states might want to enter different states depending on the situation.
>>
>> It's somewhat difficult to get the semantics right, since handles to
>> such devices might still be open. It might be easier to implement
>> behavior specific to device classes. On the other hand, it would be nice
>> to have a uniform way of shutting devices down, and not introduce
>> another possible path for a device to enter a power-saving state.
>
> What's the difference between shutting a device down and entering a
> power-saving state?  That is, why shouldn't the first be considered an
> example of the second?
>
> The general design of Linux's runtime PM is that the PM core tells
> drivers when their devices are no longer being used, and it's up to the
> driver to select an appropriate low-power state.  That philosophy
> doesn't fit well with the problem you want to solve, because you want
> to turn off devices even when they _are_ still in use.

This does not sound quite right to me. We can tell PM core when
devices absolutely can not go to low power mode, but certain devices
can go into lower power state and wake up themselves even if there are
users: i.e. mice and keyboards with autosuspend. I guess it depends
what you define as being "in use".

>
> A separate sysfs interface might work out better.
>

I am not so much concerned about userspace, but about reusing of as
much of existing PM framework in the drivers. Right now it is very
hard to correctly track dependencies between general open/close,
system suspend/resume, and various runtime-PM transitions. Adding yet
another PM mechanism into the mix will just add more complexity.

Thanks,
Dmitry
