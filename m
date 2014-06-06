Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbaFFMT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 08:19:26 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:57978 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbaFFMTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 08:19:25 -0400
X-Nat-Received: from [202.181.97.72]:59536 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1402057163.21672
To: david@fromorbit.com
Cc: rientjes@google.com, Motohiro.Kosaki@us.fujitsu.com, riel@redhat.com,
        kosaki.motohiro@jp.fujitsu.com, fengguang.wu@intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org,
        hch@infradead.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] mm/vmscan: Do not block forever atshrink_inactive_list().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <6B2BA408B38BA1478B473C31C3D2074E31D59D8673@SV-EXCHANGE1.Corp.FC.LOCAL>
	<201405262045.CDG95893.HLFFOSFMQOVOJt@I-love.SAKURA.ne.jp>
	<alpine.DEB.2.02.1406031442170.19491@chino.kir.corp.google.com>
	<201406052145.CIB35534.OQLVMSJFOHtFOF@I-love.SAKURA.ne.jp>
	<20140605131753.GD4523@dastard>
In-Reply-To: <20140605131753.GD4523@dastard>
Message-Id: <201406062119.HHJ30796.FtLFOSFJOOVQMH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 6 Jun 2014 21:19:22 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 06062014 #8155937, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> On Thu, Jun 05, 2014 at 09:45:26PM +0900, Tetsuo Handa wrote:
> > This means that, under rare circumstances, it is possible that all processes
> > other than kswapd are trapped into too_many_isolated()/congestion_wait() loop
> > while kswapd is sleeping because this loop assumes that somebody else shall
> > wake up kswapd and kswapd shall perform operations for making
> > too_many_isolated() to return 0. However, we cannot guarantee that kswapd is
> > waken by somebody nor kswapd is not blocked by blocking operations inside
> > shrinker functions (e.g. mutex_lock()).
> 
> So what you are saying is that kswapd is having problems with
> getting blocked on locks held by processes in direct reclaim?
> 
> What are the stack traces that demonstrate such a dependency loop?

If a normal task's GFP_KERNEL memory allocation called a shrinker function and
the shrinker function does GFP_WAIT-able allocation with a mutex held, there
is a possibility that kswapd is waken up due to GFP_WAIT-able allocation and
kswapd calls the shrinker function, and the kswapd is blocked at trying to
hold the same mutex inside the shrinker function, isn't it?

Since ttm_dma_pool_shrink_count()/ttm_dma_pool_shrink_scan() holds a mutex
and ttm_dma_pool_shrink_scan() does GFP_WAIT-able allocation, I think such
a dependency loop is possible.
