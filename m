Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbaIRK11 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 06:27:27 -0400
Received: from ozlabs.org ([103.22.144.67]:51395 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756324AbaIRK10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 06:27:26 -0400
Message-ID: <541AB38B.5080706@ozlabs.org>
Date: Thu, 18 Sep 2014 18:27:23 +0800
From: Jeremy Kerr <jk@ozlabs.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Michael Neuling <mikey@neuling.org>, greg@kroah.com, arnd@arndb.de,
        mpe@ellerman.id.au, benh@kernel.crashing.org
CC: anton@samba.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        imunsie@au.ibm.com, cbe-oss-dev@lists.ozlabs.org
Subject: Re: [PATCH 02/15] powerpc/cell: Move data segment faulting code out
 of cell platform
References: <1411028820-29933-1-git-send-email-mikey@neuling.org> <1411028820-29933-3-git-send-email-mikey@neuling.org>
In-Reply-To: <1411028820-29933-3-git-send-email-mikey@neuling.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mikey & Ian,

> __spu_trap_data_seg() currently contains code to determine the VSID and ESID
> required for a particular EA and mm struct.
> 
> This code is generically useful for other co-processors.  This moves the code
> of the cell platform so it can be used by other powerpc code.

OK, nice.

> +
> +int copro_data_segment(struct mm_struct *mm, u64 ea, u64 *esid, u64 *vsid)
> +{
> +	int psize, ssize;
> +
> +	*esid = (ea & ESID_MASK) | SLB_ESID_V;
> +
> +	switch (REGION_ID(ea)) {
> +	case USER_REGION_ID:
> +		pr_devel("copro_data_segment: 0x%llx -- USER_REGION_ID\n", ea);
> +#ifdef CONFIG_PPC_MM_SLICES
> +		psize = get_slice_psize(mm, ea);
> +#else
> +		psize = mm->context.user_psize;
> +#endif
> +		ssize = user_segment_size(ea);
> +		*vsid = (get_vsid(mm->context.id, ea, ssize)
> +			<< slb_vsid_shift(ssize)) | SLB_VSID_USER
> +			| (ssize == MMU_SEGSIZE_1T ? SLB_VSID_B_1T : 0);
> +		break;
> +	case VMALLOC_REGION_ID:
> +		pr_devel("copro_data_segment: 0x%llx -- VMALLOC_REGION_ID\n", ea);
> +		if (ea < VMALLOC_END)
> +			psize = mmu_vmalloc_psize;
> +		else
> +			psize = mmu_io_psize;
> +		*vsid = (get_kernel_vsid(ea, mmu_kernel_ssize)
> +			<< SLB_VSID_SHIFT) | SLB_VSID_KERNEL
> +			| (mmu_kernel_ssize == MMU_SEGSIZE_1T ? SLB_VSID_B_1T : 0);
> +		break;
> +	case KERNEL_REGION_ID:
> +		pr_devel("copro_data_segment: 0x%llx -- KERNEL_REGION_ID\n", ea);
> +		psize = mmu_linear_psize;
> +		*vsid = (get_kernel_vsid(ea, mmu_kernel_ssize)
> +			<< SLB_VSID_SHIFT) | SLB_VSID_KERNEL
> +			| (mmu_kernel_ssize == MMU_SEGSIZE_1T ? SLB_VSID_B_1T : 0);
> +		break;
> +	default:
> +		/* Future: support kernel segments so that drivers can use the
> +		 * CoProcessors */
> +		pr_debug("invalid region access at %016llx\n", ea);
> +		return 1;
> +	}
> +	*vsid |= mmu_psize_defs[psize].sllp;

A bit of a nitpick, but how about you remove the repeated:

		| (<size> == MMU_SEGSIZE_1T ? SLB_VSID_B_1T : 0)

then set ssize in each of the switch cases (like we do with psize), and
or-in the VSID_B_1T bit at the end:
	
	*vsid |= mmu_psize_defs[psize].sllp
		| (ssize == MMU_SEGSIZE_1T ? SLB_VSID_B_1T : 0);

Otherwise, looks good to me.

Cheers,


Jeremy

