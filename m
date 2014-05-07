Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbaEGVee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:34:34 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:42584 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbaEGVec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:34:32 -0400
Date: Wed, 7 May 2014 14:34:26 -0700
From: josh@joshtriplett.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 19/45] rcutorture: Print negatives for
 SRCU counter wraparound
Message-ID: <20140507213426.GK27924@cloud>
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1398731133-18925-19-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398731133-18925-19-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 05:25:07PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> The srcu_torture_stats() function prints SRCU's per-CPU c[] array with
> an unsigned format, which means that the number one less than zero is
> a very large number.  This commit therefore prints this array with a
> signed format in order to improve readability of the rcutorture output.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Nit below; with that:
Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  kernel/rcu/rcutorture.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
> index 3845ea99ccd4..0141fcff6bb9 100644
> --- a/kernel/rcu/rcutorture.c
> +++ b/kernel/rcu/rcutorture.c
> @@ -486,15 +486,16 @@ static void srcu_torture_barrier(void)
>  
>  static void srcu_torture_stats(char *page)
>  {
> +	long c0, c1;
>  	int cpu;
>  	int idx = srcu_ctl.completed & 0x1;
>  
>  	page += sprintf(page, "%s%s per-CPU(idx=%d):",
>  		       torture_type, TORTURE_FLAG, idx);
>  	for_each_possible_cpu(cpu) {
> -		page += sprintf(page, " %d(%lu,%lu)", cpu,
> -			       per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[!idx],
> -			       per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[idx]);
> +		c0 = (long)per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[!idx];
> +		c1 = (long)per_cpu_ptr(srcu_ctl.per_cpu_ref, cpu)->c[idx];
> +		page += sprintf(page, " %d(%ld,%ld)", cpu, c0, c1);

Nit: I'd suggest declaring the variables inside the loop, or not using
intermediate variables at all.

- Josh Triplett
