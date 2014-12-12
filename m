Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030966AbaLLRMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:12:23 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:33547 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030303AbaLLRMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:12:21 -0500
Date: Fri, 12 Dec 2014 12:12:16 -0500
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/5] workqueue: fix memory leak in wq_numa_init()
Message-ID: <20141212171216.GA20020@htj.dyndns.org>
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com>
 <1418379595-6281-2-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418379595-6281-2-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 06:19:51PM +0800, Lai Jiangshan wrote:
> wq_numa_init() will quit directly on some bonkers cases without freeing the
> memory.  Add the missing cleanup code.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Cc: "Gu, Zheng" <guz.fnst@cn.fujitsu.com>
> Cc: tangchen <tangchen@cn.fujitsu.com>
> Cc: Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/workqueue.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 09b685d..a6fd2b8 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -4811,6 +4811,9 @@ static void __init wq_numa_init(void)
>  		if (WARN_ON(node == NUMA_NO_NODE)) {
>  			pr_warn("workqueue: NUMA node mapping not available for cpu%d, disabling NUMA support\n", cpu);
>  			/* happens iff arch is bonkers, let's just proceed */
> +			for_each_node(node)
> +				free_cpumask_var(tbl[node]);
> +			kfree(tbl);

The comment right up there says that this happens if and only if the
arch code is seriously broken and it's consciously skipping exception
handling.  That's a condition where we might as well trigger BUG_ON().
Just leave it alone.

Thanks.

-- 
tejun
