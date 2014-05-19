Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003AbaESP7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 11:59:04 -0400
Received: from smtp.citrix.com ([66.165.176.89]:51153 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932076AbaESP7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 11:59:00 -0400
X-IronPort-AV: E=Sophos;i="4.98,868,1392163200"; 
   d="scan'208";a="133193019"
Message-ID: <537A2A28.4010903@citrix.com>
Date: Mon, 19 May 2014 16:58:32 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Daniel Kiper <daniel.kiper@oracle.com>, <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        <xen-devel@lists.xenproject.org>
CC: <boris.ostrovsky@oracle.com>, <eshelton@pobox.com>, <hpa@zytor.com>,
        <ian.campbell@citrix.com>, <jbeulich@suse.com>, <jeremy@goop.org>,
        <konrad.wilk@oracle.com>, <matt.fleming@intel.com>, <mingo@redhat.com>,
        <mjg59@srcf.ucam.org>, <stefano.stabellini@eu.citrix.com>,
        <tglx@linutronix.de>
Subject: Re: [PATCH v4 1/5] efi: Introduce EFI_DIRECT flag
References: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com> <1400272904-31121-2-git-send-email-daniel.kiper@oracle.com>
In-Reply-To: <1400272904-31121-2-git-send-email-daniel.kiper@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/05/14 21:41, Daniel Kiper wrote:
> Introduce EFI_DIRECT flag. If it is set this means that Linux
> Kernel has direct access to EFI infrastructure. If not then
> kernel runs on EFI platform but it has not direct control
> on EFI stuff. This functionality is used in Xen dom0.

This is backwards.  It should flag should indicate the weird platform
not the standard, default one.

You also need to explain why this is needed rather than presenting a
more complete EFI interface to PV guests.  And you should explain why
each use is necessary.

> +static void __init __iomem *efi_early_ioremap(resource_size_t phys_addr,
> +							unsigned long size)
> +{
> +	if (efi_enabled(EFI_DIRECT))
> +		return early_ioremap(phys_addr, size);
> +
> +	return (__force void __iomem *)phys_addr;
> +}

Er...  Perhaps you mean BUG_ON(!efi_enabled(EFI_DIRECT))? Or return NULL?

> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -893,12 +893,13 @@ extern int __init efi_setup_pcdp_console(char *);
>   * possible, remove EFI-related code altogether.
>   */
>  #define EFI_BOOT		0	/* Were we booted from EFI? */
> -#define EFI_SYSTEM_TABLES	1	/* Can we use EFI system tables? */
> -#define EFI_CONFIG_TABLES	2	/* Can we use EFI config tables? */
> -#define EFI_RUNTIME_SERVICES	3	/* Can we use runtime services? */
> -#define EFI_MEMMAP		4	/* Can we use EFI memory map? */
> -#define EFI_64BIT		5	/* Is the firmware 64-bit? */
> -#define EFI_ARCH_1		6	/* First arch-specific bit */
> +#define EFI_DIRECT		1	/* Can we access EFI directly? */
> +#define EFI_SYSTEM_TABLES	2	/* Can we use EFI system tables? */
> +#define EFI_CONFIG_TABLES	3	/* Can we use EFI config tables? */
> +#define EFI_RUNTIME_SERVICES	4	/* Can we use runtime services? */
> +#define EFI_MEMMAP		5	/* Can we use EFI memory map? */
> +#define EFI_64BIT		6	/* Is the firmware 64-bit? */
> +#define EFI_ARCH_1		7	/* First arch-specific bit */

Unnecessary shuffling of these values.  Why didn't you stick it after
EFI_64BIT?

David
