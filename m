Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab3BQXrL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 18:47:11 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:60166 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab3BQXrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 18:47:09 -0500
MIME-Version: 1.0
In-Reply-To: <CANq1E4TTB-Lp+eVRPpzOMnS7XNbzHJRTicwCcwXw3AUs11XFMw@mail.gmail.com>
References: <1361123951-587-1-git-send-email-dh.herrmann@gmail.com>
	<CAPM=9txQtJ6FLFTEFr_Wi6RK=W9y3gKYxV_+zPCo6kLi4nM8eA@mail.gmail.com>
	<CANq1E4TTB-Lp+eVRPpzOMnS7XNbzHJRTicwCcwXw3AUs11XFMw@mail.gmail.com>
Date: Mon, 18 Feb 2013 09:47:07 +1000
Message-ID: <CAPM=9tzDXLqUG3c6VsMjaJ_1997h7f+_3kB0C0N2imuQcXsD6Q@mail.gmail.com>
Subject: Re: [PATCH 0/9] System Framebuffer Bus (sysfb)
From: Dave Airlie <airlied@gmail.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I'm unsure if I like this or not, and I don't see why its greatly more
>> useful than the interface we have now.
>
> This interface at least solves the problem with having vesafb,
> uvesafb, vgacon, vga16fb, efifb, dvbe, defi and all other similar
> drivers from accessing the system framebuffer simultaneously. And
> provides a sane way of registering devices and drivers for it.

But do we have the problem now? or is it more when we get dvbe/defi?

Also vgacon is kinda different since fbcon kicks it off, not a driver,

> It also provides a way for real drivers to unload these drivers
> (sysfb_claim()) instead of using remove_conflicting_framebuffers(),
> which is horribly broken and has lots of race-conditions. (I tried
> fixing the fbdev refcounting/locking, but every time I tried, some
> driver broke because they worked around the bug. And fixing all
> drivers is just a lot of work...).
> And remove_conflicting_framebuffers() also doesn't work with
> vgacon/etc. which do _not_ use fbdev.

but vgacon is always kicked off by fbcon, so I'm not sure what etc there
is apart from it. I'd like to make fbcon a bool as well, so we don't
have to deal with it appearing after the drivers.

> We could simplify this approach by removing the bus and just providing
> the platform-device for vbefb/etc. from the arch-code. But I thought
> the bus-infrastructure allows nice rebinding of drivers if we need it
> at almost no cost.

I suspect a platform device is the right answer, since vesafb is that,

I think we should resolve vesafb vs dvbe by just making them not
config compatible, and dvbe vs defi seems like the same solution
as vesafb vs efi.

I'm just trying to work out what exactly you are fixing here, the
problems we have now don't seem to be addressed by this, if
it addresses future problems then it needs to be more upfront.

>> It doesn't solve the main problem with the current interface, which is
>> that if somebody opens has vesafb /dev/fb0, mmaps it, and modprobes a
>> real driver, things will fail either miserably or crappy from a users
>> pov.
>>
>> The internal reference counts stop vesafb from unloading due to the
>> mmaps, then i915 loads anyways and one bashes the other, or we fix so
>> i915 doesn't load and the user gets fail.
>
> It's not the mmap that prevents vesafb from unloading, it's the
> open-file instead. If a user does open(), mmap(), close(), they can
> still access the mapped memory but vesafb might get unloaded (this is,
> in fact, used by several user-space apps). So it's not about whether
> vesafb is still loaded, but rather what to do about users which have
> vesafb mmaped but don't expect it to go away.

In theory we'd have to do like GEM/TTM, and unmap_mapping_range for
all the open fd's mmaps and just point them to map something useless
or even just return -EFAULT, because really userspace needs to be told
something :-)

> So what do you propose to detect this case? Keep track of every user
> who mmap's vesafb? How can we detect when they unmap the memory? I
> think the only way to detect this is to wait for the pages'
> "mmap-count" to drop to zero and then release the memory.
>
> So lets compare this to other subsystems. If you unlink a file that is
> still mmaped, I think the file isn't removed from memory until the
> last user unmaps it. However, the memory-mapping is 'dead' in that it
> doesn't have any effect on real files.
> So why not copy that behavior to framebuffers? When a real DRM driver
> is loaded, simply reserve the VBE framebuffer-memory in VMEM until the
> last user unmaps it. But mark it 'dead' so it doesn't really belong to
> a _real_ framebuffer.
> So any access to the mmap'ed framebuffers will be a no-op as it just
> modifies 'dead' framebuffers.
>
> Another idea is copying the VBE framebuffer into the DRM driver so all
> old memory-maps are still valid. However, this prevents us from doing
> any kind of mode-setting in the DRM driver until the last fbdev user
> is gone (because there is no way to notify fbdev users of
> mode-setting).
> So in this case we are also stuck in a situation where we need to wait
> for all users to unmap their framebuffers.

It all kinda sucks, from the problems we've had previously with things
like plymouth
racing, (which all this will make much worse if we have kms vbe devices) really
what we want the system to do is give the user the proper driver asap, stalling
waiting for endless other things to let go is just going to screw
users, so I think
we need to be as upfront and brutal in the userspace interface if people mmaping
vesafb or efifb or any generic interface then expect to load a real driver, then
their old apps get killed.

> Any comments? If you have a plan on how it is supposed to work (or
> what the user-space semantics should be), tell me and I will try to
> make it work.
> I still think a central system-framebuffer registry like sysfb-bus
> (which does _not_ explicitly depend on fbdev) is the way to go.
> Whether it's a bus or not is just a matter of taste. I am willing to
> rework this.

As I said maybe I'm concentrating on the problem you aren't trying to fix,
but then I'm not sure I've enough information on the problem you are
trying to fix,

remove_confilicting_framebuffers might be ugly but it does 90% of what we want,
I just want to understand why this will make it better,

Dave.
