Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbaHUI3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 04:29:34 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63322 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaHUI3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 04:29:32 -0400
Message-ID: <53F5ADE6.30106@redhat.com>
Date: Thu, 21 Aug 2014 10:29:26 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, kvm@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v2 5/6] KVM: trace kvm_ple_window
References: <1408567997-21222-1-git-send-email-rkrcmar@redhat.com> <1408567997-21222-6-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1408567997-21222-6-git-send-email-rkrcmar@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 20/08/2014 22:53, Radim Krčmář ha scritto:
> Tracepoint for dynamic PLE window, fired on every potential change.
> 
> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> ---
>  arch/x86/kvm/trace.h | 25 +++++++++++++++++++++++++
>  arch/x86/kvm/vmx.c   |  8 +++++---
>  arch/x86/kvm/x86.c   |  1 +
>  3 files changed, 31 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index e850a7d..4b8e6cb 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -848,6 +848,31 @@ TRACE_EVENT(kvm_track_tsc,
>  		  __print_symbolic(__entry->host_clock, host_clocks))
>  );
>  
> +TRACE_EVENT(kvm_ple_window,
> +	TP_PROTO(int grow, unsigned int vcpu_id, int new, int old),

s/int grow/bool grow/ (and similarly in TP_STRUCT__entry).


> +	TP_ARGS(grow, vcpu_id, new, old),
> +
> +	TP_STRUCT__entry(
> +		__field(                 int,      grow         )
> +		__field(        unsigned int,   vcpu_id         )
> +		__field(                 int,       new         )
> +		__field(                 int,       old         )
> +	),
> +
> +	TP_fast_assign(
> +		__entry->grow           = grow;
> +		__entry->vcpu_id        = vcpu_id;
> +		__entry->new            = new;
> +		__entry->old            = old;
> +	),
> +
> +	TP_printk("vcpu %u: ple_window %d %s %d",
> +	          __entry->vcpu_id,
> +	          __entry->new,
> +	          __entry->grow ? "<+" : "<-",

? "grow" : "shrink"

With these changes,

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

> +	          __entry->old)
> +);
> +
>  #endif /* CONFIG_X86_64 */
>  
>  #endif /* _TRACE_KVM_H */
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index e63d7ac..f63ac5d 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -5728,15 +5728,17 @@ static int __shrink_ple_window(int val, int shrinker, int minimum)
>  static void modify_ple_window(struct kvm_vcpu *vcpu, int grow)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +	int old = vmx->ple_window;
>  	int new;
>  
>  	if (grow)
> -		new = __grow_ple_window(vmx->ple_window);
> +		new = __grow_ple_window(old)
>  	else
> -		new = __shrink_ple_window(vmx->ple_window, ple_window_shrink,
> -		                          ple_window);
> +		new = __shrink_ple_window(old, ple_window_shrink, ple_window);
>  
>  	vmx->ple_window = max(new, ple_window);
> +
> +	trace_kvm_ple_window(grow, vcpu->vcpu_id, vmx->ple_window, old);
>  }
>  #define grow_ple_window(vcpu)   modify_ple_window(vcpu, 1)
>  #define shrink_ple_window(vcpu) modify_ple_window(vcpu, 0)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5696ee7..814b20c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7648,3 +7648,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_invlpga);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_skinit);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intercepts);
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_write_tsc_offset);
> +EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_ple_window);
> 

