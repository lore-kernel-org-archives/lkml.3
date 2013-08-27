Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab3H0R2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 13:28:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309Ab3H0R2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 13:28:32 -0400
Date: Tue, 27 Aug 2013 19:21:55 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        John Johansen <john.johansen@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 03/12] pid: get ppid pid_t of task in init_pid_ns safely
Message-ID: <20130827172155.GC29147@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com> <a411b87ba4c4af251166ee5877cb8c646cf7826c.1377032086.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a411b87ba4c4af251166ee5877cb8c646cf7826c.1377032086.git.rgb@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20, Richard Guy Briggs wrote:
>
> Added the functions
>         task_ppid()
>         task_ppid_nr_ns()
>         task_ppid_nr_init_ns()
> to safely abstract the lookup of the PPID

but it is not safe.

> +static inline struct pid *task_ppid(struct task_struct *task)
> +{
> +	return task_tgid(rcu_dereference(current->real_parent));
                                         ^^^^^^^
task?

> +static inline pid_t task_ppid_nr_ns(struct task_struct *tsk,
> +					struct pid_namespace *ns)
> +{
> +	pid_t pid;
> +
> +	rcu_read_lock();
> +	pid = pid_nr_ns(task_ppid(current), ns);
                                  ^^^^^^^
again.

> +	rcu_read_unlock();

And why this is safe?

rcu_read_lock() can't help if tsk was already dead _before_ it takes
the rcu lock. ->real_parent can point the already freed/reused/unmapped
memory.

This is safe if, for example, the caller alredy holds rcu_read_lock()
and tsk was found by find_task_by*(), or tsk is current.

Richard, just in case... I am going to vacation, I will be completely
offline till Sep 10.

Oleg.

