Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbaEVQM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:12:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:15840 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbaEVQM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:12:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,888,1392192000"; 
   d="scan'208";a="543433823"
Date: Fri, 23 May 2014 00:14:16 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Bob Liu <bob.liu@oracle.com>, Jan Kara <jack@suse.cz>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Shrinkers and proportional reclaim
Message-ID: <20140522161416.GD25013@yliu-dev.sh.intel.com>
References: <1400749779-24879-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400749779-24879-1-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 10:09:36AM +0100, Mel Gorman wrote:
> This series is aimed at regressions noticed during reclaim activity. The
> first two patches are shrinker patches that were posted ages ago but never
> merged for reasons that are unclear to me. I'm posting them again to see if
> there was a reason they were dropped or if they just got lost. Dave?  Time?
> The last patch adjusts proportional reclaim. Yuanhan Liu, can you retest
> the vm scalability test cases on a larger machine? Hugh, does this work
> for you on the memcg test cases?

Sure, and here is the result. I applied these 3 patches on v3.15-rc6,
and head commit is 60c10afd. e82e0561 is the old commit that introduced
the regression.  The testserver has 512G memory and 120 CPU.

It's a simple result; if you need more data, I can gather them and send
it to you tomorrow:

e82e0561        v3.15-rc6       60c10afd
----------------------------------------
18560785        12232122        38868453
                -34%            +109

As you can see, the performance is back, and it is way much better ;)

        --yliu
> 
> Based on ext4, I get the following results but unfortunately my larger test
> machines are all unavailable so this is based on a relatively small machine.
> 
> postmark
>                                   3.15.0-rc5            3.15.0-rc5
>                                      vanilla       proportion-v1r4
> Ops/sec Transactions         21.00 (  0.00%)       25.00 ( 19.05%)
> Ops/sec FilesCreate          39.00 (  0.00%)       45.00 ( 15.38%)
> Ops/sec CreateTransact       10.00 (  0.00%)       12.00 ( 20.00%)
> Ops/sec FilesDeleted       6202.00 (  0.00%)     6202.00 (  0.00%)
> Ops/sec DeleteTransact       11.00 (  0.00%)       12.00 (  9.09%)
> Ops/sec DataRead/MB          25.97 (  0.00%)       30.02 ( 15.59%)
> Ops/sec DataWrite/MB         49.99 (  0.00%)       57.78 ( 15.58%)
> 
> ffsb (mail server simulator)
>                                  3.15.0-rc5             3.15.0-rc5
>                                     vanilla        proportion-v1r4
> Ops/sec readall           9402.63 (  0.00%)      9805.74 (  4.29%)
> Ops/sec create            4695.45 (  0.00%)      4781.39 (  1.83%)
> Ops/sec delete             173.72 (  0.00%)       177.23 (  2.02%)
> Ops/sec Transactions     14271.80 (  0.00%)     14764.37 (  3.45%)
> Ops/sec Read                37.00 (  0.00%)        38.50 (  4.05%)
> Ops/sec Write               18.20 (  0.00%)        18.50 (  1.65%)
> 
> dd of a large file
>                                 3.15.0-rc5            3.15.0-rc5
>                                    vanilla       proportion-v1r4
> WallTime DownloadTar       75.00 (  0.00%)       61.00 ( 18.67%)
> WallTime DD               423.00 (  0.00%)      401.00 (  5.20%)
> WallTime Delete             2.00 (  0.00%)        5.00 (-150.00%)
> 
> stutter (times mmap latency during large amounts of IO)
> 
>                             3.15.0-rc5            3.15.0-rc5
>                                vanilla       proportion-v1r4
> Unit >5ms Delays  80252.0000 (  0.00%)  81523.0000 ( -1.58%)
> Unit Mmap min         8.2118 (  0.00%)      8.3206 ( -1.33%)
> Unit Mmap mean       17.4614 (  0.00%)     17.2868 (  1.00%)
> Unit Mmap stddev     24.9059 (  0.00%)     34.6771 (-39.23%)
> Unit Mmap max      2811.6433 (  0.00%)   2645.1398 (  5.92%)
> Unit Mmap 90%        20.5098 (  0.00%)     18.3105 ( 10.72%)
> Unit Mmap 93%        22.9180 (  0.00%)     20.1751 ( 11.97%)
> Unit Mmap 95%        25.2114 (  0.00%)     22.4988 ( 10.76%)
> Unit Mmap 99%        46.1430 (  0.00%)     43.5952 (  5.52%)
> Unit Ideal  Tput     85.2623 (  0.00%)     78.8906 (  7.47%)
> Unit Tput min        44.0666 (  0.00%)     43.9609 (  0.24%)
> Unit Tput mean       45.5646 (  0.00%)     45.2009 (  0.80%)
> Unit Tput stddev      0.9318 (  0.00%)      1.1084 (-18.95%)
> Unit Tput max        46.7375 (  0.00%)     46.7539 ( -0.04%)
> 
>  fs/super.c  | 16 +++++++++-------
>  mm/vmscan.c | 36 +++++++++++++++++++++++++-----------
>  2 files changed, 34 insertions(+), 18 deletions(-)
> 
> -- 
> 1.8.4.5
