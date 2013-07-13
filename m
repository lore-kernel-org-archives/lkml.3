Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab3GMGr5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 02:47:57 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:39769 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab3GMGrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 02:47:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130712203802.GA14702@www.outflux.net>
References: <1373659660-31123-1-git-send-email-keescook@chromium.org>
	<20130712203802.GA14702@www.outflux.net>
Date: Fri, 12 Jul 2013 23:47:54 -0700
X-Google-Sender-Auth: 0BdzrtxhqG3xa7A9I_fuv0G0k1k
Message-ID: <CAE9FiQWJin8-hXsodo46vhYPMrWiiboEVQySPO-LgXtebYmUzw@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] x86, boot: add mmio serial during compressed boot
From: Yinghai Lu <yinghai@kernel.org>
To: Kees Cook <keescook@chromium.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 1:38 PM, Kees Cook <keescook@chromium.org> wrote:
> Allows "console=uart[8250],mmio[32],0xADDR[,BAUDn8[,BASE_BAUD]]" to
> be recognized during compressed boot early console setup, and during
> boot console setup. Replaces defines with common serial defines. Adds
> suport for mmio-based serial devices to compressed-boot early console,
> and plumbs support for defining the base baud rate for UART clock
> calculations (since mmio serial cards may not have the standard rate,
> resulting in incorrect baud rates for mmio devices).
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v2:
>  - fixed typo in SERIAL_RSA_...
> ---
>  Documentation/kernel-parameters.txt             |   12 ++-
>  arch/x86/boot/boot.h                            |   20 +++-
>  arch/x86/boot/compressed/early_serial_console.c |    5 +-
>  arch/x86/boot/compressed/misc.c                 |   10 +-
>  arch/x86/boot/compressed/misc.h                 |    4 +-
>  arch/x86/boot/early_serial_console.c            |  122 +++++++++++++----------
>  arch/x86/boot/early_serial_console.h            |   43 ++++++++
>  arch/x86/boot/tty.c                             |   12 +--
>  drivers/tty/serial/8250/8250_early.c            |   11 +-
>  include/uapi/linux/serial_reg.h                 |    5 +-
>  10 files changed, 168 insertions(+), 76 deletions(-)
>  create mode 100644 arch/x86/boot/early_serial_console.h
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 15356ac..52ad7d8 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -575,11 +575,21 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>                         alternative.
>
>                 uart[8250],io,<addr>[,options]
> -               uart[8250],mmio,<addr>[,options]
> +               uart[8250],mmio,<addr>[,options[,base_baud]]
>                         Start an early, polled-mode console on the 8250/16550
>                         UART at the specified I/O port or MMIO address,
>                         switching to the matching ttyS device later.  The
>                         options are the same as for ttyS, above.
> +
> +                       For x86 early boot mmio uart consoles, the base baud
> +                       rate (for calculating the UART clock) can be defined
> +                       as well. This is done after the options above, comma
> +                       separated. For example "...,115200n8,4000000" would
> +                       use 4000000 as the base baud rate. Once the real uart
> +                       driver initializes, this value will be ignored, since
> +                       it will use the known device-specific value instead.
> +                       The default is 115200.
> +
>                 hvc<n>  Use the hypervisor console device <n>. This is for
>                         both Xen and PowerPC hypervisors.
>
> diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
> index 5b75319..ae61c19 100644
> --- a/arch/x86/boot/boot.h
> +++ b/arch/x86/boot/boot.h
> @@ -80,6 +80,23 @@ static inline void io_delay(void)
>         asm volatile("outb %%al,%0" : : "dN" (DELAY_PORT));
>  }
>
> +/* Minimal mmio functions from include/asm/io.h. */
> +#define build_mmio_read(name, size, type, reg, barrier) \
> +static inline type name(const volatile void __iomem *addr) \
> +{ type ret; asm volatile("mov" size " %1,%0":reg (ret) \
> +:"m" (*(volatile type __force *)addr) barrier); return ret; }
> +
> +#define build_mmio_write(name, size, type, reg, barrier) \
> +static inline void name(type val, volatile void __iomem *addr) \
> +{ asm volatile("mov" size " %0,%1": :reg (val), \
> +"m" (*(volatile type __force *)addr) barrier); }
> +
> +build_mmio_read(readb, "b", unsigned char, "=q", :"memory")
> +build_mmio_read(readl, "l", unsigned int, "=r", :"memory")
> +
> +build_mmio_write(writeb, "b", unsigned char, "q", :"memory")
> +build_mmio_write(writel, "l", unsigned int, "r", :"memory")
> +
>  /* These functions are used to reference data in other segments. */
>
>  static inline u16 ds(void)
> @@ -319,7 +336,8 @@ int check_cpu(int *cpu_level_ptr, int *req_level_ptr, u32 **err_flags_ptr);
>  int validate_cpu(void);
>
>  /* early_serial_console.c */
> -extern int early_serial_base;
> +extern unsigned long early_serial_base;
> +extern int early_serial_type;
>  void console_init(void);

so the mmio range is under 4G.

for 32 bit, that is ok.
for 64 bit via 32bit bootloader, arch/x86/boot/compressed/head_64.S
will set page table for first 4G still ok.
for 64 bit via 64bit loader, like kexec via bzImage64, First Kernel/Kexec only
set ident mapping for usable range, so mmio just under 64 is not mapped.

Looks like we need to update boot.txt to add requirement for 64bit bootloader
that 0-4G need to be all ident mapping?

Yinghai
