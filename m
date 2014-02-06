Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbaBFQLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 11:11:18 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:48381 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbaBFQLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 11:11:16 -0500
Message-ID: <52F3B2DF.3070104@linux.vnet.ibm.com>
Date: Thu, 06 Feb 2014 21:35:51 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 35/51] acpi-cpufreq: Fix CPU hotplug callback registration
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com> <20140205221052.19080.77507.stgit@srivatsabhat.in.ibm.com> <6272120.pzpJuaTe2d@vostro.rjw.lan>
In-Reply-To: <6272120.pzpJuaTe2d@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020616-5140-0000-0000-00000485178D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2014 06:13 PM, Rafael J. Wysocki wrote:
> On Thursday, February 06, 2014 03:40:53 AM Srivatsa S. Bhat wrote:
>> Subsystems that want to register CPU hotplug callbacks, as well as perform
>> initialization for the CPUs that are already online, often do it as shown
>> below:
>>
>> 	get_online_cpus();
>>
>> 	for_each_online_cpu(cpu)
>> 		init_cpu(cpu);
>>
>> 	register_cpu_notifier(&foobar_cpu_notifier);
>>
>> 	put_online_cpus();
>>
>> This is wrong, since it is prone to ABBA deadlocks involving the
>> cpu_add_remove_lock and the cpu_hotplug.lock (when running concurrently
>> with CPU hotplug operations).
>>
>> Instead, the correct and race-free way of performing the callback
>> registration is:
>>
>> 	cpu_maps_update_begin();
>>
>> 	for_each_online_cpu(cpu)
>> 		init_cpu(cpu);
>>
>> 	/* Note the use of the double underscored version of the API */
>> 	__register_cpu_notifier(&foobar_cpu_notifier);
>>
>> 	cpu_maps_update_done();
>>
>>
>> Fix the acpi-cpufreq code by using this latter form of callback registration.
>>
>> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
>> Cc: Viresh Kumar <viresh.kumar@linaro.org>
>> Cc: cpufreq@vger.kernel.org
>> Cc: linux-pm@vger.kernel.org
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> 
> Looks OK to me.  How does it depend on the rest of your series?
> 

Thank you! Same here, every patch depends only on the first patch in
the series. (Except the raid5 and the xen/balloon patches which don't
have any dependency).

But I'll be posting a v2 of this patchset soon with a rename of the
API..

Regards,
Srivatsa S. Bhat

>> ---
>>
>>  drivers/cpufreq/acpi-cpufreq.c |    7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
>> index 18448a7..e2eb471 100644
>> --- a/drivers/cpufreq/acpi-cpufreq.c
>> +++ b/drivers/cpufreq/acpi-cpufreq.c
>> @@ -907,15 +907,16 @@ static void __init acpi_cpufreq_boost_init(void)
>>  
>>  		acpi_cpufreq_driver.boost_supported = true;
>>  		acpi_cpufreq_driver.boost_enabled = boost_state(0);
>> -		get_online_cpus();
>> +
>> +		cpu_maps_update_begin();
>>  
>>  		/* Force all MSRs to the same value */
>>  		boost_set_msrs(acpi_cpufreq_driver.boost_enabled,
>>  			       cpu_online_mask);
>>  
>> -		register_cpu_notifier(&boost_nb);
>> +		__register_cpu_notifier(&boost_nb);
>>  
>> -		put_online_cpus();
>> +		cpu_maps_update_done();
>>  	}
>>  }
>>  
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe cpufreq" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Regards,
Srivatsa S. Bhat

