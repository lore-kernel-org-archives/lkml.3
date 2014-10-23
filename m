Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbaJWQGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:06:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbaJWQGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:06:24 -0400
Message-ID: <1414080354.6829.2.camel@deneb.redhat.com>
Subject: Re: [PATCHv2] efi: efi-stub: notify on DTB absence
From: Mark Salter <msalter@redhat.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        leif.lindholm@linaro.org, ard.biesheuvel@linaro.org,
        matt.fleming@intel.com, roy.franz@linaro.org
Date: Thu, 23 Oct 2014 12:05:54 -0400
In-Reply-To: <1414078413-15439-1-git-send-email-mark.rutland@arm.com>
References: <1414078413-15439-1-git-send-email-mark.rutland@arm.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-23 at 16:33 +0100, Mark Rutland wrote:
> Since v1 [1]:
> * Add a positive acknowledgement for a configuration table DTB
> * Fixed a couple of typos in the commit message
> 
> Ard, Leif, Roy, I've assumed your acks from v1 are still valid with the
> additional print. Please shout if that's not the case.
> 
> Thanks,
> Mark.
> 
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/295521.html
> 
> ---->8----
> In the absence of a DTB configuration table, the EFI stub will happily
> continue attempting to boot a kernel, despite the fact that this kernel
> may not function without a description of the hardware. In this case, as
> with a typo'd "dtb=" option (e.g. "dbt=") or many other possible
> failures, the only output seen by the user will be the rather terse
> output from the EFI stub:
> 
> EFI stub: Booting Linux Kernel...
> 
> To aid those attempting to debug such failures, this patch adds a notice
> when no DTB is found, making the output more helpful:
> 
> EFI stub: Booting Linux Kernel...
> EFI stub: Generating empty DTB
> 
> Additionally, a positive acknowledgement is added when a user-specified
> DTB is in use:
> 
> EFI stub: Booting Linux Kernel...
> EFI stub: Using DTB from command line
> 
> Similarly, a positive acknowledgement is added when a DTB from a
> configuration table is in use:
> 
> EFI stub: Booting Linux Kernel...
> EFI stub: Using DTB from configuration table
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Acked-by: Leif Lindholm <leif.lindholm@linaro.org>
> Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Mark Salter <msalter@redhat.com>
> Cc: Matt Fleming <matt.fleming@intel.com>
> Acked-by: Roy Franz <roy.franz@linaro.org>
> ---
>  drivers/firmware/efi/libstub/arm-stub.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
> index 480339b..21fa50e 100644
> --- a/drivers/firmware/efi/libstub/arm-stub.c
> +++ b/drivers/firmware/efi/libstub/arm-stub.c
> @@ -243,9 +243,18 @@ unsigned long __init efi_entry(void *handle, efi_system_table_t *sys_table,
>  			goto fail_free_cmdline;
>  		}
>  	}
> -	if (!fdt_addr)
> +
> +	if (fdt_addr) {
> +		pr_efi(sys_table, "Using DTB from command line\n");
> +	} else {
>  		/* Look for a device tree configuration table entry. */
>  		fdt_addr = (uintptr_t)get_fdt(sys_table);
> +		if (fdt_addr)
> +			pr_efi(sys_table, "Using DTB from configuration table\n");
> +	}
> +
> +	if (!fdt_addr)
> +		pr_efi(sys_table, "Generating empty DTB\n");

Nitpicking: I'd put that as an else to the config table fdt_addr check
above. In any case,

Acked-by: Mark Salter <msalter@redhat.com>

>  
>  	status = handle_cmdline_files(sys_table, image, cmdline_ptr,
>  				      "initrd=", dram_base + SZ_512M,


