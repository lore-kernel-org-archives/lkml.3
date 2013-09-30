Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab3I3ULV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 16:11:21 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:33220 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756317Ab3I3ULT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:11:19 -0400
Message-ID: <5249DAE6.5030808@tilera.com>
Date: Mon, 30 Sep 2013 16:11:18 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH v3 1/3] tile: support KVM host mode
References: <20130826120445.GD8218@redhat.com> <4bbdcdd0e94f6a7db210ef47f4a30f06325137cd.1377736306.git.cmetcalf@tilera.com> <20130910105349.GY17294@redhat.com>
In-Reply-To: <20130910105349.GY17294@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, sorry for the slow response to your thoughtful review comments.
Things have been busy for me with a new major release of the Tilera
software environment and the usual customer bug firefighting.

On 9/10/2013 6:53 AM, Gleb Natapov wrote:
> On Wed, Aug 28, 2013 at 03:45:50PM -0400, Chris Metcalf wrote:
>> This commit enables the host side of KVM support for tilegx.
>>
>> [...]
>>
>> The commit adds a KVM_EXIT_xxx code, KVM_EXIT_AGAIN, which is used to
>> exit out to the host kernel, but not all the way out to qemu.  This is
>> helpful if we are trying to handle resched, sigpending, etc., but don't
>> need to end up back in userspace first.
>>
> I think there is a confusion here on how things suppose to work.
> KVM_EXIT_xxx defines are only meant to be meaningful to userspace, they
> are never used internally by KVM. So KVM_EXIT_AGAIN, as defined above,
> does not make sense.

Fair enough; we can certainly arrange for the same semantics without
exposing a magic value in the user API.


> Looking at the code I see that you've reused those
> defines for vmexit codes too and this is incorrect. On platform with HW
> virt support vmexit codes are defined by CPU architecture (and there are
> much more of vmexit codes that userspace exit codes), PV define their own
> interface.

I'm not clear on what you're suggesting with this comment.  We do have a
kvm_trigger_vmexit() function that takes a KVM_EXIT_xxx value and stuffs
it into kvm_run.exit_reason.  But since we are PV and don't have separate
hardware-defined values, this seems like the right approach.  We effectively
borrow the KVM_EXIT_xxx codes for our vmexit codes.  Why not?

>> +#define gpud_offset(kvm, pgd, address) pud_offset(pgd, address)
>> +
>> +#define gpud_page_vaddr(kvm, pud) gfn_to_hva(kvm, pud_pfn(pud))
>> +
>> +#define gpmd_offset(kvm, pud, address) \
>> +     ((pmd_t *)gpud_page_vaddr(kvm, *(pud)) + pmd_index(address))
>> +
>> +#define gpmd_page_vaddr(kvm, pmd) gfn_to_hva(kvm, pmd_pfn(pmd))
>> +
>> +#define gpte_offset_kernel(kvm, pmd, address) \
>> +     ((pte_t *) gpmd_page_vaddr(kvm, *(pmd)) + pte_index(address))
>> +
> I can't find where those four defines are used, but in case they are
> comment about gfn_to_pfn() bellow apples here to.

Good catch; they were for some code that we changed to something else,
so we don't need them any more.

>> +#ifndef __KERNEL__
>> +/* For hv_*() */
>> +#define KVM_EMULATE(name) [HV_SYS_##name] = qemu_emulate_illegal,
>> +#define USER_EMULATE(name) [HV_SYS_##name] = qemu_emulate_hv_##name,
>> +#define NO_EMULATE(name) [HV_SYS_##name] = qemu_emulate_illegal,
>> +#define BOTH_EMULATE(name) [HV_SYS_##name] = qemu_emulate_hv_##name,
>> +/* For others */
>> +#define USER_HCALL(name) [KVM_HCALL_##name] = qemu_handle_##name,
> This does not belong to a kernel header. QEMU is not the only user of KVM
> kernel APIs. Please drop that and change all the references in comment
> from "qemu" to "userspace". If you add code that workarounds QEMU bugs it
> is appropriate to mention QEMU by name, otherwise interface to userspace
> should not be QEMU specific.

Thanks, makes sense.


>> +void kvm_arch_commit_memory_region(struct kvm *kvm,
>> +                                struct kvm_userspace_memory_region *mem,
>> +                                const struct kvm_memory_slot *old,
>> +                                enum kvm_mr_change change)
>> +{
>> +     unsigned long gpa, address, pfn, i;
>> +     struct page *page[1];
>> +     pte_t *ptep, *vptep;
>> +
>> +     gpa = mem->guest_phys_addr;
>> +     address = mem->userspace_addr;
>> +     for (i = 0; i < mem->memory_size;
>> +          i += PAGE_SIZE, gpa += PAGE_SIZE, address += PAGE_SIZE) {
>> +             vptep = get_vpgd_pte(kvm, gpa);
>> +             BUG_ON(vptep == NULL);
>> +             get_user_pages_fast(address, 1, 1, page);
> get_user_pages_fast() can fail and you do not handle an error. Do I
> understand correctly that all guest memory is pinned here? Where is it
> unpinned? I do not see put_page anywhere.

Yes, we're pinning all of user memory here; this deserves more of
a comment than is in the code (i.e. none), but was done to simplify
our initial implementation of fast page faulting from the Tilera
hypervisor.  I'll review this all more closely for the next version
of the patch set.

> +int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
> +                               struct kvm_sregs *sregs)
> +{
> +     vcpu->arch.sregs = *sregs;
> +     return 0;
> +}
> Most arches prefer to use KVM_GET_ONE_REG/KVM_SET_ONE_REG interface
> to get/set all vcpu registers since the interface is more flexible, but
> the way you are doing it is OK too.

We can certainly provide both interfaces.  For the time being,
the way we're using it from qemu works best with SET_SREGS since we
just set a bunch of SPRs at once.  Or maybe we just don't care in
the kernel until we have a client that actually wants the ONE_REG APIs?

> +static int kvm_emulate_hv_physaddr_write64(struct kvm_vcpu *vcpu)
> +{
> +     gpa_t gpa = vcpu->arch.regs.regs[0];
> +     HV_PTE *access = (HV_PTE *)vcpu->arch.regs.regs[1];
> +     uint64_t val = vcpu->arch.regs.regs[2];
> +     gfn_t gfn;
> +     pfn_t pfn;
> +     hpa_t hpa;
> +
> +     gfn = gpa_to_gfn(gpa);
> +     pfn = gfn_to_pfn(vcpu->kvm, gfn);
> Here and in the function above you use gfn_to_pfn() which access
> memslots. Memslots are srcu protected, so you have to take kvm->srcu
> read lock around those calls. Here is the link with the patch that
> documents that: http://www.mail-archive.com/kvm@vger.kernel.org/msg95566.html

Thanks, yeah, I missed that.  I'll add the srcu stuff.


> Another thing about those function is that they are very similar to
> kvm_read_guest/kvm_write_guest, the only difference I see is that they
> use hv_physaddr_write64/hv_physaddr_read64 instead of
> __copy_to_user/__copy_from_user. What are those special functions and
> why can't we use __copy_to_user/__copy_from_user here?

The hv_physaddr_xxx functions actually do direct physical-address reads
by requesting the Tilera hypervisor (basically like a BIOS) to do it.
However, you may be right that if we instead just convert to an hva
and use __copy_to_user we'd get the same results.  I'll see if we can
convert these to just use kvm_read_guest etc.

>> +int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
>> +{
>> +     return !test_and_set_bit(KVM_REQ_KICK, &vcpu->requests);
>> +}
> Use of KVM_REQ_KICK was deprecated some time ago by commit
> d94e1dc9af60e3431a586c3edfbe42d8a0d3932b. You probably copied this from
> ia64 which is a bad example since the kvm support there is broken and
> will be removed soon. Set vcpu->mode to IN_GUEST_MODE/OUTSIDE_GUEST_MODE
> instead and helper functions such as kvm_vcpu_exiting_guest_mode() here.

Thanks.

>> +int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>> +{
>> +     int i;
>> +     unsigned long resv_gfn_start;
>> +     struct kvm_memory_slot *s;
>> +     struct kvm *kvm = vcpu->kvm;
>> +
>> +     if (!kvm->arch.resv_gpa_start) {
>> +             resv_gfn_start = 0;
>> +
>> +             for (i = 0; i < KVM_USER_MEM_SLOTS; i++) {
>> +                     s = &kvm->memslots->memslots[i];
> Slots can be added or removed after vcpu is created. And of course
> kvm->srcu comment applies. Memslot can be KVM_MEMSLOT_INVALID if it is
> in the process of been deleted, so you have to check this too, but
> probably it is better for userspace to set resv_gpa_start instead of
> kernel trying to figure it out here.

We are really just trying to get an illegal PA here.  We could probably
just use PA values starting at the highest legal value and work down
from there intead.

>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -1978,7 +1978,8 @@ static long kvm_vcpu_ioctl(struct file *filp,
>>       if (vcpu->kvm->mm != current->mm)
>>               return -EIO;
>>
>> -#if defined(CONFIG_S390) || defined(CONFIG_PPC) || defined(CONFIG_MIPS)
>> +#if defined(CONFIG_S390) || defined(CONFIG_PPC) || defined(CONFIG_MIPS) || \
>> +     defined(CONFIG_TILEGX)
> No need to do that. Use KVM_IRQ_LINE ioctl which is asynchronous in
> respect to vcpu. S390 and PPC are here for historical reason and MIPS
> was review mistake. BTW where interrupt controller is emulated in
> userspace or in the kernel?

We're using the s390 virtio model with a qemu hw/tile/tile-virtio-bus.c
component in userspace at the moment.  We'll look at KVM_IRQ_LINE.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

