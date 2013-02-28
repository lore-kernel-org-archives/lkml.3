Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785Ab3B1MUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 07:20:55 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:58757 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab3B1MUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 07:20:52 -0500
MIME-Version: 1.0
In-Reply-To: <CAPM=9tzDXLqUG3c6VsMjaJ_1997h7f+_3kB0C0N2imuQcXsD6Q@mail.gmail.com>
References: <1361123951-587-1-git-send-email-dh.herrmann@gmail.com>
	<CAPM=9txQtJ6FLFTEFr_Wi6RK=W9y3gKYxV_+zPCo6kLi4nM8eA@mail.gmail.com>
	<CANq1E4TTB-Lp+eVRPpzOMnS7XNbzHJRTicwCcwXw3AUs11XFMw@mail.gmail.com>
	<CAPM=9tzDXLqUG3c6VsMjaJ_1997h7f+_3kB0C0N2imuQcXsD6Q@mail.gmail.com>
Date: Thu, 28 Feb 2013 13:20:50 +0100
Message-ID: <CANq1E4QoutxRkuBj3p2vaw2U4-GN0Gz4ueopKkDavX_ZmgMC-w@mail.gmail.com>
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

Sorry, I was busy reworking the HIDP layer. I finally got time to
continue my work on this again. See below:

On Mon, Feb 18, 2013 at 12:47 AM, Dave Airlie <airlied@gmail.com> wrote:
[..snap..]
> As I said maybe I'm concentrating on the problem you aren't trying to fix,
> but then I'm not sure I've enough information on the problem you are
> trying to fix,
>
> remove_confilicting_framebuffers might be ugly but it does 90% of what we want,
> I just want to understand why this will make it better,

Ok, let me describe the problem in more detail:

We currently have different drivers that can make use of "system
framebuffers" (as I call them for now):
 - vgacon
 - fbdev
 - DRM
(- vgalog) (similar to fblog/drmlog but using vga/VBE)

Scenarios:
- Imagine you have CONFIG_FB=n but VGACON=y for debugging. Who is then
responsible of kicking out VGACON when DRM drivers are loaded? (and
vice versa)
- i915 is loaded and the user does a "modprobe vesafb". Who prevents
vesafb from loading?
- If I use vgalog, who unloads it when fbdev/DRM drivers are loaded?
(and vice versa)

Our current solution consists of "vgacon_cleanup()" and
"remove_conflicting_frambuffers()". We could add similar helpers for
all other scenarios, but I promise, this will get pretty complex.

Another problem: All VBE/EFI framebuffer drivers currently do something like:
  platform_driver_register("my-device"...);
  platform_device_add("my-device"...);
Why not provide a unique platform-device-name and add the device in
architecture setup code? This would prevent multiple drivers from
being probed on a single platform device.


My bus-solution was the most straightforward to implement and makes
testing really easy (as you can probe/remove drivers from userspace).
However, I understand if we don't want to introduce any ABI.

So I was rethinking this idea and maybe we simplify the bus-solution
and instead use some priority-based driver loading. That is, the
architecture code creates a platform-device for all available
system-framebuffers (which is probably always at most one device).
Then drivers simply provide platform-drivers that can be loaded on the
device. But instead of using platform_driver_register(), they use
vbe_driver_register() or something similar and pass in the
platform-driver _plus_ a priority. The wrapper then compares the
priorities, unloads the old driver and probes the new one.
This guarantees that a new driver will only replace the current driver
if it has a higher priority. vgacon/vgalog->fbdev->DRM

How does that fix the problems you described?
Well, it doesn't. But it makes them more obvious as there is now a
central place that manages the hand-over.
On the other hand, I don't understand why the problems you described
have anything to do with the hand-over itself? They also occur on
driver-unloading without any handover, don't they?
So I think we simply need to fix vesafb, efifb, ... to unmap any
pending user-space mappings during unloading. This also guarantees
that these mappings are dead when any other driver takes over. And
with the platform-devices that I want to introduce, we guarantee that
the drivers get unloaded correctly even during hand-over.

The remove_conflicting_framebuffers() call can stay for all other
conflicts, although I think these _really_ should be handled by
Kconfig. But ok, I don't mind this call. It doesn't break anything.


Why am I doing this?
To get dvbe/defi and vbelog working. I use these on my machine as
nouveau doesn't work and fbdev is just ugly to work with. I was also
told that they proved to be useful in virtualization environments.
I don't mind setting dvbe as "depends on !<any-drm-driver> &&
!CONFIG_FB && !CONFIG_VT" but I thought fixing this directly where it
is broken ought to be the better way.
So, any comments welcome.

If there are no major objections, I will try to implement it and also
try to fix vesafb to unmap the mmap()s during unloading. If that turns
out to work well, I can also fix the other drivers.

Thanks for the comments
David
