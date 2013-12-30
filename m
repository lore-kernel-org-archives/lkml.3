Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab3L3REO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 12:04:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756051Ab3L3REN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 12:04:13 -0500
Date: Mon, 30 Dec 2013 18:04:31 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] pid: get pid_t ppid of task in init_pid_ns
Message-ID: <20131230170431.GA2457@redhat.com>
References: <cover.1387834776.git.rgb@redhat.com> <c6524d385bffe974c071e46f8b1c9b1df69a7d9d.1387834776.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6524d385bffe974c071e46f8b1c9b1df69a7d9d.1387834776.git.rgb@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23, Richard Guy Briggs wrote:
>
> +static inline pid_t task_ppid_nr_ns(struct task_struct *tsk, struct pid_namespace *ns)
> +{
> +	pid_t pid;
> +
> +	rcu_read_lock();
> +	pid = pid_alive(tsk) ?
> +		task_pid_nr_ns(rcu_dereference(tsk->real_parent), ns) : 0;
> +	rcu_read_unlock();
> +
> +	return pid;
> +}

I do not really mind, but perhaps

	pid_t pid = 0;

	rcu_read_lock();
	if (pid_alive(task))
		pid = task_pid_nr_ns(rcu_dereference(tsk->real_parent);
	rcu_read_unlock();

	return pid;

looks a bit cleaner.

> +static inline pid_t task_ppid_nr(struct task_struct *tsk)
> +{
> +	pid_t pid;
> +
> +	rcu_read_lock();
> +	pid = pid_alive(tsk) ?
> +		task_pid_nr(rcu_dereference(tsk->real_parent)) : 0;
> +	rcu_read_unlock();
> +
> +	return pid;
> +}

It could simply do

	return task_ppid_nr_ns(tsk, init_pid_ns);

but again, I won't argue.

Oleg.

