Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab3ANLUu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 06:20:50 -0500
Received: from mail.skyhub.de ([78.46.96.112]:47582 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756281Ab3ANLUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 06:20:48 -0500
Date: Mon, 14 Jan 2013 12:20:45 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCH v7u1 23/31] x86, boot: update comments about entries for
 64bit image
Message-ID: <20130114112045.GF1228@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kiszka <jan.kiszka@web.de>,
	Jason Wessel <jason.wessel@windriver.com>,
	linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
	Matt Fleming <matt.fleming@intel.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
 <1357260531-11115-24-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1357260531-11115-24-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 04:48:43PM -0800, Yinghai Lu wrote:
> Now 64bit entry is fixed on 0x200, can not be changed anymore.
> 
> Update the comments to reflect that.
> 
> Also put info about it in boot.txt
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Rob Landley <rob@landley.net>
> Cc: Matt Fleming <matt.fleming@intel.com>
> ---
>  Documentation/x86/boot.txt         |   38 ++++++++++++++++++++++++++++++++++++
>  arch/x86/boot/compressed/head_64.S |   22 ++++++++++++---------
>  2 files changed, 51 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
> index 18ca9fb..24cc542 100644
> --- a/Documentation/x86/boot.txt
> +++ b/Documentation/x86/boot.txt
> @@ -1042,6 +1042,44 @@ must have read/write permission; CS must be __BOOT_CS and DS, ES, SS
>  must be __BOOT_DS; interrupt must be disabled; %esi must hold the base
>  address of the struct boot_params; %ebp, %edi and %ebx must be zero.
>  
> +**** 64-bit BOOT PROTOCOL
> +
> +For machine with 64bit cpus and 64bit kernel, we could use 64bit bootloader
> +We need a 64-bit boot protocol.

Make that:

"64-bit kernels using 64-bit bootloaders use this protocol for booting."

> +
> +In 64-bit boot protocol, the first step in loading a Linux kernel
> +should be to setup the boot parameters (struct boot_params,
> +traditionally known as "zero page"). The memory for struct boot_params
> +should be allocated under or above 4G and initialized to all zero.

"Memory for struct boot_params may be allocated anywhere (even above
4G). This memory must be zeroed out."

Also, add a \n here.

> +Then the setup header from offset 0x01f1 of kernel image on should be

"Then, the setup header at offset 0x01f1 of the kernel image should be..."

> +loaded into struct boot_params and examined. The end of setup header
> +can be calculated as follow:

			"follows:"

> +
> +	0x0202 + byte value at offset 0x0201

What is that value at 0x201? What's its name? Maybe it is called "magic" :-)

> +
> +In addition to read/modify/write the setup header of the struct
> +boot_params as that of 16-bit boot protocol,

Hmm, do you mean:

"In addition to modifying struct setup_header in boot_params as part of
the 16-bit boot protocol, the boot loader..."


> the boot loader should
> +also fill the additional fields of the struct boot_params as that

							remove "that"

> +described in zero-page.txt.

Btw, you could document the sentinel mechanism here or in zero-page.txt,
for example.

> +
> +After setting up the struct boot_params, the boot loader can load the

		s/the//

> +64-bit kernel in the same way as that of 16-bit boot protocol, but
> +kernel could be above 4G.

"... the boot loader can load a 64-bit kernel the same way as with the
16-bit boot protocol with the additional advantage that the kernel can
be placed above the 4Gb barrier."

> +
> +In 64-bit boot protocol, the kernel is started by jumping to the

"In the 64-bit... "

> +64-bit kernel entry point, which is the start address of loaded

no comma:

"... entry point which is the start address of the loaded..."

> +64-bit kernel plus 0x200.

Again, what does the 0x200 value mean?

> +
> +At entry, the CPU must be in 64-bit mode with paging enabled.
> +The range with setup_header.init_size from start address of loaded
> +kernel and zero page and command line buffer get ident mapping;

Hmm, maybe:

"The ranges from the start address of the loaded kernel and with size
setup_header.init_size, the zero page and the command line buffer are
ident-mapped."

Newline here.

Then enumerate the further steps:

> +a GDT must be loaded with the descriptors for selectors
> +__BOOT_CS(0x10) and __BOOT_DS(0x18); both descriptors must be 4G flat
> +segment; __BOOT_CS must have execute/read permission, and __BOOT_DS
> +must have read/write permission; CS must be __BOOT_CS and DS, ES, SS
> +must be __BOOT_DS; interrupt must be disabled; %rsi must hold the base
> +address of the struct boot_params.

"Then:

* a GDT must be loaded with the descriptors for selectors
  __BOOT_CS(0x10) and __BOOT_DS(0x18)

* both descriptors must describe a 4G, flat segment

* __BOOT_CS must have execute/read permissions, and __BOOT_DS must have
  read/write permissions

* CS must be __BOOT_CS and DS, ES, SS must be __BOOT_DS

* interrupts must be disabled

* %rsi must hold the base address of the struct boot_params."


> +
>  **** EFI HANDOVER PROTOCOL
>  
>  This protocol allows boot loaders to defer initialisation to the EFI
> diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
> index 5c80b94..aaafd4e 100644
> --- a/arch/x86/boot/compressed/head_64.S
> +++ b/arch/x86/boot/compressed/head_64.S
> @@ -37,6 +37,12 @@
>  	__HEAD
>  	.code32
>  ENTRY(startup_32)
> +	/*
> +	 * 32bit entry is 0, could not be changed!

What does that mean? Did we try to change it or what?

> +	 * If we come here directly from a bootloader,
> +	 * kernel(text+data+bss+brk) ramdisk, zero_page, command line
> +	 * all need to be under 4G limit.

			"under the"

> +	 */
>  	cld
>  	/*
>  	 * Test KEEP_SEGMENTS flag to see if the bootloader is asking
> @@ -182,20 +188,18 @@ ENTRY(startup_32)
>  	lret
>  ENDPROC(startup_32)
>  
> -	/*
> -	 * Be careful here startup_64 needs to be at a predictable
> -	 * address so I can export it in an ELF header.  Bootloaders
> -	 * should look at the ELF header to find this address, as
> -	 * it may change in the future.
> -	 */
>  	.code64
>  	.org 0x200
>  ENTRY(startup_64)
>  	/*
> +	 * 64bit entry is 0x200, could not be changed!

Ah, I see what you mean:

	"64-bit entry point is 0x200 and it is ABI so immutable!"

Ditto for startup_32 above.

>  	 * We come here either from startup_32 or directly from a
> -	 * 64bit bootloader.  If we come here from a bootloader we depend on
> -	 * an identity mapped page table being provied that maps our
> -	 * entire text+data+bss and hopefully all of memory.
> +	 * 64bit bootloader.
> +	 * If we come here from a bootloader, kernel(text+data+bss+brk),
> +	 * ramdisk, zero_page, command line could be above 4G.
> +	 * We depend on an identity mapped page table being provided
> +	 * that maps our entire kernel(text+data+bss+brk), zero page
> +	 * and command line.

Heey, this one is good! :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
