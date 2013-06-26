Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab3FZNOD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 09:14:03 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:35972 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab3FZNN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 09:13:59 -0400
MIME-Version: 1.0
In-Reply-To: <1372183863-11333-2-git-send-email-leif.lindholm@linaro.org>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org> <1372183863-11333-2-git-send-email-leif.lindholm@linaro.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 26 Jun 2013 14:13:39 +0100
X-Google-Sender-Auth: I6EZfICCmCZSXKoBs4jtDh1W1OA
Message-ID: <CACxGe6tUpo31p6N0BZt_jdonuPP8ijvLBygC76wQ044EFsqOwA@mail.gmail.com>
Subject: Re: [PATCH 1/4] Documentation: arm: [U]EFI runtime services
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-efi@vger.kernel.org,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, matt.fleming@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 7:11 PM, Leif Lindholm <leif.lindholm@linaro.org> wrote:
> This patch provides documentation of the [U]EFI runtime services and
> configuration features.
>
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> ---
>  Documentation/arm/00-INDEX |    3 +++
>  Documentation/arm/uefi.txt |   39 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 42 insertions(+)
>  create mode 100644 Documentation/arm/uefi.txt
>
> diff --git a/Documentation/arm/00-INDEX b/Documentation/arm/00-INDEX
> index 4978456..87e01d1 100644
> --- a/Documentation/arm/00-INDEX
> +++ b/Documentation/arm/00-INDEX
> @@ -36,3 +36,6 @@ nwfpe/
>         - NWFPE floating point emulator documentation
>  swp_emulation
>         - SWP/SWPB emulation handler/logging description
> +
> +uefi.txt
> +       - [U]EFI configuration and runtime services documentation
> diff --git a/Documentation/arm/uefi.txt b/Documentation/arm/uefi.txt
> new file mode 100644
> index 0000000..5c48271
> --- /dev/null
> +++ b/Documentation/arm/uefi.txt
> @@ -0,0 +1,39 @@
> +The nomenclature EFI and UEFI are used interchangeably in this document.
> +
> +The implementation depends on receiving pointers to the UEFI memory map
> +and System Table in a Flattened Device Tree - so is only available with
> +CONFIG_OF.
> +
> +It (early) parses the FDT for the following parameters:

Need to state which node these properties can be found in. I recommend /chosen

I would also prefix all of the following properties with "linux,"
since they are very much about what the Linux kernel needs for
booting. EFI stub will be creating these properties specifically for
Linux, and the LinuxLoader should do the same (until we eventually
kill it).

> +- 'efi-system-table':
> +  Physical address of the system table. (required)

Need to mention the size of this address. Is it 64 bit or 32 bit? I
would follow the lead of 'linux,initrd-start' here and make the size
of property the size of the address. ie. If it is 8 bytes long, then
it is a 64 bit address.

> +- 'efi-runtime-mmap':
> +  Physical address of an EFI memory map, containing at least
> +  the regions to be preserved. (required)
> +- 'efi-runtime-mmap-size':
> +  Size in bytes of the provided memory map. (required)

I would collapse the above two properties into a single property that
actually contains the memory map instead of pointing to it. You will
also need to specify the exact format of the data in this property.

> +- 'efi-mmap-desc-size':
> +  Size of each descriptor in the memory map. (override default)
> +- 'efi-mmap-desc-ver':
> +  Memory descriptor format version. (override default)

I don't understand how these properties will actually work. What
changes in the parsing if these properties are set?

> +
> +Since UEFI firmware on ARM systems are required to use a 1:1 memory map
> +even on LPAE-capable systems, the above fields are 32-bit regardless.
> +
> +It also depends on early_ioremap to parse the memory map and preserve
> +the regions required for runtime services.
> +
> +For actually enabling [U]EFI support, enable:
> +- CONFIG_EFI=y
> +- CONFIG_EFI_VARS=y or m
> +
> +After the kernel has mapped the required regions into its address space,
> +a SetVirtualAddressMap() call is made into UEFI in order to update
> +relocations. This call must be performed with all the code in a 1:1
> +mapping. This implementation achieves this by temporarily disabling the
> +MMU for the duration of this call. This can only be done safely:
> +- before secondary CPUs are brought online.
> +- after early_initcalls have completed, sinze it uses setup_mm_for_reboot().
> +
> +For verbose debug messages, specify 'uefi_debug' on the kernel command
> +line.

Looks good otherwise, Thanks!

g.
