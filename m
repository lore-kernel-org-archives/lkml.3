Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaETLap (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 07:30:45 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51000 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaETLan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 07:30:43 -0400
Date: Tue, 20 May 2014 13:29:33 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com,
        eshelton@pobox.com, hpa@zytor.com, ian.campbell@citrix.com,
        jbeulich@suse.com, jeremy@goop.org, konrad.wilk@oracle.com,
        matt.fleming@intel.com, mingo@redhat.com, mjg59@srcf.ucam.org,
        stefano.stabellini@eu.citrix.com, tglx@linutronix.de
Subject: Re: [PATCH v4 3/5] xen: Put EFI machinery in place
Message-ID: <20140520112933.GF3529@olila.local.net-space.pl>
References: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com>
 <1400272904-31121-4-git-send-email-daniel.kiper@oracle.com>
 <537B2494.2080702@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537B2494.2080702@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 10:47:00AM +0100, David Vrabel wrote:
> On 16/05/14 21:41, Daniel Kiper wrote:
> > Put EFI machinery for Xen in place.
>
> Put what machinery to do what?
>
> > @@ -1714,6 +1725,21 @@ asmlinkage __visible void __init xen_start_kernel(void)
> >
> >  	xen_setup_runstate_info(0);
> >
> > +	efi_systab_xen = xen_efi_probe();
> > +
> > +	if (efi_systab_xen) {
> > +		strncpy((char *)&boot_params.efi_info.efi_loader_signature, "Xen",
> > +				sizeof(boot_params.efi_info.efi_loader_signature));
> > +		boot_params.efi_info.efi_systab = (__u32)((__u64)efi_systab_xen);
> > +		boot_params.efi_info.efi_systab_hi = (__u32)((__u64)efi_systab_xen >> 32);
> > +
> > +		x86_platform.get_wallclock = efi_get_time;
>
> x86_platform.get_wallclock should always be xen_get_wallclock().

Hmmm... Make sens... Jan, why did you replace x86_platform.get_wallclock
with efi_get_time() in your implementation?

> > +		x86_platform.set_wallclock = efi_set_rtc_mmss;

Now I am not sure even about that. As I can see Linux Kernel
running on bare metal EFI platform directly sets RTC omitting
efi_set_rtc_mmss(). Am I missing something? IIRC, there was
discussion about that once. But where and when?

Anyway, now I think that this initialization should be done
in arch/x86/xen/time.c if needed.

> > +
> > +		set_bit(EFI_BOOT, &efi.flags);
> > +		set_bit(EFI_64BIT, &efi.flags);
> > +	}
> > +
> >  	/* Start the world */
> >  #ifdef CONFIG_X86_32
> >  	i386_start_kernel();
> > --- /dev/null
> > +++ b/drivers/xen/efi.c
> > @@ -0,0 +1,374 @@
> > + * Copyright (c) 2014 Daniel Kiper, Oracle Corporation
>
> Is this really copyright by you personally and not Oracle?

As I know it is correct but I will double check it.

>
>
> > +#define call (op.u.efi_runtime_call)
> > +#define DECLARE_CALL(what) \
> > +	struct xen_platform_op op; \
> > +	op.cmd = XENPF_efi_runtime_call; \
> > +	call.function = XEN_EFI_##what; \
> > +	call.misc = 0
>
> Macros that declare local variables are awful.
>
> Use what Andrew suggested and something like
>
> struct xen_blah *call = &op.u.efi_runtime_call;
>
>
> > +static const struct efi efi_xen __initconst = {
> > +	.systab                   = NULL, /* Initialized later. */
> > +	.runtime_version	  = 0,    /* Initialized later. */
> > +	.mps                      = EFI_INVALID_TABLE_ADDR,
> > +	.acpi                     = EFI_INVALID_TABLE_ADDR,
> > +	.acpi20                   = EFI_INVALID_TABLE_ADDR,
> > +	.smbios                   = EFI_INVALID_TABLE_ADDR,
> > +	.sal_systab               = EFI_INVALID_TABLE_ADDR,
> > +	.boot_info                = EFI_INVALID_TABLE_ADDR,
> > +	.hcdp                     = EFI_INVALID_TABLE_ADDR,
> > +	.uga                      = EFI_INVALID_TABLE_ADDR,
> > +	.uv_systab                = EFI_INVALID_TABLE_ADDR,
> > +	.fw_vendor                = EFI_INVALID_TABLE_ADDR,
> > +	.runtime                  = EFI_INVALID_TABLE_ADDR,
> > +	.config_table             = EFI_INVALID_TABLE_ADDR,
> > +	.get_time                 = xen_efi_get_time,
> > +	.set_time                 = xen_efi_set_time,
> > +	.get_wakeup_time          = xen_efi_get_wakeup_time,
> > +	.set_wakeup_time          = xen_efi_set_wakeup_time,
> > +	.get_variable             = xen_efi_get_variable,
> > +	.get_next_variable        = xen_efi_get_next_variable,
> > +	.set_variable             = xen_efi_set_variable,
> > +	.query_variable_info      = xen_efi_query_variable_info,
> > +	.update_capsule           = xen_efi_update_capsule,
> > +	.query_capsule_caps       = xen_efi_query_capsule_caps,
> > +	.get_next_high_mono_count = xen_efi_get_next_high_mono_count,
> > +	.reset_system             = NULL, /* Functionality provided by Xen. */
>
> Xen provides functionality to reset (just maybe not via an EFI call).
> Should an implementation be provided that does this?

I do not think so. efi.reset_system() would not be called on Xen because
all reset related stuff is replaced by Xen reset specific functions.
Please check arch/x86/xen/enlighten.c. Additionally, I think that
situation is a bit similar to time issue. If we are running on Xen
then we should ask Xen to do reset because Xen controls platform
and it knows how to do that.

> > +	.set_virtual_address_map  = NULL, /* Not used under Xen. */
> > +	.memmap                   = NULL, /* Not used under Xen. */
> > +	.flags			  = 0     /* Initialized later. */
> > +};
> > +
> > +efi_system_table_t __init *xen_efi_probe(void)
> > +{
> > +	struct xen_platform_op op = {
> > +		.cmd = XENPF_firmware_info,
> > +		.u.firmware_info = {
> > +			.type = XEN_FW_EFI_INFO,
> > +			.index = XEN_FW_EFI_CONFIG_TABLE
> > +		}
> > +	};
> > +	union xenpf_efi_info *info = &op.u.firmware_info.u.efi_info;
> > +
> > +	if (!xen_initial_domain() || HYPERVISOR_dom0_op(&op))
> > +		return NULL;
>
> 	if (!xen_initial_domain())
> 		return NULL;
>
> 	if (HYPERVISOR_dom0_op(&op) < 0)
> 		return NULL;

What is wrong with my if?

> > +
> > +	/* Here we know that Xen runs on EFI platform. */
> > +
> > +	efi = efi_xen;
> > +
> > +	op.cmd = XENPF_firmware_info;
> > +	op.u.firmware_info.type = XEN_FW_EFI_INFO;
> > +	op.u.firmware_info.index = XEN_FW_EFI_VENDOR;
> > +	info->vendor.bufsz = sizeof(vendor);
> > +	set_xen_guest_handle(info->vendor.name, vendor);
> > +
> > +	if (!HYPERVISOR_dom0_op(&op)) {
>
> if (HYPERVISOR_dom0_op(&op) == 0)

Ditto?

Daniel
