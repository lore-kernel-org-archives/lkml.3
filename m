Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbaBEUwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:52:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38217 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbaBEUwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:52:32 -0500
Date: Wed, 5 Feb 2014 12:52:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <devel@openvz.org>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, Glauber Costa <glommer@gmail.com>
Subject: Re: [PATCH 2/3] mm: vmscan: get rid of DEFAULT_SEEKS and document
 shrink_slab logic
Message-Id: <20140205125230.e1705369abcb634ddf141008@linux-foundation.org>
In-Reply-To: <52F1E561.8020804@parallels.com>
References: <4e2efebe688e06574f6495c634ac45d799e1518d.1389982079.git.vdavydov@parallels.com>
	<e204471853100447541ce36b198c0d45bf06379c.1389982079.git.vdavydov@parallels.com>
	<20140204135836.05c09c765073513e62edd174@linux-foundation.org>
	<52F1E561.8020804@parallels.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Feb 2014 11:16:49 +0400 Vladimir Davydov <vdavydov@parallels.com> wrote:

> > So why did I originally make DEFAULT_SEEKS=2?  Because I figured that to
> > recreate (say) an inode would require a seek to the inode data then a
> > seek back.  Is it legitimate to include the
> > seek-back-to-what-you-were-doing-before seek in the cost of an inode
> > reclaim?  I guess so...
> 
> Hmm, that explains this 2. Since we typically don't need to "seek back"
> when recreating a cache page, as they are usually read in bunches by
> readahead, the number of seeks to bring back a user page is 1, while the
> number of seeks to recreate an average inode is 2, right?

Sounds right to me.

> Then to scan inodes and user pages so that they would generate
> approximately the same number of seeks, we should calculate the number
> of objects to scan as follows:
> 
> nr_objects_to_scan = nr_pages_scanned / lru_pages *
>                                         nr_freeable_objects /
> shrinker->seeks
> 
> where shrinker->seeks = DEFAULT_SEEKS = 2 for inodes.

hm, I wonder if we should take the size of the object into account. 
Should we be maximizing (memory-reclaimed / seeks-to-reestablish-it).

> But currently we
> have four times that. I can explain why we should multiply this by 2 -
> we do not count pages moving from active to inactive lrus in
> nr_pages_scanned, and 2*nr_pages_scanned can be a good approximation for
> that - but I have no idea why we multiply it by 4...

I don't understand this code at all:

	total_scan = nr;
	delta = (4 * nr_pages_scanned) / shrinker->seeks;
	delta *= freeable;
	do_div(delta, lru_pages + 1);
	total_scan += delta;

If it actually makes any sense, it sorely sorely needs documentation.

David, you touched it last.  Any hints?
