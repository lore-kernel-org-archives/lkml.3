Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab3COOgV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 10:36:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754607Ab3COOgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 10:36:20 -0400
Date: Fri, 15 Mar 2013 15:34:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: li guang <lig.fnst@cn.fujitsu.com>
Cc: viro@zeniv.linux.org.uk, edumazet@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] task_work: make FIFO task_work list
Message-ID: <20130315143412.GA21365@redhat.com>
References: <1363247865-3531-1-git-send-email-lig.fnst@cn.fujitsu.com> <20130314144019.GA16136@redhat.com> <1363306591.21129.117.camel@liguang.fnst.cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1363306591.21129.117.camel@liguang.fnst.cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15, li guang wrote:
>
> 在 2013-03-14四的 15:40 +0100，Oleg Nesterov写道：
> > > --- a/kernel/task_work.c
> > > +++ b/kernel/task_work.c
> > > @@ -13,11 +13,12 @@ task_work_add(struct task_struct *task, struct callback_head *work, bool notify)
> > >  		head = ACCESS_ONCE(task->task_works);
> > >  		if (unlikely(head == &work_exited))
> > >  			return -ESRCH;
> > > -		work->next = head;
> > > -	} while (cmpxchg(&task->task_works, head, work) != head);
> > > +		head = head->next;
> > > +	} while (cmpxchg(&head, NULL, work) == head);
> >
> > I simply can't understand how this can work... The patch assumes
> > that head->next == NULL after head = head->next, why? And then
> > compares the result with head and succeeds if not equal.
> >
>
> then ->next filed was not initialized, so I think it will
> be 0'ed by compiler, is it unreliable?.

work->next is not necessarily initialized, but this is not the main
problem...

> > Could you please explain how it was supposed to work? If nothing
> > else, Suppose we have task->task_works -> W1 -> W2 -> W3. How this
> > code can add W4 after W3?
> >
>
> 1. head = task_works

head == &W1

> 2. head = head->next

head == &W2

> 3. if head == NULL
> 	/* it's next node of list tail (w3->next) */
> 	head = work

No,

>    else
>   	goto 1

And? You restart from ->task_works again.

> > Anyway, whatever I missed this is racy.
> >
> > 	head = head->next;
> >
> > nothing protects "head" after this. Say, it can be task_work_cancel'ed
> > and freed. So,
> >
> > 	 cmpxchg(&head, ...)
> >
> > can modify the freed and reused memory.
> >
> > Oleg.
>
> Thanks Oleg,
> Hmm, at first, I think even it was changed, it can't happened to be
> NULL, but ... maybe it need more deliberation.

My point was, even if it is not NULL nothing protects this element. It can
be freed/reused before you do cmpxchg(&head).

> The motivation it make the list FIFO at task_work_add, so you don't
> need to reverse it at task_work_run,

I understand, but this is not easy and unlikely possible without the
locking.

> and it's a time-saver if the list

Yes, but compared to the next loop which does do/while again _and_
calls the work->func() "Reverse the list" doesn't add too much.

Oleg.

