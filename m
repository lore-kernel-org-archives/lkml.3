Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbaACUS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 15:18:56 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:19697 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaACUSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 15:18:55 -0500
Message-ID: <52C71ACC.20603@oracle.com>
Date: Fri, 03 Jan 2014 15:17:16 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: Vlastimil Babka <vbabka@suse.cz>, Michel Lespinasse <walken@google.com>,
        Bob Liu <bob.liu@oracle.com>, npiggin@suse.de,
        kosaki.motohiro@jp.fujitsu.com, riel@redhat.com,
        David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] mm/mlock: fix BUG_ON unlocked page for nolinear VMAs
References: <1387267550-8689-1-git-send-email-liwanp@linux.vnet.ibm.com>	<52b1138b.0201430a.19a8.605dSMTPIN_ADDED_BROKEN@mx.google.com>	<20131218032329.GA6044@hacker.(null)>	<52B11765.8030005@oracle.com>	<52b120a5.a3b2440a.3acf.ffffd7c3SMTPIN_ADDED_BROKEN@mx.google.com>	<52B166CF.6080300@suse.cz>	<52b1699f.87293c0a.75d1.34d3SMTPIN_ADDED_BROKEN@mx.google.com> <20131218134316.977d5049209d9278e1dad225@linux-foundation.org>
In-Reply-To: <20131218134316.977d5049209d9278e1dad225@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 04:43 PM, Andrew Morton wrote:
> On Wed, 18 Dec 2013 17:23:03 +0800 Wanpeng Li <liwanp@linux.vnet.ibm.com> wrote:
>
>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>> index 55c8b8d..1e24813 100644
>>>> --- a/mm/rmap.c
>>>> +++ b/mm/rmap.c
>>>> @@ -1347,6 +1347,7 @@ static int try_to_unmap_cluster(unsigned long cursor, unsigned int *mapcount,
>>>>   	unsigned long end;
>>>>   	int ret = SWAP_AGAIN;
>>>>   	int locked_vma = 0;
>>>> +	int we_locked = 0;
>>>>
>>>>   	address = (vma->vm_start + cursor) & CLUSTER_MASK;
>>>>   	end = address + CLUSTER_SIZE;
>>>> @@ -1385,9 +1386,15 @@ static int try_to_unmap_cluster(unsigned long cursor, unsigned int *mapcount,
>>>>   		BUG_ON(!page || PageAnon(page));
>>>>
>>>>   		if (locked_vma) {
>>>> -			mlock_vma_page(page);   /* no-op if already mlocked */
>>>> -			if (page == check_page)
>>>> +			if (page != check_page) {
>>>> +				we_locked = trylock_page(page);
>>>
>>> If it's not us who has the page already locked, but somebody else, he
>>> might unlock it at this point and then the BUG_ON in mlock_vma_page()
>>> will trigger again.
>
> yes, this patch is pretty weak.
>
>> Any better idea is appreciated. ;-)
>
> Remove the BUG_ON() from mlock_vma_page()?  Why was it added?
> isolate_lru_page() and putback_lru_page() and *might* require
> the page be locked, but I don't immediately see issues?

Ping? This BUG() is triggerable in 3.13-rc6 right now.


Thanks,
Sasha

