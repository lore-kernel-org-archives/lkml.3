Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231AbaEPOqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 10:46:54 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:43071 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756188AbaEPOqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 10:46:52 -0400
Date: Fri, 16 May 2014 16:46:45 +0200
From: Michael Mueller <mimu@linux.vnet.ibm.com>
To: Alexander Graf <agraf@suse.de>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "Jason J. Herne" <jjherne@linux.vnet.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andreas Faerber <afaerber@suse.de>,
        Richard Henderson <rth@twiddle.net>
Subject: Re: [Qemu-devel] [PATCH v1 RFC 3/6] KVM: s390: use facilities and
 cpu_id per KVM
Message-ID: <20140516164645.57f22213@bee>
In-Reply-To: <5375FCBD.7010700@suse.de>
References: <1399993114-15333-1-git-send-email-mimu@linux.vnet.ibm.com>
	<1399993114-15333-4-git-send-email-mimu@linux.vnet.ibm.com>
	<5375FCBD.7010700@suse.de>
Organization: IBM
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.13; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051614-2966-0000-0000-00000B4CBC49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2014 13:55:41 +0200
Alexander Graf <agraf@suse.de> wrote:

> 
> On 13.05.14 16:58, Michael Mueller wrote:
> > The patch introduces facilities and cpu_ids per virtual machine.
> > Different virtual machines may want to expose different facilities and
> > cpu ids to the guest, so let's make them per-vm instead of global.
> >
> > In addition this patch renames all ocurrences of *facilities to *fac_list
> > smilar to the already exiting symbol stfl_fac_list in lowcore.
> >
> > Signed-off-by: Michael Mueller <mimu@linux.vnet.ibm.com>
> > Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
> > Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
> > ---
> >   arch/s390/include/asm/kvm_host.h |   7 +++
> >   arch/s390/kvm/gaccess.c          |   4 +-
> >   arch/s390/kvm/kvm-s390.c         | 107 +++++++++++++++++++++++++++------------
> >   arch/s390/kvm/kvm-s390.h         |  23 +++++++--
> >   arch/s390/kvm/priv.c             |  13 +++--
> >   5 files changed, 113 insertions(+), 41 deletions(-)
> >
> > diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> > index 38d487a..b4751ba 100644
> > --- a/arch/s390/include/asm/kvm_host.h
> > +++ b/arch/s390/include/asm/kvm_host.h
> > @@ -414,6 +414,12 @@ struct kvm_s390_config {
> >   	struct kvm_s390_attr_name name;
> >   };
> >   
> > +struct kvm_s390_cpu_model {
> > +	unsigned long *sie_fac;
> > +	struct cpuid cpu_id;
> > +	unsigned long *fac_list;
> > +};
> > +
> >   struct kvm_arch{
> >   	struct sca_block *sca;
> >   	debug_info_t *dbf;
> > @@ -427,6 +433,7 @@ struct kvm_arch{
> >   	wait_queue_head_t ipte_wq;
> >   	struct kvm_s390_config *cfg;
> >   	spinlock_t start_stop_lock;
> > +	struct kvm_s390_cpu_model model;
> >   };
> >   
> >   #define KVM_HVA_ERR_BAD		(-1UL)
> > diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> > index db608c3..4c7ca40 100644
> > --- a/arch/s390/kvm/gaccess.c
> > +++ b/arch/s390/kvm/gaccess.c
> > @@ -358,8 +358,8 @@ static unsigned long guest_translate(struct kvm_vcpu *vcpu, unsigned long
> > gva, union asce asce;
> >   
> >   	ctlreg0.val = vcpu->arch.sie_block->gcr[0];
> > -	edat1 = ctlreg0.edat && test_vfacility(8);
> > -	edat2 = edat1 && test_vfacility(78);
> > +	edat1 = ctlreg0.edat && test_kvm_facility(vcpu->kvm, 8);
> > +	edat2 = edat1 && test_kvm_facility(vcpu->kvm, 78);
> >   	asce.val = get_vcpu_asce(vcpu);
> >   	if (asce.r)
> >   		goto real_address;
> > diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> > index 01a5212..a53652f 100644
> > --- a/arch/s390/kvm/kvm-s390.c
> > +++ b/arch/s390/kvm/kvm-s390.c
> > @@ -1,5 +1,5 @@
> >   /*
> > - * hosting zSeries kernel virtual machines
> > + * Hosting zSeries kernel virtual machines
> >    *
> >    * Copyright IBM Corp. 2008, 2009
> >    *
> > @@ -30,7 +30,6 @@
> >   #include <asm/pgtable.h>
> >   #include <asm/nmi.h>
> >   #include <asm/switch_to.h>
> > -#include <asm/facility.h>
> >   #include <asm/sclp.h>
> >   #include<asm/timex.h>
> >   #include "kvm-s390.h"
> > @@ -92,15 +91,33 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
> >   	{ NULL }
> >   };
> >   
> > -unsigned long *vfacilities;
> > -static struct gmap_notifier gmap_notifier;
> > +/* upper facilities limit for kvm */
> > +unsigned long kvm_s390_fac_list_mask[] = {
> > +	0xff82fff3f47c2000UL,
> > +	0x005c000000000000UL,
> > +};
> > +
> > +unsigned long kvm_s390_fac_list_mask_size(void)
> > +{
> > +	BUILD_BUG_ON(ARRAY_SIZE(kvm_s390_fac_list_mask) >
> > +		     S390_ARCH_FAC_MASK_SIZE_U64);
> > +	return ARRAY_SIZE(kvm_s390_fac_list_mask);
> > +}
> >   
> > -/* test availability of vfacility */
> > -int test_vfacility(unsigned long nr)
> > +void kvm_s390_apply_fac_list_mask(unsigned long fac_list[])
> >   {
> > -	return __test_facility(nr, (void *) vfacilities);
> > +	unsigned int i;
> > +
> > +	for (i = 0; i < S390_ARCH_FAC_LIST_SIZE_U64; i++) {
> > +		if (i < kvm_s390_fac_list_mask_size())
> > +			fac_list[i] &= kvm_s390_fac_list_mask[i];
> > +		else
> > +			fac_list[i] &= 0UL;
> > +	}
> >   }
> >   
> > +static struct gmap_notifier gmap_notifier;
> > +
> >   /* Section: not file related */
> >   int kvm_arch_hardware_enable(void *garbage)
> >   {
> > @@ -485,6 +502,30 @@ long kvm_arch_vm_ioctl(struct file *filp,
> >   	return r;
> >   }
> >   
> > +/* make sure the memory used for fac_list is zeroed */
> > +void kvm_s390_get_hard_fac_list(unsigned long *fac_list, int size)
> 
> Hard? Wouldn't "host" make more sense here?

Renaming "*hard_fac_list" with "*host_fac_list" here and wherever it appears is ok with me. 

> 
> I also think it makes sense to expose the native host facility list to 
> user space via an ioctl somehow.
> 

In which situation do you need the full facility list. Do you have an example?

> 
> Alex
> 
> 

