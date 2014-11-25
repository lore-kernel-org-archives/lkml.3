Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbaKYRKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:10:39 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:34219 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbaKYRKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:10:37 -0500
Message-ID: <5474B806.702@redhat.com>
Date: Tue, 25 Nov 2014 18:10:30 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org
CC: Luiz Capitulino <lcapitulino@redhat.com>, Rik van Riel <riel@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch -rt 2/2] KVM: lapic: mark LAPIC timer handler as irqsafe
References: <20141125164517.205894226@redhat.com> <20141125164545.431699058@redhat.com>
In-Reply-To: <20141125164545.431699058@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 25/11/2014 17:45, Marcelo Tosatti wrote:
> Since lapic timer handler only wakes up a simple waitqueue,
> it can be executed from hardirq context.
> 
> Reduces average cyclictest latency by 3us.
> 
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

Please include kvm@vger.kernel.org too.

Paolo

> ---
>  arch/x86/kvm/lapic.c |   42 +++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 39 insertions(+), 3 deletions(-)
> 
> Index: linux-stable-rt/arch/x86/kvm/lapic.c
> ===================================================================
> --- linux-stable-rt.orig/arch/x86/kvm/lapic.c	2014-11-25 14:14:38.636810068 -0200
> +++ linux-stable-rt/arch/x86/kvm/lapic.c	2014-11-25 14:17:28.850567059 -0200
> @@ -1031,8 +1031,38 @@
>  				   apic->divide_count);
>  }
>  
> +
> +static enum hrtimer_restart apic_timer_fn(struct hrtimer *data);
> +
> +static void apic_timer_expired(struct hrtimer *data)
> +{
> +	int ret, i = 0;
> +	enum hrtimer_restart r;
> +	struct kvm_timer *ktimer = container_of(data, struct kvm_timer, timer);
> +
> +	r = apic_timer_fn(data);
> +
> +	if (r == HRTIMER_RESTART) {
> +		do {
> +			ret = hrtimer_start_expires(data, HRTIMER_MODE_ABS);
> +			if (ret == -ETIME)
> +				hrtimer_add_expires_ns(&ktimer->timer,
> +							ktimer->period);
> +			i++;
> +		} while (ret == -ETIME && i < 10);
> +
> +		if (ret == -ETIME) {
> +			printk(KERN_ERR "%s: failed to reprogram timer\n",
> +			       __func__);
> +			WARN_ON(1);
> +		}
> +	}
> +}
> +
> +
>  static void start_apic_timer(struct kvm_lapic *apic)
>  {
> +	int ret;
>  	ktime_t now;
>  	atomic_set(&apic->lapic_timer.pending, 0);
>  
> @@ -1062,9 +1092,11 @@
>  			}
>  		}
>  
> -		hrtimer_start(&apic->lapic_timer.timer,
> +		ret = hrtimer_start(&apic->lapic_timer.timer,
>  			      ktime_add_ns(now, apic->lapic_timer.period),
>  			      HRTIMER_MODE_ABS);
> +		if (ret == -ETIME)
> +			apic_timer_expired(&apic->lapic_timer.timer);
>  
>  		apic_debug("%s: bus cycle is %" PRId64 "ns, now 0x%016"
>  			   PRIx64 ", "
> @@ -1094,8 +1126,10 @@
>  			ns = (tscdeadline - guest_tsc) * 1000000ULL;
>  			do_div(ns, this_tsc_khz);
>  		}
> -		hrtimer_start(&apic->lapic_timer.timer,
> +		ret = hrtimer_start(&apic->lapic_timer.timer,
>  			ktime_add_ns(now, ns), HRTIMER_MODE_ABS);
> +		if (ret == -ETIME)
> +			apic_timer_expired(&apic->lapic_timer.timer);
>  
>  		local_irq_restore(flags);
>  	}
> @@ -1581,6 +1615,7 @@
>  	hrtimer_init(&apic->lapic_timer.timer, CLOCK_MONOTONIC,
>  		     HRTIMER_MODE_ABS);
>  	apic->lapic_timer.timer.function = apic_timer_fn;
> +	apic->lapic_timer.timer.irqsafe = 1;
>  
>  	/*
>  	 * APIC is created enabled. This will prevent kvm_lapic_set_base from
> @@ -1699,7 +1734,8 @@
>  
>  	timer = &vcpu->arch.apic->lapic_timer.timer;
>  	if (hrtimer_cancel(timer))
> -		hrtimer_start_expires(timer, HRTIMER_MODE_ABS);
> +		if (hrtimer_start_expires(timer, HRTIMER_MODE_ABS) == -ETIME)
> +			apic_timer_expired(timer);
>  }
>  
>  /*
> 
> 
