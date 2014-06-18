Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaFRNwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 09:52:34 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:63728 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaFRNwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 09:52:32 -0400
Date: Wed, 18 Jun 2014 14:52:29 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, andrew.cooper3@citrix.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        eshelton@pobox.com, hpa@zytor.com, ian.campbell@citrix.com,
        jbeulich@suse.com, jeremy@goop.org, konrad.wilk@oracle.com,
        matt.fleming@intel.com, mingo@redhat.com, mjg59@srcf.ucam.org,
        stefano.stabellini@eu.citrix.com, tglx@linutronix.de
Subject: Re: [PATCH v5 2/7] efi: Introduce EFI_NO_DIRECT flag
Message-ID: <20140618135229.GH24049@console-pimps.org>
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com>
 <1402678823-24589-3-git-send-email-daniel.kiper@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402678823-24589-3-git-send-email-daniel.kiper@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun, at 07:00:18PM, Daniel Kiper wrote:
> Introduce EFI_NO_DIRECT flag. If it is set then kernel runs
> on EFI platform but it has not direct control on EFI stuff
> like EFI runtime, tables, structures, etc. If not this means
> that Linux Kernel has direct access to EFI infrastructure
> and everything runs as usual.
> 
> This functionality is used in Xen dom0 because hypervisor
> has full control on EFI stuff and all calls from dom0 to
> EFI must be requested via special hypercall which in turn
> executes relevant EFI code in behalf of dom0.
> 
> v5 - suggestions/fixes:
>    - rename EFI_DIRECT to EFI_NO_DIRECT
>      (suggested by David Vrabel),
>    - limit EFI_NO_DIRECT usage
>      (suggested by Jan Beulich and Matt Fleming),
>    - improve commit message
>      (suggested by David Vrabel).
> 
> Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
> ---
>  arch/x86/platform/efi/efi.c |   27 +++++++++++++++++++++------
>  drivers/firmware/efi/efi.c  |   22 +++++++++++++---------
>  include/linux/efi.h         |    3 ++-
>  3 files changed, 36 insertions(+), 16 deletions(-)

[...]

> @@ -617,13 +620,16 @@ static int __init efi_runtime_init(void)
>  	 * address of several of the EFI runtime functions, needed to
>  	 * set the firmware into virtual mode.
>  	 */
> -	if (efi_enabled(EFI_64BIT))
> -		rv = efi_runtime_init64();
> -	else
> -		rv = efi_runtime_init32();
>  
> -	if (rv)
> -		return rv;
> +	if (!efi_enabled(EFI_NO_DIRECT)) {
> +		if (efi_enabled(EFI_64BIT))
> +			rv = efi_runtime_init64();
> +		else
> +			rv = efi_runtime_init32();
> +
> +		if (rv)
> +			return rv;
> +	}
>  
>  	set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
>  

This could do with some comments to explain why you want to set
EFI_RUNTIME_SERVICES even though you're skipping efi_runtime_init*(),
e.g. that for Xen things are already mapped.

I'm not likely to remember the rationale for this in 6 months time, and
anyone else hacking on this code that isn't part of this thread also may
not realise at first glance. Comments would go a long way to fixing
that.

> @@ -1220,6 +1232,9 @@ u64 efi_mem_attributes(unsigned long phys_addr)
>  	efi_memory_desc_t *md;
>  	void *p;
>  
> +	if (!efi_enabled(EFI_MEMMAP))
> +		return 0;
> +
>  	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
>  		md = p;
>  		if ((md->phys_addr <= phys_addr) &&

This should be a separate patch, please.

> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 023937a..8bb1075 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -104,16 +104,20 @@ static struct attribute *efi_subsys_attrs[] = {
>  static umode_t efi_attr_is_visible(struct kobject *kobj,
>  				   struct attribute *attr, int n)
>  {
> -	umode_t mode = attr->mode;
> -
> -	if (attr == &efi_attr_fw_vendor.attr)
> -		return (efi.fw_vendor == EFI_INVALID_TABLE_ADDR) ? 0 : mode;
> -	else if (attr == &efi_attr_runtime.attr)
> -		return (efi.runtime == EFI_INVALID_TABLE_ADDR) ? 0 : mode;
> -	else if (attr == &efi_attr_config_table.attr)
> -		return (efi.config_table == EFI_INVALID_TABLE_ADDR) ? 0 : mode;
> +	if (attr == &efi_attr_fw_vendor.attr) {
> +		if (efi_enabled(EFI_NO_DIRECT) ||
> +				efi.fw_vendor == EFI_INVALID_TABLE_ADDR)
> +			return 0;
> +	} else if (attr == &efi_attr_runtime.attr) {
> +		if (efi_enabled(EFI_NO_DIRECT) ||
> +				efi.runtime == EFI_INVALID_TABLE_ADDR)
> +			return 0;
> +	} else if (attr == &efi_attr_config_table.attr) {
> +		if (efi.config_table == EFI_INVALID_TABLE_ADDR)
> +			return 0;
> +	}
>  
> -	return mode;
> +	return attr->mode;
>  }
  
Why don't you want to export efi.fw_vendor, etc? Rationale please.

>  static struct attribute_group efi_subsys_attr_group = {
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 41bbf8b..e917c4a 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -916,7 +916,8 @@ extern int __init efi_setup_pcdp_console(char *);
>  #define EFI_RUNTIME_SERVICES	3	/* Can we use runtime services? */
>  #define EFI_MEMMAP		4	/* Can we use EFI memory map? */
>  #define EFI_64BIT		5	/* Is the firmware 64-bit? */
> -#define EFI_ARCH_1		6	/* First arch-specific bit */
> +#define EFI_NO_DIRECT		6	/* Can we access EFI directly? */
> +#define EFI_ARCH_1		7	/* First arch-specific bit */

I like David's suggestion of using EFI_PARAVIRT.

Why the bit shuffling? Are you trying to keep the non-arch bits
together? That does make sense, and I can't help but feel that
EFI_ARCH_1 should probably be bit 31 so we can subtract 1 for each new
arch bit so we don't have to do this constant shuffling in future.

I'll need to think a bit harder about that.

EFI_PARAVIRT will be usable by architectures other than x86, correct? If
your intention is for it only ever to be used by x86, then it should
probably be EFI_ARCH_2.

-- 
Matt Fleming, Intel Open Source Technology Center
