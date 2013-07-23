Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933603Ab3GWQWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 12:22:41 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:52107 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595Ab3GWQWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:22:40 -0400
Message-ID: <51EEAD93.8060300@linux.vnet.ibm.com>
Date: Tue, 23 Jul 2013 21:51:39 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Michael Ellerman <michael@ellerman.id.au>
CC: PowerPC email list <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Preeti Murthy <preeti@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: cpuidle/pseries: Fix kernel command line parameter smt-snooze-delay
References: <51EE0C65.6020903@linux.vnet.ibm.com> <20130723140256.GH31944@concordia>
In-Reply-To: <20130723140256.GH31944@concordia>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072316-0260-0000-0000-0000035B537E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 07:32 PM, Michael Ellerman wrote:
> On Tue, Jul 23, 2013 at 10:23:57AM +0530, Deepthi Dharwar wrote:
>> smt-snooze-delay is a tun-able provided currently on powerpc to delay the
>> entry of an idle cpu to NAP state. By default, the value is 100us,
>> which is entry criteria for NAP state i.e only if the idle period is
>> above 100us it would enter NAP. Value of -1 disables entry into NAP.
>> This value can be set either through sysfs, ppc64_cpu util or by
>> passing it via kernel command line. Currently this feature is broken
>> when the value is passed via the kernel command line.
> 
> Has it always been broken? Or just since some commit?

Yes, it is broken since inclusion of pseries back-end driver, around 3.3
kernel time-frame.

>> This patch aims to fix this, by taking the appropriate action
>> based on the value after the pseries driver is registered.
>> This check is carried on in the back-end driver rather than
>> setup_smt_snooze_delay(), as one is not sure if the cpuidle driver
>> is even registered when setup routine is executed.
>> Also, this fixes re-enabling of NAP states by setting appropriate
>> value without having to reboot using smt-snooze-delay parameter.
>>
>> Also, to note is, smt-snooze-delay is per-cpu variable.
>> This can be used to enable/disable NAP on per-cpu
>> basis using sysfs but when this variable is passed
>> via kernel command line or using the smt-snooze-delay
>> it applies to all the cpus. Per-cpu tuning can
>> only be done via sysfs.
>>
>> Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
>> ---
>>  arch/powerpc/platforms/pseries/processor_idle.c |   34 ++++++++++++++++++-----
>>  1 file changed, 27 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/powerpc/platforms/pseries/processor_idle.c b/arch/powerpc/platforms/pseries/processor_idle.c
>> index 4644efa0..8133f50 100644
>> --- a/arch/powerpc/platforms/pseries/processor_idle.c
>> +++ b/arch/powerpc/platforms/pseries/processor_idle.c
>> @@ -170,18 +170,36 @@ static struct cpuidle_state shared_states[MAX_IDLE_STATE_COUNT] = {
>>  void update_smt_snooze_delay(int cpu, int residency)
>>  {
>>  	struct cpuidle_driver *drv = cpuidle_get_driver();
>> -	struct cpuidle_device *dev = per_cpu(cpuidle_devices, cpu);
>> +	struct cpuidle_device *dev;
>>  
>>  	if (cpuidle_state_table != dedicated_states)
>>  		return;
>>  
>> -	if (residency < 0) {
>> -		/* Disable the Nap state on that cpu */
>> -		if (dev)
>> -			dev->states_usage[1].disable = 1;
>> -	} else
>> -		if (drv)
>> +	if (!drv)
>> +		return;
>> +
>> +	if (cpu == -1) {
>> +		if (residency < 0) {
>> +			/* Disable NAP on all cpus */
>> +			drv->states[1].disabled = true;
>> +		} else {
>>  			drv->states[1].target_residency = residency;
>> +			drv->states[1].disabled = false;
>> +		}
>> +		return;
>> +	}
>> +
>> +	dev = per_cpu(cpuidle_devices, cpu);
>> +	if (!dev)
>> +		return;
>> +
>> +	if (residency < 0)
>> +		dev->states_usage[1].disable = 1;
>> +	else {
>> +		drv->states[1].target_residency = residency;
>> +		drv->states[1].disabled = false;
>> +		dev->states_usage[1].disable = 0;
> 
> Why are we indexing into all these array with '1' ?

We are disabling/enabling  NAP state, which indexes into pseries cpuidle
state table array with index value of 1.
smt-snooze-delay of -1, disables NAP state.
Else, we need to set the residency of NAP state i.e minimum time CPU
should spend in NAP state ( based on which menu governor takes a
decision on selection of Idle state) there by delaying the entry to NAP
state.

Thanks for the review.

Regards,
Deepthi

> cheers
> 

