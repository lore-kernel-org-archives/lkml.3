Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967208Ab3HIFy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 01:54:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49779 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966964Ab3HIFy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 01:54:26 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <520483F7.9010408@jp.fujitsu.com>
Date: Fri, 9 Aug 2013 14:53:59 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
CC: <rafael.j.wysocki@intel.com>, <toshi.kani@hp.com>,
        <linux-acpi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI, cpu hotplug: move try_offline_node() after acpi_unmap_lsapic()
References: <5200CBBF.1090904@jp.fujitsu.com> <52045747.2060207@cn.fujitsu.com>
In-Reply-To: <52045747.2060207@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/09 11:43), Gu Zheng wrote:
> Hi Ishimatsu-san,
> On 08/06/2013 06:11 PM, Yasuaki Ishimatsu wrote:
> 
>> try_offline_node() checks that all cpus related with removed node have been
>> removed by using cpu_present_bits. If all cpus related with removed node have
>> been removed, try_offline_node() clears the node information.
>>
>> But try_offline_node() called from acpi_processor_remove() never clears
>> the node information. For disabling cpu_present_bits, acpi_unmap_lsapic()
>> need be called. But acpi_unmap_lsapic() is called after try_offline_node()
>> runs. So when try_offline_node() runs, the cpu's cpu_present_bits is always
>> set.
>>
>> This patch moves try_offline_node() after acpi_unmap_lsapic().
> 
> It works well.
> 
>>
>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> 
> 
> Tested-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

Thank you for testing.

Thanks,
Yasuaki Ishimatsu

> 
> Thanks,
> Gu
> 
>> ---
>>   drivers/acpi/acpi_processor.c |    3 ++-
>>   1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
>> index fd6c51c..5a74a9c 100644
>> --- a/drivers/acpi/acpi_processor.c
>> +++ b/drivers/acpi/acpi_processor.c
>> @@ -451,7 +451,6 @@ static void acpi_processor_remove(struct acpi_device *device)
>>   	/* Clean up. */
>>   	per_cpu(processor_device_array, pr->id) = NULL;
>>   	per_cpu(processors, pr->id) = NULL;
>> -	try_offline_node(cpu_to_node(pr->id));
>>
>>   	/* Remove the CPU. */
>>   	get_online_cpus();
>> @@ -459,6 +458,8 @@ static void acpi_processor_remove(struct acpi_device *device)
>>   	acpi_unmap_lsapic(pr->id);
>>   	put_online_cpus();
>>
>> +	try_offline_node(cpu_to_node(pr->id));
>> +
>>    out:
>>   	free_cpumask_var(pr->throttling.shared_cpu_map);
>>   	kfree(pr);
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 
> 


