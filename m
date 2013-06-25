Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab3FYSxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:53:15 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:46121 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab3FYSxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:53:12 -0400
Message-ID: <51C9E647.90306@linux.vnet.ibm.com>
Date: Wed, 26 Jun 2013 00:19:43 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org, walken@google.com,
        vincent.guittot@linaro.org, laijs@cn.fujitsu.com,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        sbw@mit.edu, fweisbec@gmail.com, zhong@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Shi <alex.shi@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 04/45] CPU hotplug: Add infrastructure to check lacking
 hotplug synchronization
References: <20130623133642.19094.16038.stgit@srivatsabhat.in.ibm.com> <20130623133841.19094.69631.stgit@srivatsabhat.in.ibm.com> <1372116363.18733.189.camel@gandalf.local.home>
In-Reply-To: <1372116363.18733.189.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062518-1618-0000-0000-00000426A81C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 04:56 AM, Steven Rostedt wrote:
> On Sun, 2013-06-23 at 19:08 +0530, Srivatsa S. Bhat wrote:
> 
> 
> Just to make the code a little cleaner, can you add:
> 
>> diff --git a/kernel/cpu.c b/kernel/cpu.c
>> index 860f51a..e90d9d7 100644
>> --- a/kernel/cpu.c
>> +++ b/kernel/cpu.c
>> @@ -63,6 +63,72 @@ static struct {
>>  	.refcount = 0,
>>  };
>>  
>> +#ifdef CONFIG_DEBUG_HOTPLUG_CPU
>> +
[..]
> 
> static inline void atomic_reader_refcnt_inc(void)
> {
> 	this_cpu_inc(atomic_reader_refcnt);
> }
> static inline void atomic_reader_refcnt_dec(void)
> {
> 	this_cpu_dec(atomic_reader_refcnt);
> }
> 
> #else
> static inline void atomic_reader_refcnt_inc(void)
> {
> }
> static inline void atomic_reader_refcnt_dec(void)
> {
> }
> #endif
> 
>> +#endif
>> +
>>  void get_online_cpus(void)
>>  {
>>  	might_sleep();
>> @@ -189,13 +255,22 @@ unsigned int get_online_cpus_atomic(void)
>>  	 * from going offline.
>>  	 */
>>  	preempt_disable();
>> +
>> +#ifdef CONFIG_DEBUG_HOTPLUG_CPU
>> +	this_cpu_inc(atomic_reader_refcnt);
>> +#endif
> 
> Replace the #ifdef with just:
> 
> 	atomic_reader_refcnt_inc();
> 
>>  	return smp_processor_id();
>>  }
>>  EXPORT_SYMBOL_GPL(get_online_cpus_atomic);
>>  
>>  void put_online_cpus_atomic(void)
>>  {
>> +
>> +#ifdef CONFIG_DEBUG_HOTPLUG_CPU
>> +	this_cpu_dec(atomic_reader_refcnt);
>> +#endif
> 
> And
> 
> 	atomic_reader_refcnt_dec();
> 

This makes the code look much better. Thank you!
I'll make that change in my v2.

Regards,
Srivatsa S. Bhat

