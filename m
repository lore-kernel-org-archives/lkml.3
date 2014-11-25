Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290AbaKYIl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 03:41:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:61651 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaKYIlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 03:41:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="490233586"
Date: Tue, 25 Nov 2014 16:20:59 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Juri Lelli <juri.lelli@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: Re: [PATCH v2] sched/deadline: fix rt runtime corrupt when dl refuse
 a smaller bandwidth
Message-ID: <20141125082057.GA31039@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1416351721-100675-1-git-send-email-wanpeng.li@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416351721-100675-1-git-send-email-wanpeng.li@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping Juri, could you review this one and other dl patches from me? ;-)
On Wed, Nov 19, 2014 at 07:02:01AM +0800, Wanpeng Li wrote:
>Dl class will refuse the bandwidth being set to some value smaller
>than the currently allocated bandwidth in any of the root_domains
>through sched_rt_runtime_us and sched_rt_period_us. RT runtime will
>be set according to sched_rt_runtime_us before dl class verify if
>the new bandwidth is suitable in the case of !CONFIG_RT_GROUP_SCHED.
>
>However, rt runtime will be corrupt if dl refuse the new bandwidth
>since there is no undo to reset the rt runtime to the old value.
>
>This patch fix it by verifying new bandwidth for deadline in advance.
>
>Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
>---
>v1 -> v2:
> * move sched_dl_global_constraints before sched_rt_global_constraints,
>   and change the name of the former to sched_dl_global_validate().
>
> kernel/sched/core.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>
>diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>index 2e7578a..6690778 100644
>--- a/kernel/sched/core.c
>+++ b/kernel/sched/core.c
>@@ -7812,7 +7812,7 @@ static int sched_rt_global_constraints(void)
> }
> #endif /* CONFIG_RT_GROUP_SCHED */
> 
>-static int sched_dl_global_constraints(void)
>+static int sched_dl_global_validate(void)
> {
> 	u64 runtime = global_rt_runtime();
> 	u64 period = global_rt_period();
>@@ -7913,11 +7913,11 @@ int sched_rt_handler(struct ctl_table *table, int write,
> 		if (ret)
> 			goto undo;
> 
>-		ret = sched_rt_global_constraints();
>+		ret = sched_dl_global_validate();
> 		if (ret)
> 			goto undo;
> 
>-		ret = sched_dl_global_constraints();
>+		ret = sched_rt_global_constraints();
> 		if (ret)
> 			goto undo;
> 
>-- 
>1.9.1
