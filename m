Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbaIXPWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:22:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40406 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874AbaIXPWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:22:34 -0400
Message-ID: <5422E1B8.9000100@suse.cz>
Date: Wed, 24 Sep 2014 17:22:32 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [RFC] mm: show deferred_compaction state in page alloc fail
References: <1409038219-21483-1-git-send-email-minchan@kernel.org>
In-Reply-To: <1409038219-21483-1-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2014 09:30 AM, Minchan Kim wrote:
> Recently, I saw several reports that high order allocation failed
> although there were many freeable pages but it's hard to reproduce
> so asking them to reproduce the problem several time is really painful.
>
> A culprit I doubt is compaction deferring logic which prevent
> compaction for a while so high order allocation could be fail.

Could be that, but also the non-determinism of watermark checking, where 
compaction thinks allocation should succeed, but in the end it won't.

> It would be more clear if we can see the stat which can show
> current zone's compaction deferred state when allocatil fail.
>
> It's a RFC and never test it. I just get an idea with
> handling another strange high order allocation fail.
> Any comments are welcome.

It's quite large patch. Maybe it could be much simpler if you did not 
print just true/false but:

1) true/false based on zone->compact_considered < defer_limit, ignoring
    zone->compact_order_failed

2) zone->compact_order_failed value itself

Then you wouldn't need to pass the allocation order around like you do.
The "allocation failed" message tells you the order which was attempted, 
and then it's easy for the user to compare with the reported
zone->compact_order_failed and decide if the defer status actually 
applies or not.


