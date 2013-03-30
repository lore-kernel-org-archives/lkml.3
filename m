Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027Ab3C3RD1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 13:03:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756871Ab3C3RD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 13:03:27 -0400
Date: Sat, 30 Mar 2013 18:00:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, david@fromorbit.com,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] kthread: implement probe_kthread_data()
Message-ID: <20130330170023.GA30835@redhat.com>
References: <1364612447-6810-1-git-send-email-tj@kernel.org> <1364612447-6810-2-git-send-email-tj@kernel.org> <20130330143600.GA8650@redhat.com> <CAOS58YNOGggVmTazN86HHO7p7uNn78O19AOp0_9NmhjaZheXCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOS58YNOGggVmTazN86HHO7p7uNn78O19AOp0_9NmhjaZheXCg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 03/30, Tejun Heo wrote:
>
> On Sat, Mar 30, 2013 at 7:36 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > > +void *probe_kthread_data(struct task_struct *task)
> > > +{
> > > +     struct kthread *kthread = to_kthread(task);
> > > +     void *data = NULL;
> > > +
> > > +     probe_kernel_read(&data, &kthread->data, sizeof(data));
> > > +     return data;
> > > +}
> >
> > OK, but we can simply check ->vfork_done != NULL ?
>
> Hmm... what if ->vfork_done is pointing to some weird place?

Aah...  "weird place" is not possible if we know that @task is kthread,
it is either NULL or it points into tsk->stack which can only go away
along with task. Note that kthread_stop() already relies on this.

But I guess I missed the fact that this helper should be safe even this
@task can be the a vfork'ed user-space process, yes?

In this case, yes, ->vfork_done can point to task->parent->stack, not
good...

Perhaps,

	voif *kthread_data_safe(struct task_struct *task)
	{
		if (task->parent == kthreadd_task) {
			struct kthread *kthread = to_live_kthread(task);
			if (kthread)
				return kthread->data;
		}

		return NULL;
	}

?

Or we can add to_live_kthread_safe() which checks "parent == kthreadd_task"
instead.

Oleg.

