Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaAMSnw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 13:43:52 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:53515 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaAMSnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 13:43:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 4/5] arm: Add [U]EFI runtime services support
Date: Mon, 13 Jan 2014 19:43:09 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Leif Lindholm <leif.lindholm@linaro.org>, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca, linux-efi@vger.kernel.org,
        linux@arm.linux.org.uk, patches@linaro.org,
        Will Deacon <will.deacon@arm.com>, roy.franz@linaro.org,
        matt.fleming@intel.com, msalter@redhat.com
References: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org> <1389445524-30623-5-git-send-email-leif.lindholm@linaro.org>
In-Reply-To: <1389445524-30623-5-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401131943.10352.arnd@arndb.de>
X-Provags-ID: V02:K0:U2hKmoTjn46JhiFoGrwhabvWuE7H6E3cHlNsr8VkqKy
 eiQCCeVP+GqL1FRi6t1xIqiZshfSXeN/RlRXwrJLqicj1dGpdY
 NwQ5mypOGd9hXHD8gmgpYUrAULb8UWW+M7wSfteGzw34IY0iTY
 1YF/CpUmPcgKUCrrdx/ma1LNzaYb6TAuclFiT+dKaUzTzcxYNx
 gG7nPZB43XS6691evh7VBCShGSgfviPKyXxsgVxHl9gfAy+qt5
 IqbbJYm4EW2+Y4r59TKOcdlDUupX2FkNMenk7dvJIXRrHeYWPm
 C5fFiivrX3CNpWKpwqYjhJx/JFhe37NwcBzo35vv9X+5hGVLo1
 zd7+jgPGHuLdzjNpEdUo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 January 2014, Leif Lindholm wrote:
> This patch implements basic support for UEFI runtime services in the
> ARM architecture - a requirement for using efibootmgr to read and update
> the system boot configuration.
> 
> It uses the generic configuration table scanning to populate ACPI and
> SMBIOS pointers.

As far as I'm concerned there are no plans to have ACPI support on ARM32,
so I wonder what the code to populate the ACPI tables is about. Can
you clarify this?
 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 78a79a6a..1ab24cc 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1853,6 +1853,20 @@ config EARLY_IOREMAP
>  	  the same virtual memory range as kmap so all early mappings must
>  	  be unapped before paging_init() is called.
>  
> +config EFI
> +	bool "UEFI runtime service support"
> +	depends on OF && !CPU_BIG_ENDIAN

What is the dependency on !CPU_BIG_ENDIAN? We try hard to have
all kernel code support both big-endian and little-endian, and
I'm guessing there is a significant overlap between the people
that want UEFI support and those that want big-endian kernels.

> +struct efi_memory_map memmap;

"memmap" is not a good name for a global identifier, particularly because
it's easily confused with the well-known "mem_map" array. This
wants namespace prefix like you other variable, or a "static" tag,
preferably both.

> +/*
> + * This function switches the UEFI runtime services to virtual mode.
> + * This operation must be performed only once in the system's lifetime,
> + * including any kecec calls.

                   kexec

> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index fa7d950..afaeb85 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -664,7 +664,7 @@ extern int __init efi_setup_pcdp_console(char *);
>  #define EFI_64BIT		5	/* Is the firmware 64-bit? */
>  
>  #ifdef CONFIG_EFI
> -# ifdef CONFIG_X86
> +# if defined(CONFIG_X86) || defined(CONFIG_ARM)
>  extern int efi_enabled(int facility);
>  # else
>  static inline int efi_enabled(int facility)

Maybe better #ifndef CONFIG_IA64? It seems that is the odd one out and
all possible future architectures would be like x86 and ARM.

	Arnd
