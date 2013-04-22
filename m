Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab3DVIz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 04:55:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39470 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab3DVIz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 04:55:58 -0400
Date: Mon, 22 Apr 2013 09:55:51 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Andrew Honig <ahonig@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [PATCH 35/72] KVM: x86: Convert MSR_KVM_SYSTEM_TIME to use
 gfn_to_hva_cache functions (CVE-2013-1797)
Message-ID: <20130422085551.GD3222@hercules>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
 <1366276617-3553-36-git-send-email-luis.henriques@canonical.com>
 <1366602889.3408.144.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366602889.3408.144.camel@deadeye.wl.decadent.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 04:54:49AM +0100, Ben Hutchings wrote:
> On Thu, 2013-04-18 at 10:16 +0100, Luis Henriques wrote:
> > 3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Andy Honig <ahonig@google.com>
> > 
> > commit 0b79459b482e85cb7426aa7da683a9f2c97aeae1 upstream.
> > 
> > There is a potential use after free issue with the handling of
> > MSR_KVM_SYSTEM_TIME.  If the guest specifies a GPA in a movable or removable
> > memory such as frame buffers then KVM might continue to write to that
> > address even after it's removed via KVM_SET_USER_MEMORY_REGION.  KVM pins
> > the page in memory so it's unlikely to cause an issue, but if the user
> > space component re-purposes the memory previously used for the guest, then
> > the guest will be able to corrupt that memory.
> > 
> > Tested: Tested against kvmclock unit test
> > 
> > Signed-off-by: Andrew Honig <ahonig@google.com>
> > Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> > [ luis: backported to 3.5:
> >   - Adjust context
> >   - Removed references to PVCLOCK_GUEST_STOPPED ]
> > Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> 
> This apparently needs to be followed by commit 8f964525a121 'KVM: Allow
> cross page reads and writes from cached translations.', as some guests
> don't follow the rules.

Thanks Ben, I'll add it to the queue.

Cheers,
--
Luis


> 
> Ben.
> 
> > ---
> >  arch/x86/include/asm/kvm_host.h |  4 ++--
> >  arch/x86/kvm/x86.c              | 40 +++++++++++++++-------------------------
> >  2 files changed, 17 insertions(+), 27 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index db7c1f2..9a50912 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -410,8 +410,8 @@ struct kvm_vcpu_arch {
> >  	gpa_t time;
> >  	struct pvclock_vcpu_time_info hv_clock;
> >  	unsigned int hw_tsc_khz;
> > -	unsigned int time_offset;
> > -	struct page *time_page;
> > +	struct gfn_to_hva_cache pv_time;
> > +	bool pv_time_enabled;
> >  
> >  	struct {
> >  		u64 msr_val;
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index ad5cf4b..5b4ac78 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -1118,7 +1118,6 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
> >  {
> >  	unsigned long flags;
> >  	struct kvm_vcpu_arch *vcpu = &v->arch;
> > -	void *shared_kaddr;
> >  	unsigned long this_tsc_khz;
> >  	s64 kernel_ns, max_kernel_ns;
> >  	u64 tsc_timestamp;
> > @@ -1154,7 +1153,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
> >  
> >  	local_irq_restore(flags);
> >  
> > -	if (!vcpu->time_page)
> > +	if (!vcpu->pv_time_enabled)
> >  		return 0;
> >  
> >  	/*
> > @@ -1212,14 +1211,9 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
> >  	 */
> >  	vcpu->hv_clock.version += 2;
> >  
> > -	shared_kaddr = kmap_atomic(vcpu->time_page);
> > -
> > -	memcpy(shared_kaddr + vcpu->time_offset, &vcpu->hv_clock,
> > -	       sizeof(vcpu->hv_clock));
> > -
> > -	kunmap_atomic(shared_kaddr);
> > -
> > -	mark_page_dirty(v->kvm, vcpu->time >> PAGE_SHIFT);
> > +	kvm_write_guest_cached(v->kvm, &vcpu->pv_time,
> > +				&vcpu->hv_clock,
> > +				sizeof(vcpu->hv_clock));
> >  	return 0;
> >  }
> >  
> > @@ -1508,10 +1502,7 @@ static int kvm_pv_enable_async_pf(struct kvm_vcpu *vcpu, u64 data)
> >  
> >  static void kvmclock_reset(struct kvm_vcpu *vcpu)
> >  {
> > -	if (vcpu->arch.time_page) {
> > -		kvm_release_page_dirty(vcpu->arch.time_page);
> > -		vcpu->arch.time_page = NULL;
> > -	}
> > +	vcpu->arch.pv_time_enabled = false;
> >  }
> >  
> >  static void accumulate_steal_time(struct kvm_vcpu *vcpu)
> > @@ -1606,6 +1597,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
> >  		break;
> >  	case MSR_KVM_SYSTEM_TIME_NEW:
> >  	case MSR_KVM_SYSTEM_TIME: {
> > +		u64 gpa_offset;
> >  		kvmclock_reset(vcpu);
> >  
> >  		vcpu->arch.time = data;
> > @@ -1615,21 +1607,18 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 data)
> >  		if (!(data & 1))
> >  			break;
> >  
> > -		/* ...but clean it before doing the actual write */
> > -		vcpu->arch.time_offset = data & ~(PAGE_MASK | 1);
> > +		gpa_offset = data & ~(PAGE_MASK | 1);
> >  
> >  		/* Check that the address is 32-byte aligned. */
> > -		if (vcpu->arch.time_offset &
> > -				(sizeof(struct pvclock_vcpu_time_info) - 1))
> > +		if (gpa_offset & (sizeof(struct pvclock_vcpu_time_info) - 1))
> >  			break;
> >  
> > -		vcpu->arch.time_page =
> > -				gfn_to_page(vcpu->kvm, data >> PAGE_SHIFT);
> > +		if (kvm_gfn_to_hva_cache_init(vcpu->kvm,
> > +		     &vcpu->arch.pv_time, data & ~1ULL))
> > +			vcpu->arch.pv_time_enabled = false;
> > +		else
> > +			vcpu->arch.pv_time_enabled = true;
> >  
> > -		if (is_error_page(vcpu->arch.time_page)) {
> > -			kvm_release_page_clean(vcpu->arch.time_page);
> > -			vcpu->arch.time_page = NULL;
> > -		}
> >  		break;
> >  	}
> >  	case MSR_KVM_ASYNC_PF_EN:
> > @@ -2616,7 +2605,7 @@ static int kvm_vcpu_ioctl_x86_set_xcrs(struct kvm_vcpu *vcpu,
> >  static int kvm_set_guest_paused(struct kvm_vcpu *vcpu)
> >  {
> >  	struct pvclock_vcpu_time_info *src = &vcpu->arch.hv_clock;
> > -	if (!vcpu->arch.time_page)
> > +	if (!vcpu->arch.pv_time_enabled)
> >  		return -EINVAL;
> >  	src->flags |= PVCLOCK_GUEST_STOPPED;
> >  	mark_page_dirty(vcpu->kvm, vcpu->arch.time >> PAGE_SHIFT);
> > @@ -6216,6 +6205,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
> >  	if (!zalloc_cpumask_var(&vcpu->arch.wbinvd_dirty_mask, GFP_KERNEL))
> >  		goto fail_free_mce_banks;
> >  
> > +	vcpu->arch.pv_time_enabled = false;
> >  	kvm_async_pf_hash_reset(vcpu);
> >  	kvm_pmu_init(vcpu);
> >  
> 
> -- 
> Ben Hutchings
> Klipstein's 4th Law of Prototyping and Production:
>                                     A fail-safe circuit will destroy others.


