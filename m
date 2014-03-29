Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294AbaC2Ghe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 02:37:34 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:40195 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaC2Ghd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 02:37:33 -0400
Message-ID: <533669C7.0@huawei.com>
Date: Sat, 29 Mar 2014 14:35:51 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>,
        "Li Zefan" <lizefan@huawei.com>, Zhangwei <jovi.zhangwei@huawei.com>
Subject: Re: [BUGREPORT] Tasklet scheduled issue in Linux 3.4.x-rt
References: <53144A57.4040204@huawei.com> <20140328163753.GB14842@linutronix.de>
In-Reply-To: <20140328163753.GB14842@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,
   Thanks for your reply and help to look at it, thanks!

I also check the tasklet state machine changes, and didn't find
clue for this issue. So I Temporarily reverted Ingo's patch, without
this patch, my test is ok.

commit 0d9f73fc1e7270a3f8709c59c913408153d9d9f8
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Nov 29 20:18:22 2011 -0500

    tasklet: Prevent tasklets from going into infinite spin in RT

Because this patch does not exist in the latest Linus kernel, so I
have not reported this issue to kernel bugzilla.

Finally, I would like to thank you again.

Thanks!
Yijing.


On 2014/3/29 0:37, Sebastian Andrzej Siewior wrote:
> * Yijing Wang | 2014-03-03 17:24:39 [+0800]:
> 
>> [2012-03-26 18:55:43][  929.252312] WARNING: at kernel/softirq.c:773 __tasklet_action+0x51/0x1a0()
>> [2012-03-27 03:41:06][ 3647.886005] WARNING: at kernel/softirq.c:773 __tasklet_action+0x51/0x1a0()
>> [2012-03-27 03:42:04][ 3705.434418] WARNING: at kernel/softirq.c:799 __tasklet_action+0xae/0x1a0()
> 
>> FC card hardware  -------> FC driver interrupt handler  --------->tasklet_schedule(fc driver tasklet) ------->tasklet running, call function process FC IO data.
>>                        here will disable FC card interrupt                                                     here will enable FC card interrupt again
> 
> This looks okay.
> 
>> We found the tasklet state is 0x1(mean state is TASKLET_STATE_SCHED),count is 0, before we call tasklet_schedule().
>> So the new tasklet can not add to CPU list.
>>
>> And I also add some dynamic debug in __tasklet_action(); after the issue occur, I open the dynamic debug.
>> After we force the hardware reset to interrupt OS, we never found the FC driver tasklet running in dmesg(I identify the tasklet by its data).
>> I guess the FC tasklet is not in CPU global tasklet list.
> You guess correct.
> 
>> I hope somebody can help to look at it. If I missing something, let me know.
> 
> The tasklet is always added to the local cpu, never cross. That list is
> always accessed with interrupts off.
> With TASKLET_STATE_SCHED set, the next step is to add the task let to
> the CPU's tasklet list. This isn't done if TASKLET_STATE_RUN is already
> set which means __tasklet_action() is already busy serving the tasklet.
> In that case it clears TASKLET_STATE_SCHED and invokes the tasklet
> again.
> After looking at it for a while I must say I have no idea how you
> managed to keep TASKLET_STATE_SCHED set. Further, each time
> TASKLET_STATE_RUN is cleared it is always with a cmpxchg() down to zero
> which means TASKLET_STATE_SCHED is removed earlier.
> That said, triggerring the warning at 773 is the first thing that went
> wrong. After it has been added to the list, the TASKLET_STATE_RUN is
> cleared again. I have no idea how it managed to remain still on except
> that __tasklet_common_schedule() is invoked which is protected by the
> SCHED bit…
> 
>> Thanks!
>> Yijing.
> 
> Sebastian
> 
> .
> 


-- 
Thanks!
Yijing

