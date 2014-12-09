Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbaLIJjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:39:19 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:15771 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752670AbaLIJjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:39:17 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="44731568"
Message-ID: <5486C42F.7010407@cn.fujitsu.com>
Date: Tue, 9 Dec 2014 17:43:11 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: <paulmck@linux.vnet.ibm.com>
CC: <linux-kernel@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH 0/2] tiny_rcu: simplify tiny_rcu
References: <1417167813-11963-1-git-send-email-laijs@cn.fujitsu.com> <20141128154210.GX5050@linux.vnet.ibm.com>
In-Reply-To: <20141128154210.GX5050@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2014 11:42 PM, Paul E. McKenney wrote:
> On Fri, Nov 28, 2014 at 05:43:31PM +0800, Lai Jiangshan wrote:
>> Hi, Paul
>>
>> These two patches use the special feture of the UP system:
>> 	In UP, quiescent state == grace period.
>>
>> For rcu_bh, rcu_process_callbacks() == a bh == QS == GP
>> so we can pass rcu_bh-QS and advance GP(and callbacks) in
>> rcu_process_callbacks(). After doing so, rcu_bh_qs() is useless
>> since its work is handled by rcu_process_callbacks().
>>
>> For rcu_sched, context-switch = QS = GP, thus we can force a
>> context-switch when call_rcu_sched() is happened on idle_task.
>> After doing so, rcu_idle/irq_enter/exit() are useless.
>>
>> These patches remove the useless code to simplify the tiny_rcu.
>>
>> We can change rcu_bh_qs() rcu_idle/irq_enter/exit() to static-inline-functions
>> to reduce the binary size after these two patches accepted.
>>
>> Thanks,
>> Lai
> 
> These look interesting and promising!
> 
> Could you please add the change in the tiny.o size to the commit logs?
> 
> Also, one potential performance problem with this patchset is that it is
> moving the RAISE_SOFTIRQ() from the scheduling-clock interrupt handler
> (where it simply sets a bit in a per-CPU variable) to mainline code
> (where it is often a much more expensive full wakeup of ksoftirqd).
> My guess (and hope) is that this will be in the noise for most workloads,
> but given that there is some chance of performance regressions, could
> you please measure the performance difference on some reasonable
> benchmark?  The kernbench benchmark should be just fine for this purpose.


Hi, Paul

The kernbench tests showed no performance changed.  It is expected due
to kernbench doesn't hit any network code which use RCU_BH.

But I still drop the patch1 since I only benchmarked it by kernbench.

Thanks,
Lai

> 
> 							Thanx, Paul
> 
>> Cc: Josh Triplett <josh@joshtriplett.org>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>>
>> Lai Jiangshan (2):
>>   record rcu_bh quiescent state in RCU_SOFTIRQ
>>   tiny_rcu: resched when call_rcu() on idle_task
>>
>>  kernel/rcu/rcu.h         |    6 ++
>>  kernel/rcu/tiny.c        |  134 ++++++++--------------------------------------
>>  kernel/rcu/tiny_plugin.h |    2 +-
>>  kernel/rcu/tree.c        |    6 --
>>  4 files changed, 29 insertions(+), 119 deletions(-)
>>
>> -- 
>> 1.7.4.4
>>
> 
> .
> 

