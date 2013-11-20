Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab3KTIMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 03:12:14 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:37233 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750855Ab3KTIMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 03:12:13 -0500
Message-ID: <528C6ED9.3070600@vmware.com>
Date: Wed, 20 Nov 2013 09:12:09 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-graphics-maintainer@vmware.com
Subject: Re: [PATCH RFC 0/3] Add dirty-tracking infrastructure for non-page-backed
 address spaces
References: <1384891576-7851-1-git-send-email-thellstrom@vmware.com> <528BEB60.7040402@amacapital.net>
In-Reply-To: <528BEB60.7040402@amacapital.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 11:51 PM, Andy Lutomirski wrote:
> On 11/19/2013 12:06 PM, Thomas Hellstrom wrote:
>> Hi!
>>
>> Before going any further with this I'd like to check whether this is an
>> acceptable way to go.
>> Background:
>> GPU buffer objects in general and vmware svga GPU buffers in
>> particular are mapped by user-space using MIXEDMAP or PFNMAP. Sometimes the
>> address space is backed by a set of pages, sometimes it's backed by PCI memory.
>> In the latter case in particular, there is no way to track dirty regions
>> using page_mkwrite() and page_mkclean(), other than allocating a bounce
>> buffer and perform dirty tracking on it, and then copy data to the real GPU
>> buffer. This comes with a big memory- and performance overhead.
>>
>> So I'd like to add the following infrastructure with a callback pfn_mkwrite()
>> and a function mkclean_mapping_range(). Typically we will be cleaning a range
>> of ptes rather than random ptes in a vma.
>> This comes with the extra benefit of being usable when the backing memory of
>> the GPU buffer is not coherent with the GPU itself, and where we either need
>> to flush caches or move data to synchronize.
>>
>> So this is a RFC for
>> 1) The API. Is it acceptable? Any other suggestions if not?
>> 2) Modifying apply_to_page_range(). Better to make a standalone
>> non-populating version?
>> 3) tlb- mmu- and cache-flushing calls. I've looked at unmap_mapping_range()
>> and page_mkclean_one() to try to get it right, but still unsure.
> Most (all?) architectures have real dirty tracking -- you can mark a pte
> as "clean" and the hardware (or arch code) will mark it dirty when
> written, *without* a page fault.
>
> I'm not convinced that it works completely correctly right now (I
> suspect that there are some TLB flushing issues on the dirty->clean
> transition), and it's likely prone to bit-rot, since the page cache
> doesn't rely on it.
>
> That being said, using hardware dirty tracking should be *much* faster
> and less latency-inducing than doing it in software like this.  It may
> be worth trying to get HW dirty tracking working before adding more page
> fault-based tracking.
>
> (I think there's also some oddity on S/390.  I don't know what that
> oddity is or whether you should care.)
>
> --Andy

Andy,

Thanks for the tip. It indeed sounds interesting, however there are a 
couple of culprits:

1) As you say, it sounds like there might be TLB flushing issues. Let's 
say the TLB detects a write and raises an IRQ for the arch code to set 
the PTE dirty bit, and before servicing that interrupt, we clear the PTE 
and flush that TLB. What will happen? And if the TLB hardware would 
write directly to the in-memory PTE I guess we'd have the same 
synchronization issues. I guess we'd then need an atomic 
read-modify-write against the TLB hardware?
2) Even if most hardware is capable of this stuff, I'm not sure what 
would happen in a virtual machine. Need to check.
3) For dirty contents that need to appear on a screen within a short 
interval, we need the write notification anyway, to start a delayed task 
that will gather the dirty data and flush it to the screen...

Thanks,
/Thomas
