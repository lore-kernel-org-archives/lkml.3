Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbaJBA6G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 20:58:06 -0400
Received: from ozlabs.org ([103.22.144.67]:58660 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbaJBA6E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 20:58:04 -0400
Message-ID: <1412211482.19209.83.camel@ale.ozlabs.ibm.com>
Subject: Re: [PATCH v2 02/17] powerpc/cell: Move data segment faulting code
 out of cell platform
From: Michael Neuling <mikey@neuling.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org, anton@samba.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, jk@ozlabs.org,
        imunsie@au1.ibm.com, cbe-oss-dev@lists.ozlabs.org
Date: Thu, 02 Oct 2014 10:58:02 +1000
In-Reply-To: <87zjdgm7zn.fsf@linux.vnet.ibm.com>
References: <1412073306-13812-1-git-send-email-mikey@neuling.org>
	 <1412073306-13812-3-git-send-email-mikey@neuling.org>
	 <87zjdgm7zn.fsf@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-01 at 15:23 +0530, Aneesh Kumar K.V wrote:
> Michael Neuling <mikey@neuling.org> writes:
> 
> > From: Ian Munsie <imunsie@au1.ibm.com>
> >
> > __spu_trap_data_seg() currently contains code to determine the VSID and ESID
> > required for a particular EA and mm struct.
> >
> > This code is generically useful for other co-processors.  This moves the code
> > of the cell platform so it can be used by other powerpc code.  It also adds 1TB
> > segment handling which Cell didn't have.
> >
> > Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
> > Signed-off-by: Michael Neuling <mikey@neuling.org>
> > ---
> >  arch/powerpc/include/asm/mmu-hash64.h  |  7 ++++-
> >  arch/powerpc/mm/copro_fault.c          | 48 ++++++++++++++++++++++++++++++++++
> >  arch/powerpc/mm/slb.c                  |  3 ---
> >  arch/powerpc/platforms/cell/spu_base.c | 41 +++--------------------------
> >  4 files changed, 58 insertions(+), 41 deletions(-)
> >
> > diff --git a/arch/powerpc/include/asm/mmu-hash64.h b/arch/powerpc/include/asm/mmu-hash64.h
> > index d765144..6d0b7a2 100644
> > --- a/arch/powerpc/include/asm/mmu-hash64.h
> > +++ b/arch/powerpc/include/asm/mmu-hash64.h
> > @@ -189,7 +189,12 @@ static inline unsigned int mmu_psize_to_shift(unsigned int mmu_psize)
> >  #define LP_MASK(i)	((0xFF >> (i)) << LP_SHIFT)
> >  
> >  #ifndef __ASSEMBLY__
> > -
> > +static inline int slb_vsid_shift(int ssize)
> > +{
> > +	if (ssize == MMU_SEGSIZE_256M)
> > +		return SLB_VSID_SHIFT;
> > +	return SLB_VSID_SHIFT_1T;
> > +}
> >  static inline int segment_shift(int ssize)
> >  {
> >  	if (ssize == MMU_SEGSIZE_256M)
> > diff --git a/arch/powerpc/mm/copro_fault.c b/arch/powerpc/mm/copro_fault.c
> > index ba7df14..b865697 100644
> > --- a/arch/powerpc/mm/copro_fault.c
> > +++ b/arch/powerpc/mm/copro_fault.c
> > @@ -90,3 +90,51 @@ out_unlock:
> >  	return ret;
> >  }
> >  EXPORT_SYMBOL_GPL(copro_handle_mm_fault);
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
> > +			 << slb_vsid_shift(ssize)) | SLB_VSID_USER;
> > +		break;
> > +	case VMALLOC_REGION_ID:
> > +		pr_devel("copro_data_segment: 0x%llx -- VMALLOC_REGION_ID\n", ea);
> > +		if (ea < VMALLOC_END)
> > +			psize = mmu_vmalloc_psize;
> > +		else
> > +			psize = mmu_io_psize;
> > +		ssize = mmu_kernel_ssize;
> > +		*vsid = (get_kernel_vsid(ea, mmu_kernel_ssize)
> > +			 << SLB_VSID_SHIFT) | SLB_VSID_KERNEL;
> 
> why not
> 		*vsid = (get_kernel_vsid(ea, mmu_kernel_ssize)
> 			 << slb_vsid_shift(ssize)) | SLB_VSID_KERNEL;
> 
> for vmalloc and kernel region ? We could end up using 1T segments for kernel mapping too.

Yep, but I'm going to do this in patch 10 where the other optimisations
are for this.

Mikey

