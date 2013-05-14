Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab3ENPR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 11:17:59 -0400
Received: from mail-gg0-f182.google.com ([209.85.161.182]:42618 "EHLO
	mail-gg0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab3ENPR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 11:17:57 -0400
Date: Tue, 14 May 2013 08:17:52 -0700
From: Tejun Heo <tj@kernel.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/workqueue.c: better to free related resources
 when failure occurs in wq_numa_init()
Message-ID: <20130514151752.GB6795@mtj.dyndns.org>
References: <51922D30.8000809@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51922D30.8000809@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 08:25:20PM +0800, Chen Gang wrote:
> 
> When NUMA node mapping not available for one cpu, need disabling NUMA
> support and proceed.
> 
> Also better to release unused resources (the original code can not
> cause issue, only waste some memory).
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/workqueue.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 1ae6028..a763079 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -4911,6 +4911,9 @@ static void __init wq_numa_init(void)
>  		if (WARN_ON(node == NUMA_NO_NODE)) {
>  			pr_warn("workqueue: NUMA node mapping not available for cpu%d, disabling NUMA support\n", cpu);
>  			/* happens iff arch is bonkers, let's just proceed */
> +			for_each_node(node)
> +				free_cpumask_var(tbl[node]);
> +			kfree(tbl);

Eh... let's just leave it alone.  The path is taken iff the whole
thing is seriously broken and we're triggering WARN.  I don't think we
need to worry about small memory wastage there.

Thanks.

-- 
tejun
