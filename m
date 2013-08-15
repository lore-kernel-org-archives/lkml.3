Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab3HOLUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 07:20:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50547 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab3HOLUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 07:20:23 -0400
Date: Thu, 15 Aug 2013 13:19:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH v3 2/3] sched: factor out code to should_we_balance()
Message-ID: <20130815111959.GQ24092@twins.programming.kicks-ass.net>
References: <1375778203-31343-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1375778203-31343-3-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375778203-31343-3-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 05:36:42PM +0900, Joonsoo Kim wrote:

Another one of these patches I should stare in more detail at..

>  static int load_balance(int this_cpu, struct rq *this_rq,
>  			struct sched_domain *sd, enum cpu_idle_type idle,
> -			int *balance)
> +			int *should_balance)
>  {
>  	int ld_moved, cur_ld_moved, active_balance = 0;
>  	struct sched_group *group;
> @@ -5073,12 +5070,14 @@ static int load_balance(int this_cpu, struct rq *this_rq,
>  
>  	schedstat_inc(sd, lb_count[idle]);
>  
> -redo:
> -	group = find_busiest_group(&env, balance);
> -
> -	if (*balance == 0)
> +	if (!should_we_balance(&env)) {
> +		*should_balance = 0;
>  		goto out_balanced;
> +	} else
> +		*should_balance = 1;

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5120,11 +5120,8 @@ static int load_balance(int this_cpu, st
 
 	schedstat_inc(sd, lb_count[idle]);
 
-	if (!should_we_balance(&env)) {
-		*should_balance = 0;
+	if (!(*should_balance = should_we_balance(&env)))
 		goto out_balanced;
-	} else
-		*should_balance = 1;
 
 redo:
 	group = find_busiest_group(&env);

