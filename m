Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbaGUHSS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 03:18:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43068 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946AbaGUHSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 03:18:17 -0400
Message-ID: <53CCBEB4.1050401@suse.cz>
Date: Mon, 21 Jul 2014 09:18:12 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Richard Yao <ryao@gentoo.org>, Johannes Weiner <hannes@cmpxchg.org>
CC: linux-kernel@vger.kernel.org, mthode@mthode.org, kernel@gentoo.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Glauber Costa <glommer@openvz.org>,
        Rik van Riel <riel@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Dave Chinner <dchinner@redhat.com>, open@kvack.org,
        "list@kvack.org:MEMORY MANAGEMENT" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: vmscan: unlock_page page when forcing reclaim
References: <1405698484-25803-1-git-send-email-ryao@gentoo.org> <20140718163843.GK29639@cmpxchg.org> <53C96CBF.4040705@gentoo.org>
In-Reply-To: <53C96CBF.4040705@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2014 08:51 PM, Richard Yao wrote:
> On 07/18/2014 12:38 PM, Johannes Weiner wrote:
>> I don't really understand how the scenario you describe can happen.
>>
>> Successfully reclaiming a page means that __remove_mapping() was able
>> to freeze a page count of 2 (page cache and LRU isolation), but
>> filemap_fault() increases the refcount on the page before trying to
>> lock the page.  If __remove_mapping() wins, find_get_page() does not
>> work and the fault does not lock the page.  If find_get_page() wins,
>> __remove_mapping() does not work and the reclaimer aborts and does a
>> regular unlock_page().
>>
>> page_check_references() is purely about reclaim strategy, it should
>> not be essential for correctness.
>>
>
> You are right that something else is happened here. I had not spotted
> the cmpxchg being done in __remove_mapping(). If I spot something that
> looks like it could be what went wrong doing this, I will propose a new
> fix to the list for review. Thanks for your time.
>
> P.S. The system had ECC RAM, so this was not a bit flip. My current
> method for debugging this involves using cscope to construct possible
> call paths under a couple of assumptions:
>
> 1. Something set PG_locked without calling unlock_page().
> 2. The only ways of doing #1 that I see in the code are calling
> __clear_page_locked() or failing to clear the bit. I do not believe that
> a patch was accepted that did the latter, so I assume the former.

Could it be that the process holding the lock was also stuck doing 
something, and it was not a missed unlock?

> I have root access to the system, so each time I do a lookup using
> cscope, I go through the list to logically eliminate possibilities by
> inspecting the system where the problem occurred. When I cannot
> eliminate a possibility, I recurse. This is prone to fail positives
> should I miss a subtle piece of code that prevents a problem and it is
> very tedious, but I do not see a better way of debugging based on what I
> have at my disposal. If anyone has any suggestions, I would appreciate them.

You could try enabling VM_DEBUG, possibly LOCKDEP, try a git bisect if 
there's a previous known working kernel version...

> P.P.S. I *really* wish that I had used kdump when this issue happened,
> but sadly, the system is not setup for kdump.

So it happened only once so far? How about enabling kdump and waiting if 
it happens again.
