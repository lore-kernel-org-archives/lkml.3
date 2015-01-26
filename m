Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbbAZJRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 04:17:47 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:41805 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbbAZJRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 04:17:44 -0500
Date: Mon, 26 Jan 2015 10:17:35 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 07/32] s390: use %*pb[l] to print bitmaps including
 cpumasks and nodemasks
Message-ID: <20150126091735.GB4968@osiris>
References: <1422108218-25398-1-git-send-email-tj@kernel.org>
 <1422108218-25398-8-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422108218-25398-8-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012609-0029-0000-0000-0000031897BE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 24, 2015 at 09:03:13AM -0500, Tejun Heo wrote:
> printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
> and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
> respectively which can be used to generate the two printf arguments
> necessary to format the specified cpu/nodemask.
> 
> * Line termination only requires one extra space at the end of the
>   buffer.  Use PAGE_SIZE - 1 instead of PAGE_SIZE - 2 when formatting.
> 
> This patch is dependent on the following two patches.
> 
>  lib/vsprintf: implement bitmap printing through '%*pb[l]'
>  cpumask, nodemask: implement cpumask/nodemask_pr_args()
> 
> Please wait till the forementioned patches are merged to mainline
> before applying to subsystem trees.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  arch/s390/kernel/cache.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/kernel/cache.c b/arch/s390/kernel/cache.c
> index c0b03c2..a026911 100644
> --- a/arch/s390/kernel/cache.c
> +++ b/arch/s390/kernel/cache.c
> @@ -243,9 +243,12 @@ static ssize_t shared_cpu_map_func(struct kobject *kobj, int type, char *buf)
>  	int len;
>  
>  	index = kobj_to_cache_index_dir(kobj);
> -	len = type ?
> -		cpulist_scnprintf(buf, PAGE_SIZE - 2, cpumask_of(index->cpu)) :
> -		cpumask_scnprintf(buf, PAGE_SIZE - 2, cpumask_of(index->cpu));
> +	if (type)
> +		len = scnprintf(buf, PAGE_SIZE - 1, "%*pbl",
> +				cpumask_pr_args(cpumask_of(index->cpu)));
> +	else
> +		len = scnprintf(buf, PAGE_SIZE - 1, "%*pb",
> +				cpumask_pr_args(cpumask_of(index->cpu)));
>  	len += sprintf(&buf[len], "\n");
>  	return len;
>  }

Hi Tejun,

this code will be removed during the next merge window, because we move
s390 to the generic cacheinfo infrastructure in drivers/base/cacheinfo.c.
(see linux-next)
So you can drop this patch.

Thanks,
Heiko

