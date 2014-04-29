Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965236AbaD2WLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 18:11:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35111 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965218AbaD2WLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 18:11:20 -0400
Date: Tue, 29 Apr 2014 15:11:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Dempsky <mdempsky@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Kees Cook <keescook@chromium.org>,
        Julien Tinnes <jln@chromium.org>,
        Roland McGrath <mcgrathr@chromium.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH v4] ptrace: Fix fork event messages across pid
 namespaces
Message-Id: <20140429151117.c724bd49f20d4a323abd708c@linux-foundation.org>
In-Reply-To: <1398802858-13624-1-git-send-email-mdempsky@chromium.org>
References: <1396492005-23811-1-git-send-email-mdempsky@chromium.org>
	<1398802858-13624-1-git-send-email-mdempsky@chromium.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014 13:20:58 -0700 Matthew Dempsky <mdempsky@chromium.org> wrote:

> When tracing a process in another pid namespace, it's important for
> fork event messages to contain the child's pid as seen from the
> tracer's pid namespace, not the parent's.  Otherwise, the tracer won't
> be able to correlate the fork event with later SIGTRAP signals it
> receives from the child.
> 
> We still risk a race condition if a ptracer from a different pid
> namespace attaches after we compute the pid_t value.  However, sending
> a bogus fork event message in this unlikely scenario is still a vast
> improvement over the status quo where we always send bogus fork event
> messages to debuggers in a different pid namespace than the forking
> process.

More Oleg review would be nice, please ;)

> @@ -129,6 +130,36 @@ static inline void ptrace_event(int event, unsigned long message)
>  }
>  
>  /**
> + * ptrace_event_pid - possibly stop for a ptrace event notification
> + * @event:	%PTRACE_EVENT_* value to report
> + * @pid:	process identifier for %PTRACE_GETEVENTMSG to return
> + *
> + * Check whether @event is enabled and, if so, report @event and @pid
> + * to the ptrace parent.  @pid is reported as the pid_t seen from the
> + * the ptrace parent's pid namespace.
> + *
> + * Called without locks.
> + */
> +static inline void ptrace_event_pid(int event, struct pid *pid)
> +{
> +	/*
> +	 * FIXME: There's a potential race if a ptracer in a different pid
> +	 * namespace than parent attaches between computing message below and
> +	 * and when we acquire tasklist_lock in ptrace_stop().
> +	 */

Well that's a scary comment.  If we're going to leave the code in this
state then please carefully describe (within this comment) the
*consequences* of the race.  Does the kernel crash?  Give away your ssh
keys?  If not then what.  

And how would userspace recognize and/or recover from the race?

> +	unsigned long message = 0;
> +	struct pid_namespace *ns;
> +
> +	rcu_read_lock();
> +	ns = task_active_pid_ns(rcu_dereference(current->parent));
> +	if (ns)
> +		message = pid_nr_ns(pid, ns);
> +	rcu_read_unlock();
> +
> +	ptrace_event(event, message);
> +}
>
> ...
>
