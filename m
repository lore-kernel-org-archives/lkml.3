Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab3H2OKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 10:10:43 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:64632 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab3H2OKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 10:10:42 -0400
Date: Thu, 29 Aug 2013 10:10:37 -0400
From: Tejun Heo <tj@kernel.org>
To: Libin <huawei.libin@huawei.com>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, eparis@redhat.com,
        tglx@linutronix.de, rusty@rustcorp.com.au, ebiederm@xmission.com,
        paulmck@linux.vnet.ibm.com, john.stultz@linaro.org, mingo@redhat.com,
        peterz@infradead.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com,
        jovi.zhangwei@huawei.com, guohanjun@huawei.com,
        zhangdianfang@huawei.com, wangyijing@huawei.com
Subject: Re: [PATCH 00/14] Fix bug about invalid wake up problem
Message-ID: <20130829141037.GB3985@htj.dyndns.org>
References: <1377784669-28140-1-git-send-email-huawei.libin@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377784669-28140-1-git-send-email-huawei.libin@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Libin.

I'm completely confused by this series....

On Thu, Aug 29, 2013 at 09:57:35PM +0800, Libin wrote:
> 1)Problem Description:
> The prototype of invalid wakeup problem is as follows:
> ========================================================================
> ----------------------------
> Consumer Thread
> ----------------------------
> ...
> if (list_empty(&list)){
> 	//location a 
> 	set_current_state(TASK_INTERRUPTIBLE);
> 	schedule();
> }
> ...
> ----------------------------
> Producer Thread
> ----------------------------
> ...
> list_add_tail(&item, &list);
> wake_up_process(A);
> ...

This is of course broken.  set_current_state() should of course come
*before* the conditions is checked.  This is just plain broken code.

> In most cases, the kernel codes use a form similar to the following:
> --------------------------------------------
>  ...
>  //location a
>  ...
>  set_current_state(TASK_INTERRUPTIBLE);
>  //location b
>  while (list_empty(&product_list)){
> 	schedule();	//location c
> 	set_current_state(TASK_INTERRUPTIBLE);
> 	//location d
> }
> __set_current_state(TASK_RUNNING);
> ...
> --------------------------------------------
> At location a, consumer is preempted, and producer is scheduled,
> adding item to product_list and waking up consumer. After consumer is
> re-scheduled, calling set_current_state to set itself as state
> TASK_INTERRUPTIBLE, if it is preempted again before __set_current_state(TASK_RUNNING),
> also trigger the invalid wakeup problem that the consumer will not be scheduled

Why?  Getting preempted != calling schedule().  A preempted task will
be rescheduled *regardless* of ifs current->state; otherwise, the
whole kernel is severely broken.  Tasks never get deactivated while
preempted.

> and the item be added by producer can't be consumed.
> 
> The following circumstance will also trigger this issue:
> At location c, consumer is scheduled out, and be preempted after calling
> set_current_state(TASK_INTERRUPTIBLE) when it be re-schdeuled.

What?

> 2)Test:
> I have written a test module to trigger the problem by adding some
> synchronization condition. I will post it in the form of an attachment soon.
> 
> Test result as follows:
> [103135.332683] wakeup_test: create two kernel threads - producer & consumer
> [103135.332686] wakeup_test: module loaded successfully
> [103135.332692] wakeup_test: kthread producer try to wake up the kthread consumer
> [103165.299865] wakeup_test: kthread consumer have waited for 30s, indicating
> trigger an invalid wakeup problem!

The most interesting question here is "what were you testing?".  Can
you please post the test code?

For the whole series,

 Nacked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
