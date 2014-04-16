Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbaDPLYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 07:24:04 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:7457 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755667AbaDPLXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 07:23:24 -0400
X-IronPort-AV: E=Sophos;i="4.97,871,1389715200"; 
   d="scan'208";a="29340618"
Message-ID: <534E59FC.2090001@cn.fujitsu.com>
Date: Wed, 16 Apr 2014 19:22:52 +0900
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: <rostedt@goodmis.org>, <fweisbec@gmail.com>, <mingo@redhat.com>,
        <acme@ghostprotocols.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/8] sched/core: Skip wakeup when task is already running.
References: <cover.1397562542.git.yangds.fnst@cn.fujitsu.com> <51238bf1648b1f4c66d3547a49cf949d1679d068.1397562542.git.yangds.fnst@cn.fujitsu.com> <20140415135326.GV11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140415135326.GV11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 10:53 PM, Peter Zijlstra wrote:
> On Tue, Apr 15, 2014 at 09:32:53PM +0900, Dongsheng Yang wrote:
>
> How can you get there with ->state == RUNNING? try_to_wake_up*() bail
> when !(->state & state).
Yes, try_to_wake_up() did this check. But other callers would miss it.

With the following code ,I can get the actual message of waking up
a running task

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9f63275..1369cae 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1418,8 +1418,10 @@ static void ttwu_activate(struct rq *rq, struct 
task_stru
  static void
  ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
  {
-       if (p->state == TASK_RUNNING)
+       if (p->state == TASK_RUNNING) {
+               printk("Wakeup a running task.");
                 return;
+       }

         check_preempt_curr(rq, p, wake_flags);
         trace_sched_wakeup(p, true);


# grep "Wakeup" /var/log/messages
Apr 15 20:16:21 localhost kernel: [    5.436505] Wakeup a running task.
Apr 15 20:16:21 localhost kernel: [    7.776042] Wakeup a running task.
Apr 15 20:16:21 localhost kernel: [    9.324274] Wakeup a running task.

So, I think there are some caller of ttwu_do_wakeup() is attempt to wake
up a running task.
> .
>

