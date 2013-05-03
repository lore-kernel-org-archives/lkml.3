Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306Ab3ECPxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 11:53:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932459Ab3ECPxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 11:53:30 -0400
Date: Fri, 3 May 2013 12:53:02 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, takuya.yoshikawa@gmail.com
Subject: Re: [PATCH v4 4/6] KVM: MMU: fast invalid all shadow pages
Message-ID: <20130503155302.GB3362@amt.cnet>
References: <1367032402-13729-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1367032402-13729-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130503010534.GA5467@amt.cnet>
 <51835087.8090605@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51835087.8090605@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 01:52:07PM +0800, Xiao Guangrong wrote:
> On 05/03/2013 09:05 AM, Marcelo Tosatti wrote:
> 
> >> +
> >> +/*
> >> + * Fast invalid all shadow pages belong to @slot.
> >> + *
> >> + * @slot != NULL means the invalidation is caused the memslot specified
> >> + * by @slot is being deleted, in this case, we should ensure that rmap
> >> + * and lpage-info of the @slot can not be used after calling the function.
> >> + *
> >> + * @slot == NULL means the invalidation due to other reasons, we need
> >> + * not care rmap and lpage-info since they are still valid after calling
> >> + * the function.
> >> + */
> >> +void kvm_mmu_invalid_memslot_pages(struct kvm *kvm,
> >> +				   struct kvm_memory_slot *slot)
> >> +{
> >> +	spin_lock(&kvm->mmu_lock);
> >> +	kvm->arch.mmu_valid_gen++;
> >> +
> >> +	/*
> >> +	 * All shadow paes are invalid, reset the large page info,
> >> +	 * then we can safely desotry the memslot, it is also good
> >> +	 * for large page used.
> >> +	 */
> >> +	kvm_clear_all_lpage_info(kvm);
> > 
> > Xiao,
> > 
> > I understood it was agreed that simple mmu_lock lockbreak while
> > avoiding zapping of newly instantiated pages upon a
> > 
> > 	if(spin_needbreak)
> > 		cond_resched_lock()
> > 
> > cycle was enough as a first step? And then later introduce root zapping
> > along with measurements.
> > 
> > https://lkml.org/lkml/2013/4/22/544
> 
> Yes, it is.
> 
> See the changelog in 0/0:
> 
> " we use lock-break technique to zap all sptes linked on the
> invalid rmap, it is not very effective but good for the first step."
> 
> Thanks!

Sure, but what is up with zeroing kvm_clear_all_lpage_info(kvm) and
zapping the root? Only lock-break technique along with generation number 
was what was agreed.

That is, having:

> >> +  /*
> >> +   * All shadow paes are invalid, reset the large page info,
> >> +   * then we can safely desotry the memslot, it is also good
> >> +   * for large page used.
> >> +   */
> >> +  kvm_clear_all_lpage_info(kvm);

Was an optimization step that should be done after being shown it is an
advantage?

It is more work, but it leads to a better understanding of the issues in 
practice.

If you have reasons to do it now, then please have it in the final
patches, as an optimization on top of the first patches (where the
lockbreak technique plus generation numbers is introduced).

