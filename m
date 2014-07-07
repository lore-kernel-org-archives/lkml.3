Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbaGGIwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 04:52:21 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:43691 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaGGIwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 04:52:18 -0400
Message-ID: <53BA5FBE.1020401@gmail.com>
Date: Mon, 07 Jul 2014 01:52:14 -0700
From: Matthew Rushton <mvrushton@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: boris.ostrovsky@oracle.com, david.vrabel@citrix.com, msw@amazon.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        Matt Rushton <mrushton@amazon.com>
Subject: Re: [PATCH] xen/setup: Remap Xen Identity Mapped RAM
References: <1401993794-27084-1-git-send-email-mrushton@amazon.com> <20140610143055.GA31059@laptop.dumpdata.com>
In-Reply-To: <20140610143055.GA31059@laptop.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/14 07:30, Konrad Rzeszutek Wilk wrote:
> On Thu, Jun 05, 2014 at 11:43:14AM -0700, Matt Rushton wrote:
>> Instead of ballooning up and down dom0 memory this remaps the existing mfns
>> that were replaced by the identity map. The reason for this is that the
>> existing implementation ballooned memory up and and down which caused dom0
>> to have discontiguous pages. In some cases this resulted in the use of bounce
>> buffers which reduced network I/O performance by up to 15%. This change will
>> honor the existing order of the pages with the exception of some boundary
>> conditions.
>>
>> To do this we need to update both the Linux p2m table and the Xen m2p table.
>> Particular care must be taken when updating the p2m table since it's important
>> to limit table memory consumption and reuse the existing leaf pages which get
>> freed when an entire leaf page is set to the identity map. To implement this,
>> mapping updates are grouped into blocks with table entries getting cached
>> temporarily and then released.
> Thank you for taking a stab at this!
>
> This must have been a head-ache of debugging and getting it just right.

Just saw these comments, sorry it took me a bit. Yes, it was a little 
more tricky than the Xen one liner:)

Note: resending

>
>> On my test system before:
>> Total pages: 2105014
>> Total contiguous: 1640635
>>
>> After:
>> Total pages: 2105014
>> Total contiguous: 2098904
>>
>> Signed-off-by: Matthew Rushton <mrushton@amazon.com>
>> ---
>>   arch/x86/xen/p2m.c   |   20 ++-
>>   arch/x86/xen/p2m.h   |   15 ++
>>   arch/x86/xen/setup.c |  378 ++++++++++++++++++++++++++++++++++++++------------
>>   3 files changed, 311 insertions(+), 102 deletions(-)
>>   create mode 100644 arch/x86/xen/p2m.h
>>
>> diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
>> index 85e5d78..a753fc4 100644
>> --- a/arch/x86/xen/p2m.c
>> +++ b/arch/x86/xen/p2m.c
>> @@ -164,6 +164,7 @@
>>   #include <xen/balloon.h>
>>   #include <xen/grant_table.h>
>>   
>> +#include "p2m.h"
>>   #include "multicalls.h"
>>   #include "xen-ops.h"
>>   
>> @@ -171,12 +172,6 @@ static void __init m2p_override_init(void);
>>   
>>   unsigned long xen_max_p2m_pfn __read_mostly;
>>   
>> -#define P2M_PER_PAGE		(PAGE_SIZE / sizeof(unsigned long))
>> -#define P2M_MID_PER_PAGE	(PAGE_SIZE / sizeof(unsigned long *))
>> -#define P2M_TOP_PER_PAGE	(PAGE_SIZE / sizeof(unsigned long **))
>> -
>> -#define MAX_P2M_PFN		(P2M_TOP_PER_PAGE * P2M_MID_PER_PAGE * P2M_PER_PAGE)
>> -
>>   /* Placeholders for holes in the address space */
>>   static RESERVE_BRK_ARRAY(unsigned long, p2m_missing, P2M_PER_PAGE);
>>   static RESERVE_BRK_ARRAY(unsigned long *, p2m_mid_missing, P2M_MID_PER_PAGE);
>> @@ -191,9 +186,11 @@ static RESERVE_BRK_ARRAY(unsigned long, p2m_identity, P2M_PER_PAGE);
>>   RESERVE_BRK(p2m_mid, PAGE_SIZE * (MAX_DOMAIN_PAGES / (P2M_PER_PAGE * P2M_MID_PER_PAGE)));
>>   RESERVE_BRK(p2m_mid_mfn, PAGE_SIZE * (MAX_DOMAIN_PAGES / (P2M_PER_PAGE * P2M_MID_PER_PAGE)));
>>   
>> -/* We might hit two boundary violations at the start and end, at max each
>> - * boundary violation will require three middle nodes. */
>> -RESERVE_BRK(p2m_mid_identity, PAGE_SIZE * 2 * 3);
>> +/* We may lose up to three pages due to boundary violations for each pfn range
>> + * we identity map. We use a reasonable default to define the max number of
>> + * these ranges that are possible.
>> + */
>> +RESERVE_BRK(p2m_mid_identity, PAGE_SIZE * 3 * MAX_REMAP_RANGES);
>>   
>>   /* When we populate back during bootup, the amount of pages can vary. The
>>    * max we have is seen is 395979, but that does not mean it can't be more.
>> @@ -797,10 +794,9 @@ unsigned long __init set_phys_range_identity(unsigned long pfn_s,
>>   		if (!__set_phys_to_machine(pfn, IDENTITY_FRAME(pfn)))
>>   			break;
>>   
>> -	if (!WARN((pfn - pfn_s) != (pfn_e - pfn_s),
>> +	WARN((pfn - pfn_s) != (pfn_e - pfn_s),
>>   		"Identity mapping failed. We are %ld short of 1-1 mappings!\n",
>> -		(pfn_e - pfn_s) - (pfn - pfn_s)))
>> -		printk(KERN_DEBUG "1-1 mapping on %lx->%lx\n", pfn_s, pfn);
>> +		(pfn_e - pfn_s) - (pfn - pfn_s));
> I would leave that as is. If you really want to modify it - spin another
> patch for it.

The problem is because we now call set_phys_range_identity() on small 
blocks the number of these messages printed is large. I can split it out 
to a separate patch if you'd like.

>>   
>>   	return pfn - pfn_s;
>>   }
>> diff --git a/arch/x86/xen/p2m.h b/arch/x86/xen/p2m.h
>> new file mode 100644
>> index 0000000..9ce4d51
>> --- /dev/null
>> +++ b/arch/x86/xen/p2m.h
>> @@ -0,0 +1,15 @@
>> +#ifndef _XEN_P2M_H
>> +#define _XEM_P2M_H
>> +
>> +#define P2M_PER_PAGE        (PAGE_SIZE / sizeof(unsigned long))
>> +#define P2M_MID_PER_PAGE    (PAGE_SIZE / sizeof(unsigned long *))
>> +#define P2M_TOP_PER_PAGE    (PAGE_SIZE / sizeof(unsigned long **))
>> +
>> +#define MAX_P2M_PFN         (P2M_TOP_PER_PAGE * P2M_MID_PER_PAGE * P2M_PER_PAGE)
>> +
>> +#define MAX_REMAP_RANGES    10
> Could you mention why 10 please?

10 is simply what I thought a reasonable max could ever be for the 
number of remapped ranges. A range here is defined as the combination of 
a contiguous e820 I/O range and a contiguous e820 RAM range where the 
underlying I/O memory will be remapped. I'm not really excited about 
this but I don't have a better solution. Any ideas? I believe the 
original implementation has a similar issue that it appears to ignore.

>> +
>> +extern unsigned long __init set_phys_range_identity(unsigned long pfn_s,
>> +                                      unsigned long pfn_e);
>> +
>> +#endif  /* _XEN_P2M_H */
>> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
>> index 0982233..25e7d87 100644
>> --- a/arch/x86/xen/setup.c
>> +++ b/arch/x86/xen/setup.c
>> @@ -30,6 +30,7 @@
>>   #include "mmu.h"
>>   #include "xen-ops.h"
>>   #include "vdso.h"
>> +#include "p2m.h"
>>   
>>   /* These are code, but not functions.  Defined in entry.S */
>>   extern const char xen_hypervisor_callback[];
>> @@ -47,6 +48,9 @@ struct xen_memory_region xen_extra_mem[XEN_EXTRA_MEM_MAX_REGIONS] __initdata;
>>   /* Number of pages released from the initial allocation. */
>>   unsigned long xen_released_pages;
>>   
>> +/* Buffer used to remap identity mapped pages */
>> +unsigned long xen_remap_buf[P2M_PER_PAGE] __initdata;
>> +
>>   /*
>>    * The maximum amount of extra memory compared to the base size.  The
>>    * main scaling factor is the size of struct page.  At extreme ratios
>> @@ -156,120 +160,311 @@ static unsigned long __init xen_do_chunk(unsigned long start,
>>   	return len;
>>   }
>>   
>> -static unsigned long __init xen_release_chunk(unsigned long start,
>> -					      unsigned long end)
>> -{
>> -	/*
>> -	 * Xen already ballooned out the E820 non RAM regions for us
>> -	 * and set them up properly in EPT.
>> -	 */
>> -	if (xen_feature(XENFEAT_auto_translated_physmap))
>> -		return end - start;
>> -
>> -	return xen_do_chunk(start, end, true);
>> -}
>> -
>> -static unsigned long __init xen_populate_chunk(
>> +/*
>> + * Finds the next pfn available in the E820 map after min_pfn.
> 'next RAM pfn'

ACK

>> + * This function updates min_pfn with the pfn found and returns
>> + * the size of that range or zero if not found.
>> + */
>> +static unsigned long __init xen_find_pfn_range(
>>   	const struct e820entry *list, size_t map_size,
>> -	unsigned long max_pfn, unsigned long *last_pfn,
>> -	unsigned long credits_left)
>> +	unsigned long *min_pfn)
>>   {
>>   	const struct e820entry *entry;
>>   	unsigned int i;
>>   	unsigned long done = 0;
>> -	unsigned long dest_pfn;
>>   
>>   	for (i = 0, entry = list; i < map_size; i++, entry++) {
>>   		unsigned long s_pfn;
>>   		unsigned long e_pfn;
>> -		unsigned long pfns;
>> -		long capacity;
>> -
>> -		if (credits_left <= 0)
>> -			break;
>>   
>>   		if (entry->type != E820_RAM)
>>   			continue;
>>   
>>   		e_pfn = PFN_DOWN(entry->addr + entry->size);
>>   
>> -		/* We only care about E820 after the xen_start_info->nr_pages */
>> -		if (e_pfn <= max_pfn)
>> +		/* We only care about E820 after this */
>> +		if (e_pfn < *min_pfn)
>>   			continue;
>>   
>>   		s_pfn = PFN_UP(entry->addr);
>> -		/* If the E820 falls within the nr_pages, we want to start
>> -		 * at the nr_pages PFN.
>> -		 * If that would mean going past the E820 entry, skip it
>> +
>> +		/* If min_pfn falls within the E820 entry, we want to start
>> +		 * at the min_pfn PFN.
>>   		 */
>> -		if (s_pfn <= max_pfn) {
>> -			capacity = e_pfn - max_pfn;
>> -			dest_pfn = max_pfn;
>> +		if (s_pfn <= *min_pfn) {
>> +			done = e_pfn - *min_pfn;
>>   		} else {
>> -			capacity = e_pfn - s_pfn;
>> -			dest_pfn = s_pfn;
>> +			done = e_pfn - s_pfn;
>> +			*min_pfn = s_pfn;
>>   		}
>> -
>> -		if (credits_left < capacity)
>> -			capacity = credits_left;
>> -
>> -		pfns = xen_do_chunk(dest_pfn, dest_pfn + capacity, false);
>> -		done += pfns;
>> -		*last_pfn = (dest_pfn + pfns);
>> -		if (pfns < capacity)
>> -			break;
>> -		credits_left -= pfns;
>> +		break;
>>   	}
>> +
>>   	return done;
>>   }
>>   
>> -static void __init xen_set_identity_and_release_chunk(
>> -	unsigned long start_pfn, unsigned long end_pfn, unsigned long nr_pages,
>> -	unsigned long *released, unsigned long *identity)
>> +/*
>> + * This releases a chunk of memory and then does the identity map. It's used as
>> + * as a fallback if the remapping fails.
>> + */
>> +static void __init xen_set_identity_and_release_chunk(unsigned long start_pfn,
>> +	unsigned long end_pfn, unsigned long nr_pages, unsigned long *identity,
>> +	unsigned long *released)
>>   {
>> -	unsigned long pfn;
>> +	WARN_ON(start_pfn > end_pfn);
>> +
>> +	/* Need to release pages first */
>> +	*released += xen_do_chunk(start_pfn, min(end_pfn, nr_pages), true);
>> +	*identity += set_phys_range_identity(start_pfn, end_pfn);
>> +}
>> +
>> +/*
>> + * This function updates the p2m and m2p tables with an identity map from
>> + * start_pfn to start_pfn+size and remaps the underlying RAM of the original
>> + * allocation at remap_pfn. It must do so carefully in P2M_PER_PAGE sized blocks
>> + * to not exhaust the reserved brk space. Doing it in properly aligned blocks
>> + * ensures we only allocate the minimum required leaf pages in the p2m table. It
>> + * copies the existing mfns from the p2m table under the 1:1 map, overwrites
>> + * them with the identity map and then updates the p2m and m2p tables with the
>> + * remapped memory.
>> + */
>> +static unsigned long __init xen_do_set_identity_and_remap_chunk(
>> +        unsigned long start_pfn, unsigned long size, unsigned long remap_pfn)
>> +{
>> +	unsigned long ident_pfn_iter, remap_pfn_iter;
>> +	unsigned long ident_start_pfn_align, remap_start_pfn_align;
>> +	unsigned long ident_end_pfn_align, remap_end_pfn_align;
>> +	unsigned long ident_boundary_pfn, remap_boundary_pfn;
>> +	unsigned long ident_cnt = 0;
>> +	unsigned long remap_cnt = 0;
>> +	unsigned long left = size;
>> +	unsigned long mod;
>> +	int i;
>> +
>> +	WARN_ON(size == 0);
>> +
>> +	BUG_ON(xen_feature(XENFEAT_auto_translated_physmap));
>>   
>>   	/*
>> -	 * If the PFNs are currently mapped, clear the mappings
>> -	 * (except for the ISA region which must be 1:1 mapped) to
>> -	 * release the refcounts (in Xen) on the original frames.
>> -	 */
>> +	 * Determine the proper alignment to remap memory in P2M_PER_PAGE sized
>> +	 * blocks. We need to keep track of both the existing pfn mapping and
>> +	 * the new pfn remapping.
>> + 	 */
>> +	mod = start_pfn % P2M_PER_PAGE;
>> +	ident_start_pfn_align =
>> +		mod ? (start_pfn - mod + P2M_PER_PAGE):start_pfn;
>                                                       ^^ - space between the ':' please

ACK

>
>> +	mod = remap_pfn % P2M_PER_PAGE;
>> +	remap_start_pfn_align =
>> +		mod ? (remap_pfn - mod + P2M_PER_PAGE):remap_pfn;
>> +	mod = (start_pfn + size) % P2M_PER_PAGE;
>> +	ident_end_pfn_align = start_pfn + size - mod;
>> +	mod = (remap_pfn + size) % P2M_PER_PAGE;
>> +	remap_end_pfn_align = remap_pfn + size - mod;
> Should you do a check to make sure that 'ident_[start|end]_pfn_align'
> don't overlap with 'remap_[start|end]_pfn_align' ?
>
>> +
>> +	/* Iterate over each p2m leaf node in each range */
>> +	for (ident_pfn_iter = ident_start_pfn_align, remap_pfn_iter = remap_start_pfn_align;
>> +	     ident_pfn_iter < ident_end_pfn_align && remap_pfn_iter < remap_end_pfn_align;
>> +	     ident_pfn_iter += P2M_PER_PAGE, remap_pfn_iter += P2M_PER_PAGE) {
>> +		/* Check we aren't past the end */
>> +		BUG_ON(ident_pfn_iter + P2M_PER_PAGE > start_pfn + size);
>> +		BUG_ON(remap_pfn_iter + P2M_PER_PAGE > remap_pfn + size);
> Ah, here you check for it. But wouldn't it be easier to adjust the
> remap_[start|end]_pfn_align above to check for this and make changes?

The ident_* and remap_* address ranges will never overlap each other 
unless the e820 map is broken. I'm treating both ranges as independent 
and iterating over each seperately at the same time. Each range will 
have different boundary conditions potentially. Does that make sense? Am 
I understanding the comment correctly?

>
>> +
>> +		/* Save p2m mappings */
>> +		for (i = 0; i < P2M_PER_PAGE; i++)
>> +			xen_remap_buf[i] = pfn_to_mfn(ident_pfn_iter + i);
>> +
>> +		/* Set identity map which also frees a p2m leaf */
>                                                 ^- might

Under what conditions is this not true? The goal of processing these in 
blocks is to guarantee that a leaf is freed.

>> +		ident_cnt += set_phys_range_identity(ident_pfn_iter,
>> +			ident_pfn_iter + P2M_PER_PAGE);
>> +
>> +		/* Now remap memory */
>> +		for (i = 0; i < P2M_PER_PAGE; i++) {
>> +			unsigned long mfn = xen_remap_buf[i];
>> +			struct mmu_update update = {
>> +				.ptr = (mfn << PAGE_SHIFT) |
>> +					MMU_MACHPHYS_UPDATE,
>> +				.val = remap_pfn_iter + i
>> +			};
>> +
>> +			/* Update p2m, will use the page freed above */
> What page freed above?

See above comment.

>
>> +			if (!early_set_phys_to_machine(remap_pfn_iter + i,
>> +				mfn)) {
> Please  make it more than 80 lines for this line.

ACK

>
>> +				WARN(1, "Failed to set p2m mapping for pfn=%ld mfn=%ld\n",
>> +					remap_pfn_iter + i, mfn);
>> +				return 0;
>> +			}
>> +
>> +			/* Update m2p */
>> +			if (HYPERVISOR_mmu_update(&update, 1, NULL,
>> +			    DOMID_SELF) < 0) {
> Ditto, 80 lines is Ok here.

ACK

>> +				WARN(1, "Failed to set m2p mapping for mfn=%ld pfn=%ld\n",
>> +					mfn, remap_pfn_iter + i);
>> +				return 0;
>> +			}
>> +			remap_cnt++;
>> +		}
>> +
>> +		left -= P2M_PER_PAGE;
>> +	}
>> +
>> +	/* Max boundary space possible */
>> +	BUG_ON(left > (P2M_PER_PAGE - 1) * 2);
>> +
>> +	/* Now handle the boundary conditions */
>> +	ident_boundary_pfn = start_pfn;
>> +	remap_boundary_pfn = remap_pfn;
>> +	for (i = 0; i < left; i++) {
>> +		unsigned long mfn;
>> +		struct mmu_update update;
>> +
>> +		if (ident_boundary_pfn == ident_start_pfn_align)
>> +			ident_boundary_pfn = ident_pfn_iter;
>> +		if (remap_boundary_pfn == remap_start_pfn_align)
>> +			remap_boundary_pfn = remap_pfn_iter;
> Could you add a comment above explaining that these are for the cases
> where there are no boundary on the start part. Maybe even a little
> ASCII picture (asciiflow.com)?

ACK

>> +
>> +		/* Check we aren't past the end */
>> +		BUG_ON(ident_boundary_pfn >= start_pfn + size);
>> +		BUG_ON(remap_boundary_pfn >= remap_pfn + size);
>> +
>> +		mfn = pfn_to_mfn(ident_boundary_pfn);
>> +		update.ptr = (mfn << PAGE_SHIFT) | MMU_MACHPHYS_UPDATE;
>> +		update.val = remap_boundary_pfn;
>> +
>> +		/* Update p2m */
>> +		if (!early_set_phys_to_machine(remap_boundary_pfn, mfn)) {
>> +			WARN(1, "Failed to set p2m mapping for pfn=%ld mfn=%ld\n",
>> +				remap_pfn_iter + i, mfn);
>> +			return 0;
>> +		}
>> +
>> +		/* Update m2p */
>> +		if (HYPERVISOR_mmu_update(&update, 1, NULL, DOMID_SELF) < 0) {
>> +			WARN(1, "Failed to set m2p mapping for mfn=%ld pfn=%ld\n",
>> +				mfn, remap_pfn_iter + i);
>> +			return 0;
>> +		}
> Those two calls were done in the loop above as well. Could these be in a function?

I think so, that makes sense.

>
>> +		remap_cnt++;
>> +
>> +		ident_boundary_pfn++;
>> +		remap_boundary_pfn++;
>> +	}
>>   
>>   	/*
>> -	 * PVH E820 matches the hypervisor's P2M which means we need to
>> -	 * account for the proper values of *release and *identity.
>> +	 * Finish up the identity map. We need to check if there are zero, one
>> +	 * or two boundaries.
> Why do we need to check it? (Please mention that in the comment)

The comment should be made more clear. There's a special case we need to 
check for which is that there were no blocks remapped above which means 
everything needs to be identity mapped here. If we didn't check this we 
might remap too many pages since the align boundaries are not meaningful 
in this case.

>>   	 */
>> -	for (pfn = start_pfn; !xen_feature(XENFEAT_auto_translated_physmap) &&
>> -	     pfn <= max_pfn_mapped && pfn < end_pfn; pfn++) {
>> -		pte_t pte = __pte_ma(0);
>> +	if (ident_start_pfn_align >= ident_end_pfn_align) {
>> +		/* Not remapped above, one boundary case */
> Could you describe this case a bit more in detail? I fear that in
> six months when looking at this code I will have a hard time trying
> to understand that. A little comment or even a picture could help.

See above. It can happen when we have entire identity ranges that do not 
span aligned blocks. Because we align the end down and start up, if they 
are equal or if start > end we know we have hit this special case.

>
>> +		ident_cnt += set_phys_range_identity(start_pfn,
>> +			start_pfn + size);
>> +	} else {
>> +		/* Remapped above so check each end of the chunk */
>> +		if (start_pfn < ident_start_pfn_align)
>> +			ident_cnt += set_phys_range_identity(start_pfn,
>> +				ident_start_pfn_align);
>> +		if (start_pfn + size > ident_pfn_iter)
>> +			ident_cnt += set_phys_range_identity(ident_pfn_iter,
>> +				start_pfn + size);
>> +	}
>>   
>> -		if (pfn < PFN_UP(ISA_END_ADDRESS))
>> -			pte = mfn_pte(pfn, PAGE_KERNEL_IO);
>> +	BUG_ON(ident_cnt != size);
>> +	BUG_ON(remap_cnt != size);
>>   
>> -		(void)HYPERVISOR_update_va_mapping(
>> -			(unsigned long)__va(pfn << PAGE_SHIFT), pte, 0);
>> +	return size;
>> +}
>> +
>> +/*
>> + * This function takes a contiguous pfn range that needs to be identity mapped
>> + * and:
>> + *
>> + *  1) Finds a new range of pfns to use to remap based on E820 and remap_pfn.
>> + *  2) Calls the do_ function to actually do the mapping/remapping work.
>> + *
>> + * The goal is to not allocate additional memory but to remap the existing
>> + * pages. In the case of an error the underlying memory is simply released back
>> + * to Xen and not remapped.
>> + */
>> +static unsigned long __init xen_set_identity_and_remap_chunk(
>> +        const struct e820entry *list, size_t map_size, unsigned long start_pfn,
>> +	unsigned long end_pfn, unsigned long nr_pages, unsigned long remap_pfn,
>> +	unsigned long *identity, unsigned long *remapped,
>> +	unsigned long *released)
>> +{
>> +	unsigned long pfn;
>> +	unsigned long i = 0;
>> +	unsigned long n = end_pfn - start_pfn;
>> +
>> +	while (i < n) {
>> +		unsigned long cur_pfn = start_pfn + i;
>> +		unsigned long size = n - i;
>> +		unsigned long remap_range_size;
>> +
>> +		/* Do not remap pages beyond the current allocation */
>> +		if (cur_pfn >= nr_pages) {
>> +			/* Identity map remaining pages */
>> +			*identity += set_phys_range_identity(cur_pfn,
>> +				cur_pfn + size);
> Uh, is that OK for balloon pages? I am wondering how that is going
> to interact with the latest changes that David Vrabel did to the P2M.
>
> Hm, his changes changed the default mechanism of P2M for unknown
> regions returning the identity values instead of INVALID_P2M. So that
> seems this is OK then.

OK

>> +			break;
>> +		}
>> +		remap_range_size = xen_find_pfn_range(list, map_size,
>> +			&remap_pfn);
>> +		if (!remap_range_size) {
>> +			pr_warning("Unable to find available pfn range, not remapping identity pages\n");
>> +			xen_set_identity_and_release_chunk(cur_pfn,
>> +				cur_pfn + size, nr_pages, identity, released);
> We don't need to adjust the 'nr_pages' to account cur_pfn?
>
> Hm, should this be more of:
>
> 			xen_set_identity_and_release_chunk(cur_pfn,
> 				cur_pfn + size - i, nr_pages - i, identity, released);
>
> so that we don't set these pages _past_ this region?

I think this one is correct. nr_pages is meant to pass through as is, to 
only release pages we have been allocated. While on the subject of error 
handling we could get rid of some code if the error path simply set the 
identity and did not release it back.

>> +			break;
>> +		}
>> +		if (size > remap_range_size)
> That needs a comment. Of why it would happen.

Yup, it can happen if we can't find a large enough contiguous e820 RAM 
region to remap the the memory to. If not we need to break it into 
multiple passes.

>> +			size = remap_range_size;
>> +
>> +		/* Again do not remap pages beyond the original allocation */
>> +		if (cur_pfn + size > nr_pages)
>> +			size = nr_pages - cur_pfn;
> Perhaps this check should be riht before the 'if (!remap_range_size)' ?

That makes sense as part of the cleanup, see below.

>
>> +
>> +		if (!xen_do_set_identity_and_remap_chunk(cur_pfn, size,
>> +		    remap_pfn)) {
> You can make this more than 80 characters.

ACK

>
>> +			WARN(1, "Failed to remap 1:1 memory cur_pfn=%ld size=%ld remap_pfn=%ld\n",
>> +				cur_pfn, size, remap_pfn);
>> +			xen_set_identity_and_release_chunk(cur_pfn,
>> +				cur_pfn + size, nr_pages, identity, released);
> So 'size' has been properly dealt with, but I think 'nr_pages' might still
> need 'nr_pages - i'?
>

This error path is wrong because size can get changed. I will fix this 
and clean this code up.

>> +			break;
>> +		}
>> +
>> +		/* Update variables to reflect new mappings. */
>> +		i += size;
>> +		remap_pfn += size;
>> +		*identity += size;
>> +		*remapped += size;
>>   	}
>>   
>> -	if (start_pfn < nr_pages)
>> -		*released += xen_release_chunk(
>> -			start_pfn, min(end_pfn, nr_pages));
>> +	/*
>> +	 * If the PFNs are currently mapped, the VA mapping also needs
>> +	 * to be updated to be 1:1.
>> +	 */
>> +	for (pfn = start_pfn; pfn <= max_pfn_mapped && pfn < end_pfn; pfn++)
>> +		(void)HYPERVISOR_update_va_mapping(
>> +			(unsigned long)__va(pfn << PAGE_SHIFT),
>> +			mfn_pte(pfn, PAGE_KERNEL_IO), 0);
>>   
>> -	*identity += set_phys_range_identity(start_pfn, end_pfn);
>> +	return remap_pfn;
>>   }
>>   
>> -static unsigned long __init xen_set_identity_and_release(
>> -	const struct e820entry *list, size_t map_size, unsigned long nr_pages)
>> +static unsigned long __init xen_set_identity_and_remap(
>> +	const struct e820entry *list, size_t map_size, unsigned long nr_pages,
>> +	unsigned long *released)
>>   {
>>   	phys_addr_t start = 0;
>> -	unsigned long released = 0;
>>   	unsigned long identity = 0;
>> +	unsigned long remapped = 0;
>> +	unsigned long last_pfn = nr_pages;
>>   	const struct e820entry *entry;
>> +	unsigned long num_released = 0;
>>   	int i;
>>   
>>   	/*
>>   	 * Combine non-RAM regions and gaps until a RAM region (or the
>>   	 * end of the map) is reached, then set the 1:1 map and
>> -	 * release the pages (if available) in those non-RAM regions.
>> +	 * remap the memory in those non-RAM regions.
>>   	 *
>>   	 * The combined non-RAM regions are rounded to a whole number
>>   	 * of pages so any partial pages are accessible via the 1:1
>> @@ -287,22 +482,24 @@ static unsigned long __init xen_set_identity_and_release(
>>   				end_pfn = PFN_UP(entry->addr);
>>   
>>   			if (start_pfn < end_pfn)
>> -				xen_set_identity_and_release_chunk(
>> -					start_pfn, end_pfn, nr_pages,
>> -					&released, &identity);
>> -
>> +				last_pfn = xen_set_identity_and_remap_chunk(
>> +						list, map_size, start_pfn,
>> +						end_pfn, nr_pages, last_pfn,
>> +						&identity, &remapped,
>> +						&num_released);
>>   			start = end;
>>   		}
>>   	}
>>   
>> -	if (released)
>> -		printk(KERN_INFO "Released %lu pages of unused memory\n", released);
>> -	if (identity)
>> -		printk(KERN_INFO "Set %ld page(s) to 1-1 mapping\n", identity);
>> +	*released = num_released;
>>   
>> -	return released;
>> -}
>> +	pr_info("Set %ld page(s) to 1-1 mapping\n", identity);
>> +	pr_info("Remapped %ld page(s), last_pfn=%ld\n", remapped,
>> +		last_pfn);
>> +	pr_info("Released %ld page(s)\n", num_released);
>>   
>> +	return last_pfn;
>> +}
>>   static unsigned long __init xen_get_max_pages(void)
>>   {
>>   	unsigned long max_pages = MAX_DOMAIN_PAGES;
>> @@ -410,26 +607,27 @@ char * __init xen_memory_setup(void)
>>   		extra_pages += max_pages - max_pfn;
>>   
>>   	/*
>> -	 * Set P2M for all non-RAM pages and E820 gaps to be identity
>> -	 * type PFNs.  Any RAM pages that would be made inaccesible by
>> -	 * this are first released.
>> +	 * Set identity map on non-RAM pages and remap the underlying RAM. If
>> +	 * auto-translating we simply skip this as Xen has already released the
>> +	 * E820 non-RAM memory for us. We no longer allocate additional memory
>> +	 * in this case.
>>   	 */
>> -	xen_released_pages = xen_set_identity_and_release(
>> -		map, memmap.nr_entries, max_pfn);
>> -
>> -	/*
>> -	 * Populate back the non-RAM pages and E820 gaps that had been
>> -	 * released. */
>> -	populated = xen_populate_chunk(map, memmap.nr_entries,
>> -			max_pfn, &last_pfn, xen_released_pages);
>> +	if (!xen_feature(XENFEAT_auto_translated_physmap))
>> +		last_pfn = xen_set_identity_and_remap(map, memmap.nr_entries,
>> +			max_pfn, &xen_released_pages);
>>   
>> -	xen_released_pages -= populated;
>>   	extra_pages += xen_released_pages;
>>   
>>   	if (last_pfn > max_pfn) {
>> -		max_pfn = min(MAX_DOMAIN_PAGES, last_pfn);
>> +		if (last_pfn > MAX_DOMAIN_PAGES) {
>> +			pr_warning("Not using full RAM allocation, check CONFIG_MAX_DOMAIN_PAGES");
>> +			max_pfn = MAX_DOMAIN_PAGES;
>> +		} else {
>> +			max_pfn = last_pfn;
>> +		}
> I think that check and message should be a seperate patch. It should
> probably be sent as is without being part of this patch.

OK makes sense

>>   		mem_end = PFN_PHYS(max_pfn);
>>   	}
>> +
> Not needed.

ACK

>>   	/*
>>   	 * Clamp the amount of extra memory to a EXTRA_MEM_RATIO
>>   	 * factor the base size.  On non-highmem systems, the base
>> -- 
>> 1.7.9.5
>>

