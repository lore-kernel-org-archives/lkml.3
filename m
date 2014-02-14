Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaBNKbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 05:31:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbaBNKbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 05:31:15 -0500
Message-ID: <52FDF000.5070609@redhat.com>
Date: Fri, 14 Feb 2014 11:29:20 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, paulus@samba.org,
        oleg@redhat.com, mingo@kernel.org, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org
CC: paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        ego@linux.vnet.ibm.com, linux@arm.linux.org.uk, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Gleb Natapov <gleb@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 10/52] arm, kvm: Fix CPU hotplug callback registration
References: <20140214074750.22701.47330.stgit@srivatsabhat.in.ibm.com> <20140214075122.22701.18462.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140214075122.22701.18462.stgit@srivatsabhat.in.ibm.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 14/02/2014 08:51, Srivatsa S. Bhat ha scritto:
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
> Fix the kvm code in arm by using this latter form of callback registration.
>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: Gleb Natapov <gleb@kernel.org>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: kvmarm@lists.cs.columbia.edu
> Cc: kvm@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
>
>  arch/arm/kvm/arm.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 1d8248e..147b917 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -1050,21 +1050,26 @@ int kvm_arch_init(void *opaque)
>  		}
>  	}
>
> +	cpu_notifier_register_begin();
> +
>  	err = init_hyp_mode();
>  	if (err)
>  		goto out_err;
>
> -	err = register_cpu_notifier(&hyp_init_cpu_nb);
> +	err = __register_cpu_notifier(&hyp_init_cpu_nb);
>  	if (err) {
>  		kvm_err("Cannot register HYP init CPU notifier (%d)\n", err);
>  		goto out_err;
>  	}
>
> +	cpu_notifier_register_done();
> +
>  	hyp_cpu_pm_init();
>
>  	kvm_coproc_table_init();
>  	return 0;
>  out_err:
> +	cpu_notifier_register_done();
>  	return err;
>  }
>
>

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
