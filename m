Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933070AbaEPPjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:39:17 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:38352 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390AbaEPPjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:39:14 -0400
Date: Fri, 16 May 2014 17:39:07 +0200
From: Michael Mueller <mimu@linux.vnet.ibm.com>
To: Alexander Graf <agraf@suse.de>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cornelia Huck <cornelia.huck@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Andreas Faerber <afaerber@suse.de>,
        "Jason J. Herne" <jjherne@linux.vnet.ibm.com>
Subject: Re: [PATCH v1 RFC 6/6] KVM: s390: add cpu model support
Message-ID: <20140516173907.3b1c4efa@bee>
In-Reply-To: <5375FFB8.90504@suse.de>
References: <1399993114-15333-1-git-send-email-mimu@linux.vnet.ibm.com>
	<1399993114-15333-7-git-send-email-mimu@linux.vnet.ibm.com>
	<5375FFB8.90504@suse.de>
Organization: IBM
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051615-5024-0000-0000-000000075F1B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2014 14:08:24 +0200
Alexander Graf <agraf@suse.de> wrote:

> 
> On 13.05.14 16:58, Michael Mueller wrote:
> > This patch enables cpu model support in kvm/s390 via the vm attribute
> > interface.
> >
> > During KVM initialization, the host properties cpuid, IBC value and the
> > facility list are stored in the architecture specific cpu model structure.
> >
> > During vcpu setup, these properties are taken to initialize the related SIE
> > state. This mechanism allows to adjust the properties from user space and thus
> > to implement different selectable cpu models.
> >
> > This patch uses the IBC functionality to block instructions that have not
> > been implemented at the requested CPU type and GA level compared to the
> > full host capability.
> >
> > Userspace has to initialize the cpu model before vcpu creation. A cpu model
> > change of running vcpus is currently not possible.
> 
> Why is this VM global? It usually fits a lot better modeling wise when 
> CPU types are vcpu properties.

It simplifies the code substantially because it inherently guarantees the vcpus being configured
identical. In addition, there is no S390 hardware implementation containing inhomogeneous
processor types. Thus I consider the properties as machine specific.

> 
> >
> > Signed-off-by: Michael Mueller <mimu@linux.vnet.ibm.com>
> > ---
> >   arch/s390/include/asm/kvm_host.h |   4 +-
> >   arch/s390/include/uapi/asm/kvm.h |  23 ++++++
> >   arch/s390/kvm/kvm-s390.c         | 146 ++++++++++++++++++++++++++++++++++++++-
> >   arch/s390/kvm/kvm-s390.h         |   1 +
> >   4 files changed, 172 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> > index b4751ba..6b826cb 100644
> > --- a/arch/s390/include/asm/kvm_host.h
> > +++ b/arch/s390/include/asm/kvm_host.h
> > @@ -84,7 +84,8 @@ struct kvm_s390_sie_block {
> >   	atomic_t cpuflags;		/* 0x0000 */
> >   	__u32 : 1;			/* 0x0004 */
> >   	__u32 prefix : 18;
> > -	__u32 : 13;
> > +	__u32 : 1;
> > +	__u32 ibc : 12;
> >   	__u8	reserved08[4];		/* 0x0008 */
> >   #define PROG_IN_SIE (1<<0)
> >   	__u32	prog0c;			/* 0x000c */
> > @@ -418,6 +419,7 @@ struct kvm_s390_cpu_model {
> >   	unsigned long *sie_fac;
> >   	struct cpuid cpu_id;
> >   	unsigned long *fac_list;
> > +	unsigned short ibc;
> >   };
> >   
> >   struct kvm_arch{
> > diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
> > index 313100a..82ef1b5 100644
> > --- a/arch/s390/include/uapi/asm/kvm.h
> > +++ b/arch/s390/include/uapi/asm/kvm.h
> > @@ -58,12 +58,35 @@ struct kvm_s390_io_adapter_req {
> >   
> >   /* kvm attr_group  on vm fd */
> >   #define KVM_S390_VM_MEM_CTRL		0
> > +#define KVM_S390_VM_CPU_MODEL		1
> >   
> >   /* kvm attributes for mem_ctrl */
> >   #define KVM_S390_VM_MEM_ENABLE_CMMA	0
> >   #define KVM_S390_VM_MEM_CLR_CMMA	1
> >   #define KVM_S390_VM_MEM_CLR_PAGES	2
> >   
> > +/* kvm attributes for cpu_model */
> > +
> > +/* the s390 processor related attributes are r/w */
> > +#define KVM_S390_VM_CPU_PROCESSOR	0
> > +struct kvm_s390_vm_cpu_processor {
> > +	__u64 cpuid;
> > +	__u16 ibc;
> > +	__u8  pad[6];
> > +	__u64 fac_list[256];
> > +};
> > +
> > +/* the machine related attributes are read only */
> > +#define KVM_S390_VM_CPU_MACHINE		1
> > +struct kvm_s390_vm_cpu_machine {
> > +	__u64 cpuid;
> > +	__u32 ibc_range;
> > +	__u8  pad[4];
> > +	__u64 fac_mask[256];
> > +	__u64 hard_fac_list[256];
> > +	__u64 soft_fac_list[256];
> > +};
> > +
> >   /* for KVM_GET_REGS and KVM_SET_REGS */
> >   struct kvm_regs {
> >   	/* general purpose regs for s390 */
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index a53652f..9965d8b 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -369,6 +369,110 @@ static int kvm_s390_mem_control(struct kvm *kvm, struct kvm_device_attr
> > *attr) return ret;
> >   }
> >   
> > +static int kvm_s390_set_processor(struct kvm *kvm, struct kvm_device_attr *attr)
> > +{
> > +	struct kvm_s390_vm_cpu_processor *proc;
> > +
> > +	if (atomic_read(&kvm->online_vcpus))
> > +		return -EBUSY;
> > +
> > +	proc = kzalloc(sizeof(*proc), GFP_KERNEL);
> > +	if (!proc)
> > +		return -ENOMEM;
> > +
> > +	if (copy_from_user(proc, (void __user *)attr->addr,
> > +			   sizeof(*proc))) {
> > +		kfree(proc);
> > +		return -EFAULT;
> > +	}
> > +
> > +	mutex_lock(&kvm->lock);
> > +	memcpy(&kvm->arch.model.cpu_id, &proc->cpuid,
> > +	       sizeof(struct cpuid));
> > +	kvm->arch.model.ibc = proc->ibc;
> > +	kvm_s390_apply_fac_list_mask((long unsigned *)proc->fac_list);
> > +	memcpy(kvm->arch.model.fac_list, proc->fac_list,
> > +	       S390_ARCH_FAC_LIST_SIZE_BYTE);
> > +	mutex_unlock(&kvm->lock);
> > +	kfree(proc);
> > +
> > +	return 0;
> > +}
> > +
> > +static int kvm_s390_set_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
> > +{
> > +	int ret = -ENXIO;
> > +
> > +	switch (attr->attr) {
> > +	case KVM_S390_VM_CPU_PROCESSOR:
> > +		ret = kvm_s390_set_processor(kvm, attr);
> > +		break;
> > +	}
> > +	return ret;
> > +}
> > +
> > +static int kvm_s390_get_processor(struct kvm *kvm, struct kvm_device_attr *attr)
> > +{
> > +	struct kvm_s390_vm_cpu_processor *proc;
> > +	int rc = 0;
> > +
> > +	proc = kzalloc(sizeof(*proc), GFP_KERNEL);
> > +	if (!proc) {
> > +		rc = -ENOMEM;
> > +		goto out;
> > +	}
> > +	memcpy(&proc->cpuid, &kvm->arch.model.cpu_id, sizeof(struct cpuid));
> > +	proc->ibc = kvm->arch.model.ibc;
> > +	memcpy(&proc->fac_list, kvm->arch.model.fac_list,
> > +	       S390_ARCH_FAC_LIST_SIZE_BYTE);
> > +	if (copy_to_user((void __user *)attr->addr, proc, sizeof(*proc)))
> > +		rc = -EFAULT;
> > +	kfree(proc);
> > +out:
> > +	return rc;
> > +}
> > +
> > +static int kvm_s390_get_machine(struct kvm *kvm, struct kvm_device_attr *attr)
> > +{
> > +	struct kvm_s390_vm_cpu_machine *mach;
> > +	int rc = 0;
> > +
> > +	mach = kzalloc(sizeof(*mach), GFP_KERNEL);
> > +	if (!mach) {
> > +		rc = -ENOMEM;
> > +		goto out;
> > +	}
> > +	get_cpu_id((struct cpuid *) &mach->cpuid);
> > +	mach->ibc_range = kvm_s390_lowest_ibc() << 16;
> > +	mach->ibc_range |= kvm_s390_latest_ibc();
> > +	memcpy(&mach->fac_mask, kvm_s390_fac_list_mask,
> > +	       kvm_s390_fac_list_mask_size() * sizeof(u64));
> > +	kvm_s390_get_hard_fac_list((long unsigned int *) &mach->hard_fac_list,
> > +				   S390_ARCH_FAC_LIST_SIZE_U64);
> > +	kvm_s390_get_soft_fac_list((long unsigned int *) &mach->soft_fac_list,
> > +				   S390_ARCH_FAC_LIST_SIZE_U64);
> 
> I really have a hard time grasping what hard and soft means.

Hard facilities are those that are implemented by the CPU itself, either through processor logic
or be means of firmware micro code. That's the list returned by the STFL/STFLE instruction. In
addition to that, one can imagine that in future some of that features are emulated on KVM side.
These will be placed in the soft facility list and are optionally to request by user space.

> 
> Also, if user space wants to make sure that its feature list is actually 
> workable on the host kernel, it needs to set and get the features again 
> and then compare that with the ones it set? That's different from x86's 
> cpuid implementation but probably workable.

User space will probe what facilities are available and match them with the predefined cpu model
set. Only those models which use a partial or full subset of the hard/host facility list are
selectable. 

> 
> I also don't quite grasp what the story behind IBC is. Do you actually 
> block instructions? Where do you match instructions that have to get 
> blocked with instructions that user space wants to see exposed?
> 

Instruction Blocking Control is a feature that was first introduced with the 2097 (IBM System
z10.) The IBC value is part of the SIE state. Just consider it as a kind of parameter, that
allows only instructions that have been implemented up to a certain cpu type and GA level to
become executed, all other op codes will end in an illegal opcode abort. E.g. take the
"Transactional Memory" instructions, they are implemented since type 2827, GA1
(IBM zEnterprise EC12.). The IBC value has 12 bits 8 for the type and 4 for the GA level.
0x001 means its a z10, GA1. The value 0x021 means it's a 2827 (CMOS generation 12 is 0x02) and
GA1 and so forth. A guest running with IBC value 0x012 (z196 GA2) will not be able to use
TE instructions in contrast to a guest running with IBC value 0x022 given the host supports it.

> 
> Alex
> 

Michael

