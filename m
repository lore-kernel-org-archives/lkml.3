Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaCLQyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 12:54:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50498 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbaCLQyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 12:54:50 -0400
Date: Wed, 12 Mar 2014 16:54:47 +0000
From: Mel Gorman <mgorman@suse.de>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: performance regression due to commit e82e0561("mm: vmscan: obey
 proportional scanning requirements for kswapd")
Message-ID: <20140312165447.GO10663@suse.de>
References: <20140218080122.GO26593@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140218080122.GO26593@yliu-dev.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

The filename implies that it's a sparse file with no IO but does not say
what the truncate function/program/whatever actually does. If it's really a
sparse file then the dd process should be reading zeros and writing them to
NULL without IO. Where are pages being dirtied? Does the truncate command
really create a sparse file or is it something else?

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

The impact of the patch is that a direct reclaimer will now scan and
reclaim more pages than requested so the unlucky reclaiming process will
stall for longer than it should while others make forward progress.

That would explain the difference in allocstall figure as each stall is
now doing more work than it did previously. The throughput figure is
harder to explain. What is it measuring?

Any idea why kswapd is failing to keep up?

I'm not saying the patch is wrong but there appears to be more going on
that is explained in the changelog. Is the full source of the benchmark
suite available? If so, can you point me to it and the exact commands
you use to run the testcase please?

Thanks.

-- 
Mel Gorman
SUSE Labs
