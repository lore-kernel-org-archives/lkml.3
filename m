Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbaDVSrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:47:11 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:51052 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaDVSrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:47:08 -0400
MIME-Version: 1.0
In-Reply-To: <1398191506-3741-1-git-send-email-joelf@ti.com>
References: <1398191506-3741-1-git-send-email-joelf@ti.com>
Date: Tue, 22 Apr 2014 13:47:07 -0500
X-Google-Sender-Auth: vxDv8TfniN9Fls-HJGciFfna2Bw
Message-ID: <CAGo_u6oyE0-Xnv8WV0Ks-i=jdyotGH5xTcTmNDrgT2fK3GfZFg@mail.gmail.com>
Subject: Re: [PATCH] ARM: OMAP5: Switch to THUMB mode if needed on secondary CPU
From: Nishanth Menon <nm@ti.com>
To: Joel Fernandes <joelf@ti.com>
Cc: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 1:31 PM, Joel Fernandes <joelf@ti.com> wrote:
> On my DRA7 system, when the kernel is built in THUMB mode, the secondary CPU
Did you mean THUMB2? omap2plus_defconfig works today with
CONFIG_ARM_THUMB enabled..

> (Cortex A15) fails to come up causing SMP boot on second CPU to timeout. This
> seems to be because the CPU is in ARM mode once the ROM hands over control to
> the kernel.  Switch to THUMB mode if required once the kernel is control of
> secondary CPU. On OMAP4 on the other hand, it appears to be in THUMB mode on
> entry so this is not required and SMP boot works as is.
>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Nishanth Menon <nm@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Joel Fernandes <joelf@ti.com>
> ---
>  arch/arm/mach-omap2/omap-headsmp.S |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/omap-headsmp.S b/arch/arm/mach-omap2/omap-headsmp.S
> index 75e9295..1809dce 100644
> --- a/arch/arm/mach-omap2/omap-headsmp.S
> +++ b/arch/arm/mach-omap2/omap-headsmp.S
> @@ -1,7 +1,7 @@
>  /*
>   * Secondary CPU startup routine source file.
>   *
> - * Copyright (C) 2009 Texas Instruments, Inc.
> + * Copyright (C) 2014 Texas Instruments, Inc.
2009-2014

>   *
>   * Author:
>   *      Santosh Shilimkar <santosh.shilimkar@ti.com>
> @@ -28,9 +28,13 @@
>   * code.  This routine also provides a holding flag into which
>   * secondary core is held until we're ready for it to initialise.
>   * The primary core will update this flag using a hardware
> -+ * register AuxCoreBoot0.
> + * register AuxCoreBoot0.

spurious change?

>   */
>  ENTRY(omap5_secondary_startup)
> +.arm
> +THUMB( adr     r9, BSYM(wait)  )       @ CPU may be entered in ARM mode.
> +THUMB( bx      r9              )       @ If this is a Thumb-2 kernel,
> +THUMB( .thumb                  )       @ switch to Thumb now.
>  wait:  ldr     r2, =AUX_CORE_BOOT0_PA  @ read from AuxCoreBoot0
>         ldr     r0, [r2]
>         mov     r0, r0, lsr #5
> --
> 1.7.9.5
