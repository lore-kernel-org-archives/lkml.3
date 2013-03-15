Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab3COASD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 20:18:03 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:24064 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750872Ab3COASB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 20:18:01 -0400
X-IronPort-AV: E=Sophos;i="4.84,848,1355068800"; 
   d="scan'208";a="6874641"
Subject: Re: [PATCH 1/2] task_work: make FIFO task_work list
From: li guang <lig.fnst@cn.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: viro@zeniv.linux.org.uk, edumazet@google.com, linux-kernel@vger.kernel.org
In-Reply-To: <20130314144019.GA16136@redhat.com>
References: <1363247865-3531-1-git-send-email-lig.fnst@cn.fujitsu.com>
	 <20130314144019.GA16136@redhat.com>
Date: Fri, 15 Mar 2013 08:16:31 +0800
Message-ID: <1363306591.21129.117.camel@liguang.fnst.cn.fujitsu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/15 08:16:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/15 08:16:42,
	Serialize complete at 2013/03/15 08:16:42
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

在 2013-03-14四的 15:40 +0100，Oleg Nesterov写道：
> On 03/14, liguang wrote:
> >
> > Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> 
> Changelog please...
> 

OK.

> > ---
> >  kernel/task_work.c |   15 +++------------
> >  1 files changed, 3 insertions(+), 12 deletions(-)
> > 
> > diff --git a/kernel/task_work.c b/kernel/task_work.c
> > index 65bd3c9..0bf4258 100644
> > --- a/kernel/task_work.c
> > +++ b/kernel/task_work.c
> > @@ -13,11 +13,12 @@ task_work_add(struct task_struct *task, struct callback_head *work, bool notify)
> >  		head = ACCESS_ONCE(task->task_works);
> >  		if (unlikely(head == &work_exited))
> >  			return -ESRCH;
> > -		work->next = head;
> > -	} while (cmpxchg(&task->task_works, head, work) != head);
> > +		head = head->next;
> > +	} while (cmpxchg(&head, NULL, work) == head);
> 
> I simply can't understand how this can work... The patch assumes
> that head->next == NULL after head = head->next, why? And then
> compares the result with head and succeeds if not equal.
> 

then ->next filed was not initialized, so I think it will
be 0'ed by compiler, is it unreliable?.

> Could you please explain how it was supposed to work? If nothing
> else, Suppose we have task->task_works -> W1 -> W2 -> W3. How this
> code can add W4 after W3?
> 

1. head = task_works
2. head = head->next
3. if head == NULL
	/* it's next node of list tail (w3->next) */
	head = work
   else
  	goto 1
	


> And cmpxchg(&head) should be cmpxchg(&head->next)....
> 
> 
> 
> Anyway, whatever I missed this is racy.
> 
> 	head = head->next;
> 
> nothing protects "head" after this. Say, it can be task_work_cancel'ed
> and freed. So,
> 
> 	 cmpxchg(&head, ...)
> 
> can modify the freed and reused memory.
> 
> Oleg.
> 

Thanks Oleg,
Hmm, at first, I think even it was changed, it can't happened to be
NULL, but ... maybe it need more deliberation.

The motivation it make the list FIFO at task_work_add, so you don't
need to reverse it at task_work_run, and it's a time-saver if the list
doesn't have too many nodes I think.



