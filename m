Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbaESUOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:14:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38904 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754869AbaESUOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:14:04 -0400
Message-ID: <537A6608.8000608@suse.de>
Date: Mon, 19 May 2014 22:14:00 +0200
From: Alexander Graf <agraf@suse.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Michael Mueller <mimu@linux.vnet.ibm.com>
CC: qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cornelia Huck <cornelia.huck@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Andreas Faerber <afaerber@suse.de>,
        "Jason J. Herne" <jjherne@linux.vnet.ibm.com>
Subject: Re: [PATCH v1 RFC 6/6] KVM: s390: add cpu model support
References: <1399993114-15333-1-git-send-email-mimu@linux.vnet.ibm.com>	<1399993114-15333-7-git-send-email-mimu@linux.vnet.ibm.com>	<5375FFB8.90504@suse.de>	<20140516173907.3b1c4efa@bee>	<53767590.2090605@suse.de>	<20140519125339.09840b9e@bee>	<5379EF78.9040209@suse.de>	<20140519161811.5a17bc66@bee>	<537A19F8.4060209@suse.de> <20140519190318.6f92c1bd@bee>
In-Reply-To: <20140519190318.6f92c1bd@bee>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 19.05.14 19:03, Michael Mueller wrote:
> On Mon, 19 May 2014 16:49:28 +0200
> Alexander Graf <agraf@suse.de> wrote:
>
>> On 19.05.14 16:18, Michael Mueller wrote:
>>> On Mon, 19 May 2014 13:48:08 +0200
>>> Alexander Graf <agraf@suse.de> wrote:
>>>
>>>> On 19.05.14 12:53, Michael Mueller wrote:
>>>>> On Fri, 16 May 2014 22:31:12 +0200
>>>>> Alexander Graf <agraf@suse.de> wrote:
>>>>>
>>>>>> On 16.05.14 17:39, Michael Mueller wrote:
>>>>>>> On Fri, 16 May 2014 14:08:24 +0200
>>>>>>> Alexander Graf <agraf@suse.de> wrote:
>>>>>>>
>>>>>>>> On 13.05.14 16:58, Michael Mueller wrote:
>>>>>>>>> This patch enables cpu model support in kvm/s390 via the vm attribute
>>>>>>>>> interface.
>>>>>>>>>
>>>>>>>>> During KVM initialization, the host properties cpuid, IBC value and the
>>>>>>>>> facility list are stored in the architecture specific cpu model structure.
>>>>>>>>>
>>>>>>>>> During vcpu setup, these properties are taken to initialize the related SIE
>>>>>>>>> state. This mechanism allows to adjust the properties from user space and thus
>>>>>>>>> to implement different selectable cpu models.
>>>>>>>>>
>>>>>>>>> This patch uses the IBC functionality to block instructions that have not
>>>>>>>>> been implemented at the requested CPU type and GA level compared to the
>>>>>>>>> full host capability.
>>>>>>>>>
>>>>>>>>> Userspace has to initialize the cpu model before vcpu creation. A cpu model
>>>>>>>>> change of running vcpus is currently not possible.
>>>>>>>> Why is this VM global? It usually fits a lot better modeling wise when
>>>>>>>> CPU types are vcpu properties.
>>>>>>> It simplifies the code substantially because it inherently guarantees the vcpus being
>>>>>>> configured identical. In addition, there is no S390 hardware implementation containing
>>>>>>> inhomogeneous processor types. Thus I consider the properties as machine specific.
>>>>>>>
>>>>>>>>> Signed-off-by: Michael Mueller <mimu@linux.vnet.ibm.com>
>>>>>>>>> ---
>>>>>>>>>       arch/s390/include/asm/kvm_host.h |   4 +-
>>>>>>>>>       arch/s390/include/uapi/asm/kvm.h |  23 ++++++
>>>>>>>>>       arch/s390/kvm/kvm-s390.c         | 146 ++++++++++++++++++++++++++++++++++++++-
>>>>>>>>>       arch/s390/kvm/kvm-s390.h         |   1 +
>>>>>>>>>       4 files changed, 172 insertions(+), 2 deletions(-)
>>>>>>>>>
>>>>>>>>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
>>>>>>>>> index b4751ba..6b826cb 100644
>>>>>>>>> --- a/arch/s390/include/asm/kvm_host.h
>>>>>>>>> +++ b/arch/s390/include/asm/kvm_host.h
>>>>>>>>> @@ -84,7 +84,8 @@ struct kvm_s390_sie_block {
>>>>>>>>>       	atomic_t cpuflags;		/* 0x0000 */
>>>>>>>>>       	__u32 : 1;			/* 0x0004 */
>>>>>>>>>       	__u32 prefix : 18;
>>>>>>>>> -	__u32 : 13;
>>>>>>>>> +	__u32 : 1;
>>>>>>>>> +	__u32 ibc : 12;
>>>>>>>>>       	__u8	reserved08[4];		/* 0x0008 */
>>>>>>>>>       #define PROG_IN_SIE (1<<0)
>>>>>>>>>       	__u32	prog0c;			/* 0x000c */
>>>>>>>>> @@ -418,6 +419,7 @@ struct kvm_s390_cpu_model {
>>>>>>>>>       	unsigned long *sie_fac;
>>>>>>>>>       	struct cpuid cpu_id;
>>>>>>>>>       	unsigned long *fac_list;
>>>>>>>>> +	unsigned short ibc;
>>>>>>>>>       };
>>>>>>>>>       
>>>>>>>>>       struct kvm_arch{
>>>>>>>>> diff --git a/arch/s390/include/uapi/asm/kvm.h b/arch/s390/include/uapi/asm/kvm.h
>>>>>>>>> index 313100a..82ef1b5 100644
>>>>>>>>> --- a/arch/s390/include/uapi/asm/kvm.h
>>>>>>>>> +++ b/arch/s390/include/uapi/asm/kvm.h
>>>>>>>>> @@ -58,12 +58,35 @@ struct kvm_s390_io_adapter_req {
>>>>>>>>>       
>>>>>>>>>       /* kvm attr_group  on vm fd */
>>>>>>>>>       #define KVM_S390_VM_MEM_CTRL		0
>>>>>>>>> +#define KVM_S390_VM_CPU_MODEL		1
>>>>>>>>>       
>>>>>>>>>       /* kvm attributes for mem_ctrl */
>>>>>>>>>       #define KVM_S390_VM_MEM_ENABLE_CMMA	0
>>>>>>>>>       #define KVM_S390_VM_MEM_CLR_CMMA	1
>>>>>>>>>       #define KVM_S390_VM_MEM_CLR_PAGES	2
>>>>>>>>>       
>>>>>>>>> +/* kvm attributes for cpu_model */
>>>>>>>>> +
>>>>>>>>> +/* the s390 processor related attributes are r/w */
>>>>>>>>> +#define KVM_S390_VM_CPU_PROCESSOR	0
>>>>>>>>> +struct kvm_s390_vm_cpu_processor {
>>>>>>>>> +	__u64 cpuid;
>>>>>>>>> +	__u16 ibc;
>>>>>>>>> +	__u8  pad[6];
>>>>>>>>> +	__u64 fac_list[256];
>>>>>>>>> +};
>>>>>>>>> +
>>>>>>>>> +/* the machine related attributes are read only */
>>>>>>>>> +#define KVM_S390_VM_CPU_MACHINE		1
>>>>>>>>> +struct kvm_s390_vm_cpu_machine {
>>>>>>>>> +	__u64 cpuid;
>>>>>>>>> +	__u32 ibc_range;
>>>>>>>>> +	__u8  pad[4];
>>>>>>>>> +	__u64 fac_mask[256];
>>>>>>>>> +	__u64 hard_fac_list[256];
>>>>>>>>> +	__u64 soft_fac_list[256];
>>>>>>>>> +};
>>>>>>>>> +
>>>>>>>>>       /* for KVM_GET_REGS and KVM_SET_REGS */
>>>>>>>>>       struct kvm_regs {
>>>>>>>>>       	/* general purpose regs for s390 */
>>>>>>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>>>>>>>> index a53652f..9965d8b 100644
>>>>>>>>> --- a/arch/s390/kvm/kvm-s390.c
>>>>>>>>> +++ b/arch/s390/kvm/kvm-s390.c
>>>>>>>>> @@ -369,6 +369,110 @@ static int kvm_s390_mem_control(struct kvm *kvm, struct
>>>>>>>>> kvm_device_attr *attr) return ret;
>>>>>>>>>       }
>>>>>>>>>       
>>>>>>>>> +static int kvm_s390_set_processor(struct kvm *kvm, struct kvm_device_attr *attr)
>>>>>>>>> +{
>>>>>>>>> +	struct kvm_s390_vm_cpu_processor *proc;
>>>>>>>>> +
>>>>>>>>> +	if (atomic_read(&kvm->online_vcpus))
>>>>>>>>> +		return -EBUSY;
>>>>>>>>> +
>>>>>>>>> +	proc = kzalloc(sizeof(*proc), GFP_KERNEL);
>>>>>>>>> +	if (!proc)
>>>>>>>>> +		return -ENOMEM;
>>>>>>>>> +
>>>>>>>>> +	if (copy_from_user(proc, (void __user *)attr->addr,
>>>>>>>>> +			   sizeof(*proc))) {
>>>>>>>>> +		kfree(proc);
>>>>>>>>> +		return -EFAULT;
>>>>>>>>> +	}
>>>>>>>>> +
>>>>>>>>> +	mutex_lock(&kvm->lock);
>>>>>>>>> +	memcpy(&kvm->arch.model.cpu_id, &proc->cpuid,
>>>>>>>>> +	       sizeof(struct cpuid));
>>>>>>>>> +	kvm->arch.model.ibc = proc->ibc;
>>>>>>>>> +	kvm_s390_apply_fac_list_mask((long unsigned *)proc->fac_list);
>>>>>>>>> +	memcpy(kvm->arch.model.fac_list, proc->fac_list,
>>>>>>>>> +	       S390_ARCH_FAC_LIST_SIZE_BYTE);
>>>>>>>>> +	mutex_unlock(&kvm->lock);
>>>>>>>>> +	kfree(proc);
>>>>>>>>> +
>>>>>>>>> +	return 0;
>>>>>>>>> +}
>>>>>>>>> +
>>>>>>>>> +static int kvm_s390_set_cpu_model(struct kvm *kvm, struct kvm_device_attr *attr)
>>>>>>>>> +{
>>>>>>>>> +	int ret = -ENXIO;
>>>>>>>>> +
>>>>>>>>> +	switch (attr->attr) {
>>>>>>>>> +	case KVM_S390_VM_CPU_PROCESSOR:
>>>>>>>>> +		ret = kvm_s390_set_processor(kvm, attr);
>>>>>>>>> +		break;
>>>>>>>>> +	}
>>>>>>>>> +	return ret;
>>>>>>>>> +}
>>>>>>>>> +
>>>>>>>>> +static int kvm_s390_get_processor(struct kvm *kvm, struct kvm_device_attr *attr)
>>>>>>>>> +{
>>>>>>>>> +	struct kvm_s390_vm_cpu_processor *proc;
>>>>>>>>> +	int rc = 0;
>>>>>>>>> +
>>>>>>>>> +	proc = kzalloc(sizeof(*proc), GFP_KERNEL);
>>>>>>>>> +	if (!proc) {
>>>>>>>>> +		rc = -ENOMEM;
>>>>>>>>> +		goto out;
>>>>>>>>> +	}
>>>>>>>>> +	memcpy(&proc->cpuid, &kvm->arch.model.cpu_id, sizeof(struct cpuid));
>>>>>>>>> +	proc->ibc = kvm->arch.model.ibc;
>>>>>>>>> +	memcpy(&proc->fac_list, kvm->arch.model.fac_list,
>>>>>>>>> +	       S390_ARCH_FAC_LIST_SIZE_BYTE);
>>>>>>>>> +	if (copy_to_user((void __user *)attr->addr, proc, sizeof(*proc)))
>>>>>>>>> +		rc = -EFAULT;
>>>>>>>>> +	kfree(proc);
>>>>>>>>> +out:
>>>>>>>>> +	return rc;
>>>>>>>>> +}
>>>>>>>>> +
>>>>>>>>> +static int kvm_s390_get_machine(struct kvm *kvm, struct kvm_device_attr *attr)
>>>>>>>>> +{
>>>>>>>>> +	struct kvm_s390_vm_cpu_machine *mach;
>>>>>>>>> +	int rc = 0;
>>>>>>>>> +
>>>>>>>>> +	mach = kzalloc(sizeof(*mach), GFP_KERNEL);
>>>>>>>>> +	if (!mach) {
>>>>>>>>> +		rc = -ENOMEM;
>>>>>>>>> +		goto out;
>>>>>>>>> +	}
>>>>>>>>> +	get_cpu_id((struct cpuid *) &mach->cpuid);
>>>>>>>>> +	mach->ibc_range = kvm_s390_lowest_ibc() << 16;
>>>>>>>>> +	mach->ibc_range |= kvm_s390_latest_ibc();
>>>>>>>>> +	memcpy(&mach->fac_mask, kvm_s390_fac_list_mask,
>>>>>>>>> +	       kvm_s390_fac_list_mask_size() * sizeof(u64));
>>>>>>>>> +	kvm_s390_get_hard_fac_list((long unsigned int *) &mach->hard_fac_list,
>>>>>>>>> +				   S390_ARCH_FAC_LIST_SIZE_U64);
>>>>>>>>> +	kvm_s390_get_soft_fac_list((long unsigned int *) &mach->soft_fac_list,
>>>>>>>>> +				   S390_ARCH_FAC_LIST_SIZE_U64);
>>>>>>>> I really have a hard time grasping what hard and soft means.
>>>>>>> Hard facilities are those that are implemented by the CPU itself, either through processor
>>>>>>> logic or be means of firmware micro code. That's the list returned by the STFL/STFLE
>>>>>>> instruction. In addition to that, one can imagine that in future some of that features are
>>>>>>> emulated on KVM side. These will be placed in the soft facility list and are optionally to
>>>>>>> request by user space.
>>>>>> I don't see why we would have to differentiate between the two. User
>>>>>> space wants features enabled. Whether they are done in hardware or in
>>>>>> software doesn't matter.
>>>>> I've tried to make my point on that in last answer of patch 3/6. It's a mistake
>>>>> to think that user space just wants to have features, they come with different
>>>>> qualities!
>>>> So? If I want to run a z9 compatible guest, I do -cpu z9. I can either
>>>>
>>>>      a) run it with emulation of a facility or
>>>>      b) not run it
>>>>
>>>> which one would the user choose?
>>> If you run on a z990 host, you better use -cpu z990 because emulating some
>>> fancy delta feature just cost additional CPU time. If the host is newer, please
>>> go with -cpu z9.
>> Yes, I agree on that statement. Imagine a feature gets *dropped* though.
>> In that case -cpu z9 should enable emulation of that feature to maintain
>> migratability with a real z9 machine on newer hardware.
> Nice try, but think what's happening in real world. Let's assume the feature is
> TE again, available since zEC12 but would go away with zNext. In that case the
> CPU model zNext-GA1 and all successors will not have zEC12 as supported model.
> The application will just not run on that model if it insists on executing TE
> instructions.

So what's the point in software emulated features then? Either we can 
emulate a feature or we can't. If we can, we can be compatible. If we 
can't, we're not compatible.

>
>>> What user and thus also user space wants depends on other factors:
>>>
>>> 1. reliability
>>> 2. performance
>>> 3. availability
>>>
>>> It's not features, that's what programmers want.
>>>
>>> That's why I have designed the model and migration capability around the hardware
>>> and not around the software features and don't allow them to be enabled currently
>>> together.
>>>
>>> A software feature is a nice add on that is helpful for evaluation or development
>>> purpose. There is few space for it on productions systems.
>>>
>>> One option that I currently see to make software implemented facility migration
>>> capable is to calculate some kind of hash value derived from the full set of
>>> active software facilities. That value can be compared with pre-calculated
>>> values also stored in the supported model table of qemu. This value could be
>>> seen like a virtual model extension that has to match like the model name.
>>>
>>> But I have said it elsewhere already, a soft facility should be an exception and
>>> not the rule.
>>>
>>>>>> So all we need is a list of "features the guest sees available" which is
>>>>>> the same as "features user space wants the guest to see" which then gets
>>>>>> masked through "features the host can do in hardware".
>>>>>>
>>>>>> For emulation we can just check on the global feature availability on
>>>>>> whether we should emulate them or not.
>>>>>>
>>>>>>>> Also, if user space wants to make sure that its feature list is actually
>>>>>>>> workable on the host kernel, it needs to set and get the features again
>>>>>>>> and then compare that with the ones it set? That's different from x86's
>>>>>>>> cpuid implementation but probably workable.
>>>>>>> User space will probe what facilities are available and match them with the predefined cpu
>>>>>>> model set. Only those models which use a partial or full subset of the hard/host facility
>>>>>>> list are selectable.
>>>>>> Why?
>>>>> If a host does not offer the features required for a model it is not able to
>>>>> run efficiently.
>>>>>
>>>>>> Please take a look at how x86 does cpuid masking :).
>>>>>>
>>>>>> In fact, I'm not 100% convinced that it's a good idea to link cpuid /
>>>>>> feature list exposure to the guest and actual feature implementation
>>>>>> inside the guest together. On POWER there is a patch set pending that
>>>>>> implements these two things separately - admittedly mostly because
>>>>>> hardware sucks and we can't change the PVR.
>>>>> That is maybe the big difference with s390. The cpuid in the S390 case is not
>>>>> directly comparable with the processor version register of POWER.
>>>>>
>>>>> In the S390 world we have a well defined CPU model room spanned by the machine
>>>>> type and its GA count. Thus we can define a bijective mapping between
>>>>> (type, ga) <-> (cpuid, ibc, facility set). From type and ga we form the model
>>>>> name which BTW is meaningful also for a human user.
>>>> Same thing as POWER.
>>>>
>>>>> By means of this name, a management interface (libvirt) will draw decisions if
>>>>> migration to a remote hypervisor is a good idea or not. For that it just needs
>>>>> to compare if the current model of the guest on the source hypervisor
>>>>> ("query-cpu-model"), is contained in the supported model list of the target
>>>>> hypervisor ("query-cpu-definitions").
>>>> I don't think this works, since QEMU should always return all the cpu
>>>> definitions it's aware of on query-cpu-definitions, not just the ones
>>>> that it thinks may be compatible with the host at a random point in time.
>>> It does not return model names that it thinks they are compatible at some point
>>> in time. In s390 mode, it returns all definitions (CPU models) that a given host
>>> system is capable to run. Together with the CPU model run by the guest, some upper
>>> management interface knows if the hypervisor supports the required CPU model and
>>> uses a guest definition with the same CPU model on the target hypervisor.
>>>
>>> The information for that is taken from the model table which QEMU builds up during
>>> startup time. This list limits the command line selectable CPU models as well.
>> This makes s390 derive from the way x86 handles things. NAK.
> One second, that goes a little fast here :-). x86 returns a list they support which happens to
> be the full list they define and s390 does logically the same because we know that certain
> models are not supported due to probing. BTW that happens only if you run Qemu on back
> level hardware and that is perfectly correct.

It's not what other architectures do and I'd hate to see s390 deviate 
just because.

> The migration compatibility test is pretty much ARCH dependent. I looked into the
> libvirt implementation and as one can see every architecture has its own implementation
> there (libvirt/src/cpu/cpu_<arch>.c).

So here's my question again. How does x86 evaluate whether a target 
machine is compatible with a source machine?


Alex

