Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbaELJ6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:58:31 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:12291 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752039AbaELJ6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:58:30 -0400
X-IronPort-AV: E=Sophos;i="4.97,1033,1389715200"; 
   d="scan'208";a="30399214"
Message-ID: <53708D34.1070600@cn.fujitsu.com>
Date: Mon, 12 May 2014 17:58:28 +0900
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Dongsheng Yang <dongsheng081251@gmail.com>,
        <linux-kernel@vger.kernel.org>, <mingo@redhat.com>,
        <bsegall@google.com>
Subject: Re: [PATCH] sched: Distinguish sched_wakeup event when wake up a
 task which did schedule out or not.
References: <53683B14.3060702@cn.fujitsu.com> <1399341154-11785-1-git-send-email-yangds.fnst@cn.fujitsu.com> <20140510152902.GW11096@twins.programming.kicks-ass.net> <536F90BE.2080806@gmail.com> <CA+qeAOr_PrBuo+qfjNoaZyHF21p=8UgQy1oZOjAxahhYTyrvLQ@mail.gmail.com> <20140511163531.GG30445@twins.programming.kicks-ass.net> <20140511145224.00412e59@gandalf.local.home> <20140512064730.GI30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140512064730.GI30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2014 03:47 PM, Peter Zijlstra wrote:
> On Sun, May 11, 2014 at 02:52:24PM -0400, Steven Rostedt wrote:
>> On Sun, 11 May 2014 18:35:31 +0200
>> Peter Zijlstra <peterz@infradead.org> wrote:
>> I believe you may be misunderstanding Dongsheng. It has nothing to do
>> with the wake condition. But the "success" is basically saying, "did I
>> move the task on to the run queue?". That's a relevant piece of
>> information that the wake up event isn't currently showing.
>>
>> Let me ask you this; with Donsheng's patch, will there ever be a
>> sched_switch event when the wakeup event sees 'false' and the
>> sched_switch event see the task with a state other than "R"? And if so,
>> how did the task doing the wakeup event, wake up that task?
> But that has nothing what so fucking ever to do with 'success'. Reusing
> that trace argument for something entirely different is just retarded.

Hi Peter,

we need to distinguish the true_wakeup and false_wakeup because
we want to know the timestamp when a task moved into runqueue.
Then we can calculate the latency time in perf sched latency command.

Without this patch, we will always get wakeup events with .success==true,
and we can not get the accurate time of task on run queue waiting for
cpu.

In original design of sched:sched_wakeup, actually was what I described
in commit message, .success==true means task go into run queue. And
perf-sched.c does only care events with this type:

         /* Note for later, it may be interesting to observe the failing 
cases */
         if (!success)
                 return 0;

And if scheduler raise an wakeup event with .success=true in 
ttwu_do_wakeup(),
perf sched latency will find the last state of this task is not out of 
run queue. Then
it will be confused and print a bug message for it.

# perf sched latency|tail
   bash:3498             |      0.785 ms |        1 | avg:    0.000 ms | 
max:    0.000 ms | max at:  0.000000 s
   bash:3600             |      0.522 ms |        1 | avg:    0.000 ms | 
max:    0.000 ms | max at:  0.000000 s
   bash:3570             |      0.295 ms |        1 | avg:    0.000 ms | 
max:    0.000 ms | max at:  0.000000 s
   bash:3581             |      0.288 ms |        1 | avg:    0.000 ms | 
max:    0.000 ms | max at:  0.000000 s
   bash:3594             |      0.286 ms |        1 | avg:    0.000 ms | 
max:    0.000 ms | max at:  0.000000 s
  -----------------------------------------------------------------------------------------
   TOTAL:                |   2768.420 ms |    17331 |
  ---------------------------------------------------
   INFO: 0.482% state machine bugs (82 out of 17008)



