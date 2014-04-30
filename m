Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbaD3Gfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 02:35:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:48140 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbaD3Gfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 02:35:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,956,1389772800"; 
   d="scan'208";a="425756280"
Message-ID: <536097ED.5010300@intel.com>
Date: Wed, 30 Apr 2014 14:27:57 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Jiang Liu <jiang.liu@linux.intel.com>
CC: rjw@rjwysocki.net, lenb@kernel.org, katoh@mikage.ne.jp,
        smf.linux@ntlworld.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI/Processor: Fix failure of loading acpi-cpufreq driver
References: <1398827428-25540-1-git-send-email-tianyu.lan@intel.com> <53608551.8010208@linux.intel.com> <53608727.4080405@linux.intel.com>
In-Reply-To: <53608727.4080405@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年04月30日 13:16, Jiang Liu wrote:
> Hi Tianyu,
> 	Found another issue at the second glance.
> In case of x2apic, "if (apic_id < 0)" should be replaced
> by "if (apic_id == -1)" for safety.

Hi Jiang:
	Thanks for suggestion. I will update soon.
	

> Best Regards!
> Gerry
> 
> On 2014/4/30 13:08, Jiang Liu wrote:
>> Hi Tianyu,
>> 	With the suggested fix, we still need to protect
>> acpi_processor_hotadd_init() when pr->apic_id is -1,
>> otherwise it may cause invalid memory access.
>>
>> Best Regards!
>> Gerry
>>
>> diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
>> index c29c2c3ec0ad..e17befc54c34 100644
>> --- a/drivers/acpi/acpi_processor.c
>> +++ b/drivers/acpi/acpi_processor.c
>> @@ -170,6 +170,9 @@ static int acpi_processor_hotadd_init(struct
>> acpi_processor *pr)
>>         acpi_status status;
>>         int ret;
>>
>> +       if (pr->apic_id < 0)
>> +               return -ENODEV;
>> +
>>         status = acpi_evaluate_integer(pr->handle, "_STA", NULL, &sta);
>>         if (ACPI_FAILURE(status) || !(sta & ACPI_STA_DEVICE_PRESENT))
>>                 return -ENODEV;
>>
>>
>> On 2014/4/30 11:10, Lan Tianyu wrote:
>>> According commit d640113fe(ACPI: processor: fix acpi_get_cpuid for UP
>>> processor),  Bios may not provide _MAT or MADT tables and acpi_get_apicid()
>>> always returns -1. For these cases, original code will pass apic_id with
>>> vaule of -1 to acpi_map_cpuid() and it will check the acpi_id. If acpi_id
>>> is equal to zero, ignores apic_id and return zero for CPU0.
>>>
>>> Commit b981513(ACPI / scan: bail out early if failed to parse APIC
>>> ID for CPU) changed the behavior. Return ENODEV when find apic_id is
>>> less than zero after calling acpi_get_apicid(). This causes acpi-cpufreq
>>> driver fails to be loaded on some machines. This patch is to fix it.
>>>
>>> Reference:https://bugzilla.kernel.org/show_bug.cgi?id=73781
>>> Cc: stable@vger.kernel.org v3.14
>>> Reported-and-tested-by: KATO Hiroshi <katoh@mikage.ne.jp>
>>> Reported-and-tested-by: Stuart Foster <smf.linux@ntlworld.com>
>>> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
>>> ---
>>>  drivers/acpi/acpi_processor.c | 4 +---
>>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
>>> index c29c2c3..d55b603 100644
>>> --- a/drivers/acpi/acpi_processor.c
>>> +++ b/drivers/acpi/acpi_processor.c
>>> @@ -260,10 +260,8 @@ static int acpi_processor_get_info(struct acpi_device *device)
>>>  	}
>>>  
>>>  	apic_id = acpi_get_apicid(pr->handle, device_declaration, pr->acpi_id);
>>> -	if (apic_id < 0) {
>>> +	if (apic_id < 0)
>>>  		acpi_handle_debug(pr->handle, "failed to get CPU APIC ID.\n");
>>> -		return -ENODEV;
>>> -	}
>>>  	pr->apic_id = apic_id;
>>>  
>>>  	cpu_index = acpi_map_cpuid(pr->apic_id, pr->acpi_id);
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>


-- 
Best regards
Tianyu Lan
