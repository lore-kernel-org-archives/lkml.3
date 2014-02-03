Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbaBCQoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 11:44:12 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:59685 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaBCQoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 11:44:10 -0500
MIME-Version: 1.0
In-Reply-To: <52EB804C.2090506@canonical.com>
References: <52EB804C.2090506@canonical.com>
Date: Mon, 3 Feb 2014 17:44:09 +0100
Message-ID: <CANq1E4QbCn5hLX67pEyo-=KCO5TDjSg13bcSznRg1Ti_f1iOag@mail.gmail.com>
Subject: Re: drm/cirrus: Ignore busy mem region when mapping VRAM
From: David Herrmann <dh.herrmann@gmail.com>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Jan 31, 2014 at 11:51 AM, Stefan Bader
<stefan.bader@canonical.com> wrote:
> I know this is a gross hack but something like that currently is required to
> avoid a KVM guest booted from graphical grub mode (so simplefb is taking effect)
> getting into a state where there is no framebuffer in use at all (since simplefb
> was removed but cirrus fails to acquire VRAM resources which are held by the
> platform device). _Guests in that stage appear to be frozen but can be reached
> via network login with no problems.
>
> It would be possible to release the mem region in the simplefb driver when
> unmapping but that sounds equally bad. Is someone already looking into some
> better solution here? Should the platform device be removed or what would be a
> good way to go forward here?
>
> -Stefan
>
> --
>
> From 5eaa87a69bb40ffeec759b6e5aeec1a26bba1680 Mon Sep 17 00:00:00 2001
> From: Stefan Bader <stefan.bader@canonical.com>
> Date: Wed, 29 Jan 2014 16:45:12 +0000
> Subject: [PATCH] drm/cirrus: Ignore busy mem region when mapping VRAM
>
> Since 29d274b8d3e2404cd1832b3a999b12f9d1e1d895 ("x86/simplefb: Mark
> framebuffer mem-resources as IORESOURCE_BUSY to avoid bootup warning")
> the messages for real hw drivers mapping the same region as the simple-
> framebuffer are gone. But now the cirrus drm driver will always fail
> to initialize its VRAM because the region is busy. Removing the
> conflicting framebuffer only can stop simplefb from using the memory
> and unmap it but it is the platform device which has the region assined
> to itself.
> As the comment of the above patch indicates there is currently no sane
> way to get rid of the platform device. So at least for now accept that
> the region can appear busy. It is usuable nonetheless.
> This will fix VMs using the cirrus gfx emulation to appear locked up
> when booting from GRUB gfx mode.
>
> BugLink: http://bugs.launchpad.net/bugs/1269401
>
> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>

This should be fixed by patches #1+#2 in this series:
  http://lists.freedesktop.org/archives/dri-devel/2014-January/052584.html

I hope we can get it applied this week. Just waiting for a rough
review from airlied. As a workaround, you can always disable
CONFIG_X86_SYSFB. There is no reason to activate it right now (until
SimpleDRM gets merged..).

Thanks
David

> ---
>  drivers/gpu/drm/cirrus/cirrus_main.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpu/drm/cirrus/cirrus_main.c
> b/drivers/gpu/drm/cirrus/cirrus_main.c
> index 557d094..9f0193f 100644
> --- a/drivers/gpu/drm/cirrus/cirrus_main.c
> +++ b/drivers/gpu/drm/cirrus/cirrus_main.c
> @@ -101,8 +101,15 @@ static int cirrus_vram_init(struct cirrus_device *cdev)
>
>         if (!request_mem_region(cdev->mc.vram_base, cdev->mc.vram_size,
>                                 "cirrusdrmfb_vram")) {
> -               DRM_ERROR("can't reserve VRAM\n");
> -               return -ENXIO;
> +               /*
> +                * With the simple-framebuffer now marking the region
> +                * busy there is no way of this succeeding with having
> +                * the framebuffer active. Getting here means the old
> +                * one has been kicked and the region is unmapped but
> +                * there is no way to eject the platform device to get
> +                * the request_region undone.
> +                */
> +               DRM_ERROR("can't reserve VRAM (ignored)\n");
>         }
>
>         return 0;
> --
> 1.8.3.2
