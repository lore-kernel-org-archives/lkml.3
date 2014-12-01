Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607AbaLAWD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:03:56 -0500
Received: from g4t3426.houston.hp.com ([15.201.208.54]:57436 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160AbaLAWDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:03:54 -0500
Message-ID: <547CE5C7.1060909@hp.com>
Date: Mon, 01 Dec 2014 17:03:51 -0500
From: Linda Knippers <linda.knippers@hp.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dirk Brandewie <dirk.brandewie@gmail.com>,
        Ethan Zhao <ethan.zhao@oracle.com>, dirk.j.brandewie@intel.com,
        viresh.kumar@linaro.org, rjw@rjwysocki.net, corbet@lwn.net
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, ethan.kernel@gmail.com
Subject: Re: [PATCH 1/2 V6] intel_pstate: skip this driver if Sun server has
 _PPC method
References: <1417401128-32086-1-git-send-email-ethan.zhao@oracle.com> <547C853B.4000700@gmail.com>
In-Reply-To: <547C853B.4000700@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/1/2014 10:11 AM, Dirk Brandewie wrote:
> On 11/30/2014 06:32 PM, Ethan Zhao wrote:
>> Oracle Sun X86 servers have dynamic power capping capability that works via
>> ACPI _PPC method etc, so skip loading this driver if Sun server has ACPI _PPC
>> enabled.
>>
>> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
>> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
>> Tested-by: Linda Knippers <linda.knippers@hp.com>
> 
> In the future you should not add other peoples Signed-off-by or Tested-by
> tags unless they have explicitly told you can do so. Other than that I
> am fine with this patch.

I hadn't previously testing this version of the patch but I have now so I'm
now ok with the Tested-by.

Thanks,

--ljk
> 
> --Dirk
>> ---
>>    v2: fix break HP Proliant issue.
>>    v3: expand the hardware vendor list.
>>    v4: refine code.
>>    v5v6: change enum PCC to PPC.
>>
>>   drivers/cpufreq/intel_pstate.c | 45 ++++++++++++++++++++++++++++++++++++++----
>>   1 file changed, 41 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
>> index 27bb6d3..1bb62ca 100644
>> --- a/drivers/cpufreq/intel_pstate.c
>> +++ b/drivers/cpufreq/intel_pstate.c
>> @@ -943,15 +943,46 @@ static bool intel_pstate_no_acpi_pss(void)
>>       return true;
>>   }
>>
>> +static bool intel_pstate_has_acpi_ppc(void)
>> +{
>> +    int i;
>> +
>> +    for_each_possible_cpu(i) {
>> +        struct acpi_processor *pr = per_cpu(processors, i);
>> +
>> +        if (!pr)
>> +            continue;
>> +        if (acpi_has_method(pr->handle, "_PPC"))
>> +            return true;
>> +    }
>> +    return false;
>> +}
>> +
>> +enum {
>> +    PSS,
>> +    PPC,
>> +};
>> +
>>   struct hw_vendor_info {
>>       u16  valid;
>>       char oem_id[ACPI_OEM_ID_SIZE];
>>       char oem_table_id[ACPI_OEM_TABLE_ID_SIZE];
>> +    int  oem_pwr_table;
>>   };
>>
>>   /* Hardware vendor-specific info that has its own power management modes */
>>   static struct hw_vendor_info vendor_info[] = {
>> -    {1, "HP    ", "ProLiant"},
>> +    {1, "HP    ", "ProLiant", PSS},
>> +    {1, "ORACLE", "X4-2    ", PPC},
>> +    {1, "ORACLE", "X4-2L   ", PPC},
>> +    {1, "ORACLE", "X4-2B   ", PPC},
>> +    {1, "ORACLE", "X3-2    ", PPC},
>> +    {1, "ORACLE", "X3-2L   ", PPC},
>> +    {1, "ORACLE", "X3-2B   ", PPC},
>> +    {1, "ORACLE", "X4470M2 ", PPC},
>> +    {1, "ORACLE", "X4270M3 ", PPC},
>> +    {1, "ORACLE", "X4270M2 ", PPC},
>> +    {1, "ORACLE", "X4170M2 ", PPC},
>>       {0, "", ""},
>>   };
>>
>> @@ -966,15 +997,21 @@ static bool intel_pstate_platform_pwr_mgmt_exists(void)
>>
>>       for (v_info = vendor_info; v_info->valid; v_info++) {
>>           if (!strncmp(hdr.oem_id, v_info->oem_id, ACPI_OEM_ID_SIZE) &&
>> -            !strncmp(hdr.oem_table_id, v_info->oem_table_id,
>> ACPI_OEM_TABLE_ID_SIZE) &&
>> -            intel_pstate_no_acpi_pss())
>> -            return true;
>> +            !strncmp(hdr.oem_table_id, v_info->oem_table_id,
>> +                        ACPI_OEM_TABLE_ID_SIZE))
>> +            switch (v_info->oem_pwr_table) {
>> +            case PSS:
>> +                return intel_pstate_no_acpi_pss();
>> +            case PPC:
>> +                return intel_pstate_has_acpi_ppc();
>> +            }
>>       }
>>
>>       return false;
>>   }
>>   #else /* CONFIG_ACPI not enabled */
>>   static inline bool intel_pstate_platform_pwr_mgmt_exists(void) { return
>> false; }
>> +static inline bool intel_pstate_has_acpi_ppc(void) { return false; }
>>   #endif /* CONFIG_ACPI */
>>
>>   static int __init intel_pstate_init(void)
>>
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

