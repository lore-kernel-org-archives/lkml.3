Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab3AUUyn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 15:54:43 -0500
Received: from mga14.intel.com ([143.182.124.37]:23207 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674Ab3AUUym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 15:54:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,508,1355126400"; 
   d="scan'208";a="193574151"
Message-ID: <50FDAB06.8040701@intel.com>
Date: Mon, 21 Jan 2013 13:54:30 -0700
From: Dave Jiang <dave.jiang@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        Tim Gardner <rtg.canonical@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Olof Johansson <olof@lixom.net>,
        Tony Luck <tony.luck@intel.com>,
        Steve Langasek <steve.langasek@canonical.com>,
        Colin Ian King <colin.king@canonical.com>,
        Matt Fleming <matt.fleming@intel.com>, David Airlie <airlied@linux.ie>,
        Corentin Chary <corentincj@iksaif.net>,
        Peter Jones <pjones@redhat.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, stable@vger.kernel.org,
        "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: Re: [PATCH 1/2] efi: Make 'efi_enabled' a function to query EFI facilities
References: <1358800838-10459-1-git-send-email-matt@console-pimps.org> <1358800838-10459-2-git-send-email-matt@console-pimps.org>
In-Reply-To: <1358800838-10459-2-git-send-email-matt@console-pimps.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2013 01:40 PM, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
>
> Originally 'efi_enabled' indicated whether a kernel was booted from
> EFI firmware. Over time its semantics have changed, and it now
> indicates whether or not we are booted on an EFI machine with
> bit-native firmware, e.g. 64-bit kernel with 64-bit firmware.
>
> But users actually want to query 'efi_enabled' for different reasons -
> what they really want access to is the list of available EFI
> facilities.
>
> For instance, the x86 reboot code needs to know whether it can invoke
> the ResetSystem() function provided by the EFI runtime services, while
> the ACPI OSL code wants to know whether the EFI config tables were
> mapped successfully. There are also checks in some of the platform
> driver code to simply see if they're running on an EFI machine (which
> would make it a bad idea to do BIOS-y things).
>
> Cc: David Airlie <airlied@linux.ie>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Corentin Chary <corentincj@iksaif.net>
> Cc: Matthew Garrett <mjg59@srcf.ucam.org>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: Peter Jones <pjones@redhat.com>
> Cc: Colin Ian King <colin.king@canonical.com>
> Cc: Steve Langasek <steve.langasek@canonical.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: stable@vger.kernel.org
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
>   arch/x86/include/asm/efi.h             |  1 +
>   arch/x86/kernel/reboot.c               |  2 +-
>   arch/x86/kernel/setup.c                | 28 ++++++++---------
>   arch/x86/platform/efi/efi.c            | 56 ++++++++++++++++++++--------------
>   drivers/acpi/osl.c                     |  2 +-
>   drivers/firmware/dmi_scan.c            |  2 +-
>   drivers/firmware/efivars.c             |  4 +--
>   drivers/firmware/iscsi_ibft_find.c     |  2 +-
>   drivers/gpu/drm/radeon/radeon_device.c |  3 +-
>   drivers/platform/x86/ibm_rtl.c         |  2 +-
>   drivers/scsi/isci/init.c               |  2 +-
>   include/linux/efi.h                    | 24 +++++++++++----
>   init/main.c                            |  4 +--
>   13 files changed, 78 insertions(+), 54 deletions(-)
>
<snipped>

> diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
> index b74050b..9ac1e9d 100644
> --- a/drivers/scsi/isci/init.c
> +++ b/drivers/scsi/isci/init.c
> @@ -633,7 +633,7 @@ static int __devinit isci_pci_probe(struct pci_dev *pdev, const struct pci_devic
>   		return -ENOMEM;
>   	pci_set_drvdata(pdev, pci_info);
>   
> -	if (efi_enabled)
> +	if (efi_enabled(EFI_RUNTIME_SERVICES))
>   		orom = isci_get_efi_var(pdev);
>   
>   	if (!orom)
I think that here we may need to be checking efi_enabled(EFI_BOOT) 
instead. We are interested in the kernel was booted from EFI and that 
EFI variables support is present. Or is getting efi variable part of 
runtime services?


> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 8b84916..7a9498a 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -618,18 +618,30 @@ extern int __init efi_setup_pcdp_console(char *);
>   #endif
>   
>   /*
> - * We play games with efi_enabled so that the compiler will, if possible, remove
> - * EFI-related code altogether.
> + * We play games with efi_enabled so that the compiler will, if
> + * possible, remove EFI-related code altogether.
>    */
> +#define EFI_BOOT		0	/* Were we booted from EFI? */
> +#define EFI_SYSTEM_TABLES	1	/* Can we use EFI system tables? */
> +#define EFI_CONFIG_TABLES	2	/* Can we use EFI config tables? */
> +#define EFI_RUNTIME_SERVICES	3	/* Can we use runtime services? */
> +#define EFI_MEMMAP		4	/* Can we use EFI memory map? */
> +#define EFI_64BIT		5	/* Is the firmware 64-bit? */
> +
>   #ifdef CONFIG_EFI
>   # ifdef CONFIG_X86
> -   extern int efi_enabled;
> -   extern bool efi_64bit;
> +extern int efi_enabled(int facility);
>   # else
> -#  define efi_enabled 1
> +static inline int efi_enabled(int facility)
> +{
> +	return 1;
> +}
>   # endif
>   #else
> -# define efi_enabled 0
> +static inline int efi_enabled(int facility)
> +{
> +	return 0;
> +}
>   #endif
>   
>   /*
> diff --git a/init/main.c b/init/main.c
> index 85d69df..cd30179 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -604,7 +604,7 @@ asmlinkage void __init start_kernel(void)
>   	pidmap_init();
>   	anon_vma_init();
>   #ifdef CONFIG_X86
> -	if (efi_enabled)
> +	if (efi_enabled(EFI_RUNTIME_SERVICES))
>   		efi_enter_virtual_mode();
>   #endif
>   	thread_info_cache_init();
> @@ -632,7 +632,7 @@ asmlinkage void __init start_kernel(void)
>   	acpi_early_init(); /* before LAPIC and SMP init */
>   	sfi_init_late();
>   
> -	if (efi_enabled) {
> +	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
>   		efi_late_init();
>   		efi_free_boot_services();
>   	}

