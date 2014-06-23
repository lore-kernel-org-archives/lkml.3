Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbaFWLCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 07:02:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43230 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbaFWLCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 07:02:45 -0400
Date: Mon, 23 Jun 2014 12:02:40 +0100
From: Mel Gorman <mgorman@suse.de>
To: Chen Yucong <slaoub@gmail.com>
Cc: akpm@linux-foundation.org, minchan@kernel.org, hannes@cmpxchg.org,
        mhocko@suse.cz, riel@redhat.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan.c: fix an implementation flaw in proportional
 scanning
Message-ID: <20140623110240.GI10819@suse.de>
References: <1402980902-6345-1-git-send-email-slaoub@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1402980902-6345-1-git-send-email-slaoub@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 12:55:02PM +0800, Chen Yucong wrote:
> Via https://lkml.org/lkml/2013/4/10/897, we can know that the relative design
> idea is to keep
> 
>     scan_target[anon] : scan_target[file]
>         == really_scanned_num[anon] : really_scanned_num[file]
> 
> But we can find the following snippet in shrink_lruvec():
> 
>     if (nr_file > nr_anon) {
>         ...
>     } else {
>         ...
>     }
> 

This is to preserve the ratio of scanning between the lists once the
reclaim target has been reached. One list scanning stops and the other
continues until the proportional number of pages have been scanned.

> However, the above code fragment broke the design idea. We can assume:
> 
>       nr[LRU_ACTIVE_FILE] = 30
>       nr[LRU_INACTIVE_FILE] = 30
>       nr[LRU_ACTIVE_ANON] = 0
>       nr[LRU_INACTIVE_ANON] = 40
> 
> When the value of (nr_reclaimed < nr_to_reclaim) become false, there are
> the following results:
> 
>       nr[LRU_ACTIVE_FILE] = 15
>       nr[LRU_INACTIVE_FILE] = 15
>       nr[LRU_ACTIVE_ANON] = 0
>       nr[LRU_INACTIVE_ANON] = 25
>       nr_file = 30
>       nr_anon = 25
>       file_percent = 30 / 60 = 0.5
>       anon_percent = 25 / 40 = 0.65
> 

The original proportion was

file_percent = 60
anon_percent = 40

We check nr_file > nr_anon based on the remaining scan counts in nr[].
We recheck what proportion the larger LRU should be scanned based on targets[]

> According to the above design idea, we should scan some pages from ANON,
> but in fact we execute the an error code path due to "if (nr_file > nr_anon)".
> In this way, nr[lru] is likely to be a negative number. Luckily,
> "nr[lru] -= min(nr[lru], nr_scanned)" can help us to filter this situation,
> but it has rebelled against our design idea.
> 

What problem did you encounter? What is the measurable impact of the
patch? One of the reasons why I have taken so long to look at this is
because this information was missing.

The original series that introduced this proportional reclaim was
related to kswapd scanning excessively and swapping pages due to heavy
writing IO. The overall intent of that series was to prevent kswapd
scanning excessively while preserving the property that it scan
file/anon LRU lists proportional to vm.swappiness.

The primary test case used to measure that was memcachetest with varying
amounts of IO in the background and monitoring the reclaim activity
(https://lwn.net/Articles/551643/). Later postmark, ffsb, dd of a
large file and a test that measured mmap latency during IO was used
(http://lwn.net/Articles/600145/).

In the memcachetest case, it was demonstrated that we no longer swapped
processes just because there was some IO. That test case may still be
useful for demonstrating problems with proportional reclaim but the
"stutter" test that measured mmap latency during IO might be easier. The
ideal test case would be the one you used for testing this patch and
verifying it worked as expected.

The point is that even though flaws were discovered later there was still
data supporting the inclusion of the original patches.

I did not find an example of where I talked about it publicly but at one
point I used the mm_vmscan_lru_shrink_inactive tracepoint to verify that
that lists were being scanned proportionally. At the time I would have used a
fixed version of Documentation/trace/postprocess/trace-vmscan-postprocess.pl.
mmtests has an equivalent script but it does not currently support reporting
the proportion of anon/file pages scanned. It should be easy enough to
generate a quick script that checks the file/anon rate of scanning with
and without your patch applied


> Signed-off-by: Chen Yucong <slaoub@gmail.com>
> ---
>  mm/vmscan.c |   39 ++++++++++++++++++---------------------
>  1 file changed, 18 insertions(+), 21 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index a8ffe4e..2c35e34 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2057,8 +2057,7 @@ out:
>  static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>  {
>  	unsigned long nr[NR_LRU_LISTS];
> -	unsigned long targets[NR_LRU_LISTS];
> -	unsigned long nr_to_scan;
> +	unsigned long file_target, anon_target;
>  	enum lru_list lru;
>  	unsigned long nr_reclaimed = 0;
>  	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
> @@ -2067,8 +2066,8 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>  
>  	get_scan_count(lruvec, sc, nr);
>  
> -	/* Record the original scan target for proportional adjustments later */
> -	memcpy(targets, nr, sizeof(nr));
> +	file_target = nr[LRU_INACTIVE_FILE] + nr[LRU_ACTIVE_FILE];
> +	anon_target = nr[LRU_INACTIVE_ANON] + nr[LRU_ACTIVE_ANON];
>  
>  	/*
>  	 * Global reclaiming within direct reclaim at DEF_PRIORITY is a normal
> @@ -2087,8 +2086,8 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>  	blk_start_plug(&plug);
>  	while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
>  					nr[LRU_INACTIVE_FILE]) {
> -		unsigned long nr_anon, nr_file, percentage;
> -		unsigned long nr_scanned;
> +		unsigned long nr_anon, nr_file, file_percent, anon_percent;
> +		unsigned long nr_to_scan, nr_scanned, percentage;
>  
>  		for_each_evictable_lru(lru) {
>  			if (nr[lru]) {
> @@ -2122,16 +2121,19 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>  		if (!nr_file || !nr_anon)
>  			break;
>  
> -		if (nr_file > nr_anon) {
> -			unsigned long scan_target = targets[LRU_INACTIVE_ANON] +
> -						targets[LRU_ACTIVE_ANON] + 1;
> +		file_percent = nr_file * 100 / file_target;
> +		anon_percent = nr_anon * 100 / anon_target;
> +
> +		if (file_percent > anon_percent) {

About all that can be said here is the code is different but not obviously
better or worse because there is no supporting data for your case.

In the original code, it was assumed that we scanned the LRUs in batches
of SWAP_CLUSTER_MAX until the requested number of pages were reclaimed.
Assuming the scan counts do not reach zero prematurely, the ratio
between nr_file/nr_anon should remain constant. Whether we check the
remaining counts or the percentages should be irrelevant.

>  			lru = LRU_BASE;
> -			percentage = nr_anon * 100 / scan_target;
> +			nr_scanned = file_target - nr_file;
> +			nr_to_scan = file_target * (100 - anon_percent) / 100;
> +			percentage = nr[LRU_FILE] * 100 / nr_file;
>  		} else {
> -			unsigned long scan_target = targets[LRU_INACTIVE_FILE] +
> -						targets[LRU_ACTIVE_FILE] + 1;
>  			lru = LRU_FILE;
> -			percentage = nr_file * 100 / scan_target;
> +			nr_scanned = anon_target - nr_anon;
> +			nr_to_scan = anon_target * (100 - file_percent) / 100;
> +			percentage = nr[LRU_BASE] * 100 / nr_anon;
>  		}
>  
>  		/* Stop scanning the smaller of the LRU */


There is some merit to recording the file_percentage and anon_percentage
in advance, removing the need for the targets[] array and adjust the
inactive/active lists by the scanning targets but the changelog should
include the anon/file scan rates before and after.


> @@ -2143,14 +2145,9 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>  		 * scan target and the percentage scanning already complete
>  		 */
>  		lru = (lru == LRU_FILE) ? LRU_BASE : LRU_FILE;
> -		nr_scanned = targets[lru] - nr[lru];
> -		nr[lru] = targets[lru] * (100 - percentage) / 100;
> -		nr[lru] -= min(nr[lru], nr_scanned);
> -
> -		lru += LRU_ACTIVE;
> -		nr_scanned = targets[lru] - nr[lru];
> -		nr[lru] = targets[lru] * (100 - percentage) / 100;
> -		nr[lru] -= min(nr[lru], nr_scanned);
> +		nr_to_scan -= min(nr_to_scan, nr_scanned);
> +		nr[lru] = nr_to_scan * percentage / 100;
> +		nr[lru + LRU_ACTIVE] = nr_to_scan - nr[lru];
>  
>  		scan_adjusted = true;
>  	}

-- 
Mel Gorman
SUSE Labs
