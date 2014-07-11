Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbaGKPmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 11:42:40 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:64270 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaGKPmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 11:42:38 -0400
Date: Fri, 11 Jul 2014 11:42:32 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: Oded Gabbay <oded.gabbay@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Airlie <airlied@linux.ie>,
        Alex Deucher <alexander.deucher@amd.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, linux-mm <linux-mm@kvack.org>,
        Oded Gabbay <oded.gabbay@amd.com>, Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Peter Zijlstra <peterz@infradead.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH 01/83] mm: Add kfd_process pointer to mm_struct
Message-ID: <20140711154231.GB1870@gmail.com>
References: <1405028848-5660-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405028848-5660-1-git-send-email-oded.gabbay@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 12:47:26AM +0300, Oded Gabbay wrote:
> This patch enables the KFD to retrieve the kfd_process
> object from the process's mm_struct. This is needed because kfd_process
> lifespan is bound to the process's mm_struct lifespan.
> 
> When KFD is notified about an mm_struct tear-down, it checks if the
> kfd_process pointer is valid. If so, it releases the kfd_process object
> and all relevant resources.
> 
> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
> ---
>  include/linux/mm_types.h | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 678097c..6179107 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -20,6 +20,10 @@
>  struct hmm;
>  #endif
>  
> +#ifdef CONFIG_HSA_RADEON
> +struct kfd_process;
> +#endif
> +
>  #ifndef AT_VECTOR_SIZE_ARCH
>  #define AT_VECTOR_SIZE_ARCH 0
>  #endif
> @@ -439,6 +443,16 @@ struct mm_struct {
>  	 */
>  	struct hmm *hmm;
>  #endif
> +#if defined(CONFIG_HSA_RADEON) || defined(CONFIG_HSA_RADEON_MODULE)
> +	/*
> +	 * kfd always register an mmu_notifier we rely on mmu notifier to keep
> +	 * refcount on mm struct as well as forbiding registering kfd on a
> +	 * dying mm
> +	 *
> +	 * This field is set with mmap_sem old in write mode.
> +	 */
> +	struct kfd_process *kfd_process;
> +#endif

I understand the need to bind kfd to mm life time but this is wrong
on several level. First we do not want per driver define flag here.
Second this should be a IOMMU/PASID pointer of some sort, i am sure
that Intel will want to add itself too to mm_struct so instead of
having each IOMMU add a pointer here, i would rather see a generic
pointer to a generic IOMMU struct and have this use generic IOMMU
code that can then call specific user dispatch function.

I know this add a layer but this is not a critical code path and
should never be.

I am adding Jesse as he might have thought on that.

So this one is NAK

Cheers,
Jérôme

>  #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && !USE_SPLIT_PMD_PTLOCKS
>  	pgtable_t pmd_huge_pte; /* protected by page_table_lock */
>  #endif
> -- 
> 1.9.1
> 
