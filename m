Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab3CTSgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 14:36:25 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:47718 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab3CTSgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 14:36:24 -0400
Message-ID: <5149FFE1.7030706@gmail.com>
Date: Wed, 20 Mar 2013 11:28:49 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: dirk.brandewie@gmail.com, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: Re: [PATCH] cpufreq/intel_pstate: Add function to check that all
 MSR's are valid
References: <1363796244-6658-1-git-send-email-dirk.brandewie@gmail.com> <5818534.Fj7AtdhPq1@vostro.rjw.lan>
In-Reply-To: <5818534.Fj7AtdhPq1@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 11:28 AM, Rafael J. Wysocki wrote:
> On Wednesday, March 20, 2013 09:17:24 AM dirk.brandewie@gmail.com wrote:
>> From: Dirk Brandewie <dirk.brandewie@gmail.com>
>>
>> Some VMs seem to try to implement some MSRs but not all the registers
>> the driver needs.  Check to make sure all the MSR that we need are
>> available. If any of the required MSRs are not available refuse to
>> load.
>>
>> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
>
> Is this needed for v3.9?  Any pointers to bug reports etc.?
>

Sorry I saw right after I sent the mail that the bug report was missing

     https://bugzilla.redhat.com/show_bug.cgi?id=922923
     Reported-by: Josh Stone <jistone@redhat.com>

Would you like me to spin the patch?

> Rafael
>
>
>> ---
>>   drivers/cpufreq/intel_pstate.c |   26 ++++++++++++++++++++++++++
>>   1 files changed, 26 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
>> index f6dd1e7..cd9c5f4 100644
>> --- a/drivers/cpufreq/intel_pstate.c
>> +++ b/drivers/cpufreq/intel_pstate.c
>> @@ -752,6 +752,29 @@ static struct cpufreq_driver intel_pstate_driver = {
>>
>>   static int __initdata no_load;
>>
>> +static int intel_pstate_msrs_not_valid(void)
>> +{
>> +	/* Check that all the msr's we are using are valid. */
>> +	u64 aperf, mperf, tmp;
>> +
>> +	rdmsrl(MSR_IA32_APERF, aperf);
>> +	rdmsrl(MSR_IA32_MPERF, mperf);
>> +
>> +	if (!intel_pstate_min_pstate() ||
>> +		!intel_pstate_max_pstate() ||
>> +		!intel_pstate_turbo_pstate())
>> +		return -ENODEV;
>> +
>> +	rdmsrl(MSR_IA32_APERF, tmp);
>> +	if (!(tmp - aperf))
>> +		return -ENODEV;
>> +
>> +	rdmsrl(MSR_IA32_MPERF, tmp);
>> +	if (!(tmp - mperf))
>> +		return -ENODEV;
>> +
>> +	return 0;
>> +}
>>   static int __init intel_pstate_init(void)
>>   {
>>   	int cpu, rc = 0;
>> @@ -764,6 +787,9 @@ static int __init intel_pstate_init(void)
>>   	if (!id)
>>   		return -ENODEV;
>>
>> +	if (intel_pstate_msrs_not_valid())
>> +		return -ENODEV;
>> +
>>   	pr_info("Intel P-state driver initializing.\n");
>>
>>   	all_cpu_data = vmalloc(sizeof(void *) * num_possible_cpus());
>>

