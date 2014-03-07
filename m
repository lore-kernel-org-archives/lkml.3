Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbaCGIVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 03:21:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:46120 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbaCGIVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 03:21:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,606,1389772800"; 
   d="scan'208";a="487780325"
Date: Fri, 7 Mar 2014 16:22:16 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Mel Gorman <mgorman@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: performance regression due to commit e82e0561("mm: vmscan: obey
 proportional scanning requirements for kswapd")
Message-ID: <20140307082216.GJ29270@yliu-dev.sh.intel.com>
References: <20140218080122.GO26593@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218080122.GO26593@yliu-dev.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping...

On Tue, Feb 18, 2014 at 04:01:22PM +0800, Yuanhan Liu wrote:
> Hi,
> 
> Commit e82e0561("mm: vmscan: obey proportional scanning requirements for
> kswapd") caused a big performance regression(73%) for vm-scalability/
> lru-file-readonce testcase on a system with 256G memory without swap.
> 
> That testcase simply looks like this:
>      truncate -s 1T /tmp/vm-scalability.img
>      mkfs.xfs -q /tmp/vm-scalability.img
>      mount -o loop /tmp/vm-scalability.img /tmp/vm-scalability
> 
>      SPARESE_FILE="/tmp/vm-scalability/sparse-lru-file-readonce"
>      for i in `seq 1 120`; do
>          truncate $SPARESE_FILE-$i -s 36G
>          timeout --foreground -s INT 300 dd bs=4k if=$SPARESE_FILE-$i of=/dev/null
>      done
> 
>      wait
> 
> Actually, it's not the newlly added code(obey proportional scanning)
> in that commit caused the regression. But instead, it's the following
> change:
> +
> +               if (nr_reclaimed < nr_to_reclaim || scan_adjusted)
> +                       continue;
> +
> 
> 
> -               if (nr_reclaimed >= nr_to_reclaim &&
> -                   sc->priority < DEF_PRIORITY)
> +               if (global_reclaim(sc) && !current_is_kswapd())
>                         break;
> 
> The difference is that we might reclaim more than requested before
> in the first round reclaimming(sc->priority == DEF_PRIORITY).
> 
> So, for a testcase like lru-file-readonce, the dirty rate is fast, and
> reclaimming SWAP_CLUSTER_MAX(32 pages) each time is not enough for catching
> up the dirty rate. And thus page allocation stalls, and performance drops:
> 
>    O for e82e0561
>    * for parent commit
> 
>                                 proc-vmstat.allocstall
> 
>      2e+06 ++---------------------------------------------------------------+
>    1.8e+06 O+              O                O               O               |
>            |                                                                |
>    1.6e+06 ++                                                               |
>    1.4e+06 ++                                                               |
>            |                                                                |
>    1.2e+06 ++                                                               |
>      1e+06 ++                                                               |
>     800000 ++                                                               |
>            |                                                                |
>     600000 ++                                                               |
>     400000 ++                                                               |
>            |                                                                |
>     200000 *+..............*................*...............*...............*
>          0 ++---------------------------------------------------------------+
> 
>                                vm-scalability.throughput
> 
>    2.2e+07 ++---------------------------------------------------------------+
>            |                                                                |
>      2e+07 *+..............*................*...............*...............*
>    1.8e+07 ++                                                               |
>            |                                                                |
>    1.6e+07 ++                                                               |
>            |                                                                |
>    1.4e+07 ++                                                               |
>            |                                                                |
>    1.2e+07 ++                                                               |
>      1e+07 ++                                                               |
>            |                                                                |
>      8e+06 ++              O                O               O               |
>            O                                                                |
>      6e+06 ++---------------------------------------------------------------+
> 
> I made a patch which simply keeps reclaimming more if sc->priority == DEF_PRIORITY.
> I'm not sure it's the right way to go or not. Anyway, I pasted it here for comments.
> 
> ---
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 26ad67f..37004a8 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1828,7 +1828,16 @@ static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>  	unsigned long nr_reclaimed = 0;
>  	unsigned long nr_to_reclaim = sc->nr_to_reclaim;
>  	struct blk_plug plug;
> -	bool scan_adjusted = false;
> +	/*
> +	 * On large memory systems, direct reclamming of SWAP_CLUSTER_MAX
> +	 * each time may not catch up the dirty rate in some cases(say,
> +	 * vm-scalability/lru-file-readonce), which may increase the
> +	 * page allocation stall latency in the end.
> +	 *
> +	 * Here we try to reclaim more than requested for the first round
> +	 * (sc->priority == DEF_PRIORITY) to reduce such latency.
> +	 */
> +	bool scan_adjusted = sc->priority == DEF_PRIORITY;
>  
>  	get_scan_count(lruvec, sc, nr);
>  
> -- 
> 1.7.7.6
> 
> 
> 	--yliu
