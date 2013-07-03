Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab3GCPkT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 11:40:19 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:50047 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab3GCPkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 11:40:15 -0400
Message-ID: <51D445D2.50906@linux.vnet.ibm.com>
Date: Wed, 03 Jul 2013 21:10:02 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: tony.luck@intel.com, ananth@in.ibm.com, masbock@linux.vnet.ibm.com,
        lcm@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, ying.huang@intel.com
Subject: Re: [PATCH v3 3/3] mce, acpi/apei: Soft-offline a page on firmware
 GHES notification
References: <20130701230800.GO23515@pd.tnic> <20130702112424.6401.11586.stgit@localhost.localdomain> <20130703144447.GB13951@pd.tnic>
In-Reply-To: <20130703144447.GB13951@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070315-1618-0000-0000-0000043333EF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2013 08:14 PM, Borislav Petkov wrote:
> On Tue, Jul 02, 2013 at 05:02:48PM +0530, Naveen N. Rao wrote:
>> Here is the updated patch. I also added printk_ratelimit() in line with the
>> rest of the GHES code.
>>
>> Thanks,
>> Naveen
>>
>> --
>> If the firmware indicates in GHES error data entry that the error threshold
>> has exceeded for a corrected error event, then we try to soft-offline the
>> page. This could be called in interrupt context, so we queue this up similar
>> to how we handle memory failure scenarios.
>>
>>
>> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
>> ---
>>   drivers/acpi/apei/ghes.c |   38 +++++++++++++++++++++++++++++---------
>>   include/linux/mm.h       |    1 +
>>   mm/memory-failure.c      |    5 ++++-
>>   3 files changed, 34 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
>> index fcd7d91..74ef688 100644
>> --- a/drivers/acpi/apei/ghes.c
>> +++ b/drivers/acpi/apei/ghes.c
>> @@ -409,6 +409,34 @@ static void ghes_clear_estatus(struct ghes *ghes)
>>   	ghes->flags &= ~GHES_TO_CLEAR;
>>   }
>>
>> +static void ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata, int sev)
>> +{
>> +#ifdef CONFIG_ACPI_APEI_MEMORY_FAILURE
>> +	int sec_sev = ghes_severity(gdata->error_severity);
>> +	struct cper_sec_mem_err *mem_err;
>> +	mem_err = (struct cper_sec_mem_err *)(gdata+1);
>
> A newline here please. Also, spaces around '+'.

This was borrowed from existing code in ghes_do_proc(), but yes, let me 
make this change.

>
>> +	if (sec_sev == GHES_SEV_CORRECTED &&
>> +	    (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED) &&
>> +	    (mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS)) {
>> +		unsigned long pfn;
>
> This pfn is defined twice, move it up to the beginning of the function.

Ok.

>
>> +		pfn = mem_err->physical_addr >> PAGE_SHIFT;
>> +		if (pfn_valid(pfn))
>> +			memory_failure_queue(pfn, 0, MF_SOFT_OFFLINE);
>> +		else if (printk_ratelimit())
>> +			pr_warning(FW_WARN GHES_PFX
>
> WARNING: Prefer printk_ratelimited or pr_<level>_ratelimited to printk_ratelimit
> #35: FILE: drivers/acpi/apei/ghes.c:425:
> +               else if (printk_ratelimit())
>
> Please run your patches through checkpatch.pl first.

I did run checkpatch.pl, but chose to ignore this warning. ghes.c uses 
printk_ratelimit() [hence "in line with the rest of the ghes code" in 
patch description] and I felt using it is better in this scenario given 
there will be other messages being printed by the rest of the APEI code.
So, rate-limiting these messages globally seems better rather than doing 
locally using pr_warn_ratelimited()

>
> This requested change will even simplify the code (ontop of your patch):
>
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index 74ef6882bca9..87e11d468f6b 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -422,10 +422,10 @@ static void ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata, int
>   		pfn = mem_err->physical_addr >> PAGE_SHIFT;
>   		if (pfn_valid(pfn))
>   			memory_failure_queue(pfn, 0, MF_SOFT_OFFLINE);
> -		else if (printk_ratelimit())
> -			pr_warning(FW_WARN GHES_PFX
> -			"Invalid address in generic error data: %#llx\n",
> -			mem_err->physical_addr);
> +		else
> +			pr_warn_ratelimited(FW_WARN GHES_PFX
> +					    "Invalid address in generic error data: %#llx\n",
> +					    mem_err->physical_addr);
>   	}
>   	if (sev == GHES_SEV_RECOVERABLE &&
>   	    sec_sev == GHES_SEV_RECOVERABLE &&
> ---
>
>
>
>> +			"Invalid address in generic error data: %#llx\n",
>> +			mem_err->physical_addr);
>> +	}
>> +	if (sev == GHES_SEV_RECOVERABLE &&
>> +	    sec_sev == GHES_SEV_RECOVERABLE &&
>> +	    mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS) {
>> +		unsigned long pfn;
>> +		pfn = mem_err->physical_addr >> PAGE_SHIFT;
>> +		memory_failure_queue(pfn, 0, 0);
>> +	}
>> +#endif
>> +}
>> +
>>   static void ghes_do_proc(struct ghes *ghes,
>>   			 const struct acpi_hest_generic_status *estatus)
>>   {
>> @@ -428,15 +456,7 @@ static void ghes_do_proc(struct ghes *ghes,
>>   			apei_mce_report_mem_error(sev == GHES_SEV_CORRECTED,
>>   						  mem_err);
>>   #endif
>> -#ifdef CONFIG_ACPI_APEI_MEMORY_FAILURE
>> -			if (sev == GHES_SEV_RECOVERABLE &&
>> -			    sec_sev == GHES_SEV_RECOVERABLE &&
>> -			    mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS) {
>> -				unsigned long pfn;
>> -				pfn = mem_err->physical_addr >> PAGE_SHIFT;
>> -				memory_failure_queue(pfn, 0, 0);
>> -			}
>> -#endif
>> +			ghes_handle_memory_failure(gdata, sev);
>>   		}
>>   #ifdef CONFIG_ACPI_APEI_PCIEAER
>>   		else if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index e0c8528..958e9efd 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -1784,6 +1784,7 @@ enum mf_flags {
>>   	MF_COUNT_INCREASED = 1 << 0,
>>   	MF_ACTION_REQUIRED = 1 << 1,
>>   	MF_MUST_KILL = 1 << 2,
>> +	MF_SOFT_OFFLINE = 1 << 3,
>>   };
>>   extern int memory_failure(unsigned long pfn, int trapno, int flags);
>>   extern void memory_failure_queue(unsigned long pfn, int trapno, int flags);
>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>> index ceb0c7f..0d6717e 100644
>> --- a/mm/memory-failure.c
>> +++ b/mm/memory-failure.c
>> @@ -1286,7 +1286,10 @@ static void memory_failure_work_func(struct work_struct *work)
>>   		spin_unlock_irqrestore(&mf_cpu->lock, proc_flags);
>>   		if (!gotten)
>>   			break;
>> -		memory_failure(entry.pfn, entry.trapno, entry.flags);
>> +		if (entry.flags & MF_SOFT_OFFLINE)
>> +			soft_offline_page(pfn_to_page(entry.pfn), entry.flags);
>> +		else
>> +			memory_failure(entry.pfn, entry.trapno, entry.flags);
>
> The rest looks ok to me.
>
> I'm guessing this has been tested by injecting errors...?

Yes, at least partially to ensure this works ;)

Thanks,
Naveen

