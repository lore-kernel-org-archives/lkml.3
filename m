Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515AbaESTvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:51:16 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:35506 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbaESTvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:51:14 -0400
Message-ID: <537A6060.7070406@linux.vnet.ibm.com>
Date: Tue, 20 May 2014 01:19:52 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org, fweisbec@gmail.com,
        paulmck@linux.vnet.ibm.com, peterz@infradead.org, tglx@linutronix.de,
        mingo@kernel.org, rusty@rustcorp.com.au, hch@infradead.org,
        mgorman@suse.de, riel@redhat.com, bp@suse.de, rostedt@goodmis.org,
        mgalbraith@suse.de, ego@linux.vnet.ibm.com, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 UPDATEDv2 3/3] CPU hotplug, smp: Flush any pending
 IPI callbacks before CPU offline
References: <20140515191218.19811.25887.stgit@srivatsabhat.in.ibm.com> <20140515191358.19811.70381.stgit@srivatsabhat.in.ibm.com> <20140515191938.GB21306@htj.dyndns.org> <537514D3.4060308@linux.vnet.ibm.com> <20140515193656.GM4570@linux.vnet.ibm.com> <537518D6.6030006@linux.vnet.ibm.com> <5379F6BD.1090809@linux.vnet.ibm.com> <20140519161836.GA30387@redhat.com>
In-Reply-To: <20140519161836.GA30387@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051919-1396-0000-0000-000004DE70A2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/19/2014 09:48 PM, Oleg Nesterov wrote:
> On 05/19, Srivatsa S. Bhat wrote:
>>
>> However, an IPI sent much earlier might arrive late on the target CPU
>> (possibly _after_ the CPU has gone offline) due to hardware latencies,
>> and due to this, the smp-call-function callbacks queued on the outgoing
>> CPU might not get noticed (and hence not executed) at all.
> 
> OK, but
> 
>> +void flush_smp_call_function_queue(void)
>> +{
>> +	struct llist_head *head;
>> +	struct llist_node *entry;
>> +	struct call_single_data *csd, *csd_next;
>> +
>> +	WARN_ON(!irqs_disabled());
>> +
>> +	head = &__get_cpu_var(call_single_queue);
>> +
>> +	if (likely(llist_empty(head)))
>> +		return;
>> +
>> +	entry = llist_del_all(head);
>> +	entry = llist_reverse_order(entry);
>> +
>> +	llist_for_each_entry_safe(csd, csd_next, entry, llist) {
>> +		csd->func(csd->info);
>> +		csd_unlock(csd);
>> +	}
>> +}
> 
> why do we need it? Can't multi_cpu_stop() just call
> generic_smp_call_function_single_interrupt() ? This cpu is still online,
> we should not worry about WARN_ON(!cpu_online()) ?
> 

Ah, cool idea! :-) I'll use this method and post an updated patch.

Thank you!
 
Regards,
Srivatsa S. Bhat

