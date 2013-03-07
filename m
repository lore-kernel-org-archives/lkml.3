Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760062Ab3CGXvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 18:51:22 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:49236 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab3CGXvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 18:51:21 -0500
MIME-Version: 1.0
In-Reply-To: <1357640418.2610.5.camel@ThinkPad-T5421.cn.ibm.com>
References: <1357610913-1080-1-git-send-email-fweisbec@gmail.com>
	<1357610913-1080-18-git-send-email-fweisbec@gmail.com>
	<1357640418.2610.5.camel@ThinkPad-T5421.cn.ibm.com>
Date: Fri, 8 Mar 2013 00:51:19 +0100
Message-ID: <CAFTL4hxBVUP5VRGiqCs172v1jMhX==CCAvea1SvGv26+t1w0Rw@mail.gmail.com>
Subject: Re: [PATCH 17/33] sched: Update clock of nohz busiest rq before balancing
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/8 Li Zhong <zhong@linux.vnet.ibm.com>:
> On Tue, 2013-01-08 at 03:08 +0100, Frederic Weisbecker wrote:
>> move_tasks() and active_load_balance_cpu_stop() both need
>> to have the busiest rq clock uptodate because they may end
>> up calling can_migrate_task() that uses rq->clock_task
>> to determine if the task running in the busiest runqueue
>> is cache hot.
>>
>> Hence if the busiest runqueue is tickless, update its clock
>> before reading it.
>>
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Alessio Igor Bogani <abogani@kernel.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Chris Metcalf <cmetcalf@tilera.com>
>> Cc: Christoph Lameter <cl@linux.com>
>> Cc: Geoff Levand <geoff@infradead.org>
>> Cc: Gilad Ben Yossef <gilad@benyossef.com>
>> Cc: Hakan Akkan <hakanakkan@gmail.com>
>> Cc: Ingo Molnar <mingo@kernel.org>
>> Cc: Li Zhong <zhong@linux.vnet.ibm.com>
>> Cc: Namhyung Kim <namhyung.kim@lge.com>
>> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> [ Forward port conflicts ]
>> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>> ---
>>  kernel/sched/fair.c |   17 +++++++++++++++++
>>  1 files changed, 17 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 3d65ac7..e78d81104 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -5002,6 +5002,7 @@ static int load_balance(int this_cpu, struct rq *this_rq,
>>  {
>>       int ld_moved, cur_ld_moved, active_balance = 0;
>>       int lb_iterations, max_lb_iterations;
>> +     int clock_updated;
>>       struct sched_group *group;
>>       struct rq *busiest;
>>       unsigned long flags;
>> @@ -5045,6 +5046,7 @@ redo:
>>
>>       ld_moved = 0;
>>       lb_iterations = 1;
>> +     clock_updated = 0;
>>       if (busiest->nr_running > 1) {
>>               /*
>>                * Attempt to move tasks. If find_busiest_group has found
>> @@ -5068,6 +5070,14 @@ more_balance:
>>                */
>>               cur_ld_moved = move_tasks(&env);
>>               ld_moved += cur_ld_moved;
>> +
>> +             /*
>> +              * Move tasks may end up calling can_migrate_task() which
>> +              * requires an uptodate value of the rq clock.
>> +              */
>> +             update_nohz_rq_clock(busiest);
>> +             clock_updated = 1;
>
> According to the change log, it seems these lines should be added before
> move_tasks() above?

Yeah, but eventually it seems that can_migrate_task() doesn't make use
of rq clock anymore. I guess I'll just drop that patch.

Thanks.
