Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab3FQHzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 03:55:52 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:41189 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934Ab3FQHzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 03:55:50 -0400
Message-ID: <51BEC0FE.4020805@ozlabs.ru>
Date: Mon, 17 Jun 2013 17:55:42 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@samba.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 1/4] KVM: PPC: Add support for multiple-TCE hcalls
References: <1370412673-1345-1-git-send-email-aik@ozlabs.ru> <1370412673-1345-2-git-send-email-aik@ozlabs.ru> <0A6C24DE-1422-4ABA-A516-2B864F4714F8@suse.de>
In-Reply-To: <0A6C24DE-1422-4ABA-A516-2B864F4714F8@suse.de>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2013 08:06 AM, Alexander Graf wrote:
> 
> On 05.06.2013, at 08:11, Alexey Kardashevskiy wrote:
> 
>> This adds real mode handlers for the H_PUT_TCE_INDIRECT and
>> H_STUFF_TCE hypercalls for QEMU emulated devices such as IBMVIO
>> devices or emulated PCI.  These calls allow adding multiple entries
>> (up to 512) into the TCE table in one call which saves time on
>> transition to/from real mode.
>>
>> This adds a tce_tmp cache to kvm_vcpu_arch to save valid TCEs
>> (copied from user and verified) before writing the whole list into
>> the TCE table. This cache will be utilized more in the upcoming
>> VFIO/IOMMU support to continue TCE list processing in the virtual
>> mode in the case if the real mode handler failed for some reason.
>>
>> This adds a guest physical to host real address converter
>> and calls the existing H_PUT_TCE handler. The converting function
>> is going to be fully utilized by upcoming VFIO supporting patches.
>>
>> This also implements the KVM_CAP_PPC_MULTITCE capability,
>> so in order to support the functionality of this patch, QEMU
>> needs to query for this capability and set the "hcall-multi-tce"
>> hypertas property only if the capability is present, otherwise
>> there will be serious performance degradation.
>>
>> Cc: David Gibson <david@gibson.dropbear.id.au>
>> Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
>> Signed-off-by: Paul Mackerras <paulus@samba.org>
> 
> Only a few minor nits. Ben already commented on implementation details.
> 
>>
>> ---
>> Changelog:
>> 2013/06/05:
>> * fixed mistype about IBMVIO in the commit message
>> * updated doc and moved it to another section
>> * changed capability number
>>
>> 2013/05/21:
>> * added kvm_vcpu_arch::tce_tmp
>> * removed cleanup if put_indirect failed, instead we do not even start
>> writing to TCE table if we cannot get TCEs from the user and they are
>> invalid
>> * kvmppc_emulated_h_put_tce is split to kvmppc_emulated_put_tce
>> and kvmppc_emulated_validate_tce (for the previous item)
>> * fixed bug with failthrough for H_IPI
>> * removed all get_user() from real mode handlers
>> * kvmppc_lookup_pte() added (instead of making lookup_linux_pte public)
>> ---
>> Documentation/virtual/kvm/api.txt       |   17 ++
>> arch/powerpc/include/asm/kvm_host.h     |    2 +
>> arch/powerpc/include/asm/kvm_ppc.h      |   16 +-
>> arch/powerpc/kvm/book3s_64_vio.c        |  118 ++++++++++++++
>> arch/powerpc/kvm/book3s_64_vio_hv.c     |  266 +++++++++++++++++++++++++++----
>> arch/powerpc/kvm/book3s_hv.c            |   39 +++++
>> arch/powerpc/kvm/book3s_hv_rmhandlers.S |    6 +
>> arch/powerpc/kvm/book3s_pr_papr.c       |   37 ++++-
>> arch/powerpc/kvm/powerpc.c              |    3 +
>> include/uapi/linux/kvm.h                |    1 +
>> 10 files changed, 473 insertions(+), 32 deletions(-)
>>
>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
>> index 5f91eda..6c082ff 100644
>> --- a/Documentation/virtual/kvm/api.txt
>> +++ b/Documentation/virtual/kvm/api.txt
>> @@ -2362,6 +2362,23 @@ calls by the guest for that service will be passed to userspace to be
>> handled.
>>
>>
>> +4.83 KVM_CAP_PPC_MULTITCE
>> +
>> +Capability: KVM_CAP_PPC_MULTITCE
>> +Architectures: ppc
>> +Type: vm
>> +
>> +This capability tells the guest that multiple TCE entry add/remove hypercalls
>> +handling is supported by the kernel. This significanly accelerates DMA
>> +operations for PPC KVM guests.
>> +
>> +Unlike other capabilities in this section, this one does not have an ioctl.
>> +Instead, when the capability is present, the H_PUT_TCE_INDIRECT and
>> +H_STUFF_TCE hypercalls are to be handled in the host kernel and not passed to
>> +the guest. Othwerwise it might be better for the guest to continue using H_PUT_TCE
>> +hypercall (if KVM_CAP_SPAPR_TCE or KVM_CAP_SPAPR_TCE_IOMMU are present).
> 

> While this describes perfectly well what the consequences are of the
> patches, it does not describe properly what the CAP actually expresses.
> The CAP only says "this kernel is able to handle H_PUT_TCE_INDIRECT and
> H_STUFF_TCE hypercalls directly". All other consequences are nice to
> document, but the semantics of the CAP are missing.


? It expresses ability to handle 2 hcalls. What is missing?


> We also usually try to keep KVM behavior unchanged with regards to older
> versions until a CAP is enabled. In this case I don't think it matters
> all that much, so I'm fine with declaring it as enabled by default.
> Please document that this is a change in behavior versus older KVM
> versions though.


Ok!


>> +
>> +
>> 5. The kvm_run structure
>> ------------------------
>>
>> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
>> index af326cd..85d8f26 100644
>> --- a/arch/powerpc/include/asm/kvm_host.h
>> +++ b/arch/powerpc/include/asm/kvm_host.h
>> @@ -609,6 +609,8 @@ struct kvm_vcpu_arch {
>> 	spinlock_t tbacct_lock;
>> 	u64 busy_stolen;
>> 	u64 busy_preempt;
>> +
>> +	unsigned long *tce_tmp;    /* TCE cache for TCE_PUT_INDIRECT hall */
>> #endif
>> };
> 
> [...]
>>
>>
> 
> [...]
> 
>> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
>> index 550f592..a39039a 100644
>> --- a/arch/powerpc/kvm/book3s_hv.c
>> +++ b/arch/powerpc/kvm/book3s_hv.c
>> @@ -568,6 +568,30 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
>> 			ret = kvmppc_xics_hcall(vcpu, req);
>> 			break;
>> 		} /* fallthrough */
> 
> The fallthrough comment isn't accurate anymore.
> 
>> +		return RESUME_HOST;
>> +	case H_PUT_TCE:
>> +		ret = kvmppc_virtmode_h_put_tce(vcpu, kvmppc_get_gpr(vcpu, 4),
>> +						kvmppc_get_gpr(vcpu, 5),
>> +						kvmppc_get_gpr(vcpu, 6));
>> +		if (ret == H_TOO_HARD)
>> +			return RESUME_HOST;
>> +		break;
>> +	case H_PUT_TCE_INDIRECT:
>> +		ret = kvmppc_virtmode_h_put_tce_indirect(vcpu, kvmppc_get_gpr(vcpu, 4),
>> +						kvmppc_get_gpr(vcpu, 5),
>> +						kvmppc_get_gpr(vcpu, 6),
>> +						kvmppc_get_gpr(vcpu, 7));
>> +		if (ret == H_TOO_HARD)
>> +			return RESUME_HOST;
>> +		break;
>> +	case H_STUFF_TCE:
>> +		ret = kvmppc_virtmode_h_stuff_tce(vcpu, kvmppc_get_gpr(vcpu, 4),
>> +						kvmppc_get_gpr(vcpu, 5),
>> +						kvmppc_get_gpr(vcpu, 6),
>> +						kvmppc_get_gpr(vcpu, 7));
>> +		if (ret == H_TOO_HARD)
>> +			return RESUME_HOST;
>> +		break;
>> 	default:
>> 		return RESUME_HOST;
>> 	}
>> @@ -958,6 +982,20 @@ struct kvm_vcpu *kvmppc_core_vcpu_create(struct kvm *kvm, unsigned int id)
>> 	vcpu->arch.cpu_type = KVM_CPU_3S_64;
>> 	kvmppc_sanity_check(vcpu);
>>
>> +	/*
>> +	 * As we want to minimize the chance of having H_PUT_TCE_INDIRECT
>> +	 * half executed, we first read TCEs from the user, check them and
>> +	 * return error if something went wrong and only then put TCEs into
>> +	 * the TCE table.
>> +	 *
>> +	 * tce_tmp is a cache for TCEs to avoid stack allocation or
>> +	 * kmalloc as the whole TCE list can take up to 512 items 8 bytes
>> +	 * each (4096 bytes).
>> +	 */
>> +	vcpu->arch.tce_tmp = kmalloc(4096, GFP_KERNEL);
>> +	if (!vcpu->arch.tce_tmp)
>> +		goto free_vcpu;
>> +
>> 	return vcpu;
>>
>> free_vcpu:
>> @@ -980,6 +1018,7 @@ void kvmppc_core_vcpu_free(struct kvm_vcpu *vcpu)
>> 	unpin_vpa(vcpu->kvm, &vcpu->arch.slb_shadow);
>> 	unpin_vpa(vcpu->kvm, &vcpu->arch.vpa);
>> 	spin_unlock(&vcpu->arch.vpa_update_lock);
>> +	kfree(vcpu->arch.tce_tmp);
>> 	kvm_vcpu_uninit(vcpu);
>> 	kmem_cache_free(kvm_vcpu_cache, vcpu);
>> }
>> diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
>> index b02f91e..d35554e 100644
>> --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
>> +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
>> @@ -1490,6 +1490,12 @@ hcall_real_table:
>> 	.long	0		/* 0x11c */
>> 	.long	0		/* 0x120 */
>> 	.long	.kvmppc_h_bulk_remove - hcall_real_table
>> +	.long	0		/* 0x128 */
>> +	.long	0		/* 0x12c */
>> +	.long	0		/* 0x130 */
>> +	.long	0		/* 0x134 */
>> +	.long	.kvmppc_h_stuff_tce - hcall_real_table
>> +	.long	.kvmppc_h_put_tce_indirect - hcall_real_table
>> hcall_real_table_end:
>>
>> ignore_hdec:
>> diff --git a/arch/powerpc/kvm/book3s_pr_papr.c b/arch/powerpc/kvm/book3s_pr_papr.c
>> index da0e0bc..91d4b45 100644
>> --- a/arch/powerpc/kvm/book3s_pr_papr.c
>> +++ b/arch/powerpc/kvm/book3s_pr_papr.c
>> @@ -220,7 +220,38 @@ static int kvmppc_h_pr_put_tce(struct kvm_vcpu *vcpu)
>> 	unsigned long tce = kvmppc_get_gpr(vcpu, 6);
>> 	long rc;
>>
>> -	rc = kvmppc_h_put_tce(vcpu, liobn, ioba, tce);
>> +	rc = kvmppc_virtmode_h_put_tce(vcpu, liobn, ioba, tce);
>> +	if (rc == H_TOO_HARD)
>> +		return EMULATE_FAIL;
>> +	kvmppc_set_gpr(vcpu, 3, rc);
>> +	return EMULATE_DONE;
>> +}
>> +
>> +static int kvmppc_h_pr_put_tce_indirect(struct kvm_vcpu *vcpu)
>> +{
>> +	unsigned long liobn = kvmppc_get_gpr(vcpu, 4);
>> +	unsigned long ioba = kvmppc_get_gpr(vcpu, 5);
>> +	unsigned long tce = kvmppc_get_gpr(vcpu, 6);
>> +	unsigned long npages = kvmppc_get_gpr(vcpu, 7);
>> +	long rc;
>> +
>> +	rc = kvmppc_virtmode_h_put_tce_indirect(vcpu, liobn, ioba,
>> +			tce, npages);
>> +	if (rc == H_TOO_HARD)
>> +		return EMULATE_FAIL;
>> +	kvmppc_set_gpr(vcpu, 3, rc);
>> +	return EMULATE_DONE;
>> +}
>> +
>> +static int kvmppc_h_pr_stuff_tce(struct kvm_vcpu *vcpu)
>> +{
>> +	unsigned long liobn = kvmppc_get_gpr(vcpu, 4);
>> +	unsigned long ioba = kvmppc_get_gpr(vcpu, 5);
>> +	unsigned long tce_value = kvmppc_get_gpr(vcpu, 6);
>> +	unsigned long npages = kvmppc_get_gpr(vcpu, 7);
>> +	long rc;
>> +
>> +	rc = kvmppc_virtmode_h_stuff_tce(vcpu, liobn, ioba, tce_value, npages);
>> 	if (rc == H_TOO_HARD)
>> 		return EMULATE_FAIL;
>> 	kvmppc_set_gpr(vcpu, 3, rc);
>> @@ -247,6 +278,10 @@ int kvmppc_h_pr(struct kvm_vcpu *vcpu, unsigned long cmd)
>> 		return kvmppc_h_pr_bulk_remove(vcpu);
>> 	case H_PUT_TCE:
>> 		return kvmppc_h_pr_put_tce(vcpu);
>> +	case H_PUT_TCE_INDIRECT:
>> +		return kvmppc_h_pr_put_tce_indirect(vcpu);
>> +	case H_STUFF_TCE:
>> +		return kvmppc_h_pr_stuff_tce(vcpu);
>> 	case H_CEDE:
>> 		vcpu->arch.shared->msr |= MSR_EE;
>> 		kvm_vcpu_block(vcpu);
>> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
>> index 6316ee3..8465c2a 100644
>> --- a/arch/powerpc/kvm/powerpc.c
>> +++ b/arch/powerpc/kvm/powerpc.c
>> @@ -395,6 +395,9 @@ int kvm_dev_ioctl_check_extension(long ext)
>> 		r = 1;
>> 		break;
>> #endif
>> +	case KVM_CAP_SPAPR_MULTITCE:
>> +		r = 1;
> 
> This should only be true for book3s.


We had this discussion with v2.

David:
===
So, in the case of MULTITCE, that's not quite right.  PR KVM can
emulate a PAPR system on a BookE machine, and there's no reason not to
allow TCE acceleration as well.  We can't make it dependent on PAPR
mode being selected, because that's enabled per-vcpu, whereas these
capabilities are queried on the VM before the vcpus are created.
===

Wrong?


-- 
Alexey
