Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbaKUAhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 19:37:25 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:31886 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788AbaKUAhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 19:37:23 -0500
Message-ID: <546E892C.8000209@oracle.com>
Date: Fri, 21 Nov 2014 08:37:00 +0800
From: ethan zhao <ethan.zhao@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Dirk Brandewie <dirk.brandewie@gmail.com>
CC: Linda Knippers <linda.knippers@hp.com>, viresh.kumar@linaro.org,
        rjw@rjwysocki.net, corbet@lwn.net, dirk.j.brandewie@intel.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, ethan.kernel@gmail.com, joe.jin@oracle.com,
        brian.maly@oracle.com
Subject: Re: [PATCH 1/3] intel_pstate: skip the driver if Sun server has ACPI
 _PPC method
References: <1416299826-15813-1-git-send-email-ethan.zhao@oracle.com> <1416299826-15813-2-git-send-email-ethan.zhao@oracle.com> <546CFBEE.6090103@hp.com> <546E1BBE.7050906@intel.com>
In-Reply-To: <546E1BBE.7050906@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dirk,

On 2014/11/21 0:50, Dirk Brandewie wrote:
> On 11/19/2014 12:22 PM, Linda Knippers wrote:
>> On 11/18/2014 3:37 AM, Ethan Zhao wrote:
>>> Oracle Sun X86 servers have dynamic power capping capability that 
>>> works via
>>> ACPI _PPC method etc, so skip loading this driver if Sun server has 
>>> ACPI _PPC
>>> enabled.
>>>
>>> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
>>> ---
>>>   drivers/cpufreq/intel_pstate.c | 20 ++++++++++++++++++++
>>>   1 file changed, 20 insertions(+)
>>>
>>> diff --git a/drivers/cpufreq/intel_pstate.c 
>>> b/drivers/cpufreq/intel_pstate.c
>>> index 27bb6d3..5498eb0 100644
>>> --- a/drivers/cpufreq/intel_pstate.c
>>> +++ b/drivers/cpufreq/intel_pstate.c
>>> @@ -943,6 +943,21 @@ static bool intel_pstate_no_acpi_pss(void)
>>>       return true;
>>>   }
>>>
>>> +static bool intel_pstate_has_acpi_ppc(void)
>>> +{
>>> +    int i;
>>> +
>>> +    for_each_possible_cpu(i) {
>>> +        struct acpi_processor *pr = per_cpu(processors, i);
>>> +
>>> +        if (!pr)
>>> +            continue;
>>> +        if (acpi_has_method(pr->handle, "_PPC"))
>>> +            return true;
>>> +    }
>>> +    return false;
>>> +}
>>> +
>>>   struct hw_vendor_info {
>>>       u16  valid;
>>>       char oem_id[ACPI_OEM_ID_SIZE];
>>> @@ -952,6 +967,7 @@ struct hw_vendor_info {
>>>   /* Hardware vendor-specific info that has its own power management 
>>> modes */
>>>   static struct hw_vendor_info vendor_info[] = {
>>>       {1, "HP    ", "ProLiant"},
>>> +    {1, "ORACLE", ""},
>>>       {0, "", ""},
>>>   };
>>>
>>> @@ -969,12 +985,16 @@ static bool 
>>> intel_pstate_platform_pwr_mgmt_exists(void)
>>>               !strncmp(hdr.oem_table_id, v_info->oem_table_id, 
>>> ACPI_OEM_TABLE_ID_SIZE) &&
>>>               intel_pstate_no_acpi_pss())
>>>               return true;
>>> +        if (!strncmp(hdr.oem_id, v_info->oem_id, ACPI_OEM_ID_SIZE) &&
>>> +            intel_pstate_has_acpi_ppc())
>>
>> We need try this on a few platforms to make sure this patch doesn't 
>> break the
>> HP platforms that may or may not need this driver, depending on the 
>> BIOS settings.
>>
>
> It looks like HP systems would get swept up in this check too if they 
> have _PPC
    No , this patch checks the oem_id against 'ORACLE" first, will not 
affect other vendors
   even they have _PPC.

>
> What about extending the hw_vendor_info struct to include whether _PSS or
  Except refer to ACPI DSDT, I don't know how to fill such info.
> _PPC should be done for the platform since it appears that oracle and HP
> have implemented similar functionality using two different methods.
   Maybe Linda could answer this whether HP also has _PPC and should be 
wept out.
   But that doesn't happen with on the same box at the same time.

   Thanks,
   Ethan
>
>
>> I don't suppose you tested on a ProLiant too?
>>
>> -- ljk
>>
>>> +            return true;
>>>       }
>>>
>>>       return false;
>>>   }
>>>   #else /* CONFIG_ACPI not enabled */
>>>   static inline bool intel_pstate_platform_pwr_mgmt_exists(void) { 
>>> return false; }
>>> +static inline bool intel_pstate_has_acpi_ppc(void) { return false; }
>>>   #endif /* CONFIG_ACPI */
>>>
>>>   static int __init intel_pstate_init(void)
>>>
>>
>

