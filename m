Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934827Ab3BTK5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 05:57:10 -0500
Received: from mail-ia0-f178.google.com ([209.85.210.178]:62019 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934545Ab3BTK5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 05:57:07 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <CANeU7QnQmKYXHA=aEuRGZDc7hVdY6037i=+s_n3FZNMN2njDsw@mail.gmail.com>
References: <CANeU7QmbzX4Tx1Dtu6xOiYzr6h6_8tPQvVG32Wvkt=5wAwEEAg@mail.gmail.com>
	<20130219100849.72d2330b@jbarnes-desktop>
	<CANeU7QmJb+yUGu9mVgq=_pHhvpPu6ORrikm=E6PkuHpOz9OREA@mail.gmail.com>
	<20130219125217.6b6f55ff@jbarnes-desktop>
	<CANeU7QnQmKYXHA=aEuRGZDc7hVdY6037i=+s_n3FZNMN2njDsw@mail.gmail.com>
Date: Wed, 20 Feb 2013 11:57:06 +0100
Message-ID: <CAKMK7uG7TgiAn0ZQ=E_-QBPNAVhTSxpORkX3Z1mY=54mgTzM-g@mail.gmail.com>
Subject: Re: i915 black screen introduced by ACPI changes
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Chris Li <lkml@chrisli.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        robert.moore@intel.com, feng.tang@intel.com, len.brown@intel.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 8:17 AM, Chris Li <lkml@chrisli.org> wrote:
> On Tue, Feb 19, 2013 at 12:52 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>> Well it definitely sounds i915 related.  I was just thinking that if
>> certain bits were routed to the nvidia chip instead of the i915 one,
>> the i915 driver may get confused and panic.
>
> That is certainly possible.
>
>> For debugging, you could modify the modeset_init function in i915_dma.c
>> and make it return early with an error.  You could use that to narrow
>> down which part of init was failing.
>
> I did try that. It seems there is not fail at modeset_init function. The
> function complete successfully. Here is the related section.
> [i915 Hack] was the line add by me.
>
> There is one line said: "vgaarb: transferring owner from
> PCI:0000:00:02.0 to PCI:0000:01:00.0".
> Does it mean the display switch to the Nvidia video card?

vgaarb is just about legacy VGA access routing, gpu switching is done
with vgaswitcheroo (if you have such a platform). Still, it could be
that the bios exposes different such interfaces with the differen acpi
os name. Can you please check the dmesg of a working kernel (or attach
it)?

> [    4.917591] i915 0000:00:02.0: setting latency timer to 64
> [    4.962649] i915 0000:00:02.0: irq 43 for MSI/MSI-X
> [    4.962656] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [    4.962660] [drm] Driver supports precise vblank timestamp query.
> [    4.962663] [i915 Hack] enter modeset
> [    4.962670] [i915 Hack] after intel_parse_bios
> [    4.962672] [i915 Hack] after vga_client_register
> [    4.962727] [i915 Hack] after intel_register_dsm_handler
> [    4.962730] [i915 Hack] after intel_switchroo_register_client
> [    4.962733] [i915 Hack] after i915_gen_init_stolen
> [    4.962752] vgaarb: device changed decodes:
> PCI:0000:00:02.0,olddecodes=io+mem,decodes=none:owns=io+mem
> [    4.962757] vgaarb: transferring owner from PCI:0000:00:02.0 to
> PCI:0000:01:00.0
> [    5.018486] [i915 Hack] after intel_modeset_init
> [    5.020823] [i915 Hack] after i915_gem_init
> [    5.020869] [i915 Hack] after intel_modeset_gem_init
> [    5.020892] [i915 Hack] after drm_irq_install
> [    5.051980] fbcon: inteldrmfb (fb0) is primary device
> [    5.089303] psmouse serio1: synaptics: Touchpad model: 1, fw: 8.1,
> id: 0x1e2b1, caps: 0xd00123/0x840300/0x123c00, board id: 1800, fw id:
> 1087391
> [    5.202472] input: SynPS/2 Synaptics TouchPad as
> /devices/platform/i8042/serio1/input/input5
> [    5.711448] Console: switching to colour frame buffer device 240x67
> [    5.722628] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
> [    5.722630] i915 0000:00:02.0: registered panic notifier
> [    5.722633] [i915 Hack] after intel_fbdev_init
> [    5.722634] [i915 Hack] after drm_kms_helper_poll_init
> [    5.722635] [i915 Hack] exit mode switch
> [    5.722682] nouveau 0000:01:00.0: enabling device (0006 -> 0007)
> [    5.723017] [Firmware Bug]: ACPI(PEGP) defines _DOD but not _DOS
> [    5.733222] acpi device:3c: registered as cooling_device8
> [    5.733587] ACPI: Video Device [PEGP] (multi-head: yes  rom: yes  post: no)
> [    5.733746] input: Video Bus as
> /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:3a/LNXVIDEO:00/input/input6
> [    5.745904] acpi device:48: registered as cooling_device9
>
> I attach the dmesg and config of the kernel. It is with the tip of git tree.
>
> BTW, my previous claim was wrong about the kernel is dead. It turn out the
> wifi is usable after the black screen, I just need to wait long
> enough. The kernel
> has no panic at all. That explains why I didnot get a kernel crash
> dump previously.
> The caps locks LED actually works.

Starts to smell like a bog-standard i915 black screen bug (albeit with
a strange cause for the regression). Can you please boot the broken
kernels again with drm.debug=0xe and grab the complete dmesg?
Depending upon how long it takes for your wifi to get up, you might
need to extend the log buffer, it dumps a lot.

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
