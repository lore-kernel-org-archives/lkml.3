Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbaESKNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:13:31 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:37362 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaESKN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:13:28 -0400
Date: Mon, 19 May 2014 12:13:20 +0200
From: Michael Mueller <mimu@linux.vnet.ibm.com>
To: Alexander Graf <agraf@suse.de>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Gleb Natapov <gleb@kernel.org>, qemu-devel@nongnu.org,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "Jason J. Herne" <jjherne@linux.vnet.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andreas Faerber <afaerber@suse.de>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [Qemu-devel] [PATCH v1 RFC 3/6] KVM: s390: use facilities and
 cpu_id per KVM
Message-ID: <20140519121320.0db01521@bee>
In-Reply-To: <53767696.7050905@suse.de>
References: <1399993114-15333-1-git-send-email-mimu@linux.vnet.ibm.com>
	<1399993114-15333-4-git-send-email-mimu@linux.vnet.ibm.com>
	<5375FCBD.7010700@suse.de>
	<20140516164645.57f22213@bee>
	<53762581.30708@suse.de>
	<20140516180945.588563ec@bee>
	<53767696.7050905@suse.de>
Organization: IBM
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051910-0342-0000-0000-000008D0783F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2014 22:35:34 +0200
Alexander Graf <agraf@suse.de> wrote:

> 
> On 16.05.14 18:09, Michael Mueller wrote:
> > On Fri, 16 May 2014 16:49:37 +0200
> > Alexander Graf <agraf@suse.de> wrote:
> >
> >> On 16.05.14 16:46, Michael Mueller wrote:
> >>> On Fri, 16 May 2014 13:55:41 +0200
> >>> Alexander Graf <agraf@suse.de> wrote:
> >>>
> >>>> On 13.05.14 16:58, Michael Mueller wrote:
> >>>>> The patch introduces facilities and cpu_ids per virtual machine.
> >>>>> Different virtual machines may want to expose different facilities and
> >>>>> cpu ids to the guest, so let's make them per-vm instead of global.
> >>>>>
> >>>>> In addition this patch renames all ocurrences of *facilities to *fac_list
> >>>>> smilar to the already exiting symbol stfl_fac_list in lowcore.
> >>>>>
> >>>>> Signed-off-by: Michael Mueller <mimu@linux.vnet.ibm.com>
> >>>>> Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> >>>>> Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> >>>>> ---
> >>>>>     arch/s390/include/asm/kvm_host.h |   7 +++
> >>>>>     arch/s390/kvm/gaccess.c          |   4 +-
> >>>>>     arch/s390/kvm/kvm-s390.c         | 107 +++++++++++++++++++++++++++------------
> >>>>>     arch/s390/kvm/kvm-s390.h         |  23 +++++++--
> >>>>>     arch/s390/kvm/priv.c             |  13 +++--
> >>>>>     5 files changed, 113 insertions(+), 41 deletions(-)
> >>>>>
> >>>>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> >>>>> index 38d487a..b4751ba 100644
> >>>>> --- a/arch/s390/include/asm/kvm_host.h
> >>>>> +++ b/arch/s390/include/asm/kvm_host.h
> >>>>> @@ -414,6 +414,12 @@ struct kvm_s390_config {
> >>>>>     	struct kvm_s390_attr_name name;
> >>>>>     };
> >>>>>     
> >>>>> +struct kvm_s390_cpu_model {
> >>>>> +	unsigned long *sie_fac;
> >>>>> +	struct cpuid cpu_id;
> >>>>> +	unsigned long *fac_list;
> >>>>> +};
> >>>>> +
> >>>>>     struct kvm_arch{
> >>>>>     	struct sca_block *sca;
> >>>>>     	debug_info_t *dbf;
> >>>>> @@ -427,6 +433,7 @@ struct kvm_arch{
> >>>>>     	wait_queue_head_t ipte_wq;
> >>>>>     	struct kvm_s390_config *cfg;
> >>>>>     	spinlock_t start_stop_lock;
> >>>>> +	struct kvm_s390_cpu_model model;
> >>>>>     };
> >>>>>     
> >>>>>     #define KVM_HVA_ERR_BAD		(-1UL)
> >>>>> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> >>>>> index db608c3..4c7ca40 100644
> >>>>> --- a/arch/s390/kvm/gaccess.c
> >>>>> +++ b/arch/s390/kvm/gaccess.c
> >>>>> @@ -358,8 +358,8 @@ static unsigned long guest_translate(struct kvm_vcpu *vcpu, unsigned
> >>>>> long gva, union asce asce;
> >>>>>     
> >>>>>     	ctlreg0.val = vcpu->arch.sie_block->gcr[0];
> >>>>> -	edat1 = ctlreg0.edat && test_vfacility(8);
> >>>>> -	edat2 = edat1 && test_vfacility(78);
> >>>>> +	edat1 = ctlreg0.edat && test_kvm_facility(vcpu->kvm, 8);
> >>>>> +	edat2 = edat1 && test_kvm_facility(vcpu->kvm, 78);
> >>>>>     	asce.val = get_vcpu_asce(vcpu);
> >>>>>     	if (asce.r)
> >>>>>     		goto real_address;
> >>>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> >>>>> index 01a5212..a53652f 100644
> >>>>> --- a/arch/s390/kvm/kvm-s390.c
> >>>>> +++ b/arch/s390/kvm/kvm-s390.c
> >>>>> @@ -1,5 +1,5 @@
> >>>>>     /*
> >>>>> - * hosting zSeries kernel virtual machines
> >>>>> + * Hosting zSeries kernel virtual machines
> >>>>>      *
> >>>>>      * Copyright IBM Corp. 2008, 2009
> >>>>>      *
> >>>>> @@ -30,7 +30,6 @@
> >>>>>     #include <asm/pgtable.h>
> >>>>>     #include <asm/nmi.h>
> >>>>>     #include <asm/switch_to.h>
> >>>>> -#include <asm/facility.h>
> >>>>>     #include <asm/sclp.h>
> >>>>>     #include<asm/timex.h>
> >>>>>     #include "kvm-s390.h"
> >>>>> @@ -92,15 +91,33 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
> >>>>>     	{ NULL }
> >>>>>     };
> >>>>>     
> >>>>> -unsigned long *vfacilities;
> >>>>> -static struct gmap_notifier gmap_notifier;
> >>>>> +/* upper facilities limit for kvm */
> >>>>> +unsigned long kvm_s390_fac_list_mask[] = {
> >>>>> +	0xff82fff3f47c2000UL,
> >>>>> +	0x005c000000000000UL,
> >>>>> +};
> >>>>> +
> >>>>> +unsigned long kvm_s390_fac_list_mask_size(void)
> >>>>> +{
> >>>>> +	BUILD_BUG_ON(ARRAY_SIZE(kvm_s390_fac_list_mask) >
> >>>>> +		     S390_ARCH_FAC_MASK_SIZE_U64);
> >>>>> +	return ARRAY_SIZE(kvm_s390_fac_list_mask);
> >>>>> +}
> >>>>>     
> >>>>> -/* test availability of vfacility */
> >>>>> -int test_vfacility(unsigned long nr)
> >>>>> +void kvm_s390_apply_fac_list_mask(unsigned long fac_list[])
> >>>>>     {
> >>>>> -	return __test_facility(nr, (void *) vfacilities);
> >>>>> +	unsigned int i;
> >>>>> +
> >>>>> +	for (i = 0; i < S390_ARCH_FAC_LIST_SIZE_U64; i++) {
> >>>>> +		if (i < kvm_s390_fac_list_mask_size())
> >>>>> +			fac_list[i] &= kvm_s390_fac_list_mask[i];
> >>>>> +		else
> >>>>> +			fac_list[i] &= 0UL;
> >>>>> +	}
> >>>>>     }
> >>>>>     
> >>>>> +static struct gmap_notifier gmap_notifier;
> >>>>> +
> >>>>>     /* Section: not file related */
> >>>>>     int kvm_arch_hardware_enable(void *garbage)
> >>>>>     {
> >>>>> @@ -485,6 +502,30 @@ long kvm_arch_vm_ioctl(struct file *filp,
> >>>>>     	return r;
> >>>>>     }
> >>>>>     
> >>>>> +/* make sure the memory used for fac_list is zeroed */
> >>>>> +void kvm_s390_get_hard_fac_list(unsigned long *fac_list, int size)
> >>>> Hard? Wouldn't "host" make more sense here?
> >>> Renaming "*hard_fac_list" with "*host_fac_list" here and wherever it appears is ok with me.
> >>>
> >>>> I also think it makes sense to expose the native host facility list to
> >>>> user space via an ioctl somehow.
> >>>>
> >>> In which situation do you need the full facility list. Do you have an example?
> >> If you want to just implement -cpu host to get the exact feature set
> >> that the host gives you, how do you know which set that is?
> > During qemu machine initalization I call:
> >
> > kvm_s390_get_machine_props(&mach);
> >
> > which returns the following information:
> >
> > typedef struct S390MachineProps {
> >      uint64_t cpuid;
> >      uint32_t ibc_range;
> >      uint8_t  pad[4];
> >      uint64_t fac_mask[S390_ARCH_FAC_MASK_SIZE_UINT64];
> >      uint64_t hard_fac_list[S390_ARCH_FAC_LIST_SIZE_UINT64];
> >      uint64_t soft_fac_list[S390_ARCH_FAC_LIST_SIZE_UINT64];
> > } S390MachineProps;
> 
> Ah, ok, I missed that part. So "kvm_s390_get_machine_props()" basically 
> gets us the full facility list the host supports. That makes sense.
> 
> I still don't know whether we should care about hard/soft, but I suppose 
> the rest makes sense.

The reason why I differentiate between hardware and software implemented
facilities has several reasons.

First, one should understand that both lists represent the same set of
features, there is no software feature not being implemented as hardware
feature on an existing S390 system. An optional implementation of a software
feature is usable on back-level hardware to implement functionality, not
quality or performance! That means, on OS and it's application is capable to
run most efficiently on the given hardware without that software feature.
If a system has the same facility in soft- and hardware implemented, KVM
always privileges the hardware implementation.

Second, separating both features allow user space to differentiate between
hardware and software implemented features and to give up on SW features
if not explicitly requested by the CPU model option "+sofl".

Third, and very important, the main reason for CPU model implementation
is to guarantee an identical environment on source and target side comprised
of facilities, instruction set and CPU id. The capability for migration is
lost as soon software implemented facilities become activated!

Once again the method Qemu uses to define the set of requested facilities.

The machine properties ioctl provides FMh, HFh, and SFh, ie. the mask and
hardware/software implemented facility sets of the hosts.

Qemu has knowledge on all real existing CPU models (TYPE-GA), particularly
on the facility set of these model (Fm)
 
During startup, Qemu retrives FMh, HFh and SFh. Then for all CPU models Qemu
is aware off, it calculates (Fm & FMh). If that is a subset of HFh, the model
is a supportable model on this host. If the user has specified to allow
software implemented facilities (-cpu <model>,+sofl), The facilities to
request are calculated like (Fm & FMh | SFh).

> 
> Alex
> 

