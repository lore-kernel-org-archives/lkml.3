Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979AbaBFKKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 05:10:55 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:41310 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875AbaBFKKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 05:10:51 -0500
Message-ID: <52F35E62.2060003@linux.vnet.ibm.com>
Date: Thu, 06 Feb 2014 15:35:22 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>, oleg@redhat.com
CC: paulus@samba.org, rusty@rustcorp.com.au, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 45/51] md, raid5: Fix CPU hotplug callback registration
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com> <20140205221244.19080.70910.stgit@srivatsabhat.in.ibm.com> <20140206121151.0cbdbaa1@notabene.brown>
In-Reply-To: <20140206121151.0cbdbaa1@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020610-5490-0000-0000-000004E52372
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2014 06:41 AM, NeilBrown wrote:
> On Thu, 06 Feb 2014 03:42:45 +0530 "Srivatsa S. Bhat"
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> 
>> From: Oleg Nesterov <oleg@redhat.com>
>>
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
>> Interestingly, the raid5 code can actually prevent double initialization and
>> hence can use the following simplified form of callback registration:
>>
>> 	register_cpu_notifier(&foobar_cpu_notifier);
>>
>> 	get_online_cpus();
>>
>> 	for_each_online_cpu(cpu)
>> 		init_cpu(cpu);
>>
>> 	put_online_cpus();
>>
>> A hotplug operation that occurs between registering the notifier and calling
>> get_online_cpus(), won't disrupt anything, because the code takes care to
>> perform the memory allocations only once.
>>
>> So reorganize the code in raid5 this way to fix the deadlock with callback
>> registration.
>>
>> Cc: Neil Brown <neilb@suse.de>
>> Cc: linux-raid@vger.kernel.org
>> Cc: stable@vger.kernel.org
>> [Srivatsa: Fixed the unregister_cpu_notifier() deadlock, added the
>> free_scratch_buffer() helper to condense code further and wrote the changelog.]
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>> ---
[...]
> 
> 
> Looks good, thanks.
> Shall I wait for a signed-of-by from Oleg, then queue it through my md tree?
> 

Sure, that sounds great, since this patch doesn't have any dependency.
Thanks a lot!

Oleg, it would be great if you could kindly add your S-O-B to this patch.
Thanks!

Regards,
Srivatsa S. Bhat

