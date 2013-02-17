Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585Ab3BQXfo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 18:35:44 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:36703 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab3BQXfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 18:35:43 -0500
MIME-Version: 1.0
In-Reply-To: <CAPM=9txQtJ6FLFTEFr_Wi6RK=W9y3gKYxV_+zPCo6kLi4nM8eA@mail.gmail.com>
References: <1361123951-587-1-git-send-email-dh.herrmann@gmail.com>
	<CAPM=9txQtJ6FLFTEFr_Wi6RK=W9y3gKYxV_+zPCo6kLi4nM8eA@mail.gmail.com>
Date: Mon, 18 Feb 2013 00:35:41 +0100
Message-ID: <CANq1E4TTB-Lp+eVRPpzOMnS7XNbzHJRTicwCcwXw3AUs11XFMw@mail.gmail.com>
Subject: Re: [PATCH 0/9] System Framebuffer Bus (sysfb)
From: David Herrmann <dh.herrmann@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave

On Sun, Feb 17, 2013 at 11:02 PM, Dave Airlie <airlied@gmail.com> wrote:
>>
>> This series tries to fix the mess with global system framebuffer access in
>> device drivers. Currently, architecture initialization sets the "screen_info"
>> object according to the system framebuffer that was detected during boot. The
>> device driver that can map VMEM first gets access to it. There is no way to give
>> a specific driver access to the device and no _proper_ way to revoke access
>> again. In fact, some drivers don't even check whether they mapped the VMEM
>> successfully, letting multiple drivers to access the system framebuffer at the
>> same time.
>
> I'm unsure if I like this or not, and I don't see why its greatly more
> useful than the interface we have now.

This interface at least solves the problem with having vesafb,
uvesafb, vgacon, vga16fb, efifb, dvbe, defi and all other similar
drivers from accessing the system framebuffer simultaneously. And
provides a sane way of registering devices and drivers for it.

It also provides a way for real drivers to unload these drivers
(sysfb_claim()) instead of using remove_conflicting_framebuffers(),
which is horribly broken and has lots of race-conditions. (I tried
fixing the fbdev refcounting/locking, but every time I tried, some
driver broke because they worked around the bug. And fixing all
drivers is just a lot of work...).
And remove_conflicting_framebuffers() also doesn't work with
vgacon/etc. which do _not_ use fbdev.

We could simplify this approach by removing the bus and just providing
the platform-device for vbefb/etc. from the arch-code. But I thought
the bus-infrastructure allows nice rebinding of drivers if we need it
at almost no cost.

You could even register an oops/panic-screen as driver there and
switch to it if necessary.

> It doesn't solve the main problem with the current interface, which is
> that if somebody opens has vesafb /dev/fb0, mmaps it, and modprobes a
> real driver, things will fail either miserably or crappy from a users
> pov.
>
> The internal reference counts stop vesafb from unloading due to the
> mmaps, then i915 loads anyways and one bashes the other, or we fix so
> i915 doesn't load and the user gets fail.

It's not the mmap that prevents vesafb from unloading, it's the
open-file instead. If a user does open(), mmap(), close(), they can
still access the mapped memory but vesafb might get unloaded (this is,
in fact, used by several user-space apps). So it's not about whether
vesafb is still loaded, but rather what to do about users which have
vesafb mmaped but don't expect it to go away.

So what do you propose to detect this case? Keep track of every user
who mmap's vesafb? How can we detect when they unmap the memory? I
think the only way to detect this is to wait for the pages'
"mmap-count" to drop to zero and then release the memory.

So lets compare this to other subsystems. If you unlink a file that is
still mmaped, I think the file isn't removed from memory until the
last user unmaps it. However, the memory-mapping is 'dead' in that it
doesn't have any effect on real files.
So why not copy that behavior to framebuffers? When a real DRM driver
is loaded, simply reserve the VBE framebuffer-memory in VMEM until the
last user unmaps it. But mark it 'dead' so it doesn't really belong to
a _real_ framebuffer.
So any access to the mmap'ed framebuffers will be a no-op as it just
modifies 'dead' framebuffers.

Another idea is copying the VBE framebuffer into the DRM driver so all
old memory-maps are still valid. However, this prevents us from doing
any kind of mode-setting in the DRM driver until the last fbdev user
is gone (because there is no way to notify fbdev users of
mode-setting).
So in this case we are also stuck in a situation where we need to wait
for all users to unmap their framebuffers.

Any comments? If you have a plan on how it is supposed to work (or
what the user-space semantics should be), tell me and I will try to
make it work.
I still think a central system-framebuffer registry like sysfb-bus
(which does _not_ explicitly depend on fbdev) is the way to go.
Whether it's a bus or not is just a matter of taste. I am willing to
rework this.

Thanks
David
