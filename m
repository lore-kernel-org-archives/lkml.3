Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbaEFLwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 07:52:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34406 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757358AbaEFLwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 07:52:05 -0400
Message-ID: <5368CCE2.2050602@suse.cz>
Date: Tue, 06 May 2014 13:52:02 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Greg Thelen <gthelen@google.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch v2 3/4] mm, compaction: add per-zone migration pfn cache
 for async compaction
References: <alpine.DEB.2.02.1404301744110.8415@chino.kir.corp.google.com> <alpine.DEB.2.02.1405011434140.23898@chino.kir.corp.google.com> <alpine.DEB.2.02.1405011435000.23898@chino.kir.corp.google.com> <53675B3A.5090607@suse.cz> <alpine.DEB.2.02.1405050243490.11071@chino.kir.corp.google.com> <53679F16.8020007@suse.cz> <alpine.DEB.2.02.1405051726210.4720@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1405051726210.4720@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 02:29 AM, David Rientjes wrote:
> On Mon, 5 May 2014, Vlastimil Babka wrote:
>
>> I see, although I would still welcome some numbers to back such change.
>
> It's pretty difficult to capture numbers for this in real-world scenarios
> since it happens rarely (and when it happens, it's very significant
> latency) and without an instrumented kernel that will determine how many
> pageblocks have been skipped.  I could create a synthetic example of it in
> the kernel and get numbers for a worst-case scenario with a 64GB zone if
> you'd like, I'm not sure how representative it will be.
>
>> What I still don't like is the removal of the intent of commit 50b5b094e6. You
>> now again call set_pageblock_skip() unconditionally, thus also on pageblocks
>> that async compaction skipped due to being non-MOVABLE. The sync compaction
>> will thus ignore them.
>>
>
> I'm not following you, with this patch there are two cached pfns for the
> migration scanner: one is used for sync and one is used for async.  When
> cc->sync == true, both cached pfns are updated (async is not going to
> succeed for a pageblock when sync failed for that pageblock); when
> cc->sync == false, the async cached pfn is updated only and we pick up
> again where we left off for subsequent async compactions.  Sync compaction
> will still begin where it last left off and consider these non-MOVABLE
> pageblocks.
>

Yeah I understand, the cached pfn's are not the problem. The problem is 
that with your patch, set_pageblock_skip() will be called through 
update_pageblock_skip() in async compaction, since you removed the 
skipped_async_unsuitable variable. So in sync compaction, such pageblock 
will be skipped thanks to the isolation_suitable() check which uses 
get_pageblock_skip() to read the bit set by the async compaction.
