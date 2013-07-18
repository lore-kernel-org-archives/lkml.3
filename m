Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab3GRG3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 02:29:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758251Ab3GRG3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 02:29:07 -0400
Date: Thu, 18 Jul 2013 09:28:59 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: markus@trippelsdorf.de, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: MMU: avoid fast page fault fixing mmio page fault
Message-ID: <20130718062859.GA11772@redhat.com>
References: <1374123157-11142-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130718053154.GY11772@redhat.com>
 <51E784CB.1040402@linux.vnet.ibm.com>
 <20130718060628.GA15613@redhat.com>
 <51E78A4F.9060801@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E78A4F.9060801@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 02:25:19PM +0800, Xiao Guangrong wrote:
> On 07/18/2013 02:06 PM, Gleb Natapov wrote:
> > On Thu, Jul 18, 2013 at 02:01:47PM +0800, Xiao Guangrong wrote:
> >> On 07/18/2013 01:31 PM, Gleb Natapov wrote:
> >>> On Thu, Jul 18, 2013 at 12:52:37PM +0800, Xiao Guangrong wrote:
> >>>> Currently, fast page fault tries to fix mmio page fault when the
> >>>> generation number is invalid (spte.gen != kvm.gen) and returns to
> >>>> guest to retry the fault since it sees the last spte is nonpresent
> >>>> which causes infinity loop
> >>>>
> >>>> It can be triggered only on AMD host since the mmio page fault is
> >>>> recognized as ept-misconfig
> >>>>
> >>> We still call into regular page fault handler from ept-misconfig
> >>> handler, but fake zero error_code we provide makes page_fault_can_be_fast()
> >>> return false.
> >>
> >> Yes.
> >>
> >>>
> >>> Shouldn't shadow paging trigger this too? I haven't encountered this on
> >>> Intel without ept.
> >>
> >> Since currently fast page fault only works for direct mmu. :)
> > Ah, yes. So with shadow page and paging disabled in a guest is can
> > happen eventually, but we do not trigger it for some reason?
> 
> Yes. I guess so, paging disable is short-lived and the sptes will be
> invalid after memslot changed for 150 times, so it is hard to be triggered.
> 
> I should update this to the changelog, thanks for your reminder, Gleb.
> 
> ======
> [PATCH] KVM: MMU: avoid fast page fault fixing mmio page fault
> 
> Currently, fast page fault tries to fix mmio page fault when the
> generation number is invalid (spte.gen != kvm.gen) and returns to
> guest to retry the fault since it sees the last spte is nonpresent.
> It causes infinity loop
> 
> Since fast page fault only works for direct mmu, the issue exists when
> 1) tdp is enabled. It is only triggered only on AMD host since on Intel host
>    the mmio page fault is recognized as ept-misconfig whose handler call
>    fault-page path with error_code = 0
> 
> 2) guest paging is disabled. Under this case, the issue is hardly discovered
>    since paging disable is short-lived and the sptes will be invalid after
>    memslot changed for 150 times
> 
> Fix it by filtering the mmio page fault out in page_fault_can_be_fast
> 
> Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> Tested-by: Markus Trippelsdorf <markus@trippelsdorf.de>
> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Reviewed-by: Gleb Natapov <gleb@redhat.com>


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
> 
> 
> 

--
			Gleb.
