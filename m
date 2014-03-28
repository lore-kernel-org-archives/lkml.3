Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaC1QiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 12:38:00 -0400
Received: from www.linutronix.de ([62.245.132.108]:50943 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbaC1Qh6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 12:37:58 -0400
Date: Fri, 28 Mar 2014 17:37:53 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Zhangwei <jovi.zhangwei@huawei.com>
Subject: Re: [BUGREPORT] Tasklet scheduled issue in Linux 3.4.x-rt
Message-ID: <20140328163753.GB14842@linutronix.de>
References: <53144A57.4040204@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <53144A57.4040204@huawei.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yijing Wang | 2014-03-03 17:24:39 [+0800]:

>[2012-03-26 18:55:43][  929.252312] WARNING: at kernel/softirq.c:773 __tasklet_action+0x51/0x1a0()
>[2012-03-27 03:41:06][ 3647.886005] WARNING: at kernel/softirq.c:773 __tasklet_action+0x51/0x1a0()
>[2012-03-27 03:42:04][ 3705.434418] WARNING: at kernel/softirq.c:799 __tasklet_action+0xae/0x1a0()

>FC card hardware  -------> FC driver interrupt handler  --------->tasklet_schedule(fc driver tasklet) ------->tasklet running, call function process FC IO data.
>                        here will disable FC card interrupt                                                     here will enable FC card interrupt again

This looks okay.

>We found the tasklet state is 0x1(mean state is TASKLET_STATE_SCHED),count is 0, before we call tasklet_schedule().
>So the new tasklet can not add to CPU list.
>
>And I also add some dynamic debug in __tasklet_action(); after the issue occur, I open the dynamic debug.
>After we force the hardware reset to interrupt OS, we never found the FC driver tasklet running in dmesg(I identify the tasklet by its data).
>I guess the FC tasklet is not in CPU global tasklet list.
You guess correct.

>I hope somebody can help to look at it. If I missing something, let me know.

The tasklet is always added to the local cpu, never cross. That list is
always accessed with interrupts off.
With TASKLET_STATE_SCHED set, the next step is to add the task let to
the CPU's tasklet list. This isn't done if TASKLET_STATE_RUN is already
set which means __tasklet_action() is already busy serving the tasklet.
In that case it clears TASKLET_STATE_SCHED and invokes the tasklet
again.
After looking at it for a while I must say I have no idea how you
managed to keep TASKLET_STATE_SCHED set. Further, each time
TASKLET_STATE_RUN is cleared it is always with a cmpxchg() down to zero
which means TASKLET_STATE_SCHED is removed earlier.
That said, triggerring the warning at 773 is the first thing that went
wrong. After it has been added to the list, the TASKLET_STATE_RUN is
cleared again. I have no idea how it managed to remain still on except
that __tasklet_common_schedule() is invoked which is protected by the
SCHED bit…

>Thanks!
>Yijing.

Sebastian
