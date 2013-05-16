Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753811Ab3EPMqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 08:46:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753627Ab3EPMqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 08:46:11 -0400
Message-ID: <5194D507.5080005@redhat.com>
Date: Thu, 16 May 2013 14:45:59 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 8/8] KVM: MMU: zap pages in batch
References: <1368706673-8530-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1368706673-8530-9-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
In-Reply-To: <1368706673-8530-9-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 16/05/2013 14:17, Xiao Guangrong ha scritto:
> Zap at lease 10 pages before releasing mmu-lock to reduce the overload
> caused by requiring lock
> 
> [ It improves kernel building 0.6% ~ 1% ]
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index e12f431..9c27fda 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -4216,10 +4216,12 @@ restart:
>  	spin_unlock(&kvm->mmu_lock);
>  }
>  
> +#define BATCH_ZAP_PAGES	10
>  static void zap_invalid_pages(struct kvm *kvm)
>  {
>  	struct kvm_mmu_page *sp, *node;
>  	LIST_HEAD(invalid_list);
> +	int batch = 0;
>  
>  restart:
>  	list_for_each_entry_safe(sp, node, &kvm->arch.active_mmu_pages, link) {
> @@ -4256,11 +4258,14 @@ restart:
>  		 * Need not flush tlb since we only zap the sp with invalid
>  		 * generation number.
>  		 */
> -		if (cond_resched_lock(&kvm->mmu_lock))
> +		if ((batch >= BATCH_ZAP_PAGES) &&
> +		      cond_resched_lock(&kvm->mmu_lock)) {
> +			batch = 0;
>  			goto restart;
> +		}
>  
> -		if (kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list))
> -			goto restart;
> +		batch += kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
> +		goto restart;

Would this look again and again at the same page if
kvm_mmu_prepare_zap_page returns 0?

Paolo

>  	}
>  
>  	/*
> 

