Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab3GHO0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 10:26:44 -0400
Received: from mail.windriver.com ([147.11.1.11]:48927 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab3GHO0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 10:26:43 -0400
Date: Mon, 8 Jul 2013 10:26:05 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Chen Gang <gang.chen@asianux.com>
CC: <lig.fnst@cn.fujitsu.com>, <chuansheng.liu@intel.com>,
        Wang YanQing <udknight@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/smp.c: free related resources when failure occurs
 in hotplug_cfd()
Message-ID: <20130708142605.GA2786@windriver.com>
References: <51DA7D50.8010209@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <51DA7D50.8010209@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[[PATCH] kernel/smp.c: free related resources when failure occurs in hotplug_cfd()] On 08/07/2013 (Mon 16:50) Chen Gang wrote:

> When failure occurs in hotplug_cfd(), need release related resources,
> or will cause memory leak.
> 
> Also beautify the related code.

No.  Please do not mix real fixes with trivial whitespace changes.
It makes it harder for the reviewer to find the actual fix, and it
makes the fix less portable to other releases (i.e. stable trees.)

Also, you say "beautify", but that is a matter of opinion.  You
shuffle around the tabs in your whitespace change, and yet even
then you don't manage to adapt it to the general coding style of
having multi-line args align with where the 1st arg starts.  So
you have done nothing but pollute the "git blame" history of that
file for other users.

You might want to slow down on the quantity of patches you send,
and spend more time reading the comments from other people on
reviewed patches and learning some of the implicit requirements
from those.  I've noticed that you are already dangerously close
to annoying several key subsystem maintainers, and that is not
the right long term approach to working with the linux community.

Paul.
--

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
> -- 
> 1.7.7.6
