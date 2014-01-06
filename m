Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaAFHKN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 02:10:13 -0500
Received: from mga03.intel.com ([143.182.124.21]:23881 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbaAFHKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 02:10:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,611,1384329600"; 
   d="scan'208";a="454122160"
Date: Mon, 6 Jan 2014 15:10:07 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@linux.intel.com
Subject: Re: [sched] 23f0d2093c: -12.6% regression on sparse file copy
Message-ID: <20140106071007.GB23042@localhost>
References: <20140105090456.GE28257@localhost>
 <20140106003052.GD696@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140106003052.GD696@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joonsoo,

On Mon, Jan 06, 2014 at 09:30:52AM +0900, Joonsoo Kim wrote:
> On Sun, Jan 05, 2014 at 05:04:56PM +0800, fengguang.wu@intel.com wrote:
> > Hi Joonsoo,
> > 
> > We noticed the below changes for commit 23f0d2093c ("sched: Factor out
> > code to should_we_balance()") in test vm-scalability/300s-lru-file-readtwice
> 
> Hello, Fengguang.
> 
> There was a mistake in this patch and there was a fix and it was already merged
> into mainline.
> 
> Could you test again with the commit (b0cff9d sched: Fix load balancing
> performance regression in should_we_balance())?

Yes, b0cff9d completely restores the performance. Sorry for the noise!

Thanks,
Fengguang

> > 
> >         95a79b805b935f4  23f0d2093c789e612185180c4
> >         ---------------  -------------------------
> > ==>           4.45 ~ 5%   +1777.7%      83.60 ~ 5%  vm-scalability.stddev
> > ==>       14966511 ~ 0%     -12.6%   13084545 ~ 2%  vm-scalability.throughput
> >                 38 ~ 9%    +406.3%        193 ~ 7%  proc-vmstat.kswapd_low_wmark_hit_quickly
> >             610823 ~ 0%     -41.4%     357990 ~ 0%  softirqs.SCHED
> >          5.424e+08 ~ 0%     -38.5%  3.338e+08 ~ 6%  proc-vmstat.pgdeactivate
> >           4.68e+08 ~ 0%     -37.5%  2.924e+08 ~ 6%  proc-vmstat.pgrefill_normal
> >          5.549e+08 ~ 0%     -37.1%  3.491e+08 ~ 6%  proc-vmstat.pgactivate
> >           14938509 ~ 1%     +27.0%   18974176 ~ 1%  vmstat.memory.free
> >             978771 ~ 1%     +23.9%    1212704 ~ 3%  numa-vmstat.node2.nr_free_pages
> >            3747434 ~ 0%     +21.7%    4560196 ~ 2%  proc-vmstat.nr_free_pages
> > ==>      1.353e+08 ~ 0%     +18.8%  1.607e+08 ~ 0%  proc-vmstat.numa_foreign
> >          1.353e+08 ~ 0%     +18.8%  1.607e+08 ~ 0%  proc-vmstat.numa_miss
> >          1.353e+08 ~ 0%     +18.8%  1.607e+08 ~ 0%  proc-vmstat.numa_other
> >            3936842 ~ 1%     +22.2%    4812045 ~ 4%  numa-meminfo.node2.MemFree
> >           21803812 ~ 0%     +17.7%   25661536 ~ 4%  numa-vmstat.node3.numa_foreign
> >           73701524 ~ 0%     +15.0%   84769542 ~ 0%  proc-vmstat.pgscan_direct_dma32
> >           73700683 ~ 0%     +15.0%   84768687 ~ 0%  proc-vmstat.pgsteal_direct_dma32
> >          3.101e+08 ~ 0%     +11.2%  3.448e+08 ~ 0%  proc-vmstat.pgsteal_direct_normal
> >          3.103e+08 ~ 0%     +11.2%  3.449e+08 ~ 0%  proc-vmstat.pgscan_direct_normal
> >           45613907 ~ 0%     +12.6%   51342974 ~ 3%  numa-vmstat.node0.numa_other
> >             795639 ~ 0%     -48.6%     409113 ~13%  time.voluntary_context_switches
> >                375 ~ 0%      +6.1%        398 ~ 0%  time.elapsed_time
> >               9427 ~ 0%      -5.8%       8880 ~ 0%  time.percent_of_cpu_this_job_got
> > 
> > The test case basically does
> > 
> > for i in `seq 1 $nr_cpu`
> > do      
> >         create_sparse_file huge-$i
> >         dd if=huge-$i of=/dev/null &
> >         dd if=huge-$i of=/dev/null &
> > done
> > 
> > where nr_cpu=120 (test box is a 4-socket ivybridge system).
> > 
> > The change looks stable, each point below is a sample run:
> > 
> >                                vm-scalability.stddev
> > 
> >    120 ++-------------------------------------------------------------------+
> >        |                                                                    |
> >    100 ++             *            *                                        |
> >        | *.***        :    **      :     *    *  *     *     *              |
> >        **     * *.** * :  *  :*.*  :: .* :   : * :*   * :  .* :   .*   * .**|
> >     80 ++      *    *  *. :  *   *: ** : ::  :  *  :.*  * *   * ** :   :*   *
> >        |                 *        *     : ***      *     *     *    :**     |
> >     60 ++                               *                           *       |
> >        |                                                                    |
> >     40 ++                                                                   |
> >        |                                                                    |
> >        |                                                                    |
> >     20 ++                                                                   |
> >        | O  OO OO OOO  O OO  O                                              |
> >      0 OO--O--O------OO----OO-----------------------------------------------+
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
