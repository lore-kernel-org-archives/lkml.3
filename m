Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbaG2Jby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:31:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40168 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722AbaG2Jbw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:31:52 -0400
Message-ID: <53D76A07.3000104@suse.cz>
Date: Tue, 29 Jul 2014 11:31:51 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm:;
Subject: Re: [PATCH v5 06/14] mm, compaction: reduce zone checking frequency
 in the migration scanner
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz> <1406553101-29326-7-git-send-email-vbabka@suse.cz> <alpine.DEB.2.02.1407281742580.8998@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1407281742580.8998@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2014 02:44 AM, David Rientjes wrote:
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Minchan Kim <minchan@kernel.org>
>> Acked-by: Mel Gorman <mgorman@suse.de>
>> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>> Cc: Michal Nazarewicz <mina86@mina86.com>
>> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
>> Cc: Christoph Lameter <cl@linux.com>
>> Cc: Rik van Riel <riel@redhat.com>
>> Cc: David Rientjes <rientjes@google.com>
>
> Acked-by: David Rientjes <rientjes@google.com>
>
> Minor comments below.

Thanks,

>> +/*
>> + * Check that the whole (or subset of) a pageblock given by the interval of
>> + * [start_pfn, end_pfn) is valid and within the same zone, before scanning it
>> + * with the migration of free compaction scanner. The scanners then need to
>> + * use only pfn_valid_within() check for arches that allow holes within
>> + * pageblocks.
>> + *
>> + * Return struct page pointer of start_pfn, or NULL if checks were not passed.
>> + *
>> + * It's possible on some configurations to have a setup like node0 node1 node0
>> + * i.e. it's possible that all pages within a zones range of pages do not
>> + * belong to a single zone. We assume that a border between node0 and node1
>> + * can occur within a single pageblock, but not a node0 node1 node0
>> + * interleaving within a single pageblock. It is therefore sufficient to check
>> + * the first and last page of a pageblock and avoid checking each individual
>> + * page in a pageblock.
>> + */
>> +static struct page *pageblock_within_zone(unsigned long start_pfn,
>> +				unsigned long end_pfn, struct zone *zone)
>
> The name of this function is quite strange, it's returning a pointer to
> the actual start page but the name implies it would be a boolean.

Yeah but I couldn't think of a better name that wouldn't be long and ugly :(

>> +{
>> +	struct page *start_page;
>> +	struct page *end_page;
>> +
>> +	/* end_pfn is one past the range we are checking */
>> +	end_pfn--;
>> +
>
> With the given implementation, yes, but I'm not sure if that should be
> assumed for any class of callers.  It seems better to call with
> end_pfn - 1.

Well, I think the rest of compaction functions assume one-past-end 
parameters so this would make it an exception. Better hide the exception 
in the implementation and not expose it to callers?

>> +	if (!pfn_valid(start_pfn) || !pfn_valid(end_pfn))
>> +		return NULL;
>> +
>
> Ok, so even with this check, we still need to check pfn_valid_within() for
> all pfns between start_pfn and end_pfn if there are memory holes.  I
> checked that both the migration and freeing scanners do that before
> reading your comment above the function, looks good.

Yeah, and thankfully pfn_valid_within() is a no-op on many archs :)


