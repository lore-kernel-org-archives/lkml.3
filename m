Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbaGHJA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 05:00:56 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:15677 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753397AbaGHJAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 05:00:54 -0400
X-IronPort-AV: E=Sophos;i="5.00,855,1396972800"; 
   d="scan'208";a="32986876"
Message-ID: <53BBB37F.6030807@cn.fujitsu.com>
Date: Tue, 8 Jul 2014 17:01:51 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: <linux-kernel@vger.kernel.org>, <mingo@kernel.org>, <dipankar@in.ibm.com>,
        <akpm@linux-foundation.org>, <mathieu.desnoyers@efficios.com>,
        <josh@joshtriplett.org>, <niv@us.ibm.com>, <tglx@linutronix.de>,
        <peterz@infradead.org>, <rostedt@goodmis.org>, <dhowells@redhat.com>,
        <edumazet@google.com>, <dvhart@linux.intel.com>, <fweisbec@gmail.com>,
        <oleg@redhat.com>, <sbw@mit.edu>
Subject: Re: [PATCH tip/core/rcu 03/17] signal: Explain local_irq_save() call
References: <20140707223756.GA7187@linux.vnet.ibm.com> <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com> <1404772701-8804-3-git-send-email-paulmck@linux.vnet.ibm.com>
In-Reply-To: <1404772701-8804-3-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2014 06:38 AM, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> The explicit local_irq_save() in __lock_task_sighand() is needed to avoid
> a potential deadlock condition, as noted in a841796f11c90d53 (signal:
> align __lock_task_sighand() irq disabling and RCU).  However, someone
> reading the code might be forgiven for concluding that this separate
> local_irq_save() was completely unnecessary.  This commit therefore adds
> a comment referencing the shiny new block comment on rcu_read_unlock().
> 
> Reported-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Acked-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/signal.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/signal.c b/kernel/signal.c
> index a4077e90f19f..46161e744760 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1263,6 +1263,10 @@ struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
>  	struct sighand_struct *sighand;
>  
>  	for (;;) {
> +		/*
> +		 * Disable interrupts early to avoid deadlocks.
> +		 * See rcu_read_unlock comment header for details.
> +		 */

A pair of brackets are missing here: rcu_read_unlock()
after that, please add:

Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>


It reminds me that I should keep my effort to solve the deadlock
problem where rcu_read_unlock() is overlapped with schedule locks.

>  		local_irq_save(*flags);
>  		rcu_read_lock();
>  		sighand = rcu_dereference(tsk->sighand);

