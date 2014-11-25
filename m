Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375AbaKYAdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 19:33:18 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:57570 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbaKYAdQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 19:33:16 -0500
References: <1416299826-15813-1-git-send-email-ethan.zhao@oracle.com> <1416299826-15813-2-git-send-email-ethan.zhao@oracle.com> <546CFBEE.6090103@hp.com> <546E1BBE.7050906@intel.com> <546E892C.8000209@oracle.com> <546EC348.1000001@gmail.com> <54728CC0.1030708@oracle.com> <547354AD.3010609@hp.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <547354AD.3010609@hp.com>
Content-Type: text/plain;
	charset=gb2312
Content-Transfer-Encoding: 8BIT
Message-Id: <8B34F33D-6850-402A-8089-F60D132C2C87@gmail.com>
Cc: ethan zhao <ethan.zhao@oracle.com>, Linda Knippers <ljklists@gmail.com>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "dirk.j.brandewie@intel.com" <dirk.j.brandewie@intel.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "joe.jin@oracle.com" <joe.jin@oracle.com>,
        "brian.maly@oracle.com" <brian.maly@oracle.com>
X-Mailer: iPad Mail (12B435)
From: ethan <ethan.kernel@gmail.com>
Subject: Re: [PATCH 1/3] intel_pstate: skip the driver if Sun server has ACPI _PPC method
Date: Tue, 25 Nov 2014 08:33:08 +0800
To: Linda Knippers <linda.knippers@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linda，
> 在 2014年11月24日，23:54，Linda Knippers <linda.knippers@hp.com> 写道：
> 
>> On 11/23/2014 8:41 PM, ethan zhao wrote:
>> Linda,
>> 
>>> On 2014/11/21 12:44, Linda Knippers wrote:
>>> 
>>>> On 11/20/2014 07:37 PM, ethan zhao wrote:
>>>> Dirk,
>>>> 
>>>>> On 2014/11/21 0:50, Dirk Brandewie wrote:
>>>>>> On 11/19/2014 12:22 PM, Linda Knippers wrote:
>>>>>>> On 11/18/2014 3:37 AM, Ethan Zhao wrote:
>>>>>>> Oracle Sun X86 servers have dynamic power capping capability that
>>>>>>> works via
>>>>>>> ACPI _PPC method etc, so skip loading this driver if Sun server has
>>>>>>> ACPI _PPC
>>>>>>> enabled.
>>>>>>> 
>>>>>>> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
>>>>>>> ---
>>>>>>>   drivers/cpufreq/intel_pstate.c | 20 ++++++++++++++++++++
>>>>>>>   1 file changed, 20 insertions(+)
>>>>>>> 
>>>>>>> diff --git a/drivers/cpufreq/intel_pstate.c
>>>>>>> b/drivers/cpufreq/intel_pstate.c
>>>>>>> index 27bb6d3..5498eb0 100644
>>>>>>> --- a/drivers/cpufreq/intel_pstate.c
>>>>>>> +++ b/drivers/cpufreq/intel_pstate.c
>>>>>>> @@ -943,6 +943,21 @@ static bool intel_pstate_no_acpi_pss(void)
>>>>>>>       return true;
>>>>>>>   }
>>>>>>> 
>>>>>>> +static bool intel_pstate_has_acpi_ppc(void)
>>>>>>> +{
>>>>>>> +    int i;
>>>>>>> +
>>>>>>> +    for_each_possible_cpu(i) {
>>>>>>> +        struct acpi_processor *pr = per_cpu(processors, i);
>>>>>>> +
>>>>>>> +        if (!pr)
>>>>>>> +            continue;
>>>>>>> +        if (acpi_has_method(pr->handle, "_PPC"))
>>>>>>> +            return true;
>>>>>>> +    }
>>>>>>> +    return false;
>>>>>>> +}
>>>>>>> +
>>>>>>>   struct hw_vendor_info {
>>>>>>>       u16  valid;
>>>>>>>       char oem_id[ACPI_OEM_ID_SIZE];
>>>>>>> @@ -952,6 +967,7 @@ struct hw_vendor_info {
>>>>>>>   /* Hardware vendor-specific info that has its own power management
>>>>>>> modes */
>>>>>>>   static struct hw_vendor_info vendor_info[] = {
>>>>>>>       {1, "HP    ", "ProLiant"},
>>>>>>> +    {1, "ORACLE", ""},
>>>>>>>       {0, "", ""},
>>>>>>>   };
>>>>>>> 
>>>>>>> @@ -969,12 +985,16 @@ static bool
>>>>>>> intel_pstate_platform_pwr_mgmt_exists(void)
>>>>>>>               !strncmp(hdr.oem_table_id, v_info->oem_table_id,
>>>>>>> ACPI_OEM_TABLE_ID_SIZE) &&
>>>>>>>               intel_pstate_no_acpi_pss())
>>>>>>>               return true;
>>>>>>> +        if (!strncmp(hdr.oem_id, v_info->oem_id, ACPI_OEM_ID_SIZE) &&
>>>>>>> +            intel_pstate_has_acpi_ppc())
>>>>>> We need try this on a few platforms to make sure this patch doesn't
>>>>>> break the
>>>>>> HP platforms that may or may not need this driver, depending on the
>>>>>> BIOS settings.
>>>>> It looks like HP systems would get swept up in this check too if they
>>>>> have _PPC
>>> Right.  This patch breaks HP ProLiant platforms when they are
>>> configured to have the OS do power management.  In that case,
>>> the firmware exposes _PPC information.
>>  Okay, got it, The HP ProLiant has an option in BIOS could be enabled to "OS
>> PM", so
>> will export _PSS, _PPC, and  this patch break this case.
>> 
>>> 
>>>>    No , this patch checks the oem_id against 'ORACLE" first, will not
>>>> affect other vendors even they have _PPC.
>>> I don't think that's how your code works.  This patch will match any
>>> vendor that is in the table, not just "ORACLE".
>> Will change patch to match the oem-id out of the loop, such as following , how
>> about it ?
>> 
>> static bool intel_pstate_platform_pwr_mgmt_exists(void)
>> {
>>        struct acpi_table_header hdr;
>>        struct hw_vendor_info *v_info;
>> 
>>        if (acpi_disabled
>>            || ACPI_FAILURE(acpi_get_table_header(ACPI_SIG_FADT, 0, &hdr)))
>>                return false;
>> 
>>        for (v_info = vendor_info; v_info->valid; v_info++) {
>>                if (!strncmp(hdr.oem_id, v_info->oem_id, ACPI_OEM_ID_SIZE)
>>                    && !strncmp(hdr.oem_table_id, v_info->oem_table_id,
>> ACPI_OEM_TABLE_ID_SIZE)
>>                    && intel_pstate_no_acpi_pss())
>>                        return true;
>>        }
>> 
>>   if (!strncmp(hdr.oem_id, v_info[1]->oem_id, ACPI_OEM_ID_SIZE) &&
>>          intel_pstate_has_acpi_ppc())
> 
> I really don't think you want to hard code a 1 there.
> 
> I think you need to do what Dirk suggested, which is to expand the
> hw_vendor_info structure to specify the check that needs to be done
> for each entry.  For a ProLiant, it would be to call intel_pstate_no_acpi_pss()
> and for an Oracle box, it would be to call intel_pstate_has_acpi_ppc().
> 

thanks，will do that.
Ethan

> -- ljk
> 
>>           return true;
>> 
>>        return false;
>> }
>> 
>>>>> What about extending the hw_vendor_info struct to include whether _PSS or
>>>>  Except refer to ACPI DSDT, I don't know how to fill such info.
>>>>> _PPC should be done for the platform since it appears that oracle and HP
>>>>> have implemented similar functionality using two different methods.
>>>>   Maybe Linda could answer this whether HP also has _PPC and should be
>>>> wept out.
>>>>   But that doesn't happen with on the same box at the same time.
>>> I don't know how an Oracle box works but on a ProLiant, customers can
>>> choose to have platform power management or OS power management.
>>> When the platform is managing the power, we don't provide the _PSS
>>> information.  Since our oem information is in the table and there is
>>> no _PSS, the intel_pstate driver doesn't stay loaded.  That's what we want.
>>> 
>>> When the platform configured to have the OS do the power management,
>>> the firmware has _PSS and _PPC and we want the intel_pstate driver,
>>> That's what your patch breaks.  With your patch, the driver won't
>>> stay loaded because our platform is in the table and the check for
>>> _PPC passes.
>>> 
>>> How does an Oracle box work?
>>  Oracle Sun servers (X86) don't have the option in BIOS to change the PM mode
>> to firmware/OS,
>>  The BIOS always has _PSS and _PPC exported to OS whatever 'soft power capping'
>> or 'hard power capping' enabled
>>  in SP configuration web page. if the power policy violation happened, firmware
>> will notify OS via SCI with the changed _PPC
>>  number.
>> 
>>  Thanks,
>>  Ethan
>>> 
>>> -- ljk
>>> 
>>>>   Thanks,
>>>>   Ethan
>>>>> 
>>>>>> I don't suppose you tested on a ProLiant too?
>>>>>> 
>>>>>> -- ljk
>>>>>> 
>>>>>>> +            return true;
>>>>>>>       }
>>>>>>> 
>>>>>>>       return false;
>>>>>>>   }
>>>>>>>   #else /* CONFIG_ACPI not enabled */
>>>>>>>   static inline bool intel_pstate_platform_pwr_mgmt_exists(void) {
>>>>>>> return false; }
>>>>>>> +static inline bool intel_pstate_has_acpi_ppc(void) { return false; }
>>>>>>>   #endif /* CONFIG_ACPI */
>>>>>>> 
>>>>>>>   static int __init intel_pstate_init(void)
>>>> -- 
>>>> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
