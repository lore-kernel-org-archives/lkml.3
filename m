Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab3D2RM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 13:12:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20119 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756852Ab3D2RMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 13:12:25 -0400
Message-ID: <517EA9E3.6050407@redhat.com>
Date: Mon, 29 Apr 2013 13:12:03 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Alexey Lyahkov <alexey.lyashkov@gmail.com>,
        Andrew Perepechko <anserper@ya.ru>, Robin Dong <sanbai@taobao.com>,
        Theodore Tso <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Bernd Schubert <bernd.schubert@fastmail.fm>,
        David Howells <dhowells@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux-ext4 <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 2/3] mm: Ensure that mark_page_accessed moves pages to
 the active list
References: <1367253119-6461-1-git-send-email-mgorman@suse.de> <1367253119-6461-3-git-send-email-mgorman@suse.de>
In-Reply-To: <1367253119-6461-3-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2013 12:31 PM, Mel Gorman wrote:

> A PageActive page is now added to the inactivate list.
>
> While this looks strange, I think it is sufficiently harmless that additional
> barriers to address the case is not justified.  Unfortunately, while I never
> witnessed it myself, these parallel updates potentially trigger defensive
> DEBUG_VM checks on PageActive and hence they are removed by this patch.

Could this not cause issues with __page_cache_release, called from
munmap, exit, truncate, etc.?

Could the eventual skewing of active vs inactive numbers break page
reclaim heuristics?

I wonder if we would need to move to a scheme where the PG_active bit
is always the authoritive one, and we never pass an overriding "lru"
parameter to __pagevec_lru_add.

Would memory ordering between SetPageLRU and testing for PageLRU be
enough to then prevent the statistics from going off?

-- 
All rights reversed
