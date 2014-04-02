Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbaDBP7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 11:59:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758702AbaDBP7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 11:59:36 -0400
Date: Wed, 2 Apr 2014 16:58:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matthew Dempsky <mdempsky@chromium.org>
Cc: Kees Cook <keescook@chromium.org>, Julien Tinnes <jln@chromium.org>,
        Roland McGrath <mcgrathr@chromium.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ptrace: Fix fork event messages across pid
	namespaces
Message-ID: <20140402145850.GB7332@redhat.com>
References: <CAF52+S6Y40K-sRPf4YAb8ceAmtgBzZ9OUbyhPTOc_AcOWuQ=Ng@mail.gmail.com> <1396391358-22367-1-git-send-email-mdempsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396391358-22367-1-git-send-email-mdempsky@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01, Matthew Dempsky wrote:
>
> @@ -1605,10 +1605,12 @@ long do_fork(unsigned long clone_flags,
>  	 */
>  	if (!IS_ERR(p)) {
>  		struct completion vfork;
> +		struct pid *pid;
>
>  		trace_sched_process_fork(current, p);
>
> -		nr = task_pid_vnr(p);
> +		pid = get_task_pid(p, PIDTYPE_PID);

So you decided to use get_pid/put_pid ;) Honestly, I'd prefer to just
calculate "pid_t trace_pid" before wake_up_new_task(), but I won't
argue. Plus this way the race window becomes really small, OK.

> +		if (unlikely(trace)) {
> +			/*
> +			 * We want to report the child's pid as seen from the
> +			 * tracer's pid namespace.
> +			 * FIXME: We still risk sending a bogus event message if
> +			 * debuggers from different pid namespaces detach and
> +			 * reattach between rcu_read_unlock() and ptrace_stop().
> +			 */
> +			unsigned long message;
> +			rcu_read_lock();
> +			message = pid_nr_ns(pid,
> +				task_active_pid_ns(current->parent));
> +			rcu_read_unlock();
> +			ptrace_event(trace, message);
> +		}
>
>  		if (clone_flags & CLONE_VFORK) {
> -			if (!wait_for_vfork_done(p, &vfork))
> -				ptrace_event(PTRACE_EVENT_VFORK_DONE, nr);
> +			if (!wait_for_vfork_done(p, &vfork)) {
> +				/* See comment above about pid namespaces. */
> +				unsigned long message;
> +				rcu_read_lock();
> +				message = pid_nr_ns(pid,
> +					task_active_pid_ns(current->parent));
> +				rcu_read_unlock();
> +				ptrace_event(PTRACE_EVENT_VFORK_DONE, message);
> +			}

OK, but may I suggest you to make a helper? Note that the code under
"if (trace)" and "if (CLONE_VFORK)" is the same. Even the comment above
equally applies to the CLONE_VFORK branch.

Especially because this code needs a fix. Yes, rcu_read_lock() should
be enough to ensure that ->parent and its namespace (if !NULL) can not
go away, but task_active_pid_ns() can return NULL release_task(->parent)
was already (although this race is pure theoretical). So this helper
should also check it is !NULL under rcu_read_lock(), afaics.

(Hmm... off-topic, but get_pidns looks buggy by the same reason, I'll
 send a fix).

And I forgot to mention, please send v5 to akpm. We usually route ptrace
patches via -mm tree.

Oleg.

