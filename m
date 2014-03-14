Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbaCNFn4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 01:43:56 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:58083 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbaCNFnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 01:43:53 -0400
Message-ID: <53229701.8050405@linux.vnet.ibm.com>
Date: Fri, 14 Mar 2014 11:13:29 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Christoffer Dall <christoffer.dall@linaro.org>
CC: paulus@samba.org, oleg@redhat.com, mingo@kernel.org, rjw@rjwysocki.net,
        rusty@rustcorp.com.au, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pm@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Gleb Natapov <gleb@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Bonzini <pbonzini@redhat.com>, marc.zyngier@arm.com
Subject: Re: [PATCH v3 10/52] arm, kvm: Fix CPU hotplug callback registration
References: <20140310203312.10746.310.stgit@srivatsabhat.in.ibm.com> <20140310203538.10746.25364.stgit@srivatsabhat.in.ibm.com> <20140312232127.GC24808@cbox>
In-Reply-To: <20140312232127.GC24808@cbox>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14031405-5490-0000-0000-00000529E4F0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 04:51 AM, Christoffer Dall wrote:
> On Tue, Mar 11, 2014 at 02:05:38AM +0530, Srivatsa S. Bhat wrote:
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
>> 	cpu_notifier_register_begin();
>>
>> 	for_each_online_cpu(cpu)
>> 		init_cpu(cpu);
>>
>> 	/* Note the use of the double underscored version of the API */
>> 	__register_cpu_notifier(&foobar_cpu_notifier);
>>
>> 	cpu_notifier_register_done();
>>
>>
>> Fix the kvm code in arm by using this latter form of callback registration.
>>
>> Cc: Christoffer Dall <christoffer.dall@linaro.org>
>> Cc: Gleb Natapov <gleb@kernel.org>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: kvmarm@lists.cs.columbia.edu
>> Cc: kvm@vger.kernel.org
>> Cc: linux-arm-kernel@lists.infradead.org
>> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>> ---
>>
>>  arch/arm/kvm/arm.c |    7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>> index bd18bb8..f0e50a0 100644
>> --- a/arch/arm/kvm/arm.c
>> +++ b/arch/arm/kvm/arm.c
>> @@ -1051,21 +1051,26 @@ int kvm_arch_init(void *opaque)
>>  		}
>>  	}
>>  
>> +	cpu_notifier_register_begin();
>> +
>>  	err = init_hyp_mode();
>>  	if (err)
>>  		goto out_err;
>>  
>> -	err = register_cpu_notifier(&hyp_init_cpu_nb);
>> +	err = __register_cpu_notifier(&hyp_init_cpu_nb);
>>  	if (err) {
>>  		kvm_err("Cannot register HYP init CPU notifier (%d)\n", err);
>>  		goto out_err;
>>  	}
>>  
>> +	cpu_notifier_register_done();
>> +
>>  	hyp_cpu_pm_init();
>>  
>>  	kvm_coproc_table_init();
>>  	return 0;
>>  out_err:
>> +	cpu_notifier_register_done();
>>  	return err;
>>  }
>>  
>>
> 
> Just so we're clear, the existing code was simply racy as not prone to
> deadlocks, right?
> 
> This makes it clear that the test above for compatible CPUs can be quite
> easily evaded by using CPU hotplug, but we don't really have a good
> solution for handling that yet...  Hmmm, grumble grumble, I guess if you
> hotplug unsupported CPUs on a KVM/ARM system for now, stuff will break.
> 

In this particular case, there was no deadlock possibility, rather the
existing code had insufficient synchronization against CPU hotplug.

init_hyp_mode() would invoke cpu_init_hyp_mode() on currently online CPUs
using on_each_cpu(). If a CPU came online after this point and before calling
register_cpu_notifier(), that CPU would remain uninitialized because this
subsystem would miss the hot-online event. This patch fixes this bug and
also uses the new synchronization method (instead of get/put_online_cpus())
to ensure that we don't deadlock with CPU hotplug.

> In any case:
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
> 

Thanks a lot!

Regards,
Srivatsa S. Bhat

