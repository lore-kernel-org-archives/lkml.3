Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934887Ab3BNTdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 14:33:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758644Ab3BNTdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 14:33:37 -0500
Date: Thu, 14 Feb 2013 11:33:33 -0800
From: Zach Brown <zab@redhat.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Kent Overstreet <koverstreet@google.com>, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][WIP v1] aio: experimental use of threads, demonstration
 of cancel method
Message-ID: <20130214193333.GG22221@lenny.home.zabbo.net>
References: <20130213221632.GA25312@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130213221632.GA25312@kvack.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 05:16:32PM -0500, Benjamin LaHaise wrote:
> This patch is purely for experimentation purposes, and is by no means
> complete or cleaned up for submission yet.  It is, however, useful for
> demonstrating the cancellation of a kiocb when the kiocb is being
> processed by using a kernel thread.

I'll raise the high level design questions:

1) The patch handles the processing thread's current->mm needing to
   match the submitting thread's.  What's the plan for the rest of the
   task_struct state that a processing thread might need to read from and
   write to the submitting thread?

2) Why do we want to put aio between userspace and a pool of threads
   that call syscalls?  Put another way: whatever the benefit is here,
   can't the kernel offer that benefit as some "thread pool
   coordination" interface and not force users to pass their work through
   aio contexts and iocbs and the ring?

> way had any performance tuning done on it.  A subsequent demonstration
> patch will be written to make use of queue_work() for the purpose of
> examining and comparing the overhead of various APIs.

Hopefully cmwq could help, yeah.  You could also use a wake queue func
to pass iocbs around under the wait queue lock and get rid of all the
manual waking, locking, task state, and scheduling code.

>  	struct {
> +		spinlock_t		worker_lock;
> +		struct list_head	worker_list;
> +	} ____cacheline_aligned_in_smp;
> +

wait_queue_head_t waitq;

> +	do {
> +		spin_lock(&ctx->worker_lock);
> +		if (!list_empty(&ctx->worker_list)) {
> +			task = list_entry(ctx->worker_list.next,
> +					  struct task_struct, aio_list);
> +			list_del(&task->aio_list);
> +			nr++;
> +		} else
> +			task = NULL;
> +		spin_unlock(&ctx->worker_lock);
> +		if (task)
> +			wake_up_process(task);
> +	} while (task) ;

wake_up_all(&ctx->waitq);

> +aio_submit_task:
> +		task = current->aio_data;
> +		BUG_ON(task->aio_data != NULL);
> +		if (task) {
> +			current->aio_data = NULL;
> +			req->private = task;
> +			task->aio_data = req;
> +			kiocb_set_cancel_fn(req, aio_thread_cancel_fn);
> +			wake_up_process(task);
> +			ret = -EIOCBQUEUED;

__wake_up(&ctx->waitq, TASK_NORMAL, 1, iocb);

The patch bounced the lock to set current->aio_data back up in
make_request_thread(), so it seems pretty similar.

> +static int aio_thread_fn(void *data)
> +{
> +	kiocb_cancel_fn *cancel;
> +	struct kiocb *iocb;
> +	struct kioctx *ctx;
> +	ssize_t ret;
> +again:
> +	iocb = current->aio_data;
> +	current->aio_data = NULL;

An on-stack iocb pointer and wait queue in a container struct would let
the wait queue's wakeup func set the iocb from the wake up's key and
then call default_wake_func().

> +	cancel = cmpxchg(&iocb->ki_cancel, aio_thread_cancel_fn, NULL);
> +	if (cancel == KIOCB_CANCELLED) {
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		while (!signal_pending(current)) {
> +			schedule();
> +			if (signal_pending(current))
> +				break;
> +			set_current_state(TASK_INTERRUPTIBLE);
> +		}
> +	} else
> +		BUG_ON(cancel != aio_thread_cancel_fn);

It took me a while to guess what this was doing.  Is it trying to make
sure that the cancel's force_signal() has finished before exiting? 

Are we sure that no paths that could be called from an f_op have their
own flush_signals() that would lose the cancel's signal?  Or that a call
couldn't already have pending signals before the cancel's signal has
been sent?

It seems fragile.

> +	set_current_state(TASK_INTERRUPTIBLE);
> +
> +	spin_lock(&ctx->worker_lock);
> +	list_add(&current->aio_list, &ctx->worker_list);
> +	spin_unlock(&ctx->worker_lock);
> +
> +	if (current->aio_data) {
> +		set_current_state(TASK_RUNNING);
> +		goto again;
> +	}
> +
> +	schedule();
> +	if (current->aio_data)
> +		goto again;
> +	return 0;
> +}

Scary stuff.  It'll be nice to see it go :).

> +	void *aio_data;

A task_struct for a submitter and an iocb for the processing thread?  Is
that just a quick hack for the prototype?  A few more bytes spent on
separate members with proper types would be appreciated.  My brain is
old.

- z
