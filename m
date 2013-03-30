Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab3C3OjT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 10:39:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756835Ab3C3OjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 10:39:16 -0400
Date: Sat, 30 Mar 2013 15:36:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, akpm@linux-foundation.org, jack@suse.cz,
        david@fromorbit.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] kthread: implement probe_kthread_data()
Message-ID: <20130330143600.GA8650@redhat.com>
References: <1364612447-6810-1-git-send-email-tj@kernel.org> <1364612447-6810-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364612447-6810-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29, Tejun Heo wrote:
>
> Implement probe_kthread_data() which returns kthread_data if
> accessible.  The function is equivalent to kthread_data() except that
> the specified @task may not be a kthread
                 ^^^^^^^^^^^^^^^^^^^^^^^^^

This doesn't necessarily mean its ->vfork_done != NULL... but I guess
the "false positive" is fine for your purpose.

> or its vfork_done is already
> cleared rendering struct kthread inaccessible.
> ...

> +/**
> + * probe_kthread_data - speculatively version of kthread_data()
> + * @task: possible kthread task in question
> + *
> + * @task could be a kthread task.  Return the data value specified when it
> + * was created if accessible.  If @task isn't a kthread task or its data is
> + * inaccessible for any reason, %NULL is returned.  This function requires
> + * that @task itself is safe to dereference.
> + */
> +void *probe_kthread_data(struct task_struct *task)
> +{
> +	struct kthread *kthread = to_kthread(task);
> +	void *data = NULL;
> +
> +	probe_kernel_read(&data, &kthread->data, sizeof(data));
> +	return data;
> +}

OK, but we can simply check ->vfork_done != NULL ?

We do not care if we race with the exiting thread which can clear
its ->vfork_done. If it is safe to dereference this @task then
kthread is also safe.

kthread-introduce-to_live_kthread.patch in -mm adds the trivial
helper,

	static inline struct kthread *to_kthread(struct task_struct *k)
	{
	       return __to_kthread(k->vfork_done);
	}

	static struct kthread *to_live_kthread(struct task_struct *k)
	{
	       struct completion *vfork = ACCESS_ONCE(k->vfork_done);
	       if (likely(vfork))
		       return __to_kthread(vfork);
	       return NULL;
	}

So, perhaps,

	voif *kthread_data_safe(struct task_struct *task)
	{
		struct kthread *kthread = to_live_kthread(task);
		return kthread ? kthread->data : NULL;
	}

?

Oleg.

