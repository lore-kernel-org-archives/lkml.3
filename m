Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628AbaFEMpe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 08:45:34 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:50725 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbaFEMpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 08:45:32 -0400
X-Nat-Received: from [202.181.97.72]:51650 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1401972328.29205
To: rientjes@google.com, Motohiro.Kosaki@us.fujitsu.com
Cc: david@fromorbit.com, riel@redhat.com, kosaki.motohiro@jp.fujitsu.com,
        fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com,
        akpm@linux-foundation.org, hch@infradead.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] mm/vmscan: Do not block forever at shrink_inactive_list().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20140520063024.GH18954@dastard>
	<201405202358.ADF10119.SMOFOQLFtOVHJF@I-love.SAKURA.ne.jp>
	<6B2BA408B38BA1478B473C31C3D2074E31D59D8673@SV-EXCHANGE1.Corp.FC.LOCAL>
	<201405262045.CDG95893.HLFFOSFMQOVOJt@I-love.SAKURA.ne.jp>
	<alpine.DEB.2.02.1406031442170.19491@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1406031442170.19491@chino.kir.corp.google.com>
Message-Id: <201406052145.CIB35534.OQLVMSJFOHtFOF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 5 Jun 2014 21:45:26 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 04062014 #8144375, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Rientjes wrote:
> On Mon, 26 May 2014, Tetsuo Handa wrote:
> 
> > In shrink_inactive_list(), we do not insert delay at
> > 
> >   if (!sc->hibernation_mode && !current_is_kswapd())
> >     wait_iff_congested(zone, BLK_RW_ASYNC, HZ/10);
> > 
> > if sc->hibernation_mode != 0.
> > Follow the same reason, we should not insert delay at
> > 
> >   while (unlikely(too_many_isolated(zone, file, sc))) {
> >     congestion_wait(BLK_RW_ASYNC, HZ/10);
> > 
> >     /* We are about to die and free our memory. Return now. */
> >     if (fatal_signal_pending(current))
> >       return SWAP_CLUSTER_MAX;
> >   }
> > 
> > if sc->hibernation_mode != 0.
> > 
> > Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > ---
> >  mm/vmscan.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 32c661d..89c42ca 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -1362,6 +1362,9 @@ static int too_many_isolated(struct zone *zone, int file,
> >  	if (current_is_kswapd())
> >  		return 0;
> >  
> > +	if (sc->hibernation_mode)
> > +		return 0;
> > +
> >  	if (!global_reclaim(sc))
> >  		return 0;
> >  
> 
> This isn't the only too_many_isolated() functions that do a delay, how is 
> the too_many_isolated() in mm/compaction.c different?
> 

I don't know. But today I realized that this patch is not sufficient.

I'm trying to find why __alloc_pages_slowpath() cannot return for many minutes
when a certain type of memory pressure is given on a RHEL7 environment with
4 CPU / 2GB RAM. Today I tried to use ftrace for examining the breakdown of
time-consuming functions inside __alloc_pages_slowpath(). But on the first run,
all processes are trapped into this too_many_isolated()/congestion_wait() loop
while kswapd is not running; stalling forever because nobody can perform
operations for making too_many_isolated() to return 0.

This means that, under rare circumstances, it is possible that all processes
other than kswapd are trapped into too_many_isolated()/congestion_wait() loop
while kswapd is sleeping because this loop assumes that somebody else shall
wake up kswapd and kswapd shall perform operations for making
too_many_isolated() to return 0. However, we cannot guarantee that kswapd is
waken by somebody nor kswapd is not blocked by blocking operations inside
shrinker functions (e.g. mutex_lock()).

We need some more changes. I'm thinking memory allocation watchdog thread.
Add an "unsigned long" field to "struct task_struct", set jiffies to the field
upon entry of GFP_WAIT-able memory allocation attempts, and clear the field
upon returning from GFP_WAIT-able memory allocation attempts. A kernel thread
periodically scans task list and compares the field and jiffies, and (at least)
print warning messages (maybe optionally trigger OOM-killer or kernel panic)
if single memory allocation attempt is taking too long (e.g. 60 seconds).
What do you think?
