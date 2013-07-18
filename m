Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170Ab3GRFcG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 01:32:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288Ab3GRFcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 01:32:04 -0400
Date: Thu, 18 Jul 2013 08:31:54 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: markus@trippelsdorf.de, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: MMU: avoid fast page fault fixing mmio page fault
Message-ID: <20130718053154.GY11772@redhat.com>
References: <1374123157-11142-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374123157-11142-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 12:52:37PM +0800, Xiao Guangrong wrote:
> Currently, fast page fault tries to fix mmio page fault when the
> generation number is invalid (spte.gen != kvm.gen) and returns to
> guest to retry the fault since it sees the last spte is nonpresent
> which causes infinity loop
> 
> It can be triggered only on AMD host since the mmio page fault is
> recognized as ept-misconfig
> 
We still call into regular page fault handler from ept-misconfig
handler, but fake zero error_code we provide makes page_fault_can_be_fast()
return false.

Shouldn't shadow paging trigger this too? I haven't encountered this on
Intel without ept.

> Fix it by filtering the mmio page fault out in page_fault_can_be_fast
> 
> Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> Tested-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  arch/x86/kvm/mmu.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
> index bf7af1e..3a9493a 100644
> --- a/arch/x86/kvm/mmu.c
> +++ b/arch/x86/kvm/mmu.c
> @@ -2811,6 +2811,13 @@ exit:
>  static bool page_fault_can_be_fast(struct kvm_vcpu *vcpu, u32 error_code)
>  {
>  	/*
> +	 * Do not fix the mmio spte with invalid generation number which
> +	 * need to be updated by slow page fault path.
> +	 */
> +	if (unlikely(error_code & PFERR_RSVD_MASK))
> +		return false;
> +
> +	/*
>  	 * #PF can be fast only if the shadow page table is present and it
>  	 * is caused by write-protect, that means we just need change the
>  	 * W bit of the spte which can be done out of mmu-lock.
> -- 
> 1.8.1.4

--
			Gleb.
