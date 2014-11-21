Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599AbaKUEpB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 23:45:01 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:57196 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203AbaKUEo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 23:44:59 -0500
Message-ID: <546EC348.1000001@gmail.com>
Date: Thu, 20 Nov 2014 23:44:56 -0500
From: Linda Knippers <ljklists@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: ethan zhao <ethan.zhao@oracle.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>
CC: Linda Knippers <linda.knippers@hp.com>, viresh.kumar@linaro.org,
        rjw@rjwysocki.net, corbet@lwn.net, dirk.j.brandewie@intel.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, ethan.kernel@gmail.com, joe.jin@oracle.com,
        brian.maly@oracle.com
Subject: Re: [PATCH 1/3] intel_pstate: skip the driver if Sun server has ACPI
 _PPC method
References: <1416299826-15813-1-git-send-email-ethan.zhao@oracle.com> <1416299826-15813-2-git-send-email-ethan.zhao@oracle.com> <546CFBEE.6090103@hp.com> <546E1BBE.7050906@intel.com> <546E892C.8000209@oracle.com>
In-Reply-To: <546E892C.8000209@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/20/2014 07:37 PM, ethan zhao wrote:
> Dirk,
> 
> On 2014/11/21 0:50, Dirk Brandewie wrote:
>> On 11/19/2014 12:22 PM, Linda Knippers wrote:
>>> On 11/18/2014 3:37 AM, Ethan Zhao wrote:
>>>> Oracle Sun X86 servers have dynamic power capping capability that
>>>> works via
>>>> ACPI _PPC method etc, so skip loading this driver if Sun server has
>>>> ACPI _PPC
>>>> enabled.
>>>>
>>>> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
>>>> ---
>>>>   drivers/cpufreq/intel_pstate.c | 20 ++++++++++++++++++++
>>>>   1 file changed, 20 insertions(+)
>>>>
>>>> diff --git a/drivers/cpufreq/intel_pstate.c
>>>> b/drivers/cpufreq/intel_pstate.c
>>>> index 27bb6d3..5498eb0 100644
>>>> --- a/drivers/cpufreq/intel_pstate.c
>>>> +++ b/drivers/cpufreq/intel_pstate.c
>>>> @@ -943,6 +943,21 @@ static bool intel_pstate_no_acpi_pss(void)
>>>>       return true;
>>>>   }
>>>>
>>>> +static bool intel_pstate_has_acpi_ppc(void)
>>>> +{
>>>> +    int i;
>>>> +
>>>> +    for_each_possible_cpu(i) {
>>>> +        struct acpi_processor *pr = per_cpu(processors, i);
>>>> +
>>>> +        if (!pr)
>>>> +            continue;
>>>> +        if (acpi_has_method(pr->handle, "_PPC"))
>>>> +            return true;
>>>> +    }
>>>> +    return false;
>>>> +}
>>>> +
>>>>   struct hw_vendor_info {
>>>>       u16  valid;
>>>>       char oem_id[ACPI_OEM_ID_SIZE];
>>>> @@ -952,6 +967,7 @@ struct hw_vendor_info {
>>>>   /* Hardware vendor-specific info that has its own power management
>>>> modes */
>>>>   static struct hw_vendor_info vendor_info[] = {
>>>>       {1, "HP    ", "ProLiant"},
>>>> +    {1, "ORACLE", ""},
>>>>       {0, "", ""},
>>>>   };
>>>>
>>>> @@ -969,12 +985,16 @@ static bool
>>>> intel_pstate_platform_pwr_mgmt_exists(void)
>>>>               !strncmp(hdr.oem_table_id, v_info->oem_table_id,
>>>> ACPI_OEM_TABLE_ID_SIZE) &&
>>>>               intel_pstate_no_acpi_pss())
>>>>               return true;
>>>> +        if (!strncmp(hdr.oem_id, v_info->oem_id, ACPI_OEM_ID_SIZE) &&
>>>> +            intel_pstate_has_acpi_ppc())
>>>
>>> We need try this on a few platforms to make sure this patch doesn't
>>> break the
>>> HP platforms that may or may not need this driver, depending on the
>>> BIOS settings.
>>>
>>
>> It looks like HP systems would get swept up in this check too if they
>> have _PPC

Right.  This patch breaks HP ProLiant platforms when they are
configured to have the OS do power management.  In that case,
the firmware exposes _PPC information.

>    No , this patch checks the oem_id against 'ORACLE" first, will not
> affect other vendors even they have _PPC.

I don't think that's how your code works.  This patch will match any
vendor that is in the table, not just "ORACLE".
> 
>>
>> What about extending the hw_vendor_info struct to include whether _PSS or
>  Except refer to ACPI DSDT, I don't know how to fill such info.
>> _PPC should be done for the platform since it appears that oracle and HP
>> have implemented similar functionality using two different methods.
>   Maybe Linda could answer this whether HP also has _PPC and should be
> wept out.
>   But that doesn't happen with on the same box at the same time.

I don't know how an Oracle box works but on a ProLiant, customers can
choose to have platform power management or OS power management.
When the platform is managing the power, we don't provide the _PSS
information.  Since our oem information is in the table and there is
no _PSS, the intel_pstate driver doesn't stay loaded.  That's what we want.

When the platform configured to have the OS do the power management,
the firmware has _PSS and _PPC and we want the intel_pstate driver,
That's what your patch breaks.  With your patch, the driver won't
stay loaded because our platform is in the table and the check for
_PPC passes.

How does an Oracle box work?

-- ljk

> 
>   Thanks,
>   Ethan
>>
>>
>>> I don't suppose you tested on a ProLiant too?
>>>
>>> -- ljk
>>>
>>>> +            return true;
>>>>       }
>>>>
>>>>       return false;
>>>>   }
>>>>   #else /* CONFIG_ACPI not enabled */
>>>>   static inline bool intel_pstate_platform_pwr_mgmt_exists(void) {
>>>> return false; }
>>>> +static inline bool intel_pstate_has_acpi_ppc(void) { return false; }
>>>>   #endif /* CONFIG_ACPI */
>>>>
>>>>   static int __init intel_pstate_init(void)
>>>>
>>>
>>
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
