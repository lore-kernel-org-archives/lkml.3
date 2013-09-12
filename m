Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab3ILNgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 09:36:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:58745 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab3ILNgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 09:36:35 -0400
Date: Thu, 12 Sep 2013 15:36:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Libin <huawei.libin@huawei.com>
cc: akpm@linux-foundation.org, tj@kernel.org, viro@zeniv.linux.org.uk,
        eparis@redhat.com, rusty@rustcorp.com.au, ebiederm@xmission.com,
        paulmck@linux.vnet.ibm.com, john.stultz@linaro.org, mingo@redhat.com,
        peterz@infradead.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com,
        jovi.zhangwei@huawei.com, guohanjun@huawei.com,
        zhangdianfang@huawei.com, wangyijing@huawei.com
Subject: Re: [PATCH 06/14] irq: Fix invalid wakeup in
 irq_wait_for_interrupt
In-Reply-To: <1377784669-28140-7-git-send-email-huawei.libin@huawei.com>
Message-ID: <alpine.DEB.2.02.1309121534130.4089@ionos.tec.linutronix.de>
References: <1377784669-28140-1-git-send-email-huawei.libin@huawei.com> <1377784669-28140-7-git-send-email-huawei.libin@huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Aug 2013, Libin wrote:
> If this thread is preempted at(or before) location a, and the other thread
> set the condition(kthread_stop). After that when this thread is re-scheduled,
> calling set_current_state to set itself as state TASK_INTERRUPTIBLE, if it is
> preempted again after that and before __set_current_state(TASK_RUNNING), it
> triggers the invalid wakeup problem.
> -----------------------
> irq_wait_for_interrupt()
> -----------------------
> ...
> //location a
> set_current_state(TASK_INTERRUPTIBLE);
> //location b
> while (!kthread_should_stop()) {
> 
> 	if (test_and_clear_bit(IRQTF_RUNTHREAD,
> 					   &action->thread_flags)) {
> 			__set_current_state(TASK_RUNNING);
> 			return 0;
> 	}
> 	schedule();//location c
> 	set_current_state(TASK_INTERRUPTIBLE);
> 	//location d
> }
> __set_current_state(TASK_RUNNING);
> ...
> 
> The following circumstance will also trigger this issue:
> At location c, consumer is scheduled out, and be preempted after calling
> set_current_state(TASK_INTERRUPTIBLE) when it be re-schdeuled.
> 
> To solve this problem, using preempt_disable() to bound the operaion that
> setting the task state and the conditions(set by the wake thread) validation.

This is a completely pointless exercise. The irq threads are only
woken from the core code itself and not by some random other threads.

The core code already handles the legit wakeups correctly without
having the need for preemption disable.

Thanks,

	tglx
