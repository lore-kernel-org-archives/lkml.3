Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030455AbaDBV6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 17:58:23 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:53340 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030416AbaDBV6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 17:58:22 -0400
MIME-Version: 1.0
In-Reply-To: <20140402145850.GB7332@redhat.com>
References: <CAF52+S6Y40K-sRPf4YAb8ceAmtgBzZ9OUbyhPTOc_AcOWuQ=Ng@mail.gmail.com>
 <1396391358-22367-1-git-send-email-mdempsky@chromium.org> <20140402145850.GB7332@redhat.com>
From: Matthew Dempsky <mdempsky@google.com>
Date: Wed, 2 Apr 2014 14:58:00 -0700
Message-ID: <CAF52+S6vqK_D7bAz9o65ATSZsg4MfqJgo+Qji8+4=OQJDSEJ7A@mail.gmail.com>
Subject: Re: [PATCH v3] ptrace: Fix fork event messages across pid namespaces
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Julien Tinnes <jln@chromium.org>,
        Roland McGrath <mcgrathr@chromium.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2014 at 7:58 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 04/01, Matthew Dempsky wrote:
>>
>> @@ -1605,10 +1605,12 @@ long do_fork(unsigned long clone_flags,
>>        */
>>       if (!IS_ERR(p)) {
>>               struct completion vfork;
>> +             struct pid *pid;
>>
>>               trace_sched_process_fork(current, p);
>>
>> -             nr = task_pid_vnr(p);
>> +             pid = get_task_pid(p, PIDTYPE_PID);
>
> So you decided to use get_pid/put_pid ;) Honestly, I'd prefer to just
> calculate "pid_t trace_pid" before wake_up_new_task(), but I won't
> argue. Plus this way the race window becomes really small, OK.

I was leaning towards that, but then the conditions for trying to
avoid computing the pid_t became complex and I was worried that
waiting for the vfork child to finish could make the race window
arbitrarily large.  Holding a struct pid reference for the duration of
fork seemed like the easiest fix to both of those.

>> +             if (unlikely(trace)) {
>> +                     /*
>> +                      * We want to report the child's pid as seen from the
>> +                      * tracer's pid namespace.
>> +                      * FIXME: We still risk sending a bogus event message if
>> +                      * debuggers from different pid namespaces detach and
>> +                      * reattach between rcu_read_unlock() and ptrace_stop().
>> +                      */
>> +                     unsigned long message;
>> +                     rcu_read_lock();
>> +                     message = pid_nr_ns(pid,
>> +                             task_active_pid_ns(current->parent));
>> +                     rcu_read_unlock();
>> +                     ptrace_event(trace, message);
>> +             }
>>
>>               if (clone_flags & CLONE_VFORK) {
>> -                     if (!wait_for_vfork_done(p, &vfork))
>> -                             ptrace_event(PTRACE_EVENT_VFORK_DONE, nr);
>> +                     if (!wait_for_vfork_done(p, &vfork)) {
>> +                             /* See comment above about pid namespaces. */
>> +                             unsigned long message;
>> +                             rcu_read_lock();
>> +                             message = pid_nr_ns(pid,
>> +                                     task_active_pid_ns(current->parent));
>> +                             rcu_read_unlock();
>> +                             ptrace_event(PTRACE_EVENT_VFORK_DONE, message);
>> +                     }
>
> OK, but may I suggest you to make a helper? Note that the code under
> "if (trace)" and "if (CLONE_VFORK)" is the same. Even the comment above
> equally applies to the CLONE_VFORK branch.

Sure.

> Especially because this code needs a fix. Yes, rcu_read_lock() should
> be enough to ensure that ->parent and its namespace (if !NULL) can not
> go away, but task_active_pid_ns() can return NULL release_task(->parent)
> was already (although this race is pure theoretical). So this helper
> should also check it is !NULL under rcu_read_lock(), afaics.

Does this look right?

    static inline void ptrace_event_pid(int event, struct pid *pid)
    {
        unsigned long message = -1;
        struct pid_namespace *ns;

        rcu_read_lock();
        ns = task_active_pid_ns(rcu_dereference(current->parent));
        if (ns)
            message = pid_nr_ns(pid, ns);
        rcu_read_unlock();

        ptrace_event(event, message);
    }

I'm unsure if the rcu_dereference() is appropriate.  It seems like it
is based on my reading of the RCU documentation and that parent and
real_parent have been marked __rcu since 2011, but they prevailingly
seem to be accessed/mutated without the RCU APIs.

Also, to ensure I understand the race: the issue is that if the parent
were to call do_exit() concurrently with the above RCU critical
section, that parent's call to forget_original_parent() might not yet
be visible when the above code evaluates "current->parent", but a
later call to release_task() (e.g., if autoreap is true in
exit_notify) could detach the task's pids without any intervening
synchronize_rcu() call?

If so, why isn't the fix to have forget_original_parent() call
synchronize_rcu() before returning?  (And probably to use
rcu_assign_pointer() to updater t->real_parent and t->parent.)

Otherwise, it looks like (e.g.) the attempts to get the parent's pid
in fill_prstatus() and tomoyo_sys_getppid() are also theoretical races
of the same kind?

> And I forgot to mention, please send v5 to akpm. We usually route ptrace
> patches via -mm tree.

Will do.

Thanks for being patient with my locking questions! :)
