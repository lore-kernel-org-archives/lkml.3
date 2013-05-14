Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518Ab3ENVJN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 17:09:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757962Ab3ENVJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 17:09:11 -0400
Message-ID: <5192A76E.6010509@redhat.com>
Date: Tue, 14 May 2013 17:06:54 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Michal Hocko <mhocko@suse.cz>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/9] mm: vmscan: Block kswapd if it is encountering pages
 under writeback
References: <1368432760-21573-1-git-send-email-mgorman@suse.de> <1368432760-21573-8-git-send-email-mgorman@suse.de>
In-Reply-To: <1368432760-21573-8-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2013 04:12 AM, Mel Gorman wrote:
> Historically, kswapd used to congestion_wait() at higher priorities if it
> was not making forward progress. This made no sense as the failure to make
> progress could be completely independent of IO. It was later replaced by
> wait_iff_congested() and removed entirely by commit 258401a6 (mm: don't
> wait on congested zones in balance_pgdat()) as it was duplicating logic
> in shrink_inactive_list().
>
> This is problematic. If kswapd encounters many pages under writeback and
> it continues to scan until it reaches the high watermark then it will
> quickly skip over the pages under writeback and reclaim clean young
> pages or push applications out to swap.
>
> The use of wait_iff_congested() is not suited to kswapd as it will only
> stall if the underlying BDI is really congested or a direct reclaimer was
> unable to write to the underlying BDI. kswapd bypasses the BDI congestion
> as it sets PF_SWAPWRITE but even if this was taken into account then it
> would cause direct reclaimers to stall on writeback which is not desirable.
>
> This patch sets a ZONE_WRITEBACK flag if direct reclaim or kswapd is
> encountering too many pages under writeback. If this flag is set and
> kswapd encounters a PageReclaim page under writeback then it'll assume
> that the LRU lists are being recycled too quickly before IO can complete
> and block waiting for some IO to complete.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> Reviewed-by: Michal Hocko <mhocko@suse.cz>

Acked-by: Rik van Riel <riel@redhat.com>

