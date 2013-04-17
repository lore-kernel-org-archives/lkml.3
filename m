Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966431Ab3DQVL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 17:11:56 -0400
Received: from winds.org ([68.75.195.9]:35908 "EHLO winds.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756595Ab3DQVLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 17:11:54 -0400
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Apr 2013 17:11:54 EDT
Date: Wed, 17 Apr 2013 17:05:05 -0400 (EDT)
From: Byron Stanoszek <gandalf@winds.org>
To: David Airlie <airlied@linux.ie>
cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Standalone DRM application
Message-ID: <alpine.LNX.2.00.1304171605010.19898@winds.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

I'm developing a small application that uses libdrm (DRM ioctls) to change the
resolution of a single graphics display and show a framebuffer. I've run into
two problems with this implementation that I'm hoping you can address.


1. Each application is its own process, which is designed to control 1 graphics
display. This is unlike X, for instance, which could be configured to grab all
of the displays in the system at once.

Depending on our stackup, there can be as many as 4 displays connected to a
single graphics card. One process could open /dev/dri/card0 and call
drmModeSetCrtc() to initialize one of its displays to the requested resolution.
However, whenever a second process calls drmModeSetCrtc() to control a second
display on the same card, it gets -EPERM back from the ioctl.

I've traced this down to the following line in linux/drivers/gpu/drm/drm_drv.c:

DRM_IOCTL_DEF(DRM_IOCTL_MODE_SETCRTC, drm_mode_setcrtc, DRM_MASTER|DRM_CONTROL_ALLOW|DRM_UNLOCKED),

If I remove the DRM_MASTER flag, then my application behaves correctly, and 4
separate processes can then control each individual display on the card without
issue.

My question is, is there any real benefit to restricting drm_mode_setcrtc()
with DRM_MASTER, or can we lose this flag in order to support one-process-per-
display programs like the above?


2. My application has the design requirement that "screen 1" always refers to
the card that was initialized by the PC BIOS for bootup. This is the same card
that the Linux Console framebuffer will come up on by default, and therefore
extra processing is required to handle VT switches (e.g. pause the display,
restore original CRTC mode, etc.)

Depending on the "Boot Display First [Onboard] or [PCI Slot]" option in the
BIOS, this might mean either /dev/dri/card0 or /dev/dri/card1 becomes the
default VGA card, as set by the vga_set_default_device() call in
arch/x86/pci/fixup.c.

Is there a way in userspace to identify which card# is the default card? Or
alternatively, is there some way to get the underlying PCI bus/slot ID from a
/dev/dri/card# device.

Thanks,
  -Byron

