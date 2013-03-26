Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab3CZLPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 07:15:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080Ab3CZLPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 07:15:50 -0400
Date: Tue, 26 Mar 2013 12:13:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ben Woodard <woodard@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        roland@frob.com, "Mark A. Grondona" <grondona1@llnl.gov>
Subject: Re: [PATCH] Fix child thread's introspection of /proc/self/exe
Message-ID: <20130326111335.GA23786@redhat.com>
References: <5150F5C0.70205@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5150F5C0.70205@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25, Ben Woodard wrote:
>
> Allow threads other than the main thread to do introspection of files in
> proc without relying on read permissions. proc_pid_follow_link() calls
> proc_fd_access_allowed() which ultimately calls __ptrace_may_access().
>
> Though this allows additional access to some proc files, we do not
> believe that this has any unintended security implications. However it
> probably needs to be looked at carefully.
>
> The original problem was a thread of a process whose permissions were
> 111 couldn't open its own /proc/self/exe This was interfering with a
> special purpose debugging tool. A simple reproducer is below.:

To clarify, the test-case fails if the executable is not readable.

This is because setup_new_exec()->would_dump() notices that
inode_permission(MAY_READ) fails and then we do set_dumpable(suid_dumpable).
After that __ptrace_may_access()->get_dumpable() fails.

It is not clear why proc_pid_readlink/etc should check get_dumpable(),
perhaps we could add PTRACE_MODE_NODUMPABLE. But this is offtopic and
I think the patch is fine anyway.

> --- a/kernel/ptrace.c
> +++ b/kernel/ptrace.c
> @@ -234,7 +234,7 @@ static int __ptrace_may_access(struct task_struct
> *task, unsigned int mode)
>          */
>         int dumpable = 0;
>         /* Don't let security modules deny introspection */
> -       if (task == current)
> +       if (same_thread_group(task, current))
>                 return 0;
>         rcu_read_lock();
>         tcred = __task_cred(task);

I agree. I think that any security checks are pointless in this case,
both tasks have the same ->mm.

Acked-by: Oleg Nesterov <oleg@redhat.com>

