Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab3FFA1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 20:27:20 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:19056 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092Ab3FFA1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 20:27:17 -0400
Message-ID: <51AFD75C.3030705@oracle.com>
Date: Thu, 06 Jun 2013 08:27:08 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Viresh Kumar <viresh.kumar@linaro.org>, Neil Gu <qing.gu@oracle.com>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI: update user_policy.max when _PPC updated
References: <51AE8BE4.8050409@oracle.com> <31897041.QcNuTieHbo@vostro.rjw.lan>
In-Reply-To: <31897041.QcNuTieHbo@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/13 04:40, Rafael J. Wysocki wrote:
> On Wednesday, June 05, 2013 08:52:52 AM Joe Jin wrote:
>> When _PPC changed dynamically the user_policy.max will not be updated,
>> this prevent CPU run on the highest frequency.
> 
> Why should the user setting be always related to the current maximum available
> frequency?  What if the user sets the limit for power capping purposes?

cpufreq_update_policy() get policy->max from user_policy.max:

1782 int cpufreq_update_policy(unsigned int cpu)
1783 {
[...]
1800         policy.min = data->user_policy.min;
1801         policy.max = data->user_policy.max;
1802         policy.policy = data->user_policy.policy;
1803         policy.governor = data->user_policy.governor;
[...]
1819         ret = __cpufreq_set_policy(data, &policy);
[...]

/sys/devices/system/cpu/cpu$/cpufreq/scaling_max_freq using policy->max 
and user_policy->max, when update it, so I think _PPC changes also need
to update these two?

Thanks,
Joe
 
> 
> Rafael
> 
> 
>> Signed-off-by: Joe Jin <joe.jin@oracle.com>
>> Cc: Rafael J. Wysocki <rjw@sisk.pl>
>> Cc: Viresh Kumar <viresh.kumar@linaro.org>
>> ---
>>  drivers/acpi/processor_perflib.c | 17 ++++++++++++++++-
>>  1 file changed, 16 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
>> index e854582..e01aa7d 100644
>> --- a/drivers/acpi/processor_perflib.c
>> +++ b/drivers/acpi/processor_perflib.c
>> @@ -180,6 +180,7 @@ static void acpi_processor_ppc_ost(acpi_handle handle, int status)
>>  int acpi_processor_ppc_has_changed(struct acpi_processor *pr, int event_flag)
>>  {
>>  	int ret;
>> +	unsigned int saved = (unsigned int)pr->performance_platform_limit;
>>  
>>  	if (ignore_ppc) {
>>  		/*
>> @@ -204,8 +205,22 @@ int acpi_processor_ppc_has_changed(struct acpi_processor *pr, int event_flag)
>>  	}
>>  	if (ret < 0)
>>  		return (ret);
>> -	else
>> +	else {
>> +		unsigned int ppc = (unsigned int)pr->performance_platform_limit;
>> +
>> +		if (saved != ppc) {
>> +			struct cpufreq_policy *policy;
>> +
>> +			policy = cpufreq_cpu_get(pr->id);
>> +			if (likely(policy))
>> +				policy->user_policy.max =
>> +					pr->performance->states[ppc].
>> +					core_frequency * 1000;
>> +			cpufreq_cpu_put(policy);
>> +		}
>> +
>>  		return cpufreq_update_policy(pr->id);
>> +	}
>>  }
>>  
>>  int acpi_processor_get_bios_limit(int cpu, unsigned int *limit)
>>


-- 
Oracle <http://www.oracle.com>
Joe Jin | Software Development Senior Manager | +8610.6106.5624
ORACLE | Linux and Virtualization
No. 24 Zhongguancun Software Park, Haidian District | 100193 Beijing 
