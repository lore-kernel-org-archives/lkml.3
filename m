Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbaKTQuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:50:13 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:55966 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757825AbaKTQuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:50:10 -0500
From: Dirk Brandewie <dirk.brandewie@gmail.com>
X-Google-Original-From: Dirk Brandewie <dirk.j.brandewie@intel.com>
Message-ID: <546E1BBE.7050906@intel.com>
Date: Thu, 20 Nov 2014 08:50:06 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linda Knippers <linda.knippers@hp.com>, Ethan Zhao <ethan.zhao@oracle.com>,
        viresh.kumar@linaro.org, rjw@rjwysocki.net, corbet@lwn.net
CC: dirk.j.brandewie@intel.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        ethan.kernel@gmail.com, joe.jin@oracle.com, brian.maly@oracle.com
Subject: Re: [PATCH 1/3] intel_pstate: skip the driver if Sun server has ACPI
 _PPC method
References: <1416299826-15813-1-git-send-email-ethan.zhao@oracle.com> <1416299826-15813-2-git-send-email-ethan.zhao@oracle.com> <546CFBEE.6090103@hp.com>
In-Reply-To: <546CFBEE.6090103@hp.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2014 12:22 PM, Linda Knippers wrote:
> On 11/18/2014 3:37 AM, Ethan Zhao wrote:
>> Oracle Sun X86 servers have dynamic power capping capability that works via
>> ACPI _PPC method etc, so skip loading this driver if Sun server has ACPI _PPC
>> enabled.
>>
>> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
>> ---
>>   drivers/cpufreq/intel_pstate.c | 20 ++++++++++++++++++++
>>   1 file changed, 20 insertions(+)
>>
>> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
>> index 27bb6d3..5498eb0 100644
>> --- a/drivers/cpufreq/intel_pstate.c
>> +++ b/drivers/cpufreq/intel_pstate.c
>> @@ -943,6 +943,21 @@ static bool intel_pstate_no_acpi_pss(void)
>>   	return true;
>>   }
>>
>> +static bool intel_pstate_has_acpi_ppc(void)
>> +{
>> +	int i;
>> +
>> +	for_each_possible_cpu(i) {
>> +		struct acpi_processor *pr = per_cpu(processors, i);
>> +
>> +		if (!pr)
>> +			continue;
>> +		if (acpi_has_method(pr->handle, "_PPC"))
>> +			return true;
>> +	}
>> +	return false;
>> +}
>> +
>>   struct hw_vendor_info {
>>   	u16  valid;
>>   	char oem_id[ACPI_OEM_ID_SIZE];
>> @@ -952,6 +967,7 @@ struct hw_vendor_info {
>>   /* Hardware vendor-specific info that has its own power management modes */
>>   static struct hw_vendor_info vendor_info[] = {
>>   	{1, "HP    ", "ProLiant"},
>> +	{1, "ORACLE", ""},
>>   	{0, "", ""},
>>   };
>>
>> @@ -969,12 +985,16 @@ static bool intel_pstate_platform_pwr_mgmt_exists(void)
>>   		    !strncmp(hdr.oem_table_id, v_info->oem_table_id, ACPI_OEM_TABLE_ID_SIZE) &&
>>   		    intel_pstate_no_acpi_pss())
>>   			return true;
>> +		if (!strncmp(hdr.oem_id, v_info->oem_id, ACPI_OEM_ID_SIZE) &&
>> +			intel_pstate_has_acpi_ppc())
>
> We need try this on a few platforms to make sure this patch doesn't break the
> HP platforms that may or may not need this driver, depending on the BIOS settings.
>

It looks like HP systems would get swept up in this check too if they have _PPC

What about extending the hw_vendor_info struct to include whether _PSS or
_PPC should be done for the platform since it appears that oracle and HP
have implemented similar functionality using two different methods.


> I don't suppose you tested on a ProLiant too?
>
> -- ljk
>
>> +			return true;
>>   	}
>>
>>   	return false;
>>   }
>>   #else /* CONFIG_ACPI not enabled */
>>   static inline bool intel_pstate_platform_pwr_mgmt_exists(void) { return false; }
>> +static inline bool intel_pstate_has_acpi_ppc(void) { return false; }
>>   #endif /* CONFIG_ACPI */
>>
>>   static int __init intel_pstate_init(void)
>>
>

