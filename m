Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab3KAIBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 04:01:41 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:37340 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab3KAIBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 04:01:39 -0400
Date: Fri, 1 Nov 2013 09:01:36 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH 0/4] per anon_vma lock and turn anon_vma rwsem lock to
 rwlock_t
Message-ID: <20131101080135.GB25547@gmail.com>
References: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:

> Patch 1 turns locking the anon_vma's root to locking itself to let it be
> a per anon_vma lock, which would reduce contentions.
> 
> In the same time, lock range becomes quite small then, which is bascially
> a call of anon_vma_interval_tree_insert(). Patch 2 turn rwsem to rwlock_t.
> It's a patch made from Ingo, I just made some change to let it apply based on
> patch 1.
> 
> Patch 3 is from Peter. It was a diff, I edited it to be a patch ;)
> 
> Here is the detailed changed stats with this patch applied. The test base is v3.12-rc7,
> and 1c00bef768d4341afa7d is patch 1, e3e37183ee805f33e88f is patch 2.
> 
> NOTE: both commits are compared to base v3.12-rc7.
> 
>       1c00bef768d4341afa7d      e3e37183ee805f33e88f  
>   ------------------------  ------------------------  
>        +35.0%                    +89.9%               brickland1/micro/aim7/fork_test
>        +28.4%                    +49.3%               lkp-ib03/micro/aim7/fork_test
>         +2.0%                     +2.7%               lkp-ib03/micro/aim7/shared
>         -0.4%                     +0.0%               lkp-sb03/micro/aim7/dbase
>        +16.4%                    +59.0%               lkp-sb03/micro/aim7/fork_test
>         +0.1%                     +0.3%               lkp-sb03/micro/aim7/shared
>         +2.2%                     +5.0%               TOTAL aim7.2000.jobs-per-min

Impressive!

>       1c00bef768d4341afa7d      e3e37183ee805f33e88f  
>   ------------------------  ------------------------  
>        -25.9%      1008.55       -47.3%       717.39  brickland1/micro/aim7/fork_test
>         -1.4%       641.19        -3.4%       628.45  brickland1/micro/hackbench/1600%-process-pipe
>         -1.0%       122.84        +1.1%       125.36  brickland1/micro/netperf/120s-200%-UDP_RR
>         +0.0%       121.29        +0.2%       121.57  lkp-a04/micro/netperf/120s-200%-TCP_SENDFILE
>        -22.1%       351.41       -26.3%       332.54  lkp-ib03/micro/aim7/fork_test
>         -1.9%        31.33        -2.6%        31.11  lkp-ib03/micro/aim7/shared
>         -0.4%       630.36        +0.4%       635.05  lkp-ib03/micro/hackbench/1600%-process-socket
>         -0.0%       612.62        +1.8%       623.80  lkp-ib03/micro/hackbench/1600%-threads-socket
>        -14.1%       340.30       -37.1%       249.26  lkp-sb03/micro/aim7/fork_test
>         -0.1%        41.31        -0.3%        41.22  lkp-sb03/micro/aim7/shared
>         -0.0%       614.26        +0.6%       617.81  lkp-sb03/micro/hackbench/1600%-process-socket
>        -10.4%      4515.47       -18.2%      4123.55  TOTAL time.elapsed_time

Here you scared me for a second with those negative percentages! :-)

>       1c00bef768d4341afa7d      e3e37183ee805f33e88f  
>   ------------------------  ------------------------  
>        +26.7%    323386.33       -75.7%     61980.00  brickland1/micro/aim7/fork_test
>        -22.9%     67734.00       -64.1%     31531.33  brickland1/micro/aim7/shared
>         +0.4%      3303.67        -0.8%      3264.33  brickland1/micro/dbench/100%
>         +0.7%   1871483.67        -0.4%   1850846.00  brickland1/micro/netperf/120s-200%-TCP_MAERTS
>         -1.0%    109553.00        +0.4%    111038.67  brickland1/micro/pigz/100%
>         -0.7%     13600.67        +0.1%     13718.67  lkp-a04/micro/netperf/120s-200%-TCP_CRR
>         -4.6%    995898.00       -85.2%    154621.40  lkp-ib03/micro/aim7/fork_test
>        -31.8%     32178.00       -50.3%     23442.67  lkp-ib03/micro/aim7/shared
>         +1.1%   7466432.67        -0.7%   7334831.67  lkp-ib03/micro/hackbench/1600%-threads-pipe
>         +2.5%   1044936.33        -1.3%   1006084.00  lkp-ib03/micro/hackbench/1600%-threads-socket
>         -1.3%   5635979.00        +0.2%   5721011.67  lkp-ib03/micro/netperf/120s-200%-TCP_RR
>        -24.3%     42853.33       -56.8%     24484.33  lkp-nex04/micro/aim7/shared
>        -23.3%    754297.67       -83.2%    165479.00  lkp-sb03/micro/aim7/fork_test
>         -7.4%     21586.00       -24.1%     17698.33  lkp-sb03/micro/aim7/shared
>         +1.1%   3838724.00        +0.3%   3808206.67  lkp-sb03/micro/hackbench/1600%-process-pipe
>         +0.8%   5143255.00        -1.1%   5046716.67  lkp-sb03/micro/hackbench/1600%-threads-pipe
>         +2.8%    537048.67        -0.8%    518351.67  lkp-sb03/micro/hackbench/1600%-threads-socket
>         +4.0%     50446.67        -5.3%     45960.00  lkp-sb03/micro/netperf/120s-200%-TCP_MAERTS
>        -42.0%     52693.00       -26.4%     66849.67  lkp-sb03/micro/netperf/120s-200%-TCP_STREAM
>         -0.6%  28005389.67        -7.7%  26006116.73  TOTAL vmstat.system.cs

looks like a win all across, with a few below 1% regressions what 
might be statistical outliners - it's hard to tell without a stddev 
column ...

>       1c00bef768d4341afa7d      e3e37183ee805f33e88f  
>   ------------------------  ------------------------  
>         -4.7%        82.00       -98.8%         1.00  brickland1/micro/aim7/fork_test
>        -20.5%        48.33       -94.1%         3.60  lkp-ib03/micro/aim7/fork_test
>        -21.2%        36.00       -89.8%         4.67  lkp-sb03/micro/aim7/fork_test
>        -13.6%       166.33       -95.2%         9.27  TOTAL vmstat.cpu.id
> 
>       1c00bef768d4341afa7d      e3e37183ee805f33e88f  
>   ------------------------  ------------------------  
>        +33.3%        16.00      +705.6%        96.67  brickland1/micro/aim7/fork_test
>        +19.6%        59.00       +78.4%        88.00  lkp-sb03/micro/aim7/fork_test
>        +22.3%        75.00      +201.1%       184.67  TOTAL vmstat.cpu.sy

So idle time goes down, system time goes up - we exchange 
context-switch related idle time with spinning on an rwlock.

Btw., another _really_ interesting comparison would be against the 
latest rwsem patches. Mind doing such a comparison?

Thanks,

	Ingo
