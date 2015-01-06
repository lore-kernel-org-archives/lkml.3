Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbbAFOiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 09:38:23 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:62636 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbbAFOiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 09:38:19 -0500
MIME-Version: 1.0
In-Reply-To: <1420552747-27544-1-git-send-email-vgupta@synopsys.com>
References: <54ABD526.9020907@hurleysoftware.com> <1420552747-27544-1-git-send-email-vgupta@synopsys.com>
From: Rob Herring <robh@kernel.org>
Date: Tue, 6 Jan 2015 08:37:58 -0600
X-Google-Sender-Auth: 9Ncruu8f93DIRhoSMVnKmLrdpwM
Message-ID: <CAL_JsqLzzLajoQAT3nYd5zi4=+zchXfVVPnYNriAZZi4tpa6yA@mail.gmail.com>
Subject: Re: [Patch v4] ARC: Dynamically determine BASE_BAUD from DeviceTree
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Hurley <peter@hurleysoftware.com>, Jiri Slaby <jslaby@suse.cz>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2015 at 7:59 AM, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
> 8250 earlycon is broken on multi-platform ARC because the UART clk
> value (BASE_BAUD) is fixed at build time.

Note that it should only be broken if you rely on the kernel to init
the uart. It should work if the boot loader configured the UART and
you don't specify the baudrate.

> Instead, determine the appropriate UART clk at runtime; parse the
> devicetree early for platforms requiring alternate UART clk values
> (currently only the TB10X platform).
>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: linux-serial@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: Rob Herring <robh@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Peter Hurley <peter@hurleysoftware.com>
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> ---
>  arch/arc/include/asm/serial.h | 23 +++++------------------
>  arch/arc/kernel/devtree.c     | 24 ++++++++++++++++++++++++
>  2 files changed, 29 insertions(+), 18 deletions(-)
>
> diff --git a/arch/arc/include/asm/serial.h b/arch/arc/include/asm/serial.h
> index 602b0970a764..744a6ae15754 100644
> --- a/arch/arc/include/asm/serial.h
> +++ b/arch/arc/include/asm/serial.h
> @@ -10,26 +10,13 @@
>  #define _ASM_ARC_SERIAL_H
>
>  /*
> - * early-8250 requires BASE_BAUD to be defined and includes this header.
> - * We put in a typical value:
> - *     (core clk / 16) - i.e. UART samples 16 times per sec.
> - * Athough in multi-platform-image this might not work, specially if the
> - * clk driving the UART is different.
> - * We can't use DeviceTree as this is typically for early serial.
> + * early 8250 (now earlycon) requires BASE_BAUD to be defined in this header.
> + * However to still determine it dynamically (for multi-platform images)
> + * we do this in a helper by parsing the FDT early
>   */
>
> -#include <asm/clk.h>
> +extern unsigned int __init arc_early_base_baud(void);
>
> -#define BASE_BAUD      (arc_get_core_freq() / 16)
> -
> -/*
> - * This is definitely going to break early 8250 consoles on multi-platform
> - * images but hey, it won't add any code complexity for a debug feature of
> - * one broken driver.
> - */
> -#ifdef CONFIG_ARC_PLAT_TB10X
> -#undef BASE_BAUD
> -#define BASE_BAUD      (arc_get_core_freq() / 16 / 3)
> -#endif
> +#define BASE_BAUD      arc_early_base_baud()
>
>  #endif /* _ASM_ARC_SERIAL_H */
> diff --git a/arch/arc/kernel/devtree.c b/arch/arc/kernel/devtree.c
> index fffdb5e41b20..69a790cd9b6e 100644
> --- a/arch/arc/kernel/devtree.c
> +++ b/arch/arc/kernel/devtree.c
> @@ -17,6 +17,28 @@
>  #include <asm/clk.h>
>  #include <asm/mach_desc.h>
>
> +#ifdef CONFIG_SERIAL_8250_CONSOLE
> +
> +static unsigned int arc_base_baud;

This can be initdata.

> +unsigned int __init arc_early_base_baud(void)
> +{
> +       return arc_base_baud/16;
> +}
> +
> +static void __init arc_set_early_base_baud(unsigned long dt_root)
> +{
> +       unsigned int core_clk = arc_get_core_freq();
> +
> +       if (of_flat_dt_is_compatible(dt_root, "abilis,arc-tb10x"))
> +               arc_base_baud = core_clk/3;

How many platforms do you expect this to be? This scales to maybe 10,
but not to 100 platforms. It certainly would not scale for ARM. If it
is a lot, then we need to find a generic way to describe this in DT.
For example, perhaps we require the uart node to have a
clock-frequency property or add a chosen property. You could make this
part of the machine descriptor instead, but that wouldn't be my first
choice.

Rob
