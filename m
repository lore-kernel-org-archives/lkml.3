Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbaHAAw2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 20:52:28 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:36786 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750907AbaHAAw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 20:52:27 -0400
X-IronPort-AV: E=Sophos;i="5.04,239,1406563200"; 
   d="scan'208";a="34041992"
Message-ID: <53DAE512.5030302@cn.fujitsu.com>
Date: Fri, 1 Aug 2014 08:53:38 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: <paulmck@linux.vnet.ibm.com>
CC: <linux-kernel@vger.kernel.org>, <mingo@kernel.org>, <dipankar@in.ibm.com>,
        <akpm@linux-foundation.org>, <mathieu.desnoyers@efficios.com>,
        <josh@joshtriplett.org>, <tglx@linutronix.de>, <peterz@infradead.org>,
        <rostedt@goodmis.org>, <dhowells@redhat.com>, <edumazet@google.com>,
        <dvhart@linux.intel.com>, <fweisbec@gmail.com>, <oleg@redhat.com>,
        <bobby.prani@gmail.com>
Subject: Re: [PATCH v2 tip/core/rcu 01/10] rcu: Add call_rcu_tasks()
References: <20140731003914.GA3872@linux.vnet.ibm.com> <1406767182-4356-1-git-send-email-paulmck@linux.vnet.ibm.com> <53D9F084.7000706@cn.fujitsu.com> <20140731160924.GR11241@linux.vnet.ibm.com>
In-Reply-To: <20140731160924.GR11241@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2014 12:09 AM, Paul E. McKenney wrote:

> 
>>> +		/*
>>> +		 * There were callbacks, so we need to wait for an
>>> +		 * RCU-tasks grace period.  Start off by scanning
>>> +		 * the task list for tasks that are not already
>>> +		 * voluntarily blocked.  Mark these tasks and make
>>> +		 * a list of them in rcu_tasks_holdouts.
>>> +		 */
>>> +		rcu_read_lock();
>>> +		for_each_process_thread(g, t) {
>>> +			if (t != current && ACCESS_ONCE(t->on_rq) &&
>>> +			    !is_idle_task(t)) {
>>
>> What happen when the trampoline is on the idle task?
>>
>> I think we need to use schedule_on_each_cpu() to replace one of
>> the synchronize_sched() in this function. (or other stuff which can
>> cause real schedule for *ALL* online CPUs).
> 
> Well, that is one of the questions in the 0/10 cover letter.  If it turns
> out to be necessary to worry about idle-task trampolines, it should be
> possible to avoid hammering all idle CPUs in the common case.  Though maybe
> battery-powered devices won't need RCU-tasks.
> 

trampolines on NO_HZ idle CPU can be arbitrary long, (example, SMI happens
inside the trampoline).  So only the real schedule on idle CPU is reliable
to me.
