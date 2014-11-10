Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbaKJIED (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 03:04:03 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:33738 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaKJIEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 03:04:01 -0500
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 10 Nov 2014 17:05:56 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: "P. Christeas" <xrg@linux.gr>, linux-mm@kvack.org,
        lkml <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>,
        Norbert Preining <preining@logic.at>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Pavel Machek <pavel@ucw.cz>
Subject: Re: Early test: hangs in mm/compact.c w. Linus's 12d7aacab56e9ef185c
Message-ID: <20141110080555.GA5877@js1304-P5Q-DELUXE>
References: <12996532.NCRhVKzS9J@xorhgos3.pefnos>
 <3583067.00bS4AInhm@xorhgos3.pefnos>
 <545BEA3B.40005@suse.cz>
 <3443150.6EQzxj6Rt9@xorhgos3.pefnos>
 <545E96BD.5040103@suse.cz>
 <20141110060726.GA4900@js1304-P5Q-DELUXE>
 <54606F02.5070808@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54606F02.5070808@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 08:53:38AM +0100, Vlastimil Babka wrote:
> On 11/10/2014 07:07 AM, Joonsoo Kim wrote:
> >On Sat, Nov 08, 2014 at 11:18:37PM +0100, Vlastimil Babka wrote:
> >>On 11/08/2014 02:11 PM, P. Christeas wrote:
> >>
> >>Hi,
> >>
> >>I think I finally found the cause by staring into the code... CCing
> >>people from all 4 separate threads I know about this issue.
> >>The problem with finding the cause was that the first report I got from
> >>Markus was about isolate_freepages_block() overhead, and later Norbert
> >>reported that reverting a patch for isolate_freepages* helped. But the
> >>problem seems to be that although the loop in isolate_migratepages exits
> >>because the scanners almost meet (they are within same pageblock), they
> >>don't truly meet, therefore compact_finished() decides to continue, but
> >>isolate_migratepages() exits immediately... boom! But indeed e14c720efdd7
> >>made this situation possible, as free scaner pfn can now point to a
> >>middle of pageblock.
> >
> >Indeed.
> >
> >>
> >>So I hope the attached patch will fix the soft-lockup issues in
> >>compact_zone. Please apply on 3.18-rc3 or later without any other reverts,
> >>and test. It probably won't help Markus and his isolate_freepages_block()
> >>overhead though...
> >
> >Yes, I found this bug too, but, it can't explain
> >isolate_freepages_block() overhead. Anyway, I can't find another bug
> >related to isolate_freepages_block(). :/
> 
> Thanks for checking.
> 
> >>Thanks,
> >>Vlastimil
> >>
> >>------8<------
> >>>From fbf8eb0bcd2897090312e23da6a31bad9cc6b337 Mon Sep 17 00:00:00 2001
> >>From: Vlastimil Babka <vbabka@suse.cz>
> >>Date: Sat, 8 Nov 2014 22:20:43 +0100
> >>Subject: [PATCH] mm, compaction: prevent endless loop in migrate scanner
> >>
> >>---
> >>  mm/compaction.c | 8 ++++++--
> >>  1 file changed, 6 insertions(+), 2 deletions(-)
> >>
> >>diff --git a/mm/compaction.c b/mm/compaction.c
> >>index ec74cf0..1b7a1be 100644
> >>--- a/mm/compaction.c
> >>+++ b/mm/compaction.c
> >>@@ -1029,8 +1029,12 @@ static isolate_migrate_t isolate_migratepages(struct zone *zone,
> >>  	}
> >>
> >>  	acct_isolated(zone, cc);
> >>-	/* Record where migration scanner will be restarted */
> >>-	cc->migrate_pfn = low_pfn;
> >>+	/*
> >>+	 * Record where migration scanner will be restarted. If we end up in
> >>+	 * the same pageblock as the free scanner, make the scanners fully
> >>+	 * meet so that compact_finished() terminates compaction.
> >>+	 */
> >>+	cc->migrate_pfn = (end_pfn <= cc->free_pfn) ? low_pfn : cc->free_pfn;
> >>
> >>  	return cc->nr_migratepages ? ISOLATE_SUCCESS : ISOLATE_NONE;
> >>  }
> >
> >IMHO, proper fix is not to change this logic, but, to change decision
> >logic in compact_finished() and in compact_zone(). Maybe helper
> >function would be good for readability.
> 
> OK but I would think that to fix 3.18 ASAP and not introduce more
> regressions, go with the patch above first, as it is the minimal fix
> and people already test it. Then we can implement your suggestion
> later as a cleanup for 3.19?

Yeap. Agreed.

Thanks.
