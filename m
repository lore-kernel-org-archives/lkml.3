Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaETJrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:47:07 -0400
Received: from smtp.citrix.com ([66.165.176.89]:27450 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbaETJrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:47:05 -0400
X-IronPort-AV: E=Sophos;i="4.98,873,1392163200"; 
   d="scan'208";a="133544494"
Message-ID: <537B2494.2080702@citrix.com>
Date: Tue, 20 May 2014 10:47:00 +0100
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
Subject: Re: [PATCH v4 3/5] xen: Put EFI machinery in place
References: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com> <1400272904-31121-4-git-send-email-daniel.kiper@oracle.com>
In-Reply-To: <1400272904-31121-4-git-send-email-daniel.kiper@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/05/14 21:41, Daniel Kiper wrote:
> Put EFI machinery for Xen in place.

Put what machinery to do what?

> @@ -1714,6 +1725,21 @@ asmlinkage __visible void __init xen_start_kernel(void)
>  
>  	xen_setup_runstate_info(0);
>  
> +	efi_systab_xen = xen_efi_probe();
> +
> +	if (efi_systab_xen) {
> +		strncpy((char *)&boot_params.efi_info.efi_loader_signature, "Xen",
> +				sizeof(boot_params.efi_info.efi_loader_signature));
> +		boot_params.efi_info.efi_systab = (__u32)((__u64)efi_systab_xen);
> +		boot_params.efi_info.efi_systab_hi = (__u32)((__u64)efi_systab_xen >> 32);
> +
> +		x86_platform.get_wallclock = efi_get_time;

x86_platform.get_wallclock should always be xen_get_wallclock().

> +		x86_platform.set_wallclock = efi_set_rtc_mmss;
> +
> +		set_bit(EFI_BOOT, &efi.flags);
> +		set_bit(EFI_64BIT, &efi.flags);
> +	}
> +
>  	/* Start the world */
>  #ifdef CONFIG_X86_32
>  	i386_start_kernel();
> --- /dev/null
> +++ b/drivers/xen/efi.c
> @@ -0,0 +1,374 @@
> + * Copyright (c) 2014 Daniel Kiper, Oracle Corporation

Is this really copyright by you personally and not Oracle?


> +#define call (op.u.efi_runtime_call)
> +#define DECLARE_CALL(what) \
> +	struct xen_platform_op op; \
> +	op.cmd = XENPF_efi_runtime_call; \
> +	call.function = XEN_EFI_##what; \
> +	call.misc = 0

Macros that declare local variables are awful.

Use what Andrew suggested and something like

struct xen_blah *call = &op.u.efi_runtime_call;


> +static const struct efi efi_xen __initconst = {
> +	.systab                   = NULL, /* Initialized later. */
> +	.runtime_version	  = 0,    /* Initialized later. */
> +	.mps                      = EFI_INVALID_TABLE_ADDR,
> +	.acpi                     = EFI_INVALID_TABLE_ADDR,
> +	.acpi20                   = EFI_INVALID_TABLE_ADDR,
> +	.smbios                   = EFI_INVALID_TABLE_ADDR,
> +	.sal_systab               = EFI_INVALID_TABLE_ADDR,
> +	.boot_info                = EFI_INVALID_TABLE_ADDR,
> +	.hcdp                     = EFI_INVALID_TABLE_ADDR,
> +	.uga                      = EFI_INVALID_TABLE_ADDR,
> +	.uv_systab                = EFI_INVALID_TABLE_ADDR,
> +	.fw_vendor                = EFI_INVALID_TABLE_ADDR,
> +	.runtime                  = EFI_INVALID_TABLE_ADDR,
> +	.config_table             = EFI_INVALID_TABLE_ADDR,
> +	.get_time                 = xen_efi_get_time,
> +	.set_time                 = xen_efi_set_time,
> +	.get_wakeup_time          = xen_efi_get_wakeup_time,
> +	.set_wakeup_time          = xen_efi_set_wakeup_time,
> +	.get_variable             = xen_efi_get_variable,
> +	.get_next_variable        = xen_efi_get_next_variable,
> +	.set_variable             = xen_efi_set_variable,
> +	.query_variable_info      = xen_efi_query_variable_info,
> +	.update_capsule           = xen_efi_update_capsule,
> +	.query_capsule_caps       = xen_efi_query_capsule_caps,
> +	.get_next_high_mono_count = xen_efi_get_next_high_mono_count,
> +	.reset_system             = NULL, /* Functionality provided by Xen. */

Xen provides functionality to reset (just maybe not via an EFI call).
Should an implementation be provided that does this?

> +	.set_virtual_address_map  = NULL, /* Not used under Xen. */
> +	.memmap                   = NULL, /* Not used under Xen. */
> +	.flags			  = 0     /* Initialized later. */
> +};
> +
> +efi_system_table_t __init *xen_efi_probe(void)
> +{
> +	struct xen_platform_op op = {
> +		.cmd = XENPF_firmware_info,
> +		.u.firmware_info = {
> +			.type = XEN_FW_EFI_INFO,
> +			.index = XEN_FW_EFI_CONFIG_TABLE
> +		}
> +	};
> +	union xenpf_efi_info *info = &op.u.firmware_info.u.efi_info;
> +
> +	if (!xen_initial_domain() || HYPERVISOR_dom0_op(&op))
> +		return NULL;

	if (!xen_initial_domain())
		return NULL;

	if (HYPERVISOR_dom0_op(&op) < 0)
		return NULL;

> +
> +	/* Here we know that Xen runs on EFI platform. */
> +
> +	efi = efi_xen;
> +
> +	op.cmd = XENPF_firmware_info;
> +	op.u.firmware_info.type = XEN_FW_EFI_INFO;
> +	op.u.firmware_info.index = XEN_FW_EFI_VENDOR;
> +	info->vendor.bufsz = sizeof(vendor);
> +	set_xen_guest_handle(info->vendor.name, vendor);
> +
> +	if (!HYPERVISOR_dom0_op(&op)) {

if (HYPERVISOR_dom0_op(&op) == 0)

David
