Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161193Ab3BODyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 22:54:35 -0500
Received: from ozlabs.org ([203.10.76.45]:36566 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935334Ab3BODy3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 22:54:29 -0500
Date: Fri, 15 Feb 2013 14:24:59 +1100
From: Paul Mackerras <paulus@samba.org>
To: aik@ozlabs.ru
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Graf <agraf@suse.de>,
        Michael Ellerman <michael@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH 2/4] powerpc kvm: added multiple TCEs requests support
Message-ID: <20130215032458.GB25015@drongo>
References: <1360584763-21988-1-git-send-email-a>
 <5118e064.22ca320a.1f08.ffffe2ec@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5118e064.22ca320a.1f08.ffffe2ec@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 11:12:41PM +1100, aik@ozlabs.ru wrote:

> +static long emulated_h_put_tce(struct kvmppc_spapr_tce_table *stt,
> +		unsigned long ioba, unsigned long tce)
> +{
> +	unsigned long idx = ioba >> SPAPR_TCE_SHIFT;
> +	struct page *page;
> +	u64 *tbl;
> +
> +	/* udbg_printf("H_PUT_TCE: liobn 0x%lx => stt=%p  window_size=0x%x\n", */
> +	/* 	    liobn, stt, stt->window_size); */
> +	if (ioba >= stt->window_size) {
> +		pr_err("%s failed on ioba=%lx\n", __func__, ioba);

Doesn't this give the guest a way to spam the host logs?  And in fact
printk in real mode is potentially problematic.  I would just leave
out this statement.

> +		return H_PARAMETER;
> +	}
> +
> +	page = stt->pages[idx / TCES_PER_PAGE];
> +	tbl = (u64 *)page_address(page);

I would like to see an explanation of why we are confident that
page_address() will work correctly in real mode, across all the
combinations of config options that we can have for a ppc64 book3s
kernel.

> +
> +	/* FIXME: Need to validate the TCE itself */
> +	/* udbg_printf("tce @ %p\n", &tbl[idx % TCES_PER_PAGE]); */
> +	tbl[idx % TCES_PER_PAGE] = tce;
> +
> +	return H_SUCCESS;
> +}
> +
> +/*
> + * Real mode handlers
>   */
>  long kvmppc_h_put_tce(struct kvm_vcpu *vcpu, unsigned long liobn,
>  		      unsigned long ioba, unsigned long tce)
>  {
> -	struct kvm *kvm = vcpu->kvm;
>  	struct kvmppc_spapr_tce_table *stt;
>  
> -	/* udbg_printf("H_PUT_TCE(): liobn=0x%lx ioba=0x%lx, tce=0x%lx\n", */
> -	/* 	    liobn, ioba, tce); */
> +	stt = find_tce_table(vcpu, liobn);
> +	/* Didn't find the liobn, put it to userspace */
> +	if (!stt)
> +		return H_TOO_HARD;
> +
> +	/* Emulated IO */
> +	return emulated_h_put_tce(stt, ioba, tce);
> +}
> +
> +long kvmppc_h_put_tce_indirect(struct kvm_vcpu *vcpu,
> +		unsigned long liobn, unsigned long ioba,
> +		unsigned long tce_list,	unsigned long npages)
> +{
> +	struct kvmppc_spapr_tce_table *stt;
> +	long i, ret = 0;
> +	unsigned long *tces;
> +
> +	stt = find_tce_table(vcpu, liobn);
> +	/* Didn't find the liobn, put it to userspace */
> +	if (!stt)
> +		return H_TOO_HARD;
>  
> -	list_for_each_entry(stt, &kvm->arch.spapr_tce_tables, list) {
> -		if (stt->liobn == liobn) {
> -			unsigned long idx = ioba >> SPAPR_TCE_SHIFT;
> -			struct page *page;
> -			u64 *tbl;
> +	tces = (void *) get_real_address(vcpu, tce_list, false, NULL, NULL);
> +	if (!tces)
> +		return H_TOO_HARD;
>  
> -			/* udbg_printf("H_PUT_TCE: liobn 0x%lx => stt=%p  window_size=0x%x\n", */
> -			/* 	    liobn, stt, stt->window_size); */
> -			if (ioba >= stt->window_size)
> -				return H_PARAMETER;
> +	/* Emulated IO */
> +	for (i = 0; (i < npages) && !ret; ++i, ioba += IOMMU_PAGE_SIZE)
> +		ret = emulated_h_put_tce(stt, ioba, tces[i]);

So, tces is a pointer to somewhere inside a real page.  Did we check
somewhere that tces[npages-1] is in the same page as tces[0]?  If so,
I missed it.  If we didn't, then we probably should check and do
something about it.

>  
> -			page = stt->pages[idx / TCES_PER_PAGE];
> -			tbl = (u64 *)page_address(page);
> +	return ret;
> +}
>  
> -			/* FIXME: Need to validate the TCE itself */
> -			/* udbg_printf("tce @ %p\n", &tbl[idx % TCES_PER_PAGE]); */
> -			tbl[idx % TCES_PER_PAGE] = tce;
> -			return H_SUCCESS;
> -		}
> -	}
> +long kvmppc_h_stuff_tce(struct kvm_vcpu *vcpu,
> +		unsigned long liobn, unsigned long ioba,
> +		unsigned long tce_value, unsigned long npages)
> +{
> +	struct kvmppc_spapr_tce_table *stt;
> +	long i, ret = 0;
> +
> +	stt = find_tce_table(vcpu, liobn);
> +	/* Didn't find the liobn, put it to userspace */
> +	if (!stt)
> +		return H_TOO_HARD;
>  
> -	/* Didn't find the liobn, punt it to userspace */
> -	return H_TOO_HARD;
> +	/* Emulated IO */
> +	for (i = 0; (i < npages) && !ret; ++i, ioba += IOMMU_PAGE_SIZE)
> +		ret = emulated_h_put_tce(stt, ioba, tce_value);
> +
> +	return ret;
> +}
> +
> +/*
> + * Virtual mode handlers
> + */
> +extern long kvmppc_virtmode_h_put_tce(struct kvm_vcpu *vcpu,
> +		unsigned long liobn, unsigned long ioba,
> +		unsigned long tce)
> +{
> +	/* At the moment emulated IO is handled the same way */
> +	return kvmppc_h_put_tce(vcpu, liobn, ioba, tce);
> +}
> +
> +extern long kvmppc_virtmode_h_put_tce_indirect(struct kvm_vcpu *vcpu,
> +		unsigned long liobn, unsigned long ioba,
> +		unsigned long tce_list, unsigned long npages)
> +{
> +	struct kvmppc_spapr_tce_table *stt;
> +	unsigned long *tces;
> +	long ret = 0, i;
> +
> +	stt = find_tce_table(vcpu, liobn);
> +	/* Didn't find the liobn, put it to userspace */
> +	if (!stt)
> +		return H_TOO_HARD;
> +
> +	tces = (void *) get_virt_address(vcpu, tce_list, false, NULL, NULL);
> +	if (!tces)
> +		return H_TOO_HARD;
> +
> +	/* Emulated IO */
> +	for (i = 0; (i < npages) && !ret; ++i, ioba += IOMMU_PAGE_SIZE)
> +		ret = emulated_h_put_tce(stt, ioba, tces[i]);

Same comment here about tces[i] overflowing a page boundary.

> +
> +	return ret;
> +}
> +
> +extern long kvmppc_virtmode_h_stuff_tce(struct kvm_vcpu *vcpu,
> +		unsigned long liobn, unsigned long ioba,
> +		unsigned long tce_value, unsigned long npages)
> +{
> +	/* At the moment emulated IO is handled the same way */
> +	return kvmppc_h_stuff_tce(vcpu, liobn, ioba, tce_value, npages);
>  }
> diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
> index 71d0c90..13c8436 100644
> --- a/arch/powerpc/kvm/book3s_hv.c
> +++ b/arch/powerpc/kvm/book3s_hv.c
> @@ -515,6 +515,29 @@ int kvmppc_pseries_do_hcall(struct kvm_vcpu *vcpu)
>  					kvmppc_get_gpr(vcpu, 5),
>  					kvmppc_get_gpr(vcpu, 6));
>  		break;
> +	case H_PUT_TCE:
> +		ret = kvmppc_virtmode_h_put_tce(vcpu, kvmppc_get_gpr(vcpu, 4),
> +					        kvmppc_get_gpr(vcpu, 5),
> +					        kvmppc_get_gpr(vcpu, 6));
> +		if (ret == H_TOO_HARD)
> +			return RESUME_HOST;
> +		break;
> +	case H_PUT_TCE_INDIRECT:
> +		ret = kvmppc_virtmode_h_put_tce_indirect(vcpu, kvmppc_get_gpr(vcpu, 4),
> +					        kvmppc_get_gpr(vcpu, 5),
> +					        kvmppc_get_gpr(vcpu, 6),
> +						kvmppc_get_gpr(vcpu, 7));
> +		if (ret == H_TOO_HARD)
> +			return RESUME_HOST;
> +		break;
> +	case H_STUFF_TCE:
> +		ret = kvmppc_virtmode_h_stuff_tce(vcpu, kvmppc_get_gpr(vcpu, 4),
> +					        kvmppc_get_gpr(vcpu, 5),
> +					        kvmppc_get_gpr(vcpu, 6),
> +						kvmppc_get_gpr(vcpu, 7));
> +		if (ret == H_TOO_HARD)
> +			return RESUME_HOST;
> +		break;
>  	default:
>  		return RESUME_HOST;
>  	}
[snip]
> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
> index 70739a0..95614c7 100644
> --- a/arch/powerpc/kvm/powerpc.c
> +++ b/arch/powerpc/kvm/powerpc.c
> @@ -383,6 +383,9 @@ int kvm_dev_ioctl_check_extension(long ext)
>  		r = 1;
>  		break;
>  #endif
> +	case KVM_CAP_PPC_MULTITCE:
> +		r = 1;
> +		break;
>  	default:
>  		r = 0;
>  		break;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index e6e5d4b..26e2b271 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -635,6 +635,7 @@ struct kvm_ppc_smmu_info {
>  #define KVM_CAP_IRQFD_RESAMPLE 82
>  #define KVM_CAP_PPC_BOOKE_WATCHDOG 83
>  #define KVM_CAP_PPC_HTAB_FD 84
> +#define KVM_CAP_PPC_MULTITCE 87

The capability should be described in
Documentation/virtual/kvm/api.txt.

Paul.
