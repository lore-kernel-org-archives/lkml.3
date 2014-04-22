Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548AbaDVUlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:41:13 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:33367 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758179AbaDVUYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:24:48 -0400
Message-ID: <5356D008.8040204@de.ibm.com>
Date: Tue, 22 Apr 2014 22:24:40 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Avi Kivity <avi.kivity@gmail.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
CC: Dominik Dingel <dingel@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: async_pf: mm->mm_users can not pin apf->mm
References: <20140421132601.GA13615@redhat.com>
In-Reply-To: <20140421132601.GA13615@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042220-0542-0000-0000-000008BD404B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/04/14 15:26, Oleg Nesterov wrote:
> get_user_pages(mm) is simply wrong if mm->mm_users == 0 and exit_mmap/etc
> was already called (or is in progress), mm->mm_count can only pin mm->pgd
> and mm_struct itself.
> 
> Change kvm_setup_async_pf/async_pf_execute to inc/dec mm->mm_users.
> 
> kvm_create_vm/kvm_destroy_vm play with ->mm_count too but this case looks
> fine at first glance, it seems that this ->mm is only used to verify that
> current->mm == kvm->mm.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

This looks fine, from what I can tell. The old code has the problem mentioned
in your patch description, so your version is probably better.


> ---
>  virt/kvm/async_pf.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> index 0ced4f3..cda703e 100644
> --- a/virt/kvm/async_pf.c
> +++ b/virt/kvm/async_pf.c
> @@ -99,7 +99,7 @@ static void async_pf_execute(struct work_struct *work)
>  	if (waitqueue_active(&vcpu->wq))
>  		wake_up_interruptible(&vcpu->wq);
> 
> -	mmdrop(mm);
> +	mmput(mm);
>  	kvm_put_kvm(vcpu->kvm);
>  }
> 
> @@ -116,7 +116,7 @@ void kvm_clear_async_pf_completion_queue(struct kvm_vcpu *vcpu)
>  		flush_work(&work->work);
>  #else
>  		if (cancel_work_sync(&work->work)) {
> -			mmdrop(work->mm);
> +			mmput(work->mm);
>  			kvm_put_kvm(vcpu->kvm); /* == work->vcpu->kvm */
>  			kmem_cache_free(async_pf_cache, work);
>  		}
> @@ -181,7 +181,7 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, unsigned long hva,
>  	work->addr = hva;
>  	work->arch = *arch;
>  	work->mm = current->mm;
> -	atomic_inc(&work->mm->mm_count);
> +	atomic_inc(&work->mm->mm_users);
>  	kvm_get_kvm(work->vcpu->kvm);
> 
>  	/* this can't really happen otherwise gfn_to_pfn_async
> @@ -199,7 +199,7 @@ int kvm_setup_async_pf(struct kvm_vcpu *vcpu, gva_t gva, unsigned long hva,
>  	return 1;
>  retry_sync:
>  	kvm_put_kvm(work->vcpu->kvm);
> -	mmdrop(work->mm);
> +	mmput(work->mm);
>  	kmem_cache_free(async_pf_cache, work);
>  	return 0;
>  }
> 

