Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153Ab3GCOoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:44:54 -0400
Received: from mail.skyhub.de ([78.46.96.112]:42727 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932714Ab3GCOow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:44:52 -0400
Date: Wed, 3 Jul 2013 16:44:48 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: tony.luck@intel.com, ananth@in.ibm.com, masbock@linux.vnet.ibm.com,
        lcm@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, ying.huang@intel.com
Subject: Re: [PATCH v3 3/3] mce, acpi/apei: Soft-offline a page on firmware
 GHES notification
Message-ID: <20130703144447.GB13951@pd.tnic>
References: <20130701230800.GO23515@pd.tnic>
 <20130702112424.6401.11586.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130702112424.6401.11586.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 02, 2013 at 05:02:48PM +0530, Naveen N. Rao wrote:
> Here is the updated patch. I also added printk_ratelimit() in line with the
> rest of the GHES code.
> 
> Thanks,
> Naveen
> 
> --
> If the firmware indicates in GHES error data entry that the error threshold
> has exceeded for a corrected error event, then we try to soft-offline the
> page. This could be called in interrupt context, so we queue this up similar
> to how we handle memory failure scenarios.
> 
> 
> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
> ---
>  drivers/acpi/apei/ghes.c |   38 +++++++++++++++++++++++++++++---------
>  include/linux/mm.h       |    1 +
>  mm/memory-failure.c      |    5 ++++-
>  3 files changed, 34 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index fcd7d91..74ef688 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -409,6 +409,34 @@ static void ghes_clear_estatus(struct ghes *ghes)
>  	ghes->flags &= ~GHES_TO_CLEAR;
>  }
>  
> +static void ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata, int sev)
> +{
> +#ifdef CONFIG_ACPI_APEI_MEMORY_FAILURE
> +	int sec_sev = ghes_severity(gdata->error_severity);
> +	struct cper_sec_mem_err *mem_err;
> +	mem_err = (struct cper_sec_mem_err *)(gdata+1);

A newline here please. Also, spaces around '+'.

> +	if (sec_sev == GHES_SEV_CORRECTED &&
> +	    (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED) &&
> +	    (mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS)) {
> +		unsigned long pfn;

This pfn is defined twice, move it up to the beginning of the function.

> +		pfn = mem_err->physical_addr >> PAGE_SHIFT;
> +		if (pfn_valid(pfn))
> +			memory_failure_queue(pfn, 0, MF_SOFT_OFFLINE);
> +		else if (printk_ratelimit())
> +			pr_warning(FW_WARN GHES_PFX

WARNING: Prefer printk_ratelimited or pr_<level>_ratelimited to printk_ratelimit
#35: FILE: drivers/acpi/apei/ghes.c:425:
+               else if (printk_ratelimit())

Please run your patches through checkpatch.pl first.

This requested change will even simplify the code (ontop of your patch):

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 74ef6882bca9..87e11d468f6b 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -422,10 +422,10 @@ static void ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata, int
 		pfn = mem_err->physical_addr >> PAGE_SHIFT;
 		if (pfn_valid(pfn))
 			memory_failure_queue(pfn, 0, MF_SOFT_OFFLINE);
-		else if (printk_ratelimit())
-			pr_warning(FW_WARN GHES_PFX
-			"Invalid address in generic error data: %#llx\n",
-			mem_err->physical_addr);
+		else
+			pr_warn_ratelimited(FW_WARN GHES_PFX
+					    "Invalid address in generic error data: %#llx\n",
+					    mem_err->physical_addr);
 	}
 	if (sev == GHES_SEV_RECOVERABLE &&
 	    sec_sev == GHES_SEV_RECOVERABLE &&
---



> +			"Invalid address in generic error data: %#llx\n",
> +			mem_err->physical_addr);
> +	}
> +	if (sev == GHES_SEV_RECOVERABLE &&
> +	    sec_sev == GHES_SEV_RECOVERABLE &&
> +	    mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS) {
> +		unsigned long pfn;
> +		pfn = mem_err->physical_addr >> PAGE_SHIFT;
> +		memory_failure_queue(pfn, 0, 0);
> +	}
> +#endif
> +}
> +
>  static void ghes_do_proc(struct ghes *ghes,
>  			 const struct acpi_hest_generic_status *estatus)
>  {
> @@ -428,15 +456,7 @@ static void ghes_do_proc(struct ghes *ghes,
>  			apei_mce_report_mem_error(sev == GHES_SEV_CORRECTED,
>  						  mem_err);
>  #endif
> -#ifdef CONFIG_ACPI_APEI_MEMORY_FAILURE
> -			if (sev == GHES_SEV_RECOVERABLE &&
> -			    sec_sev == GHES_SEV_RECOVERABLE &&
> -			    mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS) {
> -				unsigned long pfn;
> -				pfn = mem_err->physical_addr >> PAGE_SHIFT;
> -				memory_failure_queue(pfn, 0, 0);
> -			}
> -#endif
> +			ghes_handle_memory_failure(gdata, sev);
>  		}
>  #ifdef CONFIG_ACPI_APEI_PCIEAER
>  		else if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index e0c8528..958e9efd 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1784,6 +1784,7 @@ enum mf_flags {
>  	MF_COUNT_INCREASED = 1 << 0,
>  	MF_ACTION_REQUIRED = 1 << 1,
>  	MF_MUST_KILL = 1 << 2,
> +	MF_SOFT_OFFLINE = 1 << 3,
>  };
>  extern int memory_failure(unsigned long pfn, int trapno, int flags);
>  extern void memory_failure_queue(unsigned long pfn, int trapno, int flags);
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index ceb0c7f..0d6717e 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1286,7 +1286,10 @@ static void memory_failure_work_func(struct work_struct *work)
>  		spin_unlock_irqrestore(&mf_cpu->lock, proc_flags);
>  		if (!gotten)
>  			break;
> -		memory_failure(entry.pfn, entry.trapno, entry.flags);
> +		if (entry.flags & MF_SOFT_OFFLINE)
> +			soft_offline_page(pfn_to_page(entry.pfn), entry.flags);
> +		else
> +			memory_failure(entry.pfn, entry.trapno, entry.flags);

The rest looks ok to me.

I'm guessing this has been tested by injecting errors...?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
