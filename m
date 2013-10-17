Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab3JQKjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 06:39:16 -0400
Received: from mail-qe0-f48.google.com ([209.85.128.48]:58113 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab3JQKjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 06:39:13 -0400
Message-ID: <525FBE4B.9060206@redhat.com>
Date: Thu, 17 Oct 2013 12:39:07 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: linux-kernel@vger.kernel.org, Gleb Natapov <gleb@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        kvm@vger.kernel.org
Subject: Re: [PATCH 4/7] static_key: use static_key_slow_inc_deferred()
References: <1382004631-25895-1-git-send-email-rkrcmar@redhat.com> <1382004631-25895-5-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1382004631-25895-5-git-send-email-rkrcmar@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/10/2013 12:10, Radim Krčmář ha scritto:
> Simple replacement where possible.
> Saves us problematic access to the structure and allows optimalizations
> and bug fixes to take place.

I think you should introduce this first as a simple wrapper around
static_key_slow_inc, and then add the bells and whistles you have in
patches 2 and 3.

Paolo

> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> ---
>  arch/x86/kvm/lapic.c | 7 ++++---
>  kernel/events/core.c | 6 +++---
>  2 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 5439117..eff85f6 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -121,7 +121,7 @@ static inline void apic_set_spiv(struct kvm_lapic *apic, u32 val)
>  		if (val & APIC_SPIV_APIC_ENABLED)
>  			static_key_slow_dec_deferred(&apic_sw_disabled);
>  		else
> -			static_key_slow_inc(&apic_sw_disabled.key);
> +			static_key_slow_inc_deferred(&apic_sw_disabled);
>  	}
>  	apic_set_reg(apic, APIC_SPIV, val);
>  }
> @@ -1351,7 +1351,7 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
>  		if (value & MSR_IA32_APICBASE_ENABLE)
>  			static_key_slow_dec_deferred(&apic_hw_disabled);
>  		else
> -			static_key_slow_inc(&apic_hw_disabled.key);
> +			static_key_slow_inc_deferred(&apic_hw_disabled);
>  		recalculate_apic_map(vcpu->kvm);
>  	}
>  
> @@ -1546,7 +1546,8 @@ int kvm_create_lapic(struct kvm_vcpu *vcpu)
>  	kvm_lapic_set_base(vcpu,
>  			APIC_DEFAULT_PHYS_BASE | MSR_IA32_APICBASE_ENABLE);
>  
> -	static_key_slow_inc(&apic_sw_disabled.key); /* sw disabled at reset */
> +	/* sw disabled at reset */
> +	static_key_slow_inc_deferred(&apic_sw_disabled);
>  	kvm_lapic_reset(vcpu);
>  	kvm_iodevice_init(&apic->dev, &apic_mmio_ops);
>  
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index d49a9d2..ade89a1 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -6565,7 +6565,7 @@ static void account_event(struct perf_event *event)
>  		return;
>  
>  	if (event->attach_state & PERF_ATTACH_TASK)
> -		static_key_slow_inc(&perf_sched_events.key);
> +		static_key_slow_inc_deferred(&perf_sched_events);
>  	if (event->attr.mmap || event->attr.mmap_data)
>  		atomic_inc(&nr_mmap_events);
>  	if (event->attr.comm)
> @@ -6577,9 +6577,9 @@ static void account_event(struct perf_event *event)
>  			tick_nohz_full_kick_all();
>  	}
>  	if (has_branch_stack(event))
> -		static_key_slow_inc(&perf_sched_events.key);
> +		static_key_slow_inc_deferred(&perf_sched_events);
>  	if (is_cgroup_event(event))
> -		static_key_slow_inc(&perf_sched_events.key);
> +		static_key_slow_inc_deferred(&perf_sched_events);
>  
>  	account_event_cpu(event, event->cpu);
>  }
> 

