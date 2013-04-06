Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422912Ab3DFNZI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 09:25:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55091 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757236Ab3DFNZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 09:25:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Tang <dt.tangr@gmail.com>
Subject: Re: [RFC PATCH arm: initial TI-Nspire support]
Date: Sat, 6 Apr 2013 15:24:56 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        fabian@ritter-vogt.de, Lionel Debroux <lionel_debroux@yahoo.fr>,
        linux-kernel@vger.kernel.org
References: <6FE4B33E-A503-4A75-AEED-831CB2C06D83@gmail.com> <201304061351.00889.arnd@arndb.de> <F832F4F9-8162-43B8-B9E0-D5D8C8B8C77A@gmail.com>
In-Reply-To: <F832F4F9-8162-43B8-B9E0-D5D8C8B8C77A@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304061524.56502.arnd@arndb.de>
X-Provags-ID: V02:K0:mV1u+fQcJ6A4GU4uByFQEj0V8nS0yNt2EfhF2grCyfr
 8Vw81naj1vPiOFYEEQ/Hx9VSVC3EpkSrCqKQkVnVcsMb8uNshI
 qaolEX3uiSZvRiWDvZO6+HMzZwJkkUjesg9PglESzyq89E+XED
 RjyvWo7ucwLBrG19e2TIuUgRO3UhAF8Z5du4a4udikHDmtz9SP
 gkzp9y9Ntomdipd+wfT6MfYLEqZ9ivgawCVbT1dfczi82oKoRD
 1H4JHW8ugQHenfG/N8lIWIgXoAN/jT8q9XCTK5uWlaiYJGWGjg
 C7PUxBPq4A8zd3rZbYcagveyhZKnzOD6HebHgszbDh6b5kHGzk
 EVEOvZWiEq/rhwHP/UvM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 April 2013, Daniel Tang wrote:
> Hi,
> 
> 
> On 06/04/2013, at 10:51 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > 
> > Ok, whichever way you prefer. If you have questions while working on this,
> > feel free to join #armlinux on irc.freenode.net, there are usually other
> > people working on the same things.
> > 
> 
> Cheers.
> 
> We already have something basic that boots successfully using device trees. 
> 
> Some comments before we continue would be greatly appreciated.
> 
> Signed-off-by: Daniel Tang <dt.tangr@gmail.com>

Wow, that was quick!

The patch looks great overall, I just found a few details and have some comments
that you might find helpful.

>  arch/arm/Kconfig                                |   13 ++
>  arch/arm/Makefile                               |    3 +-
>  arch/arm/boot/dts/nspire-cx.dts                 |   85 +++++++++++++
>  arch/arm/boot/dts/nspire.dtsi                   |  154 +++++++++++++++++++++++
>  arch/arm/mach-nspire/Makefile                   |    3 +
>  arch/arm/mach-nspire/include/mach/debug-macro.S |   25 ++++
>  arch/arm/mach-nspire/include/mach/timex.h       |   15 +++
>  arch/arm/mach-nspire/include/mach/uncompress.h  |   25 ++++
>  arch/arm/mach-nspire/mmio.h                     |   13 ++
>  arch/arm/mach-nspire/nspire.c                   |  107 ++++++++++++++++

A good next step before doing anything else might be to put it under
CONFIG_ARCH_MULTIPLATFORM and remove the include/mach directory.

The only requirement for that should be to move debug-macro.S to
include/debug/nspire.S

> +config ARCH_NSPIRE
> +	bool "TI-NSPIRE based"
> +	depends on MMU
> +	select CPU_ARM926T
> +	select COMMON_CLK
> +	select GENERIC_CLOCKEVENTS
> +	select SPARSE_IRQ
> +	select ARM_AMBA
> +	select ARM_VIC
> +	select ARM_TIMER_SP804
> +	help
> +	  This enables support for systems using the TI-NSPIRE CPU

Since this has all the required changes already.

> @@ -313,7 +314,7 @@ define archhelp
>    echo  '  Image         - Uncompressed kernel image (arch/$(ARCH)/boot/Image)'
>    echo  '* xipImage      - XIP kernel image, if configured (arch/$(ARCH)/boot/xipImage)'
>    echo  '  uImage        - U-Boot wrapped zImage'
> -  echo  '  bootpImage    - Combined zImage and initial RAM disk' 
> +  echo  '  bootpImage    - Combined zImage and initial RAM disk'
>    echo  '                  (supply initrd image via make variable INITRD=<path>)'
>    echo  '* dtbs          - Build device tree blobs for enabled boards'
>    echo  '  install       - Install uncompressed kernel'

This looks like it wasn't meant to be in the patch.

> +		tdes: tdes@C8010000 {
> +			reg = <0xC8010000 0x1000>;
> +		};
> +
> +		sha256: sha256@CC000000 {
> +			reg = <0xCC000000 0x1000>;
> +		};

maybe rename the actual nodes to "crypto@c...". The device name should
be a really generic word in general.

> +			uart: uart@90020000 {
> +				reg = <0x90020000 0x1000>;
> +				interrupts = <1>;
> +
> +				clocks = <&uart_clk>;
> +				clock-names = "uart_clk";
> +			};

The name for a uart should be "serial". Since this is a pl01x, please add
the required properties for the device, e.g. 

	compatible = "arm,pl011", "arm,primecell";

You will need the "arm,primecell" bit to make the device appear on the
amba bus rather than the platform bus.

> +			timer0: timer0@900C0000 {
> +				reg = <0x900C0000 0x1000>;
> +				interrupts = <18>;
> +
> +				clocks = <&timer_clk>;
> +				clock-names = "timer_clk";
> +			};
> +
> +			timer1: timer1@900D0000 {
> +				reg = <0x900D0000 0x1000>;
> +				interrupts = <19>;
> +
> +				clocks = <&timer_clk>;
> +				clock-names = "timer_clk";
> +			};

Name the devices "timer", not "timer0" and "timer1", the address after @ is
used to disambiguate them. There are currently patches for sp804 under
discussion on the mailing list, you should probably watch those.

> --- /dev/null
> +++ b/arch/arm/mach-nspire/Makefile
> @@ -0,0 +1,3 @@
> +obj-y				:=
> +
> +obj-y				+= nspire.o

The first line is not actually needed.

> +
> +#include "../../mmio.h"
> +
> +.macro	addruart, rp, rv, tmp
> +	ldr \rp, =(NSPIRE_EARLY_UART_PHYS_BASE)		@ physical base address
> +	ldr \rv, =(NSPIRE_EARLY_UART_VIRT_BASE)		@ virtual base address
> +.endm
> +
> +#include <asm/hardware/debug-pl01x.S>
> +

There is no nice solution for getting the addresses here, but the consensus
was to just define the macros in this file rather than try to include a
header from elsewhere.


> +	err = of_property_read_string(of_aliases, "timer0", &path);
> +	if (WARN_ON(err))
> +		return;
> +
> +	timer = of_find_node_by_path(path);
> +	base = of_iomap(timer, 0);
> +	if (WARN_ON(!base))
> +		return;
> +
> +	clk = of_clk_get_by_name(timer, NULL);
> +	clk_register_clkdev(clk, timer->name, "sp804");
> +
> +	sp804_clocksource_init(base, timer->name);
> +
> +	err = of_property_read_string(of_aliases, "timer1", &path);
> +	if (WARN_ON(err))
> +		return;

In particular, I think the method of using aliases to pick the right sp804
instance is being deprecated now. If both timers are identical, the kernel
will now just pick one of them.

	Arnd
