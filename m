Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab3LPM4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 07:56:20 -0500
Received: from smtp.citrix.com ([66.165.176.89]:36660 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753859Ab3LPM4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 07:56:16 -0500
X-IronPort-AV: E=Sophos;i="4.95,494,1384300800"; 
   d="scan'208";a="84884172"
Message-ID: <52AEF86D.808@citrix.com>
Date: Mon, 16 Dec 2013 12:56:13 +0000
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
References: <52A899AB.3010506@citrix.com>	<20131211133917.dd10cb2c4360dba65d8e6ce2@linux-foundation.org>	<52A9B127.9010501@citrix.com> <20131214003208.f99bc37c.akpm@linux-foundation.org>
In-Reply-To: <20131214003208.f99bc37c.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/12/13 08:32, Andrew Morton wrote:
> On Thu, 12 Dec 2013 12:50:47 +0000 David Vrabel <david.vrabel@citrix.com> wrote:
> 
>>> each time.  But that would require difficult tuning of N.
>>>
>>> I suppose we could just do
>>>
>>> 	if (!in_interrupt())
>>> 		cond_resched();
>>>
>>> in vunmap_pmd_range(), but that's pretty specific to ghes.c and doesn't
>>> permit unmap-inside-spinlock.
>>>
>>> So I can't immediately think of a suitable fix apart from adding a new
>>> unmap_kernel_range_atomic().  Then add a `bool atomic' arg to
>>> vunmap_page_range() and pass that all the way down.
>>
>> That would work for the unmap, but looking at the GHES driver some more
>> and it looks like it's call to ioremap_page_range() is already unsafe --
>> it may need to allocate a new PTE page with a non-atomic alloc in
>> pte_alloc_one_kernel().
>>
>> Perhaps what's needed here is a pair of ioremap_page_atomic() and
>> iounmap_page_atomic() calls?  With some prep function to sure the PTE
>> pages (etc.) are preallocated.
> 
> Is ghes.c the only problem source here?  If so then a suitable solution
> would be to declare that driver hopelessly busted and proceed as if it
> didn't exist :(

All the other callers do so from non-atomic context.  ghes.c is the only
broken caller.

Shall I resend or are you happy to take the patch off the first email in
this thread?

David

