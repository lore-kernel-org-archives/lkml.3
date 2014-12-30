Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbaL3VuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 16:50:17 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51633 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbaL3VuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 16:50:15 -0500
MIME-Version: 1.0
In-Reply-To: <1419895935-22966-9-git-send-email-stefan@agner.ch>
References: <1419895935-22966-1-git-send-email-stefan@agner.ch> <1419895935-22966-9-git-send-email-stefan@agner.ch>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 30 Dec 2014 15:42:29 -0600
Message-ID: <CAL_JsqK94Pk2xPF1MMX0GU0CQEiwiDD2qv9v3k4WLg2znDVjgA@mail.gmail.com>
Subject: Re: [PATCH v2 08/12] ARM: allow MULTIPLATFORM with !MMU
To: Stefan Agner <stefan@agner.ch>
Cc: Shawn Guo <shawn.guo@linaro.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Marc Zyngier <marc.zyngier@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2014 at 5:32 PM, Stefan Agner <stefan@agner.ch> wrote:
> In order to support SoC with heterogenous CPU architectures (such
> as Freescale Vybrid/i.MXSX) it is preferable to use the same
> architecture (ARCH_MXC in this case) for the MMU enabled and !MMU
> CPU. Hence allow to select MULTIPLATFORM even without MMU.

This has been submitted before[1], but you obviously have a better
reason now. I also need this for my Versatile series to fix
allnoconfig. However, there are some issues with your implementation.

> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
>  arch/arm/Kconfig | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 97d07ed..95007b9 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -228,7 +228,7 @@ config VECTORS_BASE
>           in size.
>
>  config ARM_PATCH_PHYS_VIRT
> -       bool "Patch physical to virtual translations at runtime" if EMBEDDED
> +       bool "Patch physical to virtual translations at runtime" if EMBEDDED || (ARCH_MULTIPLATFORM && MMU)
>         default y
>         depends on !XIP_KERNEL && MMU
>         depends on !ARCH_REALVIEW || !SPARSEMEM
> @@ -303,15 +303,12 @@ config MMU
>  #
>  choice
>         prompt "ARM system type"
> -       default ARCH_VERSATILE if !MMU
> -       default ARCH_MULTIPLATFORM if MMU
> +       default ARCH_MULTIPLATFORM
>
>  config ARCH_MULTIPLATFORM
>         bool "Allow multiple platforms to be selected"
> -       depends on MMU
>         select ARCH_WANT_OPTIONAL_GPIOLIB
>         select ARM_HAS_SG_CHAIN
> -       select ARM_PATCH_PHYS_VIRT
>         select AUTO_ZRELADDR
>         select CLKSRC_OF
>         select COMMON_CLK
> @@ -783,13 +780,13 @@ comment "CPU Core family selection"
>
>  config ARCH_MULTI_V4
>         bool "ARMv4 based platforms (FA526)"
> -       depends on !ARCH_MULTI_V6_V7
> +       depends on !ARCH_MULTI_V6_V7 && MMU

This is not right. !MMU does not mean the ARM arch does not have an
MMU, but rather the MMU is already setup with identity mapping (or
some other static mapping).

Rob

[1] http://patchwork.ozlabs.org/patch/278996/
