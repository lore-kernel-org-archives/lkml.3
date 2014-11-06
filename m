Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751081AbaKFKxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 05:53:19 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:60340 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaKFKxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 05:53:13 -0500
Message-ID: <545B5315.50903@redhat.com>
Date: Thu, 06 Nov 2014 11:53:09 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.comp.emulators.kvm.devel
To: David Matlack <dmatlack@google.com>, kvm@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: x86: add trace event for pvclock updates
References: <1415216802-19201-1-git-send-email-dmatlack@google.com>
In-Reply-To: <1415216802-19201-1-git-send-email-dmatlack@google.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/11/2014 20:46, David Matlack wrote:
> The new trace event records:
>   * the id of vcpu being updated
>   * the pvclock_vcpu_time_info struct being written to guest memory
> 
> This is useful for debugging pvclock bugs, such as the bug fixed by
> "[PATCH] kvm: x86: Fix kvm clock versioning.".
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/trace.h | 37 +++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/x86.c   |  2 ++
>  2 files changed, 39 insertions(+)
> 
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index 6b06ab8..c2a34bb 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -5,6 +5,7 @@
>  #include <asm/vmx.h>
>  #include <asm/svm.h>
>  #include <asm/clocksource.h>
> +#include <asm/pvclock-abi.h>
>  
>  #undef TRACE_SYSTEM
>  #define TRACE_SYSTEM kvm
> @@ -877,6 +878,42 @@ TRACE_EVENT(kvm_ple_window,
>  #define trace_kvm_ple_window_shrink(vcpu_id, new, old) \
>  	trace_kvm_ple_window(false, vcpu_id, new, old)
>  
> +TRACE_EVENT(kvm_pvclock_update,
> +	TP_PROTO(unsigned int vcpu_id, struct pvclock_vcpu_time_info *pvclock),
> +	TP_ARGS(vcpu_id, pvclock),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned int,	vcpu_id			)
> +		__field(	__u32,		version			)
> +		__field(	__u64,		tsc_timestamp		)
> +		__field(	__u64,		system_time		)
> +		__field(	__u32,		tsc_to_system_mul	)
> +		__field(	__s8,		tsc_shift		)
> +		__field(	__u8,		flags			)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->vcpu_id	   = vcpu_id;
> +		__entry->version	   = pvclock->version;
> +		__entry->tsc_timestamp	   = pvclock->tsc_timestamp;
> +		__entry->system_time	   = pvclock->system_time;
> +		__entry->tsc_to_system_mul = pvclock->tsc_to_system_mul;
> +		__entry->tsc_shift	   = pvclock->tsc_shift;
> +		__entry->flags		   = pvclock->flags;
> +	),
> +
> +	TP_printk("vcpu_id %u, pvclock { version %u, tsc_timestamp 0x%llx, "
> +		  "system_time 0x%llx, tsc_to_system_mul 0x%x, tsc_shift %d, "
> +		  "flags 0x%x }",
> +		  __entry->vcpu_id,
> +		  __entry->version,
> +		  __entry->tsc_timestamp,
> +		  __entry->system_time,
> +		  __entry->tsc_to_system_mul,
> +		  __entry->tsc_shift,
> +		  __entry->flags)
> +);
> +
>  #endif /* _TRACE_KVM_H */
>  
>  #undef TRACE_INCLUDE_PATH
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 0033df3..0f533df 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1662,6 +1662,8 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>  
>  	vcpu->hv_clock.flags = pvclock_flags;
>  
> +	trace_kvm_pvclock_update(v->vcpu_id, &vcpu->hv_clock);
> +
>  	kvm_write_guest_cached(v->kvm, &vcpu->pv_time,
>  				&vcpu->hv_clock,
>  				sizeof(vcpu->hv_clock));
> 

Applied, thanks.

Paolo
