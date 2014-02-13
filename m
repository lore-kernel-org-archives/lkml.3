Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaBMWdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 17:33:08 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:40605 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaBMWdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 17:33:05 -0500
MIME-Version: 1.0
In-Reply-To: <20140213140523.099fd03418d8fe1467db3bd9@linux-foundation.org>
References: <20140213215652.22950.12180.stgit@viggo.jf.intel.com>
	<20140213140523.099fd03418d8fe1467db3bd9@linux-foundation.org>
Date: Thu, 13 Feb 2014 14:33:03 -0800
Message-ID: <CAPcyv4jbc5vHpXVcvnT2DoiwYvcQPO9ivAO+zThbw_-YYRyrHA@mail.gmail.com>
Subject: Re: [PATCH regression] dma debug: account for cachelines and
 read-only mappings in overlap tracking
From: Dan Williams <dan.j.williams@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wei Liu <wei.liu2@citrix.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        Francois Romieu <romieu@fr.zoreil.com>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 2:05 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 13 Feb 2014 13:58:00 -0800 Dan Williams <dan.j.williams@intel.com> wrote:
>
>> While debug_dma_assert_idle() checks if a given *page* is actively
>> undergoing dma the valid granularity of a dma mapping is a *cacheline*.
>> Sander's testing shows that the warning message "DMA-API: exceeded 7
>> overlapping mappings of pfn..." is falsely triggering.  The test is
>> simply mapping multiple cachelines in a given page.
>>
>> Ultimately we want overlap tracking to be valid as it is a real api
>> violation, so we need to track active mappings by cachelines.  Update
>> the active dma tracking to use the page-frame-relative cacheline of the
>> mapping as the key, and update debug_dma_assert_idle() to check for all
>> possible mapped cachelines for a given page.
>>
>> However, the need to track active mappings is only relevant when the
>> dma-mapping is writable by the device.  In fact it is fairly standard
>> for read-only mappings to have hundreds or thousands of overlapping
>> mappings at once.  Limiting the overlap tracking to writable
>> (!DMA_TO_DEVICE) eliminates this class of false-positive overlap
>> reports.
>>
>> Note, the radix gang lookup is sub-optimal.  It would be best if it
>> stopped fetching entries once the search passed a page boundary.
>> Nevertheless, this implementation does not perturb the original net_dma
>> failing case.  That is to say the extra overhead does not show up in
>> terms of making the failing case pass due to a timing change.
>>
>> References:
>> http://marc.info/?l=linux-netdev&m=139232263419315&w=2
>> http://marc.info/?l=linux-netdev&m=139217088107122&w=2
>>
>> ...
>>
>> --- a/lib/dma-debug.c
>> +++ b/lib/dma-debug.c
>> @@ -424,111 +424,132 @@ void debug_dma_dump_mappings(struct device *dev)
>>  EXPORT_SYMBOL(debug_dma_dump_mappings);
>>
>>  /*
>> - * For each page mapped (initial page in the case of
>> - * dma_alloc_coherent/dma_map_{single|page}, or each page in a
>> - * scatterlist) insert into this tree using the pfn as the key. At
>> + * For each mapping (initial cacheline in the case of
>> + * dma_alloc_coherent/dma_map_page, initial cacheline in each page of a
>> + * scatterlist, or the cacheline specified in dma_map_single) insert
>> + * into this tree using the cacheline as the key. At
>>   * dma_unmap_{single|sg|page} or dma_free_coherent delete the entry.  If
>> - * the pfn already exists at insertion time add a tag as a reference
>> + * the entry already exists at insertion time add a tag as a reference
>>   * count for the overlapping mappings.  For now, the overlap tracking
>> - * just ensures that 'unmaps' balance 'maps' before marking the pfn
>> - * idle, but we should also be flagging overlaps as an API violation.
>> + * just ensures that 'unmaps' balance 'maps' before marking the
>> + * cacheline idle, but we should also be flagging overlaps as an API
>> + * violation.
>>   *
>>   * Memory usage is mostly constrained by the maximum number of available
>>   * dma-debug entries in that we need a free dma_debug_entry before
>> - * inserting into the tree.  In the case of dma_map_{single|page} and
>> - * dma_alloc_coherent there is only one dma_debug_entry and one pfn to
>> - * track per event.  dma_map_sg(), on the other hand,
>> - * consumes a single dma_debug_entry, but inserts 'nents' entries into
>> - * the tree.
>> + * inserting into the tree.  In the case of dma_map_page and
>> + * dma_alloc_coherent there is only one dma_debug_entry and one
>> + * dma_active_cacheline entry to track per event.  dma_map_sg(), on the
>> + * other hand, consumes a single dma_debug_entry, but inserts 'nents'
>> + * entries into the tree.
>>   *
>>   * At any time debug_dma_assert_idle() can be called to trigger a
>> - * warning if the given page is in the active set.
>> + * warning if any cachelines in the given page are in the active set.
>>   */
>> -static RADIX_TREE(dma_active_pfn, GFP_NOWAIT);
>> +static RADIX_TREE(dma_active_cacheline, GFP_NOWAIT);
>>  static DEFINE_SPINLOCK(radix_lock);
>> -#define ACTIVE_PFN_MAX_OVERLAP ((1 << RADIX_TREE_MAX_TAGS) - 1)
>> +#define ACTIVE_CLN_MAX_OVERLAP ((1 << RADIX_TREE_MAX_TAGS) - 1)
>> +#define CACHELINE_PER_PAGE_SHIFT (PAGE_SHIFT - L1_CACHE_SHIFT)
>> +#define CACHELINES_PER_PAGE (1 << CACHELINE_PER_PAGE_SHIFT)
>>
>> -static int active_pfn_read_overlap(unsigned long pfn)
>> +unsigned long to_cln(struct dma_debug_entry *entry)
>> +{
>> +     return (entry->pfn << CACHELINE_PER_PAGE_SHIFT) +
>> +             (entry->offset >> L1_CACHE_SHIFT);
>> +}
>
> "cln" is ugly and isn't a well-known kernel abbreviation.  We typically
> spell these things out, so "cacheline".  But I think you mean
> "cacheline number", and that is too long to spell out.
>

I do mean cacheline number.

> So I guess "cln" just became a well-known kernel abbreviation.

I can at least make the function names use "cacheline" to give better
context about the local 'cln' variable.

>> ....
>>
>>  void debug_dma_assert_idle(struct page *page)
>>  {
>> +     unsigned long cln = page_to_pfn(page) << CACHELINE_PER_PAGE_SHIFT;
>
> This worries me.  Are you sure we cannot overflow the ulong here under
> any circumstances?  32GB PAE with sparsemem or whatever?

You're right, I can't be sure.  Certainly page_to_pfn() and max_pfn
are unsigned long, but I don't know how much headroom we have to play
with on all memory-models...  so better make a 'cacheline number' be a
phys_addr_t to be safe.

--
Dan
