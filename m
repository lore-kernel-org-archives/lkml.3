Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab3JKDzY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 23:55:24 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:56336 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab3JKDzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 23:55:23 -0400
MIME-Version: 1.0
In-Reply-To: <20131010105324.GA5105@n2100.arm.linux.org.uk>
References: <20131007051038.GA9764@localhost>
	<CA+55aFz85in-ntjF_VT4=kBoUrw1m8ON7xL-=431vQKL5oCMxQ@mail.gmail.com>
	<20131007083505.GA22585@localhost>
	<CA+55aFzknXawREZRBrr0Hs+crKt62fPf+S8SubJHXk84U8AFaw@mail.gmail.com>
	<CA+55aFyrDme-oNKe9=9vppct5+qCo4=Ug35np1fZiC1da64i_Q@mail.gmail.com>
	<20131008020918.GA1220@localhost>
	<20131008021452.GA6456@localhost>
	<20131008080625.GA25034@n2100.arm.linux.org.uk>
	<alpine.DEB.2.00.1310100322040.14436@skynet.skynet.ie>
	<20131010091920.GO25034@n2100.arm.linux.org.uk>
	<20131010105324.GA5105@n2100.arm.linux.org.uk>
Date: Fri, 11 Oct 2013 13:55:21 +1000
Message-ID: <CAPM=9twEehVg4JNqVrvEgCQ6R_0Saae0e9Gj2EsQSFviSywzEQ@mail.gmail.com>
Subject: Re: [xen] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
From: Dave Airlie <airlied@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Dave Airlie <airlied@linux.ie>, Fengguang Wu <fengguang.wu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 8:53 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, Oct 10, 2013 at 10:19:20AM +0100, Russell King - ARM Linux wrote:
>> On Thu, Oct 10, 2013 at 03:23:45AM +0100, Dave Airlie wrote:
>> >
>> > > I think David Arlie also needs a quiet talking to about how to use the
>> > > device model:
>> > >
>> > > int drm_sysfs_device_add(struct drm_minor *minor)
>> > > {
>> > >         minor->kdev.release = drm_sysfs_device_release;
>> > > ...
>> > >         err = device_register(&minor->kdev);
>> > > }
>> > >
>> > > static void drm_sysfs_device_release(struct device *dev)
>> > > {
>> > >         memset(dev, 0, sizeof(struct device));
>> > >         return;
>> > > }
>> > >
>> > > Since when has that been acceptable in a release function?
>> >
>> > Well the commit that added it had a reason that seems to cover some other
>> > device model abuses, so maybe someone who actually understands the device
>> > model (all 2 people) can review usage.
>>
>> Please - there's more than two people who understand this stuff.
>>
>> You appear to manage to understand the refcounting principle for things
>> like the DRM framebuffers, DRM buffer objects etc, and the driver model
>> (and kobjects in general) are no different.
>>
>> I've just been reading the code around here little more, and hit the usb
>> implementation.  I don't see how USB drivers get cleaned up when they're
>> disconnected from the USB bus.  I see drm_unplug_dev() which gets called
>> on a USB disconnection (from udl/udl_drv.c) which effectively makes the
>> device unavailable, but I don't see anything which frees anything.  I see
>> nothing calling drm_put_dev() here.  How does the drm_device in this case
>> get freed?
>
> Don't worry about the above - I've worked out how USB works in that regard.
> However, I can't say that I like the feel of the code in drm_unplug_dev()
> and drm_put_dev() - if these two can run simultaneously in two threads of
> execution, there's the chance that things will go awry.  I don't think
> that can happen due to the way the unplugged-ness is dealt with, but it
> doesn't "feel" safe.
>
> I think something like the below may address the issue - I've only build
> tested this so far.
>
> We have another case where DRM does the wrong thing here too - a similar
> thing goes on with connectors as well.  I've not yet looked into this,
> but I'll take a look later today.
>

Damn gmail screwed up my reply-all,

anyhoo I get the feeling I'd rather do this like fbdev does and stop using
an embedded kdev for this if I can. The lifetime of the minor and the sysfs
objects aren't necessarily that tied together esp with hot unplug of
USB devices.

e.g. when a USB device goes away I don't want the sysfs files to
remain hanging around,
or the userspace device nodes, however I can't remove all the internal
driver state until userspace finally closes all open device
files,

I think this is a bit of a bad misdesign of the whole device api that
sysfs exposure and device exposure is tied
to objects you are encourgaged to embed.

I think maybe I'll just copy fbdev and do a separate device_create
with a nonembedded dev.

Dave.
