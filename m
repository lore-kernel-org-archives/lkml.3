Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab3DRNSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 09:18:51 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:60917 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641Ab3DRNSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 09:18:50 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1304171605010.19898@winds.org>
References: <alpine.LNX.2.00.1304171605010.19898@winds.org>
Date: Thu, 18 Apr 2013 15:18:49 +0200
Message-ID: <CANq1E4RGD+8QNAin+A-MZWAiqhLLvH+zG+gfhi7Vd6bYOuV75A@mail.gmail.com>
Subject: Re: Standalone DRM application
From: David Herrmann <dh.herrmann@gmail.com>
To: Byron Stanoszek <gandalf@winds.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Wed, Apr 17, 2013 at 11:05 PM, Byron Stanoszek <gandalf@winds.org> wrote:
> David,
>
> I'm developing a small application that uses libdrm (DRM ioctls) to change
> the
> resolution of a single graphics display and show a framebuffer. I've run
> into
> two problems with this implementation that I'm hoping you can address.
>
>
> 1. Each application is its own process, which is designed to control 1
> graphics
> display. This is unlike X, for instance, which could be configured to grab
> all
> of the displays in the system at once.
>
> Depending on our stackup, there can be as many as 4 displays connected to a
> single graphics card. One process could open /dev/dri/card0 and call
> drmModeSetCrtc() to initialize one of its displays to the requested
> resolution.
> However, whenever a second process calls drmModeSetCrtc() to control a
> second
> display on the same card, it gets -EPERM back from the ioctl.
>
> I've traced this down to the following line in
> linux/drivers/gpu/drm/drm_drv.c:
>
> DRM_IOCTL_DEF(DRM_IOCTL_MODE_SETCRTC, drm_mode_setcrtc,
> DRM_MASTER|DRM_CONTROL_ALLOW|DRM_UNLOCKED),
>
> If I remove the DRM_MASTER flag, then my application behaves correctly, and
> 4
> separate processes can then control each individual display on the card
> without
> issue.
>
> My question is, is there any real benefit to restricting drm_mode_setcrtc()
> with DRM_MASTER, or can we lose this flag in order to support
> one-process-per-
> display programs like the above?

Only one open-file can be DRM-Master. And only DRM-Master is allowed
to perform mode-setting. This is to prevent render-clients (like
OpenGL clients) to perform mode-setting, which should be restricted to
the compositor/...

In your scenario, you should share a single open-file between the
processes by passing the FDs to each. Or do all of that in a single
process. There is no way to split CRTCs/connectors between different
nodes or have multiple DRM-Masters on a single node at once. (There is
work going on to allow this, but it will take a while...)

You can acquire/drop DRM-Master via drmSetMaster/drmDropMaster.

>
> 2. My application has the design requirement that "screen 1" always refers
> to
> the card that was initialized by the PC BIOS for bootup. This is the same
> card
> that the Linux Console framebuffer will come up on by default, and therefore
> extra processing is required to handle VT switches (e.g. pause the display,
> restore original CRTC mode, etc.)
>
> Depending on the "Boot Display First [Onboard] or [PCI Slot]" option in the
> BIOS, this might mean either /dev/dri/card0 or /dev/dri/card1 becomes the
> default VGA card, as set by the vga_set_default_device() call in
> arch/x86/pci/fixup.c.
>
> Is there a way in userspace to identify which card# is the default card? Or
> alternatively, is there some way to get the underlying PCI bus/slot ID from
> a
> /dev/dri/card# device.

If your DRM card is a PCI device, you can use the sysfs "boot_vga"
attribute of the parent PCI device.
(/sys/class/drm/card0/device/boot_vga)

Regards
David
