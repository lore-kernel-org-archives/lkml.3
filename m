Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934442AbaEFI2B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 04:28:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934235AbaEFI15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 04:27:57 -0400
Message-ID: <53689D08.2070801@redhat.com>
Date: Tue, 06 May 2014 10:27:52 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Bandan Das <bsd@redhat.com>, kvm@vger.kernel.org
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] KVM: x86: use memory_prepare in fetch helper
 function
References: <1399336859-7227-1-git-send-email-bsd@redhat.com> <1399336859-7227-3-git-send-email-bsd@redhat.com>
In-Reply-To: <1399336859-7227-3-git-send-email-bsd@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 06/05/2014 02:40, Bandan Das ha scritto:
> Insn fetch fastpath function. Not that
> arch.walk_mmu->gva_to_gpa can't be used but let's
> piggyback on top of interface meant for our purpose
>
> Signed-off-by: Bandan Das <bsd@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 25 +++++++++++++++++--------
>  1 file changed, 17 insertions(+), 8 deletions(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 17e3d661..cf69e3b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4065,29 +4065,38 @@ static int kvm_read_guest_virt_helper(gva_t addr, void *val, unsigned int bytes,
>  				      struct x86_exception *exception)
>  {
>  	void *data = val;
> -	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
>  	int r = X86EMUL_CONTINUE;
>
>  	while (bytes) {
> -		gpa_t gpa = vcpu->arch.walk_mmu->gva_to_gpa(vcpu, addr, access,
> -							    exception);
>  		unsigned offset = addr & (PAGE_SIZE-1);
>  		unsigned toread = min(bytes, (unsigned)PAGE_SIZE - offset);
>  		int ret;
> +		unsigned long uaddr;
>
> -		if (gpa == UNMAPPED_GVA)
> -			return X86EMUL_PROPAGATE_FAULT;
> -		ret = kvm_read_guest(vcpu->kvm, gpa, data, toread);
> +		ret = ctxt->ops->memory_prepare(ctxt, addr, toread,
> +						exception, false,
> +						NULL, &uaddr);

You can call the function from x86.c directly, no need to go through 
ctxt->ops.

> +		if (ret != X86EMUL_CONTINUE)
> +			return ret;
> +
> +		if (unlikely(kvm_is_error_hva(uaddr))) {
> +			r = X86EMUL_PROPAGATE_FAULT;
> +			return r;
> +		}
> +
> +		ret = __copy_from_user(data, (void __user *)uaddr, toread);
>  		if (ret < 0) {
>  			r = X86EMUL_IO_NEEDED;
> -			goto out;
> +			return r;
>  		}
>
> +		ctxt->ops->memory_finish(ctxt, NULL, uaddr);

No need to call memory_finish, since you know the implementation 
(perhaps add a comment).

Paolo

>  		bytes -= toread;
>  		data += toread;
>  		addr += toread;
>  	}
> -out:
> +
>  	return r;
>  }
>
>

