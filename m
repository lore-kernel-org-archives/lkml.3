Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaFECdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 22:33:45 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:56768 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaFECdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 22:33:43 -0400
Date: Thu, 5 Jun 2014 10:33:34 +0800
From: Shaohua Li <shli@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Matias =?iso-8859-1?Q?Bj=F8rling?= <m@bjorling.me>,
        "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: per-cpu counters for in-flight IO accounting
Message-ID: <20140605023334.GB22826@kernel.org>
References: <1399627061-5960-2-git-send-email-m@bjorling.me>
 <536CE25C.5040107@kernel.dk>
 <536D0537.7010905@kernel.dk>
 <20140530121119.GA1637@kernel.org>
 <53888C80.2020206@kernel.dk>
 <20140604103901.GA14383@kernel.org>
 <CAOu_J6nRZuktyozjychkLOA+1zwct2+7KPUxfNAghVOOOBfi+g@mail.gmail.com>
 <538F7CCE.3050508@kernel.dk>
 <20140605020934.GB13953@kernel.org>
 <538FD300.7010706@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <538FD300.7010706@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 08:16:32PM -0600, Jens Axboe wrote:
> On 2014-06-04 20:09, Shaohua Li wrote:
> >On Wed, Jun 04, 2014 at 02:08:46PM -0600, Jens Axboe wrote:
> >>On 06/04/2014 05:29 AM, Matias Bjørling wrote:
> >>>It's in
> >>>
> >>>blk_io_account_start
> >>>   part_round_stats
> >>>     part_round_state_single
> >>>       part_in_flight
> >>>
> >>>I like the granularity idea.
> >>
> >>And similarly from blk_io_account_done() - which makes it even worse,
> >>since it at both ends of the IO chain.
> >
> >But part_round_state_single is supposed to only call part_in_flight every
> >jiffery. Maybe we need something below:
> >1. set part->stamp immediately
> >2. fixed granularity
> >Untested though.
> >
> >
> >diff --git a/block/blk-core.c b/block/blk-core.c
> >index 40d6548..5f0acaa 100644
> >--- a/block/blk-core.c
> >+++ b/block/blk-core.c
> >@@ -1270,17 +1270,19 @@ static void part_round_stats_single(int cpu, struct hd_struct *part,
> >  				    unsigned long now)
> >  {
> >  	int inflight;
> >+	unsigned long old_stamp;
> >
> >-	if (now == part->stamp)
> >+	if (time_before(now, part->stamp + msecs_to_jiffies(10)))
> >  		return;
> >+	old_stamp = part->stamp;
> >+	part->stamp = now;
> >
> >  	inflight = part_in_flight(part);
> >  	if (inflight) {
> >  		__part_stat_add(cpu, part, time_in_queue,
> >-				inflight * (now - part->stamp));
> >-		__part_stat_add(cpu, part, io_ticks, (now - part->stamp));
> >+				inflight * (now - old_stamp));
> >+		__part_stat_add(cpu, part, io_ticks, (now - old_stamp));
> >  	}
> >-	part->stamp = now;
> >  }
> >
> >  /**
> 
> It'd be a good improvement, and one we should be able to do without
> screwing anything up. It'd be identical to anyone running at HZ==100
> right now.
> 
> So the above we can easily do, and arguably should just do. We wont
> see real scaling in the IO stats path before we fixup the hd_struct
> referencing as well, however.

That's true. maybe a percpu_ref works here.

Thanks,
Shaohua
