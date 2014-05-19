Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbaESXho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 19:37:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50617 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbaESXhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 19:37:42 -0400
Date: Mon, 19 May 2014 16:37:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, David Rientjes <rientjes@google.com>,
        Hugh Dickins <hughd@google.com>, Greg Thelen <gthelen@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2] mm, compaction: properly signal and act upon lock
 and need_sched() contention
Message-Id: <20140519163741.55998ce65534ed73d913ee2c@linux-foundation.org>
In-Reply-To: <1400233673-11477-1-git-send-email-vbabka@suse.cz>
References: <1399904111-23520-1-git-send-email-vbabka@suse.cz>
	<1400233673-11477-1-git-send-email-vbabka@suse.cz>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2014 11:47:53 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:

> Compaction uses compact_checklock_irqsave() function to periodically check for
> lock contention and need_resched() to either abort async compaction, or to
> free the lock, schedule and retake the lock. When aborting, cc->contended is
> set to signal the contended state to the caller. Two problems have been
> identified in this mechanism.
> 
> First, compaction also calls directly cond_resched() in both scanners when no
> lock is yet taken. This call either does not abort async compaction, or set
> cc->contended appropriately. This patch introduces a new compact_should_abort()
> function to achieve both. In isolate_freepages(), the check frequency is
> reduced to once by SWAP_CLUSTER_MAX pageblocks to match what the migration
> scanner does in the preliminary page checks. In case a pageblock is found
> suitable for calling isolate_freepages_block(), the checks within there are
> done on higher frequency.
> 
> Second, isolate_freepages() does not check if isolate_freepages_block()
> aborted due to contention, and advances to the next pageblock. This violates
> the principle of aborting on contention, and might result in pageblocks not
> being scanned completely, since the scanning cursor is advanced. This patch
> makes isolate_freepages_block() check the cc->contended flag and abort.
> 
> In case isolate_freepages() has already isolated some pages before aborting
> due to contention, page migration will proceed, which is OK since we do not
> want to waste the work that has been done, and page migration has own checks
> for contention. However, we do not want another isolation attempt by either
> of the scanners, so cc->contended flag check is added also to
> compaction_alloc() and compact_finished() to make sure compaction is aborted
> right after the migration.

What are the runtime effect of this change?

> Reported-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

What did Joonsoo report?  Perhaps this is the same thing..

>
> ...
>
> @@ -718,9 +739,11 @@ static void isolate_freepages(struct zone *zone,
>  		/*
>  		 * This can iterate a massively long zone without finding any
>  		 * suitable migration targets, so periodically check if we need
> -		 * to schedule.
> +		 * to schedule, or even abort async compaction.
>  		 */
> -		cond_resched();
> +		if (!(block_start_pfn % (SWAP_CLUSTER_MAX * pageblock_nr_pages))
> +						&& compact_should_abort(cc))

This seems rather gratuitously inefficient and isn't terribly clear. 
What's wrong with

	if ((++foo % SWAP_CLUSTER_MAX) == 0 && compact_should_abort(cc))

?

(Assumes that SWAP_CLUSTER_MAX is power-of-2 and that the compiler will
use &)

