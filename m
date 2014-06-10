Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085AbaFJH00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 03:26:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51054 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbaFJH0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 03:26:23 -0400
Message-ID: <5396B31B.6080706@suse.cz>
Date: Tue, 10 Jun 2014 09:26:19 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [RFC PATCH 4/6] mm, compaction: skip buddy pages by their order
 in the migrate scanner
References: <alpine.DEB.2.02.1405211954410.13243@chino.kir.corp.google.com> <1401898310-14525-1-git-send-email-vbabka@suse.cz> <1401898310-14525-4-git-send-email-vbabka@suse.cz> <alpine.DEB.2.02.1406041656400.22536@chino.kir.corp.google.com> <5390374E.5080708@suse.cz> <alpine.DEB.2.02.1406051428360.18119@chino.kir.corp.google.com> <53916BB0.3070001@suse.cz> <alpine.DEB.2.02.1406090207300.24247@chino.kir.corp.google.com> <53959C11.2000305@suse.cz> <alpine.DEB.2.02.1406091512540.5271@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1406091512540.5271@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2014 12:25 AM, David Rientjes wrote:
> On Mon, 9 Jun 2014, Vlastimil Babka wrote:
>
>>>>> Sorry, I meant ACCESS_ONCE(page_private(page)) in the migration scanner
>>>>
>>>> Hm but that's breaking the abstraction of page_order(). I don't know if
>>>> it's
>>>> worse to create a new variant of page_order() or to do this. BTW, seems
>>>> like
>>>> next_active_pageblock() in memory-hotplug.c should use this variant too.
>>>>
>>>
>>> The compiler seems free to disregard the access of a volatile object above
>>> because the return value of the inline function is unsigned long.  What's
>>> the difference between unsigned long order = page_order_unsafe(page) and
>>> unsigned long order = (unsigned long)ACCESS_ONCE(page_private(page)) and
>>
>> I think there's none functionally, but one is abstraction layer violation and
>> the other imply the context of usage as you say (but is that so uncommon?).
>>
>>> the compiler being able to reaccess page_private() because the result is
>>> no longer volatile qualified?
>>
>> You think it will reaccess? That would defeat all current ACCESS_ONCE usages,
>> no?
>>
>
> I think the compiler is allowed to turn this into
>
> 	if (ACCESS_ONCE(page_private(page)) > 0 &&
> 	    ACCESS_ONCE(page_private(page)) < MAX_ORDER)
> 		low_pfn += (1UL << ACCESS_ONCE(page_private(page))) - 1;
>
> since the inline function has a return value of unsigned long but gcc may
> not do this.  I think
>
> 	/*
> 	 * Big fat comment describing why we're using ACCESS_ONCE(), that
> 	 * we're ok to race, and that this is meaningful only because of
> 	 * the previous PageBuddy() check.
> 	 */
> 	unsigned long pageblock_order = ACCESS_ONCE(page_private(page));
>
> is better.

I've talked about it with a gcc guy and (although he didn't actually see 
the code so it might be due to me not explaining it perfectly), the 
compiler will inline page_order_unsafe() so that there's effectively.

unsigned long freepage_order = ACCESS_ONCE(page_private(page));

and now it cannot just replace all freepage_order occurences with new 
page_private() accesses. So thanks to the inlining, the volatile 
qualification propagates to where it matters. It makes sense to me, but 
if it's according to standard or gcc specific, I don't know.


