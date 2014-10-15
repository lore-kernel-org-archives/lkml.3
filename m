Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaJOXHo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 19:07:44 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:53078 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaJOXHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 19:07:43 -0400
MIME-Version: 1.0
In-Reply-To: <20141015130544.380aca0acfcb1413459520b0@linux-foundation.org>
References: <1413403115-1551-1-git-send-email-jamieliu@google.com>
	<20141015130544.380aca0acfcb1413459520b0@linux-foundation.org>
Date: Wed, 15 Oct 2014 16:07:42 -0700
Message-ID: <CAKU+Ga8Onii31qr5OJOrAJt1CPde-0zG703fkxKyJV5ATBkPQQ@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: count only dirty pages as congested
From: Jamie Liu <jamieliu@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Greg Thelen <gthelen@google.com>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wait_iff_congested() only waits if ZONE_CONGESTED is set (and at least
one BDI is still congested). Modulo concurrent changes to BDI
congestion status:

After this change, the probability that a given shrink_inactive_list()
sets ZONE_CONGESTED increases monotonically with the fraction of dirty
pages on the LRU, to 100% if all dirty pages are backed by a
write-congested BDI. This is in line with what appears to intended,
judging by the comment:

/*
* Tag a zone as congested if all the dirty pages scanned were
* backed by a congested BDI and wait_iff_congested will stall.
*/
if (nr_dirty && nr_dirty == nr_congested)
set_bit(ZONE_CONGESTED, &zone->flags);

Before this change, the probability that a given
shrink_inactive_list() sets ZONE_CONGESTED varies erratically. Because
the ZONE_CONGESTED condition is nr_dirty && nr_dirty == nr_congested,
the probability peaks when the fraction of dirty pages is equal to the
fraction of file pages backed by congested BDIs. So under some
circumstances, an increase in the fraction of dirty pages or in the
fraction of congested pages can actually result in an *decreased*
probability that reclaim will stall for writeback congestion, and vice
versa; which is both counterintuitive and counterproductive.

On Wed, Oct 15, 2014 at 1:05 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 15 Oct 2014 12:58:35 -0700 Jamie Liu <jamieliu@google.com> wrote:
>
>> shrink_page_list() counts all pages with a mapping, including clean
>> pages, toward nr_congested if they're on a write-congested BDI.
>> shrink_inactive_list() then sets ZONE_CONGESTED if nr_dirty ==
>> nr_congested. Fix this apples-to-oranges comparison by only counting
>> pages for nr_congested if they count for nr_dirty.
>>
>> ...
>>
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -875,7 +875,8 @@ static unsigned long shrink_page_list(struct list_head *page_list,
>>                * end of the LRU a second time.
>>                */
>>               mapping = page_mapping(page);
>> -             if ((mapping && bdi_write_congested(mapping->backing_dev_info)) ||
>> +             if (((dirty || writeback) && mapping &&
>> +                  bdi_write_congested(mapping->backing_dev_info)) ||
>>                   (writeback && PageReclaim(page)))
>>                       nr_congested++;
>
> What are the observed runtime effects of this change?
