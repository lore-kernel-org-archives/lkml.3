Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933594AbaGQOM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:12:28 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:41763 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139AbaGQOM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:12:26 -0400
Date: Thu, 17 Jul 2014 10:12:18 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: David Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Bridgman <John.Bridgman@amd.com>, Joerg Roedel <joro@8bytes.org>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Christian =?iso-8859-1?Q?K=F6nig?= <deathsimple@vodafone.de>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel.daenzer@amd.com>,
        Ben Goz <Ben.Goz@amd.com>, Alexey Skidanov <Alexey.Skidanov@amd.com>,
        Evgeny Pinchuk <Evgeny.Pinchuk@amd.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH v2 01/25] mm: Add kfd_process pointer to mm_struct
Message-ID: <20140717141216.GA1963@gmail.com>
References: <1405603773-32688-1-git-send-email-oded.gabbay@amd.com>
 <53C7D666.6000405@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53C7D666.6000405@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 04:57:58PM +0300, Oded Gabbay wrote:
> Forgot to add mm mailing list. Sorry.
> 
> This patch enables the amdkfd driver to retrieve the kfd_process
> object from the process's mm_struct. This is needed because kfd_process
> lifespan is bound to the process's mm_struct lifespan.
> 
> When amdkfd is notified about an mm_struct tear-down, it checks if the
> kfd_process pointer is valid. If so, it releases the kfd_process object
> and all relevant resources.
> 
> In v3 of the patchset I will update the binding to match the final discussions
> on [PATCH 1/8] mmput: use notifier chain to call subsystem exit handler.
> In the meantime, I'm going to try and see if I can drop the kfd_process
> in mm_struct and remove the use of the new notification chain in mmput.
> Instead, I will try to use the mmu release notifier.

So the mmput notifier chain will not happen. I did a patch with call_srcu
and adding couple more helper to mmu_notifier. I will send that today for
review.

That being said, adding a device driver specific to mm_struct will most
likely be a big no. I am myself gonna remove hmm from mm_struct as people
are reluctant to see such change.

Cheers,
Jérôme


> 
> Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
> ---
>  include/linux/mm_types.h | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 678097c..ff71496 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -20,6 +20,10 @@
>  struct hmm;
>  #endif
>  +#if defined(CONFIG_HSA_RADEON) || defined(CONFIG_HSA_RADEON_MODULE)
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
>  #if defined(CONFIG_TRANSPARENT_HUGEPAGE) && !USE_SPLIT_PMD_PTLOCKS
>  	pgtable_t pmd_huge_pte; /* protected by page_table_lock */
>  #endif
> -- 
> 1.9.1
> 
