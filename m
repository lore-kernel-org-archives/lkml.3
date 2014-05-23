Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbaEWOs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 10:48:57 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:55290 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbaEWOsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 10:48:55 -0400
Message-ID: <537F5F8D.3030405@linux.vnet.ibm.com>
Date: Fri, 23 May 2014 20:17:41 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: peterz@infradead.org, tglx@linutronix.de, mingo@kernel.org, tj@kernel.org,
        rusty@rustcorp.com.au, akpm@linux-foundation.org, hch@infradead.org,
        mgorman@suse.de, riel@redhat.com, bp@suse.de, rostedt@goodmis.org,
        mgalbraith@suse.de, ego@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        oleg@redhat.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 3/3] CPU hotplug, smp: Flush any pending IPI callbacks
 before CPU offline
References: <20140523101134.17924.31463.stgit@srivatsabhat.in.ibm.com> <20140523101229.17924.50256.stgit@srivatsabhat.in.ibm.com> <20140523132747.GB1768@localhost.localdomain>
In-Reply-To: <20140523132747.GB1768@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052314-3864-0000-0000-00000E615274
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 06:57 PM, Frederic Weisbecker wrote:
> On Fri, May 23, 2014 at 03:42:35PM +0530, Srivatsa S. Bhat wrote:
>> During CPU offline, in the stop-machine loop, we use 2 separate stages to
>> disable interrupts, to ensure that the CPU going offline doesn't get any new
>> IPIs from the other CPUs after it has gone offline.
>>
[...]
>> +/**
>> + * generic_smp_call_function_single_interrupt - Execute SMP IPI callbacks
>> + *
>> + * Invoked by arch to handle an IPI for call function single.
>> + * Must be called with interrupts disabled.
>> + */
>> +void generic_smp_call_function_single_interrupt(void)
>> +{
>> +	static bool warned;
>> +
>> +	WARN_ON(!irqs_disabled());
>> +
>>  	/*
>>  	 * Shouldn't receive this interrupt on a cpu that is not yet online.
>>  	 */
>>  	if (unlikely(!cpu_online(smp_processor_id()) && !warned)) {
>> +		struct llist_node *entry;
>> +		struct call_single_data *csd;
>> +
>>  		warned = true;
>>  		WARN(1, "IPI on offline CPU %d\n", smp_processor_id());
>>  
>> +		entry = llist_del_all(&__get_cpu_var(call_single_queue));
> 
> This is deleting all the entries, the call to flush_smp_call_function_queue()
> will then miss these.
>

Argh! And I thought I had finally nailed it this time. :-(

Regards,
Srivatsa S. Bhat
 
>> +		entry = llist_reverse_order(entry);
> 
> 
> 
>> +
>>  		/*
>>  		 * We don't have to use the _safe() variant here
>>  		 * because we are not invoking the IPI handlers yet.
>> @@ -206,10 +250,7 @@ void generic_smp_call_function_single_interrupt(void)
>>  				csd->func);
>>  	}
>>  
>> -	llist_for_each_entry_safe(csd, csd_next, entry, llist) {
>> -		csd->func(csd->info);
>> -		csd_unlock(csd);
>> -	}
>> +	flush_smp_call_function_queue();
>>  }
>>  
>>  /*
>>
> 

