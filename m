Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaI0Fdq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 01:33:46 -0400
Received: from [119.145.14.64] ([119.145.14.64]:26131 "EHLO
	szxga01-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbaI0Fdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 01:33:45 -0400
Message-ID: <54264C0B.1000607@huawei.com>
Date: Sat, 27 Sep 2014 13:32:59 +0800
From: Wang Weidong <wangweidong1@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: <viresh.kumar@linaro.org>, <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org >> \"linux-kernel@vger.kernel.org\"" 
	<linux-kernel@vger.kernel.org>
Subject: Re: [RESEND PATCH] acpi-cpufreq: get the cur_freq from acpi_processor_performance
 states
References: <53F589C3.4050504@huawei.com> <2075276.PKjjuvNeys@vostro.rjw.lan>
In-Reply-To: <2075276.PKjjuvNeys@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.75]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/27 7:21, Rafael J. Wysocki wrote:
> On Thursday, August 21, 2014 01:55:15 PM Wang Weidong wrote:
>> As the initialized freq_tables maybe different from the p-states
>> values, so the array index is different as well.
>>
>> p-states value: [2400 2400 2000 ...], while the freq_tables:
>> [2400 2000 ... CPUFREQ_TABLE_END]. After setted the freqs 2000,
>> the perf->state is 3 while the freqs_table's index should be 2.
>> So when call the get_cur_freq_on_cpu, the freqs value we get
>> is 2400.
>>
>> So, fix the problem with the correct tables.
> 
> What you're saying is basically that freq_table and perf->states
> diverge at one point.  Shouldn't we re-generate freq_table in that
> case instead of fixing up get_cur_freq_on_cpu() only in a quite
> indirect way? 
> 
Hi Rafael,

Thanks for your reply.

You mean that we should re-generate the freq_table in that case?
Could we fix the table init like this:

--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -779,7 +779,7 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)

        /* table init */
        for (i = 0; i < perf->state_count; i++) {
-               if (i > 0 && perf->states[i].core_frequency >=
+               if (i > 0 && perf->states[i].core_frequency >
                    data->freq_table[valid_states-1].frequency / 1000)
                        continue;

when the value is same, we just keep the value into the freq_table.

Regards,
Wang

>> Signed-off-by: Wang Weidong <wangweidong1@huawei.com>
>> ---
>>  drivers/cpufreq/acpi-cpufreq.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
>> index b0c18ed..ac93885 100644
>> --- a/drivers/cpufreq/acpi-cpufreq.c
>> +++ b/drivers/cpufreq/acpi-cpufreq.c
>> @@ -365,6 +365,7 @@ static u32 get_cur_val(const struct cpumask *mask)
>>  static unsigned int get_cur_freq_on_cpu(unsigned int cpu)
>>  {
>>  	struct acpi_cpufreq_data *data = per_cpu(acfreq_data, cpu);
>> +	struct acpi_processor_performance *perf;
>>  	unsigned int freq;
>>  	unsigned int cached_freq;
>>  
>> @@ -375,7 +376,8 @@ static unsigned int get_cur_freq_on_cpu(unsigned int cpu)
>>  		return 0;
>>  	}
>>  
>> -	cached_freq = data->freq_table[data->acpi_data->state].frequency;
>> +	perf = data->acpi_data;
>> +	cached_freq = perf->states[perf->state].core_frequency * 1000;
>>  	freq = extract_freq(get_cur_val(cpumask_of(cpu)), data);
>>  	if (freq != cached_freq) {
>>  		/*
>>
> 


