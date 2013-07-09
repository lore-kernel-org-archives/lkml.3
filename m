Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab3GIA3K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 20:29:10 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:38168 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab3GIA3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 20:29:07 -0400
Date: Tue, 9 Jul 2013 08:28:30 +0800
From: Wang YanQing <udknight@gmail.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, lig.fnst@cn.fujitsu.com,
        chuansheng.liu@intel.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/smp.c: free related resources when failure occurs
 in hotplug_cfd()
Message-ID: <20130709002830.GA2071@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Chen Gang <gang.chen@asianux.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	lig.fnst@cn.fujitsu.com, chuansheng.liu@intel.com,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <51DA7D50.8010209@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DA7D50.8010209@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 04:50:24PM +0800, Chen Gang wrote:
> When failure occurs in hotplug_cfd(), need release related resources,
> or will cause memory leak.
> 
> Also beautify the related code.
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/smp.c |   13 +++++++++----
>  1 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 02a885d..c264623 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -45,15 +45,20 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
>  	switch (action) {
>  	case CPU_UP_PREPARE:
>  	case CPU_UP_PREPARE_FROZEN:
> -		if (!zalloc_cpumask_var_node(&cfd->cpumask, GFP_KERNEL,
> -				cpu_to_node(cpu)))
> +		if (!zalloc_cpumask_var_node(&cfd->cpumask,
> +						GFP_KERNEL, cpu_to_node(cpu)))
>  			return notifier_from_errno(-ENOMEM);

What did you fixed here? code style?
You can drop this part.

> -		if (!zalloc_cpumask_var_node(&cfd->cpumask_ipi, GFP_KERNEL,
> -				cpu_to_node(cpu)))
> +
> +		if (!zalloc_cpumask_var_node(&cfd->cpumask_ipi,
> +						GFP_KERNEL, cpu_to_node(cpu))) {
> +			free_cpumask_var(cfd->cpumask);
>  			return notifier_from_errno(-ENOMEM);
> +		}
> +
>  		cfd->csd = alloc_percpu(struct call_single_data);
>  		if (!cfd->csd) {
>  			free_cpumask_var(cfd->cpumask);
> +			free_cpumask_var(cfd->cpumask_ipi);
>  			return notifier_from_errno(-ENOMEM);
>  		}
>  		break;

Yes, we need this fix.

If you resend the v2, I will give acked-by :)

Thanks.
