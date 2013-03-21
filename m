Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933520Ab3CUJyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 05:54:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50674 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757950Ab3CUJyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 05:54:49 -0400
Date: Thu, 21 Mar 2013 09:54:45 +0000
From: Mel Gorman <mgorman@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: Linux-MM <linux-mm@kvack.org>, Jiri Slaby <jslaby@suse.cz>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Zlatko Calusic <zcalusic@bitsync.net>,
        Johannes Weiner <hannes@cmpxchg.org>, dormando <dormando@rydia.net>,
        Satoru Moriya <satoru.moriya@hds.com>, Michal Hocko <mhocko@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/10] mm: vmscan: Obey proportional scanning
 requirements for kswapd
Message-ID: <20130321095444.GE1878@suse.de>
References: <1363525456-10448-1-git-send-email-mgorman@suse.de>
 <1363525456-10448-3-git-send-email-mgorman@suse.de>
 <514A5E07.3080501@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <514A5E07.3080501@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 09:10:31PM -0400, Rik van Riel wrote:
> On 03/17/2013 09:04 AM, Mel Gorman wrote:
> >Simplistically, the anon and file LRU lists are scanned proportionally
> >depending on the value of vm.swappiness although there are other factors
> >taken into account by get_scan_count().  The patch "mm: vmscan: Limit
> >the number of pages kswapd reclaims" limits the number of pages kswapd
> >reclaims but it breaks this proportional scanning and may evenly shrink
> >anon/file LRUs regardless of vm.swappiness.
> >
> >This patch preserves the proportional scanning and reclaim. It does mean
> >that kswapd will reclaim more than requested but the number of pages will
> >be related to the high watermark.
> >
> >Signed-off-by: Mel Gorman <mgorman@suse.de>
> >---
> >  mm/vmscan.c | 52 +++++++++++++++++++++++++++++++++++++++++-----------
> >  1 file changed, 41 insertions(+), 11 deletions(-)
> >
> >diff --git a/mm/vmscan.c b/mm/vmscan.c
> >index 4835a7a..182ff15 100644
> >--- a/mm/vmscan.c
> >+++ b/mm/vmscan.c
> >@@ -1815,6 +1815,45 @@ out:
> >  	}
> >  }
> >
> >+static void recalculate_scan_count(unsigned long nr_reclaimed,
> >+		unsigned long nr_to_reclaim,
> >+		unsigned long nr[NR_LRU_LISTS])
> >+{
> >+	enum lru_list l;
> >+
> >+	/*
> >+	 * For direct reclaim, reclaim the number of pages requested. Less
> >+	 * care is taken to ensure that scanning for each LRU is properly
> >+	 * proportional. This is unfortunate and is improper aging but
> >+	 * minimises the amount of time a process is stalled.
> >+	 */
> >+	if (!current_is_kswapd()) {
> >+		if (nr_reclaimed >= nr_to_reclaim) {
> >+			for_each_evictable_lru(l)
> >+				nr[l] = 0;
> >+		}
> >+		return;
> >+	}
> 
> This part is obvious.
> 
> >+	/*
> >+	 * For kswapd, reclaim at least the number of pages requested.
> >+	 * However, ensure that LRUs shrink by the proportion requested
> >+	 * by get_scan_count() so vm.swappiness is obeyed.
> >+	 */
> >+	if (nr_reclaimed >= nr_to_reclaim) {
> >+		unsigned long min = ULONG_MAX;
> >+
> >+		/* Find the LRU with the fewest pages to reclaim */
> >+		for_each_evictable_lru(l)
> >+			if (nr[l] < min)
> >+				min = nr[l];
> >+
> >+		/* Normalise the scan counts so kswapd scans proportionally */
> >+		for_each_evictable_lru(l)
> >+			nr[l] -= min;
> >+	}
> >+}
> 
> This part took me a bit longer to get.
> 
> Before getting to this point, we scanned the LRUs evenly.
> By subtracting min from all of the LRUs, we end up stopping
> the scanning of the LRU where we have the fewest pages left
> to scan.
> 
> This results in the scanning being concentrated where it
> should be - on the LRUs where we have not done nearly
> enough scanning yet.
> 

This is exactly what my intention was. It does mean that we potentially
reclaim much more than required by sc->nr_to_reclaim but I did not think
of a straight-forward way around that that would work in every case.

> However, I am not sure how to document it better than
> your comment already has...
> 
> Acked-by: Rik van Riel <riel@redhat.com>
> 

Thanks.

-- 
Mel Gorman
SUSE Labs
