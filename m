Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761Ab3LLMuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 07:50:52 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:16596 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab3LLMut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 07:50:49 -0500
X-IronPort-AV: E=Sophos;i="4.93,878,1378857600"; 
   d="scan'208";a="81309829"
Message-ID: <52A9B127.9010501@citrix.com>
Date: Thu, 12 Dec 2013 12:50:47 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        <linux-acpi@vger.kernel.org>,
        xen-devel <xen-devel@lists.xenproject.org>,
        Dietmar Hahn <dietmar.hahn@ts.fujitsu.com>
Subject: Re: vunmap() on large regions may trigger soft lockup warnings
References: <52A899AB.3010506@citrix.com> <20131211133917.dd10cb2c4360dba65d8e6ce2@linux-foundation.org>
In-Reply-To: <20131211133917.dd10cb2c4360dba65d8e6ce2@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/13 21:39, Andrew Morton wrote:
> On Wed, 11 Dec 2013 16:58:19 +0000 David Vrabel <david.vrabel@citrix.com> wrote:
> 
>> Andrew,
>>
>> Dietmar Hahn reported an issue where calling vunmap() on a large (50 GB)
>> region would trigger soft lockup warnings.
>>
>> The following patch would resolve this (by adding a cond_resched() call
>> to vunmap_pmd_range()). Almost calls of vunmap(), unmap_kernel_range()
>> are from process context (as far as I could tell) except for an ACPI
>> driver (drivers/acpi/apei/ghes.c) calls unmap_kernel_range_noflush()
>> from an interrupt and NMI contexts.
>>
>> Can you advise on a preferred solution?
>>
>> For example, an unmap_kernel_page() function (callable from atomic
>> context) could be provided since the GHES driver only maps/unmaps a
>> single page.
>>
>> 8<-------------------------
>> mm/vmalloc: avoid soft lockup warnings when vunmap()'ing large ranges
>>
>> From: David Vrabel <david.vrabel@citrix.com>
>>
>> If vunmap() is used to unmap a large (e.g., 50 GB) region, it may take
>> sufficiently long that it triggers soft lockup warnings.
>>
>> Add a cond_resched() into vunmap_pmd_range() so the calling task may
>> be resheduled after unmapping each PMD entry.  This is how
>> zap_pmd_range() fixes the same problem for userspace mappings.
>>
>> ...
>>
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -75,6 +75,7 @@ static void vunmap_pmd_range(pud_t *pud, unsigned long
>> addr, unsigned long end)
>>  		if (pmd_none_or_clear_bad(pmd))
>>  			continue;
>>  		vunmap_pte_range(pmd, addr, next);
>> +		cond_resched();
>>  	} while (pmd++, addr = next, addr != end);
>>  }
> 
> Well that's ugly.
> 
> We could redo unmap_kernel_range() so it takes an `atomic' flag then
> loops around unmapping N MB at a time, doing
> 
> 	if (!atomic)
> 		cond_resched()
> 
> each time.  But that would require difficult tuning of N.
> 
> I suppose we could just do
> 
> 	if (!in_interrupt())
> 		cond_resched();
> 
> in vunmap_pmd_range(), but that's pretty specific to ghes.c and doesn't
> permit unmap-inside-spinlock.
> 
> So I can't immediately think of a suitable fix apart from adding a new
> unmap_kernel_range_atomic().  Then add a `bool atomic' arg to
> vunmap_page_range() and pass that all the way down.

That would work for the unmap, but looking at the GHES driver some more
and it looks like it's call to ioremap_page_range() is already unsafe --
it may need to allocate a new PTE page with a non-atomic alloc in
pte_alloc_one_kernel().

Perhaps what's needed here is a pair of ioremap_page_atomic() and
iounmap_page_atomic() calls?  With some prep function to sure the PTE
pages (etc.) are preallocated.

David
