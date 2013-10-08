Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab3JHNhL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 09:37:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038Ab3JHNhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 09:37:06 -0400
Date: Tue, 8 Oct 2013 09:37:05 -0400
From: Don Zickus <dzickus@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, gleb@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] pvclock: detect watchdog reset at pvclock read
Message-ID: <20131008133705.GR227855@redhat.com>
References: <20131008010515.516032211@amt.cnet>
 <20131008010552.779616517@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008010552.779616517@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 10:05:17PM -0300, Marcelo Tosatti wrote:
> Implement reset of kernel watchdogs at pvclock read time. This avoids
> adding special code to every watchdog.
> 
> This is possible for watchdogs which measure time based on sched_clock() or 
> ktime_get() variants.
> 
> Suggested by Don Zickus.
> 
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

Awesome.  Thanks for figuring this out Marcelo.  Does that mean we can
revert commit 5d1c0f4a now? :-)

This meets my expectations.  I'll leave it to the virt folks to figure out
if this covers all the corner cases or not.

Cheers,
Don

> 
> Index: kvm/arch/x86/kernel/kvmclock.c
> ===================================================================
> --- kvm.orig/arch/x86/kernel/kvmclock.c
> +++ kvm/arch/x86/kernel/kvmclock.c
> @@ -139,6 +139,7 @@ bool kvm_check_and_clear_guest_paused(vo
>  	src = &hv_clock[cpu].pvti;
>  	if ((src->flags & PVCLOCK_GUEST_STOPPED) != 0) {
>  		src->flags &= ~PVCLOCK_GUEST_STOPPED;
> +		pvclock_touch_watchdogs();
>  		ret = true;
>  	}
>  
> Index: kvm/arch/x86/kernel/pvclock.c
> ===================================================================
> --- kvm.orig/arch/x86/kernel/pvclock.c
> +++ kvm/arch/x86/kernel/pvclock.c
> @@ -21,6 +21,7 @@
>  #include <linux/sched.h>
>  #include <linux/gfp.h>
>  #include <linux/bootmem.h>
> +#include <linux/hung_task.h>
>  #include <asm/fixmap.h>
>  #include <asm/pvclock.h>
>  
> @@ -43,6 +44,14 @@ unsigned long pvclock_tsc_khz(struct pvc
>  	return pv_tsc_khz;
>  }
>  
> +void pvclock_touch_watchdogs(void)
> +{
> +	touch_softlockup_watchdog_sync();
> +	clocksource_touch_watchdog();
> +	rcu_cpu_stall_reset();
> +	reset_hung_task_detector();
> +}
> +
>  static atomic64_t last_value = ATOMIC64_INIT(0);
>  
>  void pvclock_resume(void)
> @@ -74,6 +83,11 @@ cycle_t pvclock_clocksource_read(struct
>  		version = __pvclock_read_cycles(src, &ret, &flags);
>  	} while ((src->version & 1) || version != src->version);
>  
> +	if (unlikely((flags & PVCLOCK_GUEST_STOPPED) != 0)) {
> +		src->flags &= ~PVCLOCK_GUEST_STOPPED;
> +		pvclock_touch_watchdogs();
> +	}
> +
>  	if ((valid_flags & PVCLOCK_TSC_STABLE_BIT) &&
>  		(flags & PVCLOCK_TSC_STABLE_BIT))
>  		return ret;
> Index: kvm/arch/x86/include/asm/pvclock.h
> ===================================================================
> --- kvm.orig/arch/x86/include/asm/pvclock.h
> +++ kvm/arch/x86/include/asm/pvclock.h
> @@ -14,6 +14,8 @@ void pvclock_read_wallclock(struct pvclo
>  			    struct timespec *ts);
>  void pvclock_resume(void);
>  
> +void pvclock_touch_watchdogs(void);
> +
>  /*
>   * Scale a 64-bit delta by scaling and multiplying by a 32-bit fraction,
>   * yielding a 64-bit result.
> 
> 
