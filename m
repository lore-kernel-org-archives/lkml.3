Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab3DTRtI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 13:49:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997Ab3DTRtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 13:49:06 -0400
Date: Sat, 20 Apr 2013 14:18:59 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 15/15] KVM: MMU: replace kvm_zap_all with
 kvm_mmu_invalid_all_pages
Message-ID: <20130420171859.GA15140@amt.cnet>
References: <1366093973-2617-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1366093973-2617-16-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20130418000812.GF31059@amt.cnet>
 <516F70A1.7010007@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <516F70A1.7010007@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 12:03:45PM +0800, Xiao Guangrong wrote:
> On 04/18/2013 08:08 AM, Marcelo Tosatti wrote:
> > On Tue, Apr 16, 2013 at 02:32:53PM +0800, Xiao Guangrong wrote:
> >> Use kvm_mmu_invalid_all_pages in kvm_arch_flush_shadow_all and
> >> rename kvm_zap_all to kvm_free_all which is used to free all
> >> memmory used by kvm mmu when vm is being destroyed, at this time,
> >> no vcpu exists and mmu-notify has been unregistered, so we can
> >> free the shadow pages out of mmu-lock
> > 
> > Since there is no contention for mmu-lock its also not a problem to 
> > grab the lock right?
> 
> This still has contention. Other mmu-notify can happen when we handle
> ->release(). On the other handle, spin-lock is not preemptable.

Don't think so:

        kvm_coalesced_mmio_free(kvm);
#if defined(CONFIG_MMU_NOTIFIER) && defined(KVM_ARCH_WANT_MMU_NOTIFIER)
        mmu_notifier_unregister(&kvm->mmu_notifier, kvm->mm);
#else
        kvm_arch_flush_shadow_all(kvm);
#endif
        kvm_arch_destroy_vm(kvm);

> > Automated verification of locking/srcu might complain.
> 
> We hold slot-lock to free shadow page out of mmu-lock, it can avoid
> the complain. No?

Not if it realizes srcu is required to access the data structures.

