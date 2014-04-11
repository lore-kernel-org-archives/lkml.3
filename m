Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbaDKRrC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 13:47:02 -0400
Received: from smtprelay0016.hostedemail.com ([216.40.44.16]:41954 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751060AbaDKRrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 13:47:01 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3871:3872:4250:4321:5007:6119:7652:7903:10004:10400:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: offer66_3cebbc8676511
X-Filterd-Recvd-Size: 2003
Message-ID: <1397238417.7113.29.camel@joe-AO722>
Subject: Re: [PATCH 2/3] sched,numa: retry placement more frequently when
 misplaced
From: Joe Perches <joe@perches.com>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, peterz@infradead.org,
        chegu_vinod@hp.com, mgorman@suse.de
Date: Fri, 11 Apr 2014 10:46:57 -0700
In-Reply-To: <1397235629-16328-3-git-send-email-riel@redhat.com>
References: <1397235629-16328-1-git-send-email-riel@redhat.com>
	 <1397235629-16328-3-git-send-email-riel@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-11 at 13:00 -0400, riel@redhat.com wrote:
> This patch reduces the interval at which migration is retried,
> when the task's numa_scan_period is small.

More style trivia and a question.

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
[]
> @@ -1326,12 +1326,15 @@ static int task_numa_migrate(struct task_struct *p)
>  /* Attempt to migrate a task to a CPU on the preferred node. */
>  static void numa_migrate_preferred(struct task_struct *p)
>  {
> +	unsigned long interval = HZ;

Perhaps it'd be better without the unnecessary initialization.

>  	/* This task has no NUMA fault statistics yet */
>  	if (unlikely(p->numa_preferred_nid == -1 || !p->numa_faults_memory))
>  		return;
>  
>  	/* Periodically retry migrating the task to the preferred node */
> -	p->numa_migrate_retry = jiffies + HZ;
> +	interval = min(interval, msecs_to_jiffies(p->numa_scan_period) / 16);

and use

	interval = min_t(unsigned long, HZ,
			 msecs_to_jiffies(p->numa_scan_period) / 16);


btw; why 16?

Can msecs_to_jiffies(p->numa_scan_period) ever be < 16?


