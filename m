Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbaKTBHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 20:07:54 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:44436 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756706AbaKTBHw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 20:07:52 -0500
References: <1416299826-15813-1-git-send-email-ethan.zhao@oracle.com> <1416299826-15813-6-git-send-email-ethan.zhao@oracle.com> <546CB057.7040902@intel.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <546CB057.7040902@intel.com>
Content-Type: text/plain;
	charset=gb2312
Content-Transfer-Encoding: 8BIT
Message-Id: <90C55A7F-F1E6-486E-BEA7-9619A67BC7CF@gmail.com>
Cc: Ethan Zhao <ethan.zhao@oracle.com>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "dirk.j.brandewie@intel.com" <dirk.j.brandewie@intel.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "joe.jin@oracle.com" <joe.jin@oracle.com>,
        "brian.maly@oracle.com" <brian.maly@oracle.com>
X-Mailer: iPad Mail (12B410)
From: ethan <ethan.kernel@gmail.com>
Subject: Re: [PATCH 1/3] intel_pstate: skip the driver if Sun server has ACPI _PPC method
Date: Thu, 20 Nov 2014 09:07:51 +0800
To: Dirk Brandewie <dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dirk,

> 在 2014年11月19日，22:59，Dirk Brandewie <dirk.brandewie@gmail.com> 写道：
> 
>> On 11/18/2014 12:37 AM, Ethan Zhao wrote:
>> Oracle Sun X86 servers have dynamic power capping capability that works via
>> ACPI _PPC method etc, so skip loading this driver if Sun server has ACPI _PPC
>> enabled.
>> 
>> Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
>> ---
>>  drivers/cpufreq/intel_pstate.c | 20 ++++++++++++++++++++
>>  1 file changed, 20 insertions(+)
>> 
>> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
>> index 27bb6d3..5498eb0 100644
>> --- a/drivers/cpufreq/intel_pstate.c
>> +++ b/drivers/cpufreq/intel_pstate.c
>> @@ -943,6 +943,21 @@ static bool intel_pstate_no_acpi_pss(void)
>>      return true;
>>  }
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
>>  struct hw_vendor_info {
>>      u16  valid;
>>      char oem_id[ACPI_OEM_ID_SIZE];
>> @@ -952,6 +967,7 @@ struct hw_vendor_info {
>>  /* Hardware vendor-specific info that has its own power management modes */
>>  static struct hw_vendor_info vendor_info[] = {
>>      {1, "HP    ", "ProLiant"},
>> +    {1, "ORACLE", ""},
>>      {0, "", ""},
>>  };
> 
> Does this apply to ALL oracle systems?
Yes, as I know, all recent oracle x86 servers have power capping functions.
> 
> Is the presence or absense of the _PPC method configurable in the oracle BIOS?
There is no option in BIOS to enable or disable _PPC. But they configure power limit
Functions via SP(service processors).

Thanks,
Ethan
> 
>> @@ -969,12 +985,16 @@ static bool intel_pstate_platform_pwr_mgmt_exists(void)
>>              !strncmp(hdr.oem_table_id, v_info->oem_table_id, ACPI_OEM_TABLE_ID_SIZE) &&
>>              intel_pstate_no_acpi_pss())
>>              return true;
>> +        if (!strncmp(hdr.oem_id, v_info->oem_id, ACPI_OEM_ID_SIZE) &&
>> +            intel_pstate_has_acpi_ppc())
>> +            return true;
>>      }
>> 
>>      return false;
>>  }
>>  #else /* CONFIG_ACPI not enabled */
>>  static inline bool intel_pstate_platform_pwr_mgmt_exists(void) { return false; }
>> +static inline bool intel_pstate_has_acpi_ppc(void) { return false; }
>>  #endif /* CONFIG_ACPI */
>> 
>>  static int __init intel_pstate_init(void)
> 
