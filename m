Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab3HGBtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 21:49:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756740Ab3HGBtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 21:49:16 -0400
Date: Tue, 6 Aug 2013 22:48:29 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 04/12] KVM: MMU: log dirty page after marking spte
 writable
Message-ID: <20130807014828.GA4781@amt.cnet>
References: <1375189330-24066-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1375189330-24066-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375189330-24066-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 09:02:02PM +0800, Xiao Guangrong wrote:
> Make sure we can see the writable spte before the dirt bitmap is visible
> 
> We do this is for kvm_vm_ioctl_get_dirty_log() write-protects the spte based
> on the dirty bitmap, we should ensure the writable spte can be found in rmap
> before the dirty bitmap is visible. Otherwise, we cleared the dirty bitmap and
> failed to write-protect the page
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Can you explain why this is safe, with regard to the rule 
at edde99ce05290e50 ?

"The rule is that all pages are either dirty in the current bitmap,
or write-protected, which is violated here."

Overall, please document what is the required order of operations for
both set_spte and get_dirty_log and why this order is safe (right on top
of the code).

> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index 35d4b50..0fe56ad 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2486,12 +2486,12 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>  		}
>  	}
>  
> -	if (pte_access & ACC_WRITE_MASK)
> -		mark_page_dirty(vcpu->kvm, gfn);
> -
>  set_pte:
>  	if (mmu_spte_update(sptep, spte))
>  		kvm_flush_remote_tlbs(vcpu->kvm);

Here, there is a modified guest page without dirty log bit set (think
another vcpu writing to the page via this spte).

> +
> +	if (pte_access & ACC_WRITE_MASK)
> +		mark_page_dirty(vcpu->kvm, gfn);
>  done:
>  	return ret;
>  }
> -- 
> 1.8.1.4
