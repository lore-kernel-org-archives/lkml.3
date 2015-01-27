Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699AbbA0ECw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 23:02:52 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:53006 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbbA0ECt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 23:02:49 -0500
Message-ID: <54C70DDD.9040408@linux.vnet.ibm.com>
Date: Tue, 27 Jan 2015 09:32:37 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>, rafael.j.wysocki@intel.com
CC: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: cpuidle/powernv: Read target_residency value of idle states from
 DT if available
References: <20150123045906.D0086140297@ozlabs.org>
In-Reply-To: <20150123045906.D0086140297@ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-6
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012704-0025-0000-0000-00000813E49B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2015 10:29 AM, Michael Ellerman wrote:
> On Tue, 2015-20-01 at 11:26:49 UTC, Preeti U Murthy wrote:
>> @@ -177,34 +178,39 @@ static int powernv_add_idle_states(void)
>>  		return nr_idle_states;
>>  	}
>>  
>> -	idle_state_latency = of_get_property(power_mgt,
>> -			"ibm,cpu-idle-state-latencies-ns", NULL);
>> -	if (!idle_state_latency) {
>> +	dt_idle_states = len_flags / sizeof(u32);
>> +
>> +	latency_ns = kzalloc(sizeof(*latency_ns) * dt_idle_states, GFP_KERNEL);
>> +	rc = of_property_read_u32(power_mgt,
>> +			"ibm,cpu-idle-state-latencies-ns", latency_ns);
> 
> That's only reading the first value.
> 
> If you want to read the full property you need the _array version.

Right, thanks for pointing this out.
> 
>> +	if (rc) {
>>  		pr_warn("DT-PowerMgmt: missing ibm,cpu-idle-state-latencies-ns\n");
> 
> You missed my hint that "DT-PowerMgmt" is a weird and ugly prefix. Can you use
> "cpuidle-powernv:" instead?

Yes will change this.
> 
>>  
>> -	dt_idle_states = len_flags / sizeof(u32);
>> +	residency_ns = kzalloc(sizeof(*residency_ns) * dt_idle_states, GFP_KERNEL);
>> +	rc = of_property_read_u32(power_mgt,
>> +			"ibm,cpu-idle-state-residency-ns", residency_ns);
>> +	if (rc) {
>> +		pr_warn("DT-PowerMgmt: missing ibm,cpu-idle-state-residency-ns\n");
>> +		pr_warn("Falling back to default values\n");
> 
> I don't think this is worth a warning seeing as we know there are firmwares out
> there which do not have the property.
> 
>>  	for (i = 0; i < dt_idle_states; i++) {
>>  
>>  		flags = be32_to_cpu(idle_state_flags[i]);
>> -
>> -		/* Cpuidle accepts exit_latency in us and we estimate
>> -		 * target residency to be 10x exit_latency
>> +		/*
>> +		 * Cpuidle accepts exit_latency and target_residency in us.
>> +		 * Use default target_residency values if f/w does not expose it.
>>  		 */
>> -		latency_ns = be32_to_cpu(idle_state_latency[i]);
>>  		if (flags & OPAL_PM_NAP_ENABLED) {
>>  			/* Add NAP state */
>>  			strcpy(powernv_states[nr_idle_states].name, "Nap");
>>  			strcpy(powernv_states[nr_idle_states].desc, "Nap");
>>  			powernv_states[nr_idle_states].flags = 0;
>> -			powernv_states[nr_idle_states].exit_latency =
>> -					((unsigned int)latency_ns) / 1000;
>> -			powernv_states[nr_idle_states].target_residency =
>> -					((unsigned int)latency_ns / 100);
>> +			powernv_states[nr_idle_states].target_residency = 100;
>>  			powernv_states[nr_idle_states].enter = &nap_loop;
>> -			nr_idle_states++;
> 
> That looks wrong? Or do you mean to do that?

Are you pointing at removing the lines that populate the exit_latency ?
I read the latency value from the DT outside of these conditions because
it is guaranteed to be present at this point. We return back from this
function early on if we do not find it in the DT.

If you are pointing at the lines that remove increment of
nr_idle_states, it has to be done so towards the end of the iteration
because we are yet to populate the exit_latency and target_residency
outside of these conditions using this index.

Regards
Preeti U Murthy
> 
> cheers
> 

