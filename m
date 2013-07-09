Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab3GIAqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 20:46:38 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:41965 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab3GIAqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 20:46:37 -0400
Date: Tue, 9 Jul 2013 08:46:17 +0800
From: Wang YanQing <udknight@gmail.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, lig.fnst@cn.fujitsu.com,
        chuansheng.liu@intel.com, Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] kernel/smp.c: free related resources when failure
 occurs in hotplug_cfd()
Message-ID: <20130709004617.GA3129@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Chen Gang <gang.chen@asianux.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	lig.fnst@cn.fujitsu.com, chuansheng.liu@intel.com,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <51DA7D50.8010209@asianux.com>
 <20130709002830.GA2071@udknight>
 <51DB5A22.9080307@asianux.com>
 <51DB5C99.50405@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51DB5C99.50405@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 08:43:05AM +0800, Chen Gang wrote:
> When failure occurs in hotplug_cfd(), need release related resources,
> or will cause memory leak.
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/smp.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 02a885d..2a3a017 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -49,10 +49,13 @@ hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
>  				cpu_to_node(cpu)))
>  			return notifier_from_errno(-ENOMEM);
>  		if (!zalloc_cpumask_var_node(&cfd->cpumask_ipi, GFP_KERNEL,
> -				cpu_to_node(cpu)))
> +				cpu_to_node(cpu))) {
> +			free_cpumask_var(cfd->cpumask);
>  			return notifier_from_errno(-ENOMEM);
> +		}
>  		cfd->csd = alloc_percpu(struct call_single_data);
>  		if (!cfd->csd) {
> +			free_cpumask_var(cfd->cpumask_ipi);
>  			free_cpumask_var(cfd->cpumask);
>  			return notifier_from_errno(-ENOMEM);
>  		}
> -- 
> 1.7.7.6
Acked-by: Wang YanQing <udknight@gmail.com>
