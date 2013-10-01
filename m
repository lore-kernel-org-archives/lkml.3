Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab3JAPVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 11:21:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075Ab3JAPVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 11:21:35 -0400
Date: Tue, 1 Oct 2013 18:21:26 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH v3 1/3] tile: support KVM host mode
Message-ID: <20131001152126.GP11993@redhat.com>
References: <20130826120445.GD8218@redhat.com>
 <4bbdcdd0e94f6a7db210ef47f4a30f06325137cd.1377736306.git.cmetcalf@tilera.com>
 <20130910105349.GY17294@redhat.com>
 <5249DAE6.5030808@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5249DAE6.5030808@tilera.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 04:11:18PM -0400, Chris Metcalf wrote:
> On 9/10/2013 6:53 AM, Gleb Natapov wrote:
> > On Wed, Aug 28, 2013 at 03:45:50PM -0400, Chris Metcalf wrote:
> >> This commit enables the host side of KVM support for tilegx.
> >>
> >> [...]
> >>
> >> The commit adds a KVM_EXIT_xxx code, KVM_EXIT_AGAIN, which is used to
> >> exit out to the host kernel, but not all the way out to qemu.  This is
> >> helpful if we are trying to handle resched, sigpending, etc., but don't
> >> need to end up back in userspace first.
> >>
> > I think there is a confusion here on how things suppose to work.
> > KVM_EXIT_xxx defines are only meant to be meaningful to userspace, they
> > are never used internally by KVM. So KVM_EXIT_AGAIN, as defined above,
> > does not make sense.
> 
> Fair enough; we can certainly arrange for the same semantics without
> exposing a magic value in the user API.
> 
> 
> > Looking at the code I see that you've reused those
> > defines for vmexit codes too and this is incorrect. On platform with HW
> > virt support vmexit codes are defined by CPU architecture (and there are
> > much more of vmexit codes that userspace exit codes), PV define their own
> > interface.
> 
> I'm not clear on what you're suggesting with this comment.  We do have a
> kvm_trigger_vmexit() function that takes a KVM_EXIT_xxx value and stuffs
> it into kvm_run.exit_reason.  But since we are PV and don't have separate
> hardware-defined values, this seems like the right approach.  We effectively
> borrow the KVM_EXIT_xxx codes for our vmexit codes.  Why not?
> 
Experience shows that there are much more reasons for vmexits than
reasons to exit to userspace. Even with your initial implementation here
you found that you need KVM_EXIT_AGAIN, but going forward you may find
out you need more and more vmexit reasons and we will not define new
KVM_EXIT_xxx for that. The main loop logic usually looks like that:

 while (r != exit_user) {
  enter_guest_mode();
  vmexit = get_vmexit_reason();

  switch (vmexit) {
    case A:
    break;
    case B:
    break;
    case C:
       if (need_userspace_attention())
          kvm_run.exit_reason = KVM_EXIT_xxx;
          r = exit_user;
    break;
  }
 }

> >> +void kvm_arch_commit_memory_region(struct kvm *kvm,
> >> +                                struct kvm_userspace_memory_region *mem,
> >> +                                const struct kvm_memory_slot *old,
> >> +                                enum kvm_mr_change change)
> >> +{
> >> +     unsigned long gpa, address, pfn, i;
> >> +     struct page *page[1];
> >> +     pte_t *ptep, *vptep;
> >> +
> >> +     gpa = mem->guest_phys_addr;
> >> +     address = mem->userspace_addr;
> >> +     for (i = 0; i < mem->memory_size;
> >> +          i += PAGE_SIZE, gpa += PAGE_SIZE, address += PAGE_SIZE) {
> >> +             vptep = get_vpgd_pte(kvm, gpa);
> >> +             BUG_ON(vptep == NULL);
> >> +             get_user_pages_fast(address, 1, 1, page);
> > get_user_pages_fast() can fail and you do not handle an error. Do I
> > understand correctly that all guest memory is pinned here? Where is it
> > unpinned? I do not see put_page anywhere.
> 
> Yes, we're pinning all of user memory here; this deserves more of
> a comment than is in the code (i.e. none), but was done to simplify
> our initial implementation of fast page faulting from the Tilera
> hypervisor.  I'll review this all more closely for the next version
> of the patch set.
OK. Pinning pages is OK, what puzzled me is that I haven't found where
they unpinned.

> 
> > +int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
> > +                               struct kvm_sregs *sregs)
> > +{
> > +     vcpu->arch.sregs = *sregs;
> > +     return 0;
> > +}
> > Most arches prefer to use KVM_GET_ONE_REG/KVM_SET_ONE_REG interface
> > to get/set all vcpu registers since the interface is more flexible, but
> > the way you are doing it is OK too.
> 
> We can certainly provide both interfaces.  For the time being,
> the way we're using it from qemu works best with SET_SREGS since we
> just set a bunch of SPRs at once.  Or maybe we just don't care in
> the kernel until we have a client that actually wants the ONE_REG APIs?
> 
Fine with me, just pointed out the alternative.

> >> +int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
> >> +{
> >> +     int i;
> >> +     unsigned long resv_gfn_start;
> >> +     struct kvm_memory_slot *s;
> >> +     struct kvm *kvm = vcpu->kvm;
> >> +
> >> +     if (!kvm->arch.resv_gpa_start) {
> >> +             resv_gfn_start = 0;
> >> +
> >> +             for (i = 0; i < KVM_USER_MEM_SLOTS; i++) {
> >> +                     s = &kvm->memslots->memslots[i];
> > Slots can be added or removed after vcpu is created. And of course
> > kvm->srcu comment applies. Memslot can be KVM_MEMSLOT_INVALID if it is
> > in the process of been deleted, so you have to check this too, but
> > probably it is better for userspace to set resv_gpa_start instead of
> > kernel trying to figure it out here.
> 
> We are really just trying to get an illegal PA here.  We could probably
> just use PA values starting at the highest legal value and work down
> from there intead.
> 
OK. But making userspace configuring it may be even easier. After all
userspace is the one who defines memory layout. X86 has similar things
where userspace configures available PA address for KVM to use.

--
			Gleb.
