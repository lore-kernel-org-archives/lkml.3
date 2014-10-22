Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932895AbaJVVPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 17:15:33 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:62245 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210AbaJVVPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 17:15:32 -0400
MIME-Version: 1.0
In-Reply-To: <20141017171756.GA22238@dtor-ws>
References: <5440F282.8040306@itdev.co.uk> <20141017171756.GA22238@dtor-ws>
From: Andrew de los Reyes <andrew-vger@gizmolabs.org>
Date: Wed, 22 Oct 2014 14:15:10 -0700
X-Google-Sender-Auth: NqPLsiIDKjh6xE3dBocBd5yIgLM
Message-ID: <CAG_cf+fop1bYe+82yDyDYX4sTkN4_gCBM=nvVyKwp6C8v6z4gQ@mail.gmail.com>
Subject: Re: Touch processing on host CPU
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Nick Dyer <nick.dyer@itdev.co.uk>, Greg KH <greg@kroah.com>,
        Jonathan Cameron <jic23@kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 10:17 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi Nick,
>
> On Fri, Oct 17, 2014 at 11:42:10AM +0100, Nick Dyer wrote:
>> Hi-
>>
>> I'm trying to find out which subsystem maintainer I should be talking to -
>> apologies if I'm addressing the wrong people.
>>
>> There is a model for doing touch processing where the touch controller
>> becomes a much simpler device which sends out raw acquisitions (over SPI
>> at up to 1Mbps + protocol overheads). All touch processing is then done in
>> user space by the host CPU. An example of this is NVIDIA DirectTouch - see:
>> http://blogs.nvidia.com/blog/2012/02/24/industry-adopts-nvidia-directtouch/
>>
>> In the spirit of "upstream first", I'm trying to figure out how to get a
>> driver accepted. Obviously it's not an input device in the normal sense. Is
>> it acceptable just to send the raw touch data out via a char device? Is
>> there another subsystem which is a good match (eg IIO)? Does the protocol
>> (there is ancillary/control data as well) need to be documented?
>
> I'd really think *long* and *hard* about this. Even if you will have the
> touch process open source you have 2 options: route it back into the
> kernel through uinput, thus adding latency (which might be OK, need to
> measure and decide), or go back about 10 years where we had
> device-specific drivers in XFree86 and re-create them again, and also do
> the same for Wayland, Chrome, Android, etc.
>
> If you will have touch processing in a binary blob, you'll also be going
> to ages "Works with Ubuntu 12.04 on x86_32!" (and nothing else), or
> "Android 5.1.2 on Tegra Blah (build 78912KT)" (and nothing else).

I think we have some interest on the Chrome OS team. We've often had
issues on touch devices with centroiding problems like split/merge,
and have thought it might be nice to have lower level access to be
able to actually solve these problems, rather than just complain to
the touch vendor. Historically, however, raw touch heatmaps have not
been available, making this idea unfeasible. Maybe this is starting to
change with the push from Nvidia!

I would agree with Dmitry that we would want a consistent unified
interface that could work with different touch vendors. I am assuming
that Nick's model is roughly 60-120 frames/sec, where each frame is
NxMx16bits. Pixels would generally be ~4mm on a side for touch sensors
today, but they may get significantly smaller if stylus becomes
popular. Nick, is that roughly what you have in mind? Also, touch
sensors generally have a baseline image that is subtracted from each
recorded raw image to form the delta image (ie, raw - baseline =
delta). Nick, do you envision sending raw or delta up to userspace? I
would assume delta, b/c I think the touch controller will need to
compute delta internally to see if there's a touch. It would be quite
wasteful to invoke the kernel/userspace on an image with no touches.
That said, there may be some situations (ie, factory validation) where
getting raw images is preferred.

Also, what about self-cap scan? I know some controllers will do
self-cap when there's just one finger. I'm guessing the data for such
a frame would be (N+M)x16bits.

In order to support X, Wayland, Android, etc, I would assume that
parsed frames would be injected back into the kernel in a format
similar (identical?) to MT-B. As far as the availability of an
open-source user-space driver to convert heat-map into MT-B, maybe I'm
overly optimistic, but I would guess we could start with something
simple like center-of-mass, and the community will help make it more
robust.

Sorry I have more questions than suggestions. Hopefully Nick can shed
more light on what type of interface he would like.

-andrew

>
> Thanks.
>
> --
> Dmitry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-input" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
