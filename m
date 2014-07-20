Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbaGTA20 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 20:28:26 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:54931 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbaGTA2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 20:28:24 -0400
Message-ID: <53CB0D25.1030508@gmail.com>
Date: Sat, 19 Jul 2014 17:28:21 -0700
From: Matthew Rushton <mvrushton@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: boris.ostrovsky@oracle.com, david.vrabel@citrix.com, msw@amazon.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Matt Rushton <mrushton@amazon.com>
Subject: Re: [PATCH] xen/setup: Remap Xen Identity Mapped RAM
References: <1401993794-27084-1-git-send-email-mrushton@amazon.com> <20140610143055.GA31059@laptop.dumpdata.com> <53BA5FBE.1020401@gmail.com> <20140708155713.GD2863@laptop.dumpdata.com>
In-Reply-To: <20140708155713.GD2863@laptop.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/14 08:57, Konrad Rzeszutek Wilk wrote:
> Responding :-)
>>
>> @@ -797,10 +794,9 @@ unsigned long __init set_phys_range_identity(unsigned long pfn_s,
>>   		if (!__set_phys_to_machine(pfn, IDENTITY_FRAME(pfn)))
>>   			break;
>> -	if (!WARN((pfn - pfn_s) != (pfn_e - pfn_s),
>> +	WARN((pfn - pfn_s) != (pfn_e - pfn_s),
>>   		"Identity mapping failed. We are %ld short of 1-1 mappings!\n",
>> -		(pfn_e - pfn_s) - (pfn - pfn_s)))
>> -		printk(KERN_DEBUG "1-1 mapping on %lx->%lx\n", pfn_s, pfn);
>> +		(pfn_e - pfn_s) - (pfn - pfn_s));
>>> I would leave that as is. If you really want to modify it - spin another
>>> patch for it.
>> The problem is because we now call set_phys_range_identity() on small blocks
>> the number of these messages printed is large. I can split it out to a
>> separate patch if you'd like.
> Please do. Also you would have to rebase all this code on the latest Linus's
> tree as there are some changes there.

I posted a v2 which split this patch out, addressed feedback and rebased 
on Linus's tree.


>>>>   	return pfn - pfn_s;
>>>>   }
>>>> diff --git a/arch/x86/xen/p2m.h b/arch/x86/xen/p2m.h
>>>> new file mode 100644
>>>> index 0000000..9ce4d51
>>>> --- /dev/null
>>>> +++ b/arch/x86/xen/p2m.h
>>>> @@ -0,0 +1,15 @@
>>>> +#ifndef _XEN_P2M_H
>>>> +#define _XEM_P2M_H
>>>> +
>>>> +#define P2M_PER_PAGE        (PAGE_SIZE / sizeof(unsigned long))
>>>> +#define P2M_MID_PER_PAGE    (PAGE_SIZE / sizeof(unsigned long *))
>>>> +#define P2M_TOP_PER_PAGE    (PAGE_SIZE / sizeof(unsigned long **))
>>>> +
>>>> +#define MAX_P2M_PFN         (P2M_TOP_PER_PAGE * P2M_MID_PER_PAGE * P2M_PER_PAGE)
>>>> +
>>>> +#define MAX_REMAP_RANGES    10
>>> Could you mention why 10 please?
>> 10 is simply what I thought a reasonable max could ever be for the number of
>> remapped ranges. A range here is defined as the combination of a contiguous
>> e820 I/O range and a contiguous e820 RAM range where the underlying I/O
>> memory will be remapped. I'm not really excited about this but I don't have
>> a better solution. Any ideas? I believe the original implementation has a
>> similar issue that it appears to ignore.
> Is that based on a worst case scenario? As in could you write in the comment
> an example of a worst case E820 and scenario and when would 10 be more than
> enough to cover it?
>

I changed reserved brk space slightly in my updated patch. Really 
MAX_REMAP_RANGES in the worst case should be E820MAX. That seems like an 
unrealistic worst case though and a lot of space to reserve. I'm fairly 
certain the existing code also has a similar worst case which it doesn't 
take into account. It currently seems to assume there is only one E820 
I/O region that will be identity mapped? I think it works because in 
practice we don't come close to the worst case. I'm still not sure how 
to best handle this.

>>>> +	mod = remap_pfn % P2M_PER_PAGE;
>>>> +	remap_start_pfn_align =
>>>> +		mod ? (remap_pfn - mod + P2M_PER_PAGE):remap_pfn;
>>>> +	mod = (start_pfn + size) % P2M_PER_PAGE;
>>>> +	ident_end_pfn_align = start_pfn + size - mod;
>>>> +	mod = (remap_pfn + size) % P2M_PER_PAGE;
>>>> +	remap_end_pfn_align = remap_pfn + size - mod;
>>> Should you do a check to make sure that 'ident_[start|end]_pfn_align'
>>> don't overlap with 'remap_[start|end]_pfn_align' ?
>>>
>>>> +
>>>> +	/* Iterate over each p2m leaf node in each range */
>>>> +	for (ident_pfn_iter = ident_start_pfn_align, remap_pfn_iter = remap_start_pfn_align;
>>>> +	     ident_pfn_iter < ident_end_pfn_align && remap_pfn_iter < remap_end_pfn_align;
>>>> +	     ident_pfn_iter += P2M_PER_PAGE, remap_pfn_iter += P2M_PER_PAGE) {
>>>> +		/* Check we aren't past the end */
>>>> +		BUG_ON(ident_pfn_iter + P2M_PER_PAGE > start_pfn + size);
>>>> +		BUG_ON(remap_pfn_iter + P2M_PER_PAGE > remap_pfn + size);
>>> Ah, here you check for it. But wouldn't it be easier to adjust the
>>> remap_[start|end]_pfn_align above to check for this and make changes?
>> The ident_* and remap_* address ranges will never overlap each other unless
>> the e820 map is broken. I'm treating both ranges as independent and
> Right.
>> iterating over each seperately at the same time. Each range will have
>> different boundary conditions potentially. Does that make sense? Am I
>> understanding the comment correctly?
> I was thinking that if the E820 is broken then try our best (and stop
> trying to remap) and continue. The E820 is guaranteed to be sane (no
> overlapping regions), but the sizes could be bogus (zero size for example).

I think the current code does handle the zero case ok.

>>>> +
>>>> +		/* Save p2m mappings */
>>>> +		for (i = 0; i < P2M_PER_PAGE; i++)
>>>> +			xen_remap_buf[i] = pfn_to_mfn(ident_pfn_iter + i);
>>>> +
>>>> +		/* Set identity map which also frees a p2m leaf */
>>>                                                 ^- might
>> Under what conditions is this not true? The goal of processing these in
>> blocks is to guarantee that a leaf is freed.
> Perhaps change it 'also frees' to 'MUST free'
> and then have (debug code) to double-check that Naturally
> after calling the early_set_phys_identity?
>
> 	for (i = 0; i < P2M_PER_PAGE; i++) {
> 		unsigned int pfn = ident_pfn_iter + i;
> 		BUG_ON(pfn_to_mfn(pfn) != INVALID_P2M_ENTRY)
> ?
I added a debug check. It must check for the identity page and not 
INVALID_P2M_ENTRY however.

>>>> +		ident_cnt += set_phys_range_identity(ident_pfn_iter,
>>>> +			ident_pfn_iter + P2M_PER_PAGE);
>>>> +
>>>> +		/* Now remap memory */
>>>> +		for (i = 0; i < P2M_PER_PAGE; i++) {
>>>> +			unsigned long mfn = xen_remap_buf[i];
>>>> +			struct mmu_update update = {
>>>> +				.ptr = (mfn << PAGE_SHIFT) |
>>>> +					MMU_MACHPHYS_UPDATE,
>>>> +				.val = remap_pfn_iter + i
>>>> +			};
>>>> +
>>>> +			/* Update p2m, will use the page freed above */
>>> What page freed above?
>> See above comment.
> Perhaps 'use the page free above' with 'use the P2M leaf freed above'.
ACK


