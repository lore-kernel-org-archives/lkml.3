Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106AbaJXR55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 13:57:57 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:60080 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932608AbaJXR5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 13:57:55 -0400
Message-ID: <544A9320.6010102@amacapital.net>
Date: Fri, 24 Oct 2014 10:57:52 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
CC: "Michael S. Tsirkin" <mst@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH 08/14] kvm: x86: don't kill guest on unknown exit reason
References: <1414163245-18555-1-git-send-email-pbonzini@redhat.com> <1414163245-18555-9-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1414163245-18555-9-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2014 08:07 AM, Paolo Bonzini wrote:
> From: "Michael S. Tsirkin" <mst@redhat.com>
> 
> KVM_EXIT_UNKNOWN is a kvm bug, we don't really know whether it was
> triggered by a priveledged application.  Let's not kill the guest: WARN
> and inject #UD instead.

This scares me a bit.  For guest CPL3, it's probably okay.  For guest
CPL0, on the other hand, #UD might not use IST (or a task switch on
32-bit guests), resulting in possible corruption if unprivileged code
controls SP.  Admittedly, there aren't that many contexts from which
that should happen (on Linux, at least), but something like #DF (or even
a triple fault) might be safer if the guest is at CPL0 when this happens.

--Andy

> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm.c | 6 +++---
>  arch/x86/kvm/vmx.c | 6 +++---
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 00bed2c5e948..7527cefc5a43 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -3551,9 +3551,9 @@ static int handle_exit(struct kvm_vcpu *vcpu)
>  
>  	if (exit_code >= ARRAY_SIZE(svm_exit_handlers)
>  	    || !svm_exit_handlers[exit_code]) {
> -		kvm_run->exit_reason = KVM_EXIT_UNKNOWN;
> -		kvm_run->hw.hardware_exit_reason = exit_code;
> -		return 0;
> +		WARN_ONCE(1, "vmx: unexpected exit reason 0x%x\n", exit_code);
> +		kvm_queue_exception(vcpu, UD_VECTOR);
> +		return 1;
>  	}
>  
>  	return svm_exit_handlers[exit_code](svm);
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index cf3cd079ec52..a8b76c4c95e2 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -7174,10 +7174,10 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu)
>  	    && kvm_vmx_exit_handlers[exit_reason])
>  		return kvm_vmx_exit_handlers[exit_reason](vcpu);
>  	else {
> -		vcpu->run->exit_reason = KVM_EXIT_UNKNOWN;
> -		vcpu->run->hw.hardware_exit_reason = exit_reason;
> +		WARN_ONCE(1, "vmx: unexpected exit reason 0x%x\n", exit_reason);
> +		kvm_queue_exception(vcpu, UD_VECTOR);
> +		return 1;
>  	}
> -	return 0;
>  }
>  
>  static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
> 

