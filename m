Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205Ab3CNOmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 10:42:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755766Ab3CNOmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 10:42:20 -0400
Date: Thu, 14 Mar 2013 15:40:19 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: liguang <lig.fnst@cn.fujitsu.com>
Cc: viro@zeniv.linux.org.uk, edumazet@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] task_work: make FIFO task_work list
Message-ID: <20130314144019.GA16136@redhat.com>
References: <1363247865-3531-1-git-send-email-lig.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363247865-3531-1-git-send-email-lig.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14, liguang wrote:
>
> Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>

Changelog please...

> ---
>  kernel/task_work.c |   15 +++------------
>  1 files changed, 3 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/task_work.c b/kernel/task_work.c
> index 65bd3c9..0bf4258 100644
> --- a/kernel/task_work.c
> +++ b/kernel/task_work.c
> @@ -13,11 +13,12 @@ task_work_add(struct task_struct *task, struct callback_head *work, bool notify)
>  		head = ACCESS_ONCE(task->task_works);
>  		if (unlikely(head == &work_exited))
>  			return -ESRCH;
> -		work->next = head;
> -	} while (cmpxchg(&task->task_works, head, work) != head);
> +		head = head->next;
> +	} while (cmpxchg(&head, NULL, work) == head);

I simply can't understand how this can work... The patch assumes
that head->next == NULL after head = head->next, why? And then
compares the result with head and succeeds if not equal.

Could you please explain how it was supposed to work? If nothing
else, Suppose we have task->task_works -> W1 -> W2 -> W3. How this
code can add W4 after W3?

And cmpxchg(&head) should be cmpxchg(&head->next)....



Anyway, whatever I missed this is racy.

	head = head->next;

nothing protects "head" after this. Say, it can be task_work_cancel'ed
and freed. So,

	 cmpxchg(&head, ...)

can modify the freed and reused memory.

Oleg.

