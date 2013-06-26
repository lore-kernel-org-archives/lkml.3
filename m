Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304Ab3FZUtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 16:49:32 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:34730 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab3FZUta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 16:49:30 -0400
Message-ID: <51CB53D7.7030602@wwwdotorg.org>
Date: Wed, 26 Jun 2013 14:49:27 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>
CC: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>, linux-fbdev@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [RFC 2/6] x86: provide platform-devices for boot-framebuffers
References: <1372112849-670-1-git-send-email-dh.herrmann@gmail.com> <1372112849-670-3-git-send-email-dh.herrmann@gmail.com>
In-Reply-To: <1372112849-670-3-git-send-email-dh.herrmann@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 04:27 PM, David Herrmann wrote:
> The current situation regarding boot-framebuffers (VGA, VESA/VBE, EFI) on
> x86 causes troubles when loading multiple fbdev drivers. The global
> "struct screen_info" does not provide any state-tracking about which
> drivers use the FBs. request_mem_region() theoretically works, but
> unfortunately vesafb/efifb ignore it due to quirks for broken boards.
> 
> Avoid this by creating a "platform-framebuffer" device with a pointer
> to the "struct screen_info" as platform-data. Drivers can now create
> platform-drivers and the driver-core will refuse multiple drivers being
> active simultaneously.
> 
> We keep the screen_info available for backwards-compatibility. Drivers
> can be converted in follow-up patches.
> 
> Apart from "platform-framebuffer" devices, this also introduces a
> compatibility option for "simple-framebuffer" drivers which recently got
> introduced for OF based systems. If CONFIG_X86_SYSFB is selected, we
> try to match the screen_info against a simple-framebuffer supported
> format. If we succeed, we create a "simple-framebuffer" device instead
> of a platform-framebuffer.
> This allows to reuse the simplefb.c driver across architectures and also
> to introduce a SimpleDRM driver. There is no need to have vesafb.c,
> efifb.c, simplefb.c and more just to have architecture specific quirks
> in their setup-routines.
> 
> Instead, we now move the architecture specific quirks into x86-setup and
> provide a generic simple-framebuffer. For backwards-compatibility (if
> strange formats are used), we still allow vesafb/efifb to be loaded
> simultaneously and pick up all remaining devices.

> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig

> +config X86_SYSFB
> +	bool "Mark VGA/VBE/EFI FB as generic system framebuffer"
> +	help
> +	  Firmwares often provide initial graphics framebuffers so the BIOS,
> +	  bootloader or kernel can show basic video-output during boot for
> +	  user-guidance and debugging. Historically, x86 used the VESA BIOS
> +	  Extensions and EFI-framebuffers for this, which are mostly limited
> +	  to x86. However, a generic system-framebuffer initialization emerged
> +	  recently on some non-x86 architectures.

After this patch has been in the kernel a while, that very last won't
really be true; simplefb won't have been introduced recently. Perhaps
just delete that one sentence?

> +	  This option, if enabled, marks VGA/VBE/EFI framebuffers as generic
> +	  framebuffers so the new generic system-framebuffer drivers can be
> +	  used on x86.
> +
> +	  This breaks any x86-only driver like efifb, vesafb, uvesafb, which
> +	  will not work if this is selected.

Doesn't that imply that some form of conflicts or depends ! statement
should be added here?

> diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile

> +obj-y					+= sysfb.o

I suspect that should be obj-$(CONFIG_X86_SYSFB) += sysfb.o.

> diff --git a/arch/x86/kernel/sysfb.c b/arch/x86/kernel/sysfb.c

> +#ifdef CONFIG_X86_SYSFB

Rather than ifdef'ing the body of this file, why not create a dummy
static inline version of add_sysfb() and put that into a header file
that users include. There should be a header file to prototype the
function anyway. That way, you avoid all of the ifdefs and static inline
functions in this file.

> +static bool parse_mode(const struct screen_info *si,
> +		       struct simplefb_platform_data *mode)

> +			strlcpy(mode->format, f->name, sizeof(mode->format));

Per my comments about the type of mode->format, I think that could just be:

mode->format = f->name;

... since formats[] (i.e. f) isn't initdata.

> +#else /* CONFIG_X86_SYSFB */
> +
> +static bool parse_mode(const struct screen_info *si,
> +		       struct simplefb_platform_data *mode)
> +{
> +	return false;
> +}
> +
> +static int create_simplefb(const struct screen_info *si,
> +			   const struct simplefb_platform_data *mode)
> +{
> +	return -EINVAL;
> +}
> +
> +#endif /* CONFIG_X86_SYSFB */

Following on from my ifdef comment above, I believe those versions of
those functions will always cause add_sysfb() to return -ENODEV, so you
may as well provide a static inline for add_sysfb() instead.
