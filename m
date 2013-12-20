Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471Ab3LTR7E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 12:59:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938Ab3LTR7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 12:59:01 -0500
Date: Fri, 20 Dec 2013 18:59:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: John Johansen <john.johansen@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Peter Zijlstra <peterz@infradead.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] apparmor: remove the "task" arg from
	may_change_ptraced_domain()
Message-ID: <20131220175926.GA31032@redhat.com>
References: <20131218194338.GB23692@madcap2.tricolour.ca> <20131218201940.GA9694@redhat.com> <20131220043632.GA14884@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131220043632.GA14884@madcap2.tricolour.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19, Richard Guy Briggs wrote:
>
> On 13/12/18, Oleg Nesterov wrote:
>
> > Otherwise I can't understand your email, at least right now... I do not
> > know how/where audit uses parent/real_parent.
>
> It uses real_parent to include the ppid number of a process in a couple
> of log records.

I did a quick grep, it seems that audit uses sys_getppid() which should be
fine. Nevermind, if you meant that (say) audit_alloc() paths use tsk->parent
somehow, I agree this doesn't look right/safe. new_child->*parent can point
to nowhere right after dup_task_struct() and there is no way to detect this.

Unless, of course new_child->*parent == current, but copy_process() changes
child->parent only after it takes tasklist_lock.

> > But yes, unless tsk == current, the usage of tsk->*parent is not safe even
> > under rcu_read_lock() unless you verify that this task was not unhashed.
>
> As I said, the only case I can see is in copy_process() when a signal is
> pending when neither CLONE_PARENT nor CLONE_THREAD is passed to it.
> Still, that is enough to need to check it.

Hmm, so I guess you are worried about audit_free?

But this error path can be called even before it checks signal_pending(),
suppose that copy_semundo() fails?

So it seems that CLONE_PARENT/THREAD doesn't really matter because it
audit_free() can be called before copy_process() sets ->parent = current?

Most probably I misunderstood you, so please ignore. I am sure you fully
understand the problems and do not need my comments ;)

> So what are you saying?  I should use pid_alive() inside the
> rcu_read_lock() to verify it is not unhashed since I don't have anything
> to do with ->ptrace or any other task lock?  In fact, the answer is
> under my nose in __task_pid_nr_ns(), which already uses this approach.

Yes. task->parent (or real_parent) can only make sense if this task can
be re-parented (if parent exits, or debugger detaches). If the task is
dead (removed from the parent->children list), obviously nobody can update
this pointer.

And this reminds me we should simply clear ->parent/real_parent on exit.
And ->group_leader. I'll try to make the patch(s), after I finish
thread_group changes. Unfortunately this needs a lot of grepping.

Oleg.

