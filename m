Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbaIRXp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 19:45:59 -0400
Received: from ozlabs.org ([103.22.144.67]:34887 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282AbaIRXp6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 19:45:58 -0400
Message-ID: <1411083956.12154.29.camel@ale.ozlabs.ibm.com>
Subject: Re: [PATCH 02/15] powerpc/cell: Move data segment faulting code out
 of cell platform
From: Michael Neuling <mikey@neuling.org>
To: Jeremy Kerr <jk@ozlabs.org>
Cc: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org, anton@samba.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        imunsie@au.ibm.com, cbe-oss-dev@lists.ozlabs.org
Date: Fri, 19 Sep 2014 09:45:56 +1000
In-Reply-To: <541AB38B.5080706@ozlabs.org>
References: <1411028820-29933-1-git-send-email-mikey@neuling.org>
	 <1411028820-29933-3-git-send-email-mikey@neuling.org>
	 <541AB38B.5080706@ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +
> > +int copro_data_segment(struct mm_struct *mm, u64 ea, u64 *esid, u64 *vsid)
> > +{
> > +	int psize, ssize;
> > +
> > +	*esid = (ea & ESID_MASK) | SLB_ESID_V;
> > +
> > +	switch (REGION_ID(ea)) {
> > +	case USER_REGION_ID:
> > +		pr_devel("copro_data_segment: 0x%llx -- USER_REGION_ID\n", ea);
> > +#ifdef CONFIG_PPC_MM_SLICES
> > +		psize = get_slice_psize(mm, ea);
> > +#else
> > +		psize = mm->context.user_psize;
> > +#endif
> > +		ssize = user_segment_size(ea);
> > +		*vsid = (get_vsid(mm->context.id, ea, ssize)
> > +			<< slb_vsid_shift(ssize)) | SLB_VSID_USER
> > +			| (ssize == MMU_SEGSIZE_1T ? SLB_VSID_B_1T : 0);
> > +		break;
> > +	case VMALLOC_REGION_ID:
> > +		pr_devel("copro_data_segment: 0x%llx -- VMALLOC_REGION_ID\n", ea);
> > +		if (ea < VMALLOC_END)
> > +			psize = mmu_vmalloc_psize;
> > +		else
> > +			psize = mmu_io_psize;
> > +		*vsid = (get_kernel_vsid(ea, mmu_kernel_ssize)
> > +			<< SLB_VSID_SHIFT) | SLB_VSID_KERNEL
> > +			| (mmu_kernel_ssize == MMU_SEGSIZE_1T ? SLB_VSID_B_1T : 0);
> > +		break;
> > +	case KERNEL_REGION_ID:
> > +		pr_devel("copro_data_segment: 0x%llx -- KERNEL_REGION_ID\n", ea);
> > +		psize = mmu_linear_psize;
> > +		*vsid = (get_kernel_vsid(ea, mmu_kernel_ssize)
> > +			<< SLB_VSID_SHIFT) | SLB_VSID_KERNEL
> > +			| (mmu_kernel_ssize == MMU_SEGSIZE_1T ? SLB_VSID_B_1T : 0);
> > +		break;
> > +	default:
> > +		/* Future: support kernel segments so that drivers can use the
> > +		 * CoProcessors */
> > +		pr_debug("invalid region access at %016llx\n", ea);
> > +		return 1;
> > +	}
> > +	*vsid |= mmu_psize_defs[psize].sllp;
> 
> A bit of a nitpick, but how about you remove the repeated:
> 
> 		| (<size> == MMU_SEGSIZE_1T ? SLB_VSID_B_1T : 0)
> 
> then set ssize in each of the switch cases (like we do with psize), and
> or-in the VSID_B_1T bit at the end:
> 	
> 	*vsid |= mmu_psize_defs[psize].sllp
> 		| (ssize == MMU_SEGSIZE_1T ? SLB_VSID_B_1T : 0);

Nice.  I think below is what you mean.

I'll fold this into the existing patch and repost in a few days.

Thanks,
Mikey

diff --git a/arch/powerpc/mm/copro_fault.c b/arch/powerpc/mm/copro_fault.c
index 4105a63..939caf6 100644
--- a/arch/powerpc/mm/copro_fault.c
+++ b/arch/powerpc/mm/copro_fault.c
@@ -107,8 +107,7 @@ int copro_data_segment(struct mm_struct *mm, u64 ea, u64 *esid, u64 *vsid)
 #endif
 		ssize = user_segment_size(ea);
 		*vsid = (get_vsid(mm->context.id, ea, ssize)
-			<< slb_vsid_shift(ssize)) | SLB_VSID_USER
-			| (ssize == MMU_SEGSIZE_1T ? SLB_VSID_B_1T : 0);
+			 << slb_vsid_shift(ssize)) | SLB_VSID_USER;
 		break;
 	case VMALLOC_REGION_ID:
 		pr_devel("copro_data_segment: 0x%llx -- VMALLOC_REGION_ID\n", ea);
@@ -116,16 +115,16 @@ int copro_data_segment(struct mm_struct *mm, u64 ea, u64 *esid, u64 *vsid)
 			psize = mmu_vmalloc_psize;
 		else
 			psize = mmu_io_psize;
+		ssize = mmu_kernel_ssize;
 		*vsid = (get_kernel_vsid(ea, mmu_kernel_ssize)
-			<< SLB_VSID_SHIFT) | SLB_VSID_KERNEL
-			| (mmu_kernel_ssize == MMU_SEGSIZE_1T ? SLB_VSID_B_1T : 0);
+			 << SLB_VSID_SHIFT) | SLB_VSID_KERNEL;
 		break;
 	case KERNEL_REGION_ID:
 		pr_devel("copro_data_segment: 0x%llx -- KERNEL_REGION_ID\n", ea);
 		psize = mmu_linear_psize;
+		ssize = mmu_kernel_ssize;
 		*vsid = (get_kernel_vsid(ea, mmu_kernel_ssize)
-			<< SLB_VSID_SHIFT) | SLB_VSID_KERNEL
-			| (mmu_kernel_ssize == MMU_SEGSIZE_1T ? SLB_VSID_B_1T : 0);
+			 << SLB_VSID_SHIFT) | SLB_VSID_KERNEL;
 		break;
 	default:
 		/* Future: support kernel segments so that drivers can use the
@@ -133,7 +132,8 @@ int copro_data_segment(struct mm_struct *mm, u64 ea, u64 *esid, u64 *vsid)
 		pr_debug("invalid region access at %016llx\n", ea);
 		return 1;
 	}
-	*vsid |= mmu_psize_defs[psize].sllp;
+	*vsid |= mmu_psize_defs[psize].sllp |
+		(ssize == MMU_SEGSIZE_1T) ? SLB_VSID_B_1T : 0;
 
 	return 0;
 }

