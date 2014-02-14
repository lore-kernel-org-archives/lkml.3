Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbaBNKat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 05:30:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242AbaBNKaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 05:30:46 -0500
Message-ID: <52FDF013.2030101@redhat.com>
Date: Fri, 14 Feb 2014 11:29:39 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, paulus@samba.org,
        oleg@redhat.com, mingo@kernel.org, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org
CC: paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Gleb Natapov <gleb@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 29/52] x86, kvm: Fix CPU hotplug callback registration
References: <20140214074750.22701.47330.stgit@srivatsabhat.in.ibm.com> <20140214075542.22701.24501.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140214075542.22701.24501.stgit@srivatsabhat.in.ibm.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 14/02/2014 08:55, Srivatsa S. Bhat ha scritto:
> Subsystems that want to register CPU hotplug callbacks, as well as perform
> initialization for the CPUs that are already online, often do it as shown
> below:
>
> 	get_online_cpus();
>
> 	for_each_online_cpu(cpu)
> 		init_cpu(cpu);
>
> 	register_cpu_notifier(&foobar_cpu_notifier);
>
> 	put_online_cpus();
>
> This is wrong, since it is prone to ABBA deadlocks involving the
> cpu_add_remove_lock and the cpu_hotplug.lock (when running concurrently
> with CPU hotplug operations).
>
> Instead, the correct and race-free way of performing the callback
> registration is:
>
> 	cpu_notifier_register_begin();
>
> 	for_each_online_cpu(cpu)
> 		init_cpu(cpu);
>
> 	/* Note the use of the double underscored version of the API */
> 	__register_cpu_notifier(&foobar_cpu_notifier);
>
> 	cpu_notifier_register_done();
>
>
> Fix the kvm code in x86 by using this latter form of callback registration.
>
> Cc: Gleb Natapov <gleb@kernel.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
>
>  arch/x86/kvm/x86.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 39c28f09..0166923 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5365,7 +5365,8 @@ static void kvm_timer_init(void)
>  	int cpu;
>
>  	max_tsc_khz = tsc_khz;
> -	register_hotcpu_notifier(&kvmclock_cpu_notifier_block);
> +
> +	cpu_notifier_register_begin();
>  	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC)) {
>  #ifdef CONFIG_CPU_FREQ
>  		struct cpufreq_policy policy;
> @@ -5382,6 +5383,10 @@ static void kvm_timer_init(void)
>  	pr_debug("kvm: max_tsc_khz = %ld\n", max_tsc_khz);
>  	for_each_online_cpu(cpu)
>  		smp_call_function_single(cpu, tsc_khz_changed, NULL, 1);
> +
> +	__register_hotcpu_notifier(&kvmclock_cpu_notifier_block);
> +	cpu_notifier_register_done();
> +
>  }
>
>  static DEFINE_PER_CPU(struct kvm_vcpu *, current_vcpu);
>

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
