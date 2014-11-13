Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbaKMGXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 01:23:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54138 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044AbaKMGXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 01:23:09 -0500
Message-ID: <54644E48.3040506@suse.com>
Date: Thu, 13 Nov 2014 07:23:04 +0100
From: Juergen Gross <jgross@suse.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [PATCH V3 2/8] xen: Delay remapping memory of pv-domain
References: <1415684626-18590-1-git-send-email-jgross@suse.com> <1415684626-18590-3-git-send-email-jgross@suse.com> <20141112214506.GA5922@laptop.dumpdata.com>
In-Reply-To: <20141112214506.GA5922@laptop.dumpdata.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2014 10:45 PM, Konrad Rzeszutek Wilk wrote:
> On Tue, Nov 11, 2014 at 06:43:40AM +0100, Juergen Gross wrote:
>> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
>> index a8a1a3d..d3e492b 100644
>> --- a/arch/x86/xen/mmu.c
>> +++ b/arch/x86/xen/mmu.c
>> @@ -1223,6 +1223,10 @@ static void __init xen_pagetable_init(void)
>>   	/* Allocate and initialize top and mid mfn levels for p2m structure */
>>   	xen_build_mfn_list_list();
>>
>> +	/* Remap memory freed because of conflicts with E820 map */
>
> s/becasue of/due to

Okay.

>>   	/* Boundary cross-over for the edges: */
>> -	p2m = extend_brk(PAGE_SIZE, PAGE_SIZE);
>> +	p2m = alloc_p2m_page();
>>
>>   	p2m_init(p2m);
>>
>> @@ -640,7 +651,7 @@ static bool __init early_alloc_p2m_middle(unsigned long pfn)
>>
>>   	mid = p2m_top[topidx];
>>   	if (mid == p2m_mid_missing) {
>> -		mid = extend_brk(PAGE_SIZE, PAGE_SIZE);
>> +		mid = alloc_p2m_page();
>>
>>   		p2m_mid_init(mid, p2m_missing);
>>
>> @@ -649,100 +660,6 @@ static bool __init early_alloc_p2m_middle(unsigned long pfn)
>>   	return true;
>>   }
>>
>
> I would split this patch in two - one for the extend_brk/alloc_page conversation
> to alloc_p2m_page and free_page to free_p2m_page.

Okay.

>> -/* Buffer used to remap identity mapped pages */
>> -unsigned long xen_remap_buf[P2M_PER_PAGE] __initdata;
>> +/*
>> + * Buffer used to remap identity mapped pages. We only need the virtual space.
>
> Could you expand on the 'need the virtual space'?

I'll update the comment to:

/*
  * Buffer used to remap identity mapped pages. We only need the virtual
  * space. The physical page behind this address is remapped as needed to
  * different buffer pages.
  */

>
>
> .. snip..
>>   /*
>>    * This function updates the p2m and m2p tables with an identity map from
>> - * start_pfn to start_pfn+size and remaps the underlying RAM of the original
>> - * allocation at remap_pfn. It must do so carefully in P2M_PER_PAGE sized blocks
>> - * to not exhaust the reserved brk space. Doing it in properly aligned blocks
>> - * ensures we only allocate the minimum required leaf pages in the p2m table. It
>> - * copies the existing mfns from the p2m table under the 1:1 map, overwrites
>> - * them with the identity map and then updates the p2m and m2p tables with the
>> - * remapped memory.
>> + * start_pfn to start_pfn+size and prepares remapping the underlying RAM of the
>> + * original allocation at remap_pfn. The information needed for remapping is
>> + * saved in the memory itself to avoid the need for allocating buffers. The
>> + * complete remap information is contained in a list of MFNs each containing
>> + * up to REMAP_SIZE MFNs and the start target PFN for doing the remap.
>> + * This enables to preserve the original mfn sequence while doing the remapping
>
> us to

Yep.

>> + * at a time when the memory management is capable of allocating virtual and
>> + * physical memory in arbitrary amounts.
>
> You might want to add, see 'xen_remap_memory' and its callers.

Okay.

>> -		/* These two checks move from the start to end boundaries */
>> -		if (ident_boundary_pfn == ident_start_pfn_align)
>> -			ident_boundary_pfn = ident_pfn_iter;
>> -		if (remap_boundary_pfn == remap_start_pfn_align)
>> -			remap_boundary_pfn = remap_pfn_iter;
>> +		/* Map first pfn to xen_remap_buf */
>> +		mfn = pfn_to_mfn(ident_pfn_iter);
>> +		set_pte_mfn(buf, mfn, PAGE_KERNEL);
>
> So you set the buf to be point to 'mfn'.

Correct.

>>
>> -		/* Check we aren't past the end */
>> -		BUG_ON(ident_boundary_pfn >= start_pfn + size);
>> -		BUG_ON(remap_boundary_pfn >= remap_pfn + size);
>> +		/* Save mapping information in page */
>> +		xen_remap_buf.next_area_mfn = xen_remap_mfn;
>> +		xen_remap_buf.target_pfn = remap_pfn_iter;
>> +		xen_remap_buf.size = chunk;
>> +		for (i = 0; i < chunk; i++)
>> +			xen_remap_buf.mfns[i] = pfn_to_mfn(ident_pfn_iter + i);
>>
>> -		mfn = pfn_to_mfn(ident_boundary_pfn);
>> +		/* New element first in list */
>
> I don't get that comment. Don't you mean the MFN of the last chunk you
> had stashed the 'xen_remap_buf' structure in?
>
> The 'xen_remap_mfn' ends up being the the tail value of this
> "list".

I'll redo the comment:

/* Put remap buf into list. */

>> +/*
>> + * Remap the memory prepared in xen_do_set_identity_and_remap_chunk().
>> + */
>> +void __init xen_remap_memory(void)
>> +{
>> +	unsigned long buf = (unsigned long)&xen_remap_buf;
>> +	unsigned long mfn_save, mfn, pfn;
>> +	unsigned long remapped = 0, released = 0;
>> +	unsigned int i, free;
>> +	unsigned long pfn_s = ~0UL;
>> +	unsigned long len = 0;
>> +
>> +	mfn_save = virt_to_mfn(buf);
>> +
>> +	while (xen_remap_mfn != INVALID_P2M_ENTRY) {
>
> So the 'list' is constructed by going forward - that is from low-numbered
> PFNs to higher numbered ones. But the 'xen_remap_mfn' is going the
> other way - from the highest PFN to the lowest PFN.
>
> Won't that mean we will restore the chunks of memory in the wrong
> order? That is we will still restore them in chunks size, but the
> chunks will be in descending order instead of ascending?

No, the information where to put each chunk is contained in the chunk
data. I can add a comment explaining this.

>
>> +		/* Map the remap information */
>> +		set_pte_mfn(buf, xen_remap_mfn, PAGE_KERNEL);
>> +
>> +		BUG_ON(xen_remap_mfn != xen_remap_buf.mfns[0]);
>> +
>> +		free = 0;
>> +		pfn = xen_remap_buf.target_pfn;
>> +		for (i = 0; i < xen_remap_buf.size; i++) {
>> +			mfn = xen_remap_buf.mfns[i];
>> +			if (!released && xen_update_mem_tables(pfn, mfn)) {
>> +				remapped++;
>
> If we fail 'xen_update_mem_tables' we will on the next chunk (so i+1) keep on
> freeing pages instead of trying to remap. Is that intentional? Could we
> try to remap?

Hmm, I'm not sure this is worth the effort. What could lead to failure
here? I suspect we could even just BUG() on failure. What do you think?


Juergen

