Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285Ab3GaJkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 05:40:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756031Ab3GaJkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 05:40:32 -0400
Date: Wed, 31 Jul 2013 12:40:30 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/3] KVM: x86: rename EMULATE_DO_MMIO
Message-ID: <20130731094030.GD7484@redhat.com>
References: <1375197096-2454-1-git-send-email-pbonzini@redhat.com>
 <1375197096-2454-2-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375197096-2454-2-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 05:11:34PM +0200, Paolo Bonzini wrote:
> The next patch will reuse it for other userspace exits than MMIO,
> namely debug events.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 4 ++--
>  arch/x86/kvm/mmu.c              | 2 +-
>  arch/x86/kvm/vmx.c              | 2 +-
>  arch/x86/kvm/x86.c              | 4 ++--
>  4 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1f98c1b..b33e9dc 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -795,8 +795,8 @@ extern u32  kvm_min_guest_tsc_khz;
>  extern u32  kvm_max_guest_tsc_khz;
>  
>  enum emulation_result {
> -	EMULATE_DONE,       /* no further processing */
> -	EMULATE_DO_MMIO,      /* kvm_run filled with mmio request */
> +	EMULATE_DONE,         /* no further processing */
> +	EMULATE_USER_EXIT,    /* kvm_run ready for userspace exit */
>  	EMULATE_FAIL,         /* can't emulate this instruction */
>  };
>  
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 6941fa7..7ee30d4 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -4096,7 +4096,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t cr2, u32 error_code,
>  	switch (er) {
>  	case EMULATE_DONE:
>  		return 1;
> -	case EMULATE_DO_MMIO:
> +	case EMULATE_USER_EXIT:
>  		++vcpu->stat.mmio_exits;
>  		/* fall through */
>  	case EMULATE_FAIL:
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 260a919..0c87015 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -5422,7 +5422,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
>  
>  		err = emulate_instruction(vcpu, EMULTYPE_NO_REEXECUTE);
>  
> -		if (err == EMULATE_DO_MMIO) {
> +		if (err == EMULATE_USER_EXIT) {
Not related to the patch, but here we need ++vcpu->stat.mmio_exits too.
And mmio_exits is not really about mmios any more, oh well.

The patch itself looks good.
>  			ret = 0;
>  			goto out;
>  		}
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 737c804..c2a0674 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5038,11 +5038,11 @@ restart:
>  			writeback = false;
>  			vcpu->arch.complete_userspace_io = complete_emulated_pio;
>  		}
> -		r = EMULATE_DO_MMIO;
> +		r = EMULATE_USER_EXIT;
>  	} else if (vcpu->mmio_needed) {
>  		if (!vcpu->mmio_is_write)
>  			writeback = false;
> -		r = EMULATE_DO_MMIO;
> +		r = EMULATE_USER_EXIT;
>  		vcpu->arch.complete_userspace_io = complete_emulated_mmio;
>  	} else if (r == EMULATION_RESTART)
>  		goto restart;
> -- 
> 1.8.1.4
> 

--
			Gleb.
