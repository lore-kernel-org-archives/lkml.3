Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab3CSKMY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 06:12:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58432 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330Ab3CSKMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 06:12:23 -0400
Date: Tue, 19 Mar 2013 10:12:19 +0000
From: Mel Gorman <mgorman@suse.de>
To: Simon Jeons <simon.jeons@gmail.com>
Cc: Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Rik van Riel <riel@redhat.com>, Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/10] mm: vmscan: Flatten kswapd priority loop
Message-ID: <20130319101219.GC2055@suse.de>
References: <1363525456-10448-1-git-send-email-mgorman@suse.de>
 <1363525456-10448-4-git-send-email-mgorman@suse.de>
 <5147AA3B.9080807@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <5147AA3B.9080807@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 07:58:51AM +0800, Simon Jeons wrote:
> >@@ -2672,26 +2677,25 @@ static void kswapd_shrink_zone(struct zone *zone,
> >  static unsigned long balance_pgdat(pg_data_t *pgdat, int order,
> >  							int *classzone_idx)
> >  {
> >-	bool pgdat_is_balanced = false;
> >  	int i;
> >  	int end_zone = 0;	/* Inclusive.  0 = ZONE_DMA */
> >  	unsigned long nr_soft_reclaimed;
> >  	unsigned long nr_soft_scanned;
> >  	struct scan_control sc = {
> >  		.gfp_mask = GFP_KERNEL,
> >+		.priority = DEF_PRIORITY,
> >  		.may_unmap = 1,
> >  		.may_swap = 1,
> >+		.may_writepage = !laptop_mode,
> 
> What's the influence of this change? If there are large numbers of
> anonymous pages and very little file pages, anonymous pages will not
> be swapped out when priorty >= DEF_PRIORITY-2. Just no sense scan.

None. The initialisation just moves from where it was after the
loop_again label to here. See the next hunk.

> >  		.order = order,
> >  		.target_mem_cgroup = NULL,
> >  	};
> >-loop_again:
> >-	sc.priority = DEF_PRIORITY;
> >-	sc.nr_reclaimed = 0;
> >-	sc.may_writepage = !laptop_mode;
> >  	count_vm_event(PAGEOUTRUN);
> >  	do {
> >  		unsigned long lru_pages = 0;
> >+		unsigned long nr_reclaimed = sc.nr_reclaimed;
> >+		bool raise_priority = true;
> >  		/*
> >  		 * Scan in the highmem->dma direction for the highest

-- 
Mel Gorman
SUSE Labs
