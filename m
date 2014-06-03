Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933661AbaFCUdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:33:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:42396 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbaFCUdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:33:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,968,1392192000"; 
   d="scan'208";a="551073622"
Message-ID: <538E3101.6030900@intel.com>
Date: Tue, 03 Jun 2014 13:33:05 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH -mm] mincore: apply page table walker on do_mincore()
 (Re: [PATCH 00/10] mm: pagewalk: huge page cleanups and VMA passing)
References: <20140602213644.925A26D0@viggo.jf.intel.com> <1401745925-l651h3s9@n-horiguchi@ah.jp.nec.com> <538CF25E.8070905@sr71.net> <1401776292-dn0fof8e@n-horiguchi@ah.jp.nec.com> <538DEFD8.4050506@intel.com> <1401825676-8py0r32h@n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1401825676-8py0r32h@n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2014 01:01 PM, Naoya Horiguchi wrote:
> On Tue, Jun 03, 2014 at 08:55:04AM -0700, Dave Hansen wrote:
>> On 06/02/2014 11:18 PM, Naoya Horiguchi wrote:
>>> And for patch 8, 9, and 10, I don't think it's good idea to add a new callback
>>> which can handle both pmd and pte (because they are essentially differnt thing).
>>> But the underneath idea of doing pmd_trans_huge_lock() in the common code in
>>> walk_single_entry_locked() looks nice to me. So it would be great if we can do
>>> the same thing in walk_pmd_range() (of linux-mm) to reduce code in callbacks.
>>
>> You think they are different, I think they're the same. :)
>>
>> What the walkers *really* care about is getting a leaf node in the page
>> tables.  They generally don't *care* whether it is a pmd or pte, they
>> just want to know what its value is and how large it is.
> 
> OK, I see your idea, so I think that we could go to the direction to
> unify all p(gd|ud|md|te)_entry() callbacks.
> And if we find the leaf entry in whatever level, we call the common entry
> handler on the entry, right?

That's a level farther than I took it, but I think it makes sense.
Nobody is using the walkers for the purposes of looking at anything but
leaf nodes.

> It would takes some time and effort to make all users to fit to this new
> scheme, so my suggestion is:
>  1. move pmd locking to walk_pmd_range() (then, your locked_single_entry()
>     callback is equal to pmd_entry())

Yes, except that still means that each walker needs separate code for
regular _and_ transparent huge pages.  It would be nice to be able to
have a single handler which handles both.

>  2. let each existing user have its common entry handler, and connect it to
>     its pmd_entry() and/or pte_entry() to keep compatibility
>  3. apply page table walker to potential users.
>     I'd like to keep pmd/pte_entry() until we complete phase 2.,
>     because we could find something which let us change core code,
>  4. and finaly replace all p(gd|ud|md|te)_entry() with a unified callback.
> 
> Could you let me have a few days to work on 1.?
> I think that it means your patch 8 is effectively merged on top of mine.
> So your current problem will be solved.

That sounds quite nice.

>> I'd argue that they don't really ever need to actually know at which
>> level they are in the page tables, just if they are at the bottom or
>> not.  Note that *NOBODY* sets a pud or pgd entry.  That's because the
>> walkers are 100% concerned about leaf nodes (pte's) at this point.
> 
> Yes. BTW do you think we should pud_entry() and pgd_entry() immediately?
> We can do it and it reduces some trivial evaluations, so it's optimized
> a little.

Yeah, we might as well.  They're just wasted space at the moment.


