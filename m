Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691AbaHYNyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 09:54:14 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:34789 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406AbaHYNyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 09:54:12 -0400
Date: Mon, 25 Aug 2014 15:53:41 +0200
From: Sabrina Dubroca <sd@queasysnail.net>
To: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi Zhao <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Lisa Mitchell <lisa.mitchell@hp.com>
Subject: Re: [PATCH v3 5/7] KVM: trace kvm_ple_window grow/shrink
Message-ID: <20140825135341.GA20218@kria>
References: <1408637291-18533-1-git-send-email-rkrcmar@redhat.com>
 <1408637291-18533-6-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1408637291-18533-6-git-send-email-rkrcmar@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2014-08-21, 18:08:09 +0200, Radim Krčmář wrote:
> Tracepoint for dynamic PLE window, fired on every potential change.
> 
> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> ---
>  arch/x86/kvm/trace.h | 30 ++++++++++++++++++++++++++++++
>  arch/x86/kvm/vmx.c   | 10 ++++++++--
>  arch/x86/kvm/x86.c   |  1 +
>  3 files changed, 39 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index e850a7d..1742dfb 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -848,6 +848,36 @@ TRACE_EVENT(kvm_track_tsc,
>  		  __print_symbolic(__entry->host_clock, host_clocks))
>  );
>  
> +TRACE_EVENT(kvm_ple_window,
> +	TP_PROTO(bool grow, unsigned int vcpu_id, int new, int old),
> +	TP_ARGS(grow, vcpu_id, new, old),
> +
> +	TP_STRUCT__entry(
> +		__field(                bool,      grow         )
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
> +	TP_printk("vcpu %u: ple_window %d (%s %d)",
> +	          __entry->vcpu_id,
> +	          __entry->new,
> +	          __entry->grow ? "grow" : "shrink",
> +	          __entry->old)
> +);
> +
> +#define trace_kvm_ple_window_grow(vcpu_id, new, old) \
> +	trace_kvm_ple_window(true, vcpu_id, new, old)
> +#define trace_kvm_ple_window_shrink(vcpu_id, new, old) \
> +	trace_kvm_ple_window(false, vcpu_id, new, old)
> +
>  #endif /* CONFIG_X86_64 */

Looks like these are needed on 32-bit as well.
Today's linux-next doesn't build:

  CC [M]  arch/x86/kvm/x86.o
In file included from include/linux/linkage.h:6:0,
                 from include/linux/preempt.h:9,
                 from include/linux/preempt_mask.h:4,
                 from include/linux/hardirq.h:4,
                 from include/linux/kvm_host.h:10,
                 from arch/x86/kvm/x86.c:22:
include/linux/tracepoint.h:214:20: error: ‘__tracepoint_kvm_ple_window’ undeclared here (not in a function)
  EXPORT_SYMBOL_GPL(__tracepoint_##name)
                    ^
include/linux/export.h:57:16: note: in definition of macro ‘__EXPORT_SYMBOL’
  extern typeof(sym) sym;     \
                ^
include/linux/tracepoint.h:214:2: note: in expansion of macro ‘EXPORT_SYMBOL_GPL’
  EXPORT_SYMBOL_GPL(__tracepoint_##name)
  ^
arch/x86/kvm/x86.c:7676:1: note: in expansion of macro ‘EXPORT_TRACEPOINT_SYMBOL_GPL’
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_ple_window);
 ^


and if I comment out the EXPORT_TRACEPOINT_SYMBOL_GPL:

arch/x86/kvm/vmx.c: In function ‘grow_ple_window’:
arch/x86/kvm/vmx.c:5742:2: error: implicit declaration of function ‘trace_kvm_ple_window_grow’ [-Werror=implicit-function-declaration]
  trace_kvm_ple_window_grow(vcpu->vcpu_id, vmx->ple_window, old);
  ^
arch/x86/kvm/vmx.c: In function ‘shrink_ple_window’:
arch/x86/kvm/vmx.c:5756:2: error: implicit declaration of function ‘trace_kvm_ple_window_shrink’ [-Werror=implicit-function-declaration]
  trace_kvm_ple_window_shrink(vcpu->vcpu_id, vmx->ple_window, old);
  ^
cc1: some warnings being treated as errors
make[2]: *** [arch/x86/kvm/vmx.o] Error 1



I moved the line

#endif /* CONFIG_X86_64 */

above

TRACE_EVENT(kvm_ple_window,

and it builds.


Thanks,

-- 
Sabrina
