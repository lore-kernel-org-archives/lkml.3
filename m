Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbaDCPoF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:44:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbaDCPn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:43:59 -0400
Date: Thu, 3 Apr 2014 17:44:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matthew Dempsky <mdempsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Julien Tinnes <jln@chromium.org>,
        Roland McGrath <mcgrathr@chromium.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] ptrace: Fix fork event messages across pid
	namespaces
Message-ID: <20140403154413.GA16684@redhat.com>
References: <1396391358-22367-1-git-send-email-mdempsky@chromium.org> <1396492005-23811-1-git-send-email-mdempsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396492005-23811-1-git-send-email-mdempsky@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02, Matthew Dempsky wrote:
>
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
>
> Signed-off-by: Matthew Dempsky <mdempsky@chromium.org>

Thanks,

Acked-by: Oleg Nesterov <oleg@redhat.com>



Some notes for potential future changes...

	- I do not not see any potential user of ptrace_event_pid() outside
	  of fork.c, so perhaps this helper should not be exported.

	  In fact I wouldn't mind if you send v5 which moves it into fork.c ;)

	- The usage of "trace" doesn't look very consistent after this patch...
	  OK, probably I'll try to cleanup this later.		

	- OTOH, calculating pid_nr in the namespace of ->parent can probably
	  go into another simple (exported) helper. do_notify_parent_*() and
	  exec_binprm() could use it, even they do not have the problem with
	  task_active_pid_ns(parent) == NULL. Not sure.

	- I am thinking about another approach... Suppose that we change
	  ptrace_attach() to nullify ->ptrace_message, as we already discussed
	  this probably makes sense anyway.

	  Now (ignoring CLONE_VFORK to simplify the discussion), do_fork() can
	  do something like the following:

		...

		if (trace)
			current->ptrace_message = calc_its_pid_in_parent_ns();

		wake_up_new_task(p);
		
		if (trace && current->ptrace_message && ptrace_event_enabled(trace))
			ptrace_notify(...);

	 so that if we race with detach + attach we should likely see
	 ->ptrace_message == 0 and report nothing as if the new debugger
	 attached after do_fork().

	 Not sure this is really possible (without additional complications),
	 and of course we still can't close the race completely.

	 But even if this can work and will not look too ugly, it would be
	 better to do this on top of your simple patch.


Matthew, I see other emails from you, will try to reply tomorrow.

Oleg.

