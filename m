Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068AbaJUOca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 10:32:30 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59037 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702AbaJUOc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 10:32:28 -0400
Date: Tue, 21 Oct 2014 16:32:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, pjt@google.com,
        bsegall@google.com, arjan.van.de.ven@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        fengguang.wu@intel.com
Subject: Re: [RESEND PATCH 2/3 v5] sched: Rewrite per entity runnable load
 average tracking
Message-ID: <20141021143221.GZ23531@worktop.programming.kicks-ass.net>
References: <1412907717-2871-1-git-send-email-yuyang.du@intel.com>
 <1412907717-2871-3-git-send-email-yuyang.du@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412907717-2871-3-git-send-email-yuyang.du@intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 10:21:56AM +0800, Yuyang Du wrote:
> +static __always_inline u64 decay_load(u64 val, u64 n)
> +{
> +	if (likely(val <= UINT_MAX))
> +		return decay_load32(val, n);
> +
> +	return mul_u64_u32_shr(val, decay_load32(1 << 15, n), 15);
> +}

This still doesn't make any sense, why not put that mul_u64_u32_shr()
into decay_load() and be done with it?

---
 kernel/sched/fair.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b78280c59b46..67c08d4a3df8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2231,9 +2231,8 @@ static __always_inline u64 decay_load(u64 val, u64 n)
 		local_n %= LOAD_AVG_PERIOD;
 	}
 
-	val *= runnable_avg_yN_inv[local_n];
-	/* We don't use SRR here since we always want to round down. */
-	return val >> 32;
+	val = mul_u64_u32_shr(val, runnable_avg_yN_inv[local_n], 32);
+	return val;
 }
 
 /*
