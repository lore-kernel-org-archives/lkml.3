Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbaG3GvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 02:51:25 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:46546 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752052AbaG3GvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 02:51:24 -0400
X-IronPort-AV: E=Sophos;i="5.00,993,1396972800"; 
   d="scan'208";a="33949723"
Message-ID: <53D89639.5080405@cn.fujitsu.com>
Date: Wed, 30 Jul 2014 14:52:41 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: <linux-kernel@vger.kernel.org>, <mingo@kernel.org>, <dipankar@in.ibm.com>,
        <akpm@linux-foundation.org>, <mathieu.desnoyers@efficios.com>,
        <josh@joshtriplett.org>, <tglx@linutronix.de>, <peterz@infradead.org>,
        <rostedt@goodmis.org>, <dhowells@redhat.com>, <edumazet@google.com>,
        <dvhart@linux.intel.com>, <fweisbec@gmail.com>, <oleg@redhat.com>,
        <bobby.prani@gmail.com>
Subject: Re: [PATCH RFC tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
References: <20140728225556.GA19493@linux.vnet.ibm.com> <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
In-Reply-To: <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2014 06:56 AM, Paul E. McKenney wrote:

> +		/*
> +		 * Each pass through the following loop scans the list
> +		 * of holdout tasks, removing any that are no longer
> +		 * holdouts.  When the list is empty, we are done.
> +		 */
> +		while (!list_empty(&rcu_tasks_holdouts)) {
> +			schedule_timeout_interruptible(HZ / 10);
> +			flush_signals(current);
> +			rcu_read_lock();
> +			list_for_each_entry_rcu(t, &rcu_tasks_holdouts,
> +						rcu_tasks_holdout_list) {
> +				if (smp_load_acquire(&t->rcu_tasks_holdout))
> +					continue;
> +				list_del_init(&t->rcu_tasks_holdout_list);
> +				/* @@@ need to check for usermode on CPU. */
> +			}
> +			rcu_read_unlock();

Maybe I missed something. The task @t may already exited and we access to
the stale memory here if without patch 8/9.
