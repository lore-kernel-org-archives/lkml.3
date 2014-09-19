Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932421AbaISU6G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 16:58:06 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:37593 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195AbaISU6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 16:58:04 -0400
X-Originating-IP: 173.246.103.110
Date: Fri, 19 Sep 2014 13:57:54 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] rcu: Change use of __this_cpu ops on a bool type
Message-ID: <20140919205754.GE26432@jtriplet-mobl1>
References: <1411147563-9136-1-git-send-email-bobby.prani@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411147563-9136-1-git-send-email-bobby.prani@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 01:26:03PM -0400, Pranith Kumar wrote:
> __this_cpu_{read/write}() uses sizeof() to determine the size of the variable.
> Using this operation on a bool type causes sparse to complain.
> 
> I checked the generated code and there is only a slight difference in
> instructions generated.
> 
> I am not sure this warning by sparse is really valid, but let us silence it
> anyways.
> 
> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>

I believe this warning was actually fixed with current versions of
Sparse; there was some discussion and a patch on the linux-sparse
mailing list.  Can you please recheck with the latest Sparse from git,
and if it still breaks, please raise that on linux-sparse?

>  kernel/rcu/tree.c        | 12 ++++++++----
>  kernel/rcu/tree_plugin.h |  6 ++++--
>  2 files changed, 12 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index bc085e5..85f228a 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -186,21 +186,25 @@ static int rcu_gp_in_progress(struct rcu_state *rsp)
>   */
>  void rcu_sched_qs(void)
>  {
> -	if (!__this_cpu_read(rcu_sched_data.passed_quiesce)) {
> +	struct rcu_data *rdp = __this_cpu_ptr(&rcu_sched_data);
> +
> +	if (!rdp->passed_quiesce) {
>  		trace_rcu_grace_period(TPS("rcu_sched"),
>  				       __this_cpu_read(rcu_sched_data.gpnum),
>  				       TPS("cpuqs"));
> -		__this_cpu_write(rcu_sched_data.passed_quiesce, 1);
> +		rdp->passed_quiesce = true;
>  	}
>  }
>  
>  void rcu_bh_qs(void)
>  {
> -	if (!__this_cpu_read(rcu_bh_data.passed_quiesce)) {
> +	struct rcu_data *rdp = __this_cpu_ptr(&rcu_bh_data);
> +
> +	if (!rdp->passed_quiesce) {
>  		trace_rcu_grace_period(TPS("rcu_bh"),
>  				       __this_cpu_read(rcu_bh_data.gpnum),
>  				       TPS("cpuqs"));
> -		__this_cpu_write(rcu_bh_data.passed_quiesce, 1);
> +		rdp->passed_quiesce = true;
>  	}
>  }
>  
> diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
> index 77f9376..98de303 100644
> --- a/kernel/rcu/tree_plugin.h
> +++ b/kernel/rcu/tree_plugin.h
> @@ -143,11 +143,13 @@ EXPORT_SYMBOL_GPL(rcu_batches_completed);
>   */
>  static void rcu_preempt_qs(void)
>  {
> -	if (!__this_cpu_read(rcu_preempt_data.passed_quiesce)) {
> +	struct rcu_data *rdp = __this_cpu_ptr(&rcu_preempt_data);
> +
> +	if (!rdp->passed_quiesce) {
>  		trace_rcu_grace_period(TPS("rcu_preempt"),
>  				       __this_cpu_read(rcu_preempt_data.gpnum),
>  				       TPS("cpuqs"));
> -		__this_cpu_write(rcu_preempt_data.passed_quiesce, 1);
> +		rdp->passed_quiesce = true;
>  		barrier(); /* Coordinate with rcu_preempt_check_callbacks(). */
>  		current->rcu_read_unlock_special.b.need_qs = false;
>  	}
> -- 
> 2.1.0
> 
