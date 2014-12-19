Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbaLSI2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 03:28:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:17460 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbaLSI2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 03:28:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,605,1413270000"; 
   d="scan'208";a="656975469"
Date: Fri, 19 Dec 2014 08:29:56 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: sched: odd values for effective load calculations
Message-ID: <20141219002956.GA25405@intel.com>
References: <547E42F7.5070105@gmail.com>
 <20141213083012.GH32572@gmail.com>
 <20141215121227.GZ29390@twins.programming.kicks-ass.net>
 <548FBA62.5090603@oracle.com>
 <20141216020948.GA6399@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141216020948.GA6399@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 10:09:48AM +0800, Yuyang Du wrote:
> 
> Sasha, it might be helpful to see this_load is from:
> 
> this_load1: this_load = target_load(this_cpu, idx);
> 
> or
> 
> this_load2: this_load += effective_load(tg, this_cpu, -weight, -weight);
> 
> It really does not seem to be this_load1, while the calc of effective_load is a bit
> complicated to see what the problem is.

Hi all,

I finally managed to reproduce this, but not by trinity, just by keeping rebooting.

Indeed, the problem is from:

this_load2: this_load += effective_load(tg, this_cpu, -weight, -weight);

After digging into effective_load(), the root cause is:

wl = (w * tg->shares) / W;

if we have negative w, then it will be cast to unsigned long, and then may or may not
overflow, and end up an insane number.

I tried this in userspace, interestingly if we have:

wl = w * tg->shares;
wl /= W;

the result is ok, but not ok with the lines combined as the original one.

Anyway, the following patch can fix this.

---
Subject: [PATCH] sched: Fix long and unsigned long multiplication error in
 effective_load

In effective_load, we have (long w * unsigned long tg->shares) / long W,
when w is negative, it is cast to unsigned long and hence the product is
insanely large. Fix this by casting tg->shares to long.

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Yuyang Du <yuyang.du@intel.com>
---
 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index df2cdf7..6b99659 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4424,7 +4424,7 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
 		 * wl = S * s'_i; see (2)
 		 */
 		if (W > 0 && w < W)
-			wl = (w * tg->shares) / W;
+			wl = (w * (long)tg->shares) / W;
 		else
 			wl = tg->shares;
 
-- 
