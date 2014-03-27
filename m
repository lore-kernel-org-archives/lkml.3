Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbaC0AHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 20:07:19 -0400
Received: from smtprelay0032.hostedemail.com ([216.40.44.32]:51315 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753291AbaC0AHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 20:07:14 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:966:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:4385:4605:5007:6119:7652:7903:10004:10400:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12740:13161:13229:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sheet62_791c2f667301a
X-Filterd-Recvd-Size: 3694
Message-ID: <1395878830.3726.55.camel@joe-AO722>
Subject: Re: [PATCH] mm: convert some level-less printks to pr_*
From: Joe Perches <joe@perches.com>
To: Mitchel Humpherys <mitchelh@codeaurora.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Wed, 26 Mar 2014 17:07:10 -0700
In-Reply-To: <1395877783-18910-2-git-send-email-mitchelh@codeaurora.org>
References: <1395877783-18910-1-git-send-email-mitchelh@codeaurora.org>
	 <1395877783-18910-2-git-send-email-mitchelh@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-26 at 16:49 -0700, Mitchel Humpherys wrote:
> printk is meant to be used with an associated log level. There are some
> instances of printk scattered around the mm code where the log level is
> missing. Add a log level and adhere to suggestions by
> scripts/checkpatch.pl by moving to the pr_* macros.

There are some defects in this patch:
Conversions of printk to pr_info that should be pr_cont.

I've also got some other trivial comments about it.

For each file modified, if it's not already there,
please add before any #include

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

[]

> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
[]
> @@ -2751,7 +2752,7 @@ void __init numa_policy_init(void)
>  		node_set(prefer, interleave_nodes);
>  
>  	if (do_set_mempolicy(MPOL_INTERLEAVE, 0, &interleave_nodes))
> -		printk("numa_policy_init: interleaving failed\n");
> +		pr_warn("numa_policy_init: interleaving failed\n");

That seems more like pr_err to me.

Also please remove embedded function names and use
"%s: ", __func__

> @@ -3237,7 +3238,7 @@ static struct notifier_block reserve_mem_nb = {
>  static int __meminit init_reserve_notifier(void)
>  {
>  	if (register_hotmemory_notifier(&reserve_mem_nb))
> -		printk("Failed registering memory add/remove notifier for admin reserve");
> +		pr_info("Failed registering memory add/remove notifier for admin reserve");

Another more likely pr_err
Also missing a "\n" terminating newline

> diff --git a/mm/nommu.c b/mm/nommu.c
[]
> @@ -1241,7 +1242,7 @@ error_free:
>  	return ret;
>  
>  enomem:
> -	printk("Allocation of length %lu from process %d (%s) failed\n",
> +	pr_warn("Allocation of length %lu from process %d (%s) failed\n",
>  	       len, current->pid, current->comm);

pr_err

> diff --git a/mm/slub.c b/mm/slub.c
[]
> @@ -1774,15 +1775,15 @@ static inline void note_cmpxchg_failure(const char *n,
>  
>  #ifdef CONFIG_PREEMPT
>  	if (tid_to_cpu(tid) != tid_to_cpu(actual_tid))
> -		printk("due to cpu change %d -> %d\n",
> +		pr_info("due to cpu change %d -> %d\n",
>  			tid_to_cpu(tid), tid_to_cpu(actual_tid));

This should be pr_cont

>  	else
>  #endif
>  	if (tid_to_event(tid) != tid_to_event(actual_tid))
> -		printk("due to cpu running other code. Event %ld->%ld\n",
> +		pr_info("due to cpu running other code. Event %ld->%ld\n",

pr_cont

>  			tid_to_event(tid), tid_to_event(actual_tid));
>  	else
> -		printk("for unknown reason: actual=%lx was=%lx target=%lx\n",
> +		pr_info("for unknown reason: actual=%lx was=%lx target=%lx\n",

pr_cont

>  			actual_tid, tid, next_tid(tid));
>  #endif
>  	stat(s, CMPXCHG_DOUBLE_CPU_FAIL);


