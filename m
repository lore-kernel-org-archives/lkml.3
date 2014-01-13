Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaAMStw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 13:49:52 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:56314 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaAMStt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 13:49:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/6] arm64: add EFI stub
Date: Mon, 13 Jan 2014 19:49:38 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Mark Salter <msalter@redhat.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>, matt.fleming@intel.com,
        patches@linaro.org, Catalin Marinas <catalin.marinas@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Leif Lindholm <leif.lindholm@linaro.org>, roy.franz@linaro.org,
        linux-efi@vger.kernel.org
References: <1389392950-22457-1-git-send-email-msalter@redhat.com> <1389392950-22457-5-git-send-email-msalter@redhat.com>
In-Reply-To: <1389392950-22457-5-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401131949.39358.arnd@arndb.de>
X-Provags-ID: V02:K0:cmMoBb+c3I/OIIWocZqW9FYrR5QBNRkW13393belNQb
 +pqEjiKKSlZwcZGIY/osY+afGRorzrL9xkCZqXx9VJlMo0+bFe
 UmEwQgXzXXEk5uwv+l30foued+AVHrS0FWpg+W6ohXEBhsTLQX
 7RBavhLHOdc7BNamU0KQGZaAzbmnjJdB6lUDIduXU0MOgLOSF/
 TtENm8YmrroO6kFlYh20PGxMVhOcoHUVu77rewj9OhDLPcBW3J
 /CqqwEKQ/e+nj0qO54FZz+pBehkVTi+y0Xg4yvrNCt7iQOf9Z+
 GzFqrpKP/beKPS+Dc4u7JBeb4lppd1zcnf+rYjdtHo8ydEnJtl
 kOhf1fyQd2y0IEjzH59w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 January 2014, Mark Salter wrote:
> This patch adds PE/COFF header fields to the start of the Image
> so that it appears as an EFI application to EFI firmware. An EFI
> stub is included to allow direct booting of the kernel Image. Due
> to EFI firmware limitations, only little endian kernels with 4K
> page sizes are supported at this time. Support in the COFF header
> for signed images was provided by Ard Biesheuvel.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

You got the ordering of the S-o-b lines wrong. Since you send the
patch, your name should come last.

> +config EFI_STUB
> +	bool "EFI stub support"
> +	depends on !ARM64_64K_PAGES && OF
> +	select LIBFDT
> +	default y
> +	help
> +	  This kernel feature allows an Image to be loaded directly
> +	  by EFI firmware without the use of a bootloader.
> +	  See Documentation/efi-stub.txt for more information.
> +
>  endmenu

Why not ARM64_64K_PAGES? I thought that it was going to be the
default for a lot of distros that would need to run on UEFI systems.

>  menu "Userspace binary formats"
> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> index 5ba2fd4..1c52b84 100644
> --- a/arch/arm64/kernel/Makefile
> +++ b/arch/arm64/kernel/Makefile
> @@ -4,6 +4,8 @@
>  
>  CPPFLAGS_vmlinux.lds	:= -DTEXT_OFFSET=$(TEXT_OFFSET)
>  AFLAGS_head.o		:= -DTEXT_OFFSET=$(TEXT_OFFSET)
> +CFLAGS_efi-stub.o 	:= -DTEXT_OFFSET=$(TEXT_OFFSET) \
> +			   -I$(src)/../../../scripts/dtc/libfdt

Hmm, this is pretty ugly. I notice the same has been done on MIPS
as well, but I'd hope we can find a proper way to do it.

> diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
> new file mode 100644
> index 0000000..10d02bf
> --- /dev/null
> +++ b/arch/arm64/kernel/efi-stub.c
> +
> +/* Include shared EFI stub code */
> +#include "../../../drivers/firmware/efi/efi-stub-helper.c"
> +#include "../../../drivers/firmware/efi/fdt.c"

It gets worse here.

	Arnd
