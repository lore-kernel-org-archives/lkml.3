Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659AbaANS7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 13:59:15 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:57556 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaANS7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 13:59:12 -0500
MIME-Version: 1.0
In-Reply-To: <52D47890.2060901@mit.edu>
References: <1389645028-17157-1-git-send-email-wad@chromium.org>
	<1389645028-17157-2-git-send-email-wad@chromium.org>
	<52D47890.2060901@mit.edu>
Date: Tue, 14 Jan 2014 12:59:11 -0600
Message-ID: <CABqD9haytfoxeahQKL7G7uZJdKAhvYpqzGshC9a-U60==jYMFA@mail.gmail.com>
Subject: Re: [PATCH 2/2] sys, seccomp: add PR_SECCOMP_EXT and SECCOMP_EXT_ACT_TSYNC
From: Will Drewry <wad@chromium.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Nicolas Schichan <nschichan@freebox.fr>,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Julien Tinnes <jln@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 5:36 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On 01/13/2014 12:30 PM, Will Drewry wrote:
>> Applying restrictive seccomp filter programs to large or diverse
>> codebases often requires handling threads which may be started early in
>> the process lifetime (e.g., by code that is linked in).  While it is
>> possible to apply permissive programs prior to process start up, it is
>> difficult to further restrict the kernel ABI to those threads after that
>> point.
>>
>> This change adds a new seccomp "extension" for synchronizing thread
>> group seccomp filters and a prctl() for accessing that functionality.
>> The need for the added prctl() is due to the lack of reserved arguments
>> in PR_SET_SECCOMP.
>>
>> When prctl(PR_SECCOMP_EXT, SECCOMP_EXT_ACT_TSYNC, 0, 0) is called, it
>> will attempt to synchronize all threads in current's threadgroup to its
>> seccomp filter program.  This is possible iff all threads are using a
>> filter that is an ancestor to the filter current is attempting to
>> synchronize to. NULL filters (where the task is running as
>> SECCOMP_MODE_NONE) are also treated as ancestors allowing threads to be
>> transitioned into SECCOMP_MODE_FILTER.  On success, 0 is returned.  On
>> failure, the pid of one of the failing threads will be returned.
>>
>> Suggested-by: Julien Tinnes <jln@chromium.org>
>> Signed-off-by: Will Drewry <wad@chromium.org>
>> ---
>>  include/linux/seccomp.h      |    7 +++
>>  include/uapi/linux/prctl.h   |    6 ++
>>  include/uapi/linux/seccomp.h |    6 ++
>>  kernel/seccomp.c             |  128 ++++++++++++++++++++++++++++++++++++++++++
>>  kernel/sys.c                 |    3 +
>>  5 files changed, 150 insertions(+)
>>
>> diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
>> index 85c0895..3163db6 100644
>> --- a/include/linux/seccomp.h
>> +++ b/include/linux/seccomp.h
>> @@ -77,6 +77,8 @@ static inline int seccomp_mode(struct seccomp *s)
>>  extern void put_seccomp_filter(struct task_struct *tsk);
>>  extern void get_seccomp_filter(struct task_struct *tsk);
>>  extern u32 seccomp_bpf_load(int off);
>> +extern long prctl_seccomp_ext(unsigned long, unsigned long,
>> +                           unsigned long, unsigned long);
>>  #else  /* CONFIG_SECCOMP_FILTER */
>>  static inline void put_seccomp_filter(struct task_struct *tsk)
>>  {
>> @@ -86,5 +88,10 @@ static inline void get_seccomp_filter(struct task_struct *tsk)
>>  {
>>       return;
>>  }
>> +static inline long prctl_seccomp_ext(unsigned long arg2, unsigned long arg3,
>> +                                  unsigned long arg4, unsigned long arg5)
>> +{
>> +     return -EINVAL;
>> +}
>>  #endif /* CONFIG_SECCOMP_FILTER */
>>  #endif /* _LINUX_SECCOMP_H */
>> diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
>> index 289760f..5dcd5d3 100644
>> --- a/include/uapi/linux/prctl.h
>> +++ b/include/uapi/linux/prctl.h
>> @@ -149,4 +149,10 @@
>>
>>  #define PR_GET_TID_ADDRESS   40
>>
>> +/*
>> + * Access seccomp extensions
>> + * See Documentation/prctl/seccomp_filter.txt for more details.
>> + */
>> +#define PR_SECCOMP_EXT       41
>> +
>>  #endif /* _LINUX_PRCTL_H */
>> diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
>> index ac2dc9f..49b5279 100644
>> --- a/include/uapi/linux/seccomp.h
>> +++ b/include/uapi/linux/seccomp.h
>> @@ -10,6 +10,12 @@
>>  #define SECCOMP_MODE_STRICT  1 /* uses hard-coded filter. */
>>  #define SECCOMP_MODE_FILTER  2 /* uses user-supplied filter. */
>>
>> +/* Valid extension types as arg2 for prctl(PR_SECCOMP_EXT) */
>> +#define SECCOMP_EXT_ACT              1
>> +
>> +/* Valid extension actions as arg3 to prctl(PR_SECCOMP_EXT, SECCOMP_EXT_ACT) */
>> +#define SECCOMP_EXT_ACT_TSYNC        1 /* attempt to synchronize thread filters */
>> +
>>  /*
>>   * All BPF programs must return a 32-bit value.
>>   * The bottom 16-bits are for optional return data.
>> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
>> index 71512e4..8a0de7b 100644
>> --- a/kernel/seccomp.c
>> +++ b/kernel/seccomp.c
>> @@ -24,6 +24,7 @@
>>  #ifdef CONFIG_SECCOMP_FILTER
>>  #include <asm/syscall.h>
>>  #include <linux/filter.h>
>> +#include <linux/pid.h>
>>  #include <linux/ptrace.h>
>>  #include <linux/security.h>
>>  #include <linux/slab.h>
>> @@ -220,6 +221,108 @@ static u32 seccomp_run_filters(int syscall)
>>       return ret;
>>  }
>>
>> +/* Returns 1 if the candidate is an ancestor. */
>> +static int is_ancestor(struct seccomp_filter *candidate,
>> +                    struct seccomp_filter *child)
>> +{
>> +     /* NULL is the root ancestor. */
>> +     if (candidate == NULL)
>> +             return 1;
>> +     for (; child; child = child->prev)
>> +             if (child == candidate)
>> +                     return 1;
>> +     return 0;
>> +}
>> +
>> +/**
>> + * seccomp_sync_threads: sets all threads to use current's filter
>> + *
>> + * Returns 0 on success or the pid of a thread which was either not
>> + * in the correct seccomp mode or it did not have an ancestral
>> + * seccomp filter. current must be in seccomp.mode=2 already.
>> + */
>> +static pid_t seccomp_sync_threads(void)
>> +{
>> +     struct task_struct *thread, *caller;
>> +     pid_t failed = 0;
>> +     thread = caller = current;
>> +
>> +     read_lock(&tasklist_lock);
>> +     if (thread_group_empty(caller))
>> +             goto done;
>> +     while_each_thread(caller, thread) {
>> +             task_lock(thread);
>> +             /*
>> +              * All threads must not be in SECCOMP_MODE_STRICT to
>> +              * be eligible for synchronization.
>> +              */
>> +             if ((thread->seccomp.mode == SECCOMP_MODE_DISABLED ||
>> +                  thread->seccomp.mode == SECCOMP_MODE_FILTER) &&
>> +                 is_ancestor(thread->seccomp.filter,
>> +                             caller->seccomp.filter)) {
>> +                     /* Get a task reference for the new leaf node. */
>> +                     get_seccomp_filter(caller);
>> +                     /*
>> +                      * Drop the task reference to the shared ancestor since
>> +                      * current's path will hold a reference.  (This also
>> +                      * allows a put before the assignment.)
>> +                      */
>> +                     put_seccomp_filter(thread);
>> +                     thread->seccomp.filter = caller->seccomp.filter;
>> +                     /* Opt the other thread into seccomp if needed.
>> +                      * As threads are considered to be trust-realm
>> +                      * equivalent (see ptrace_may_access), it is safe to
>> +                      * allow one thread to transition the other.
>> +                      */
>> +                     if (thread->seccomp.mode == SECCOMP_MODE_DISABLED) {
>> +                             thread->seccomp.mode = SECCOMP_MODE_FILTER;
>> +                             /*
>> +                              * Don't let an unprivileged task work around
>> +                              * the no_new_privs restriction by creating
>> +                              * a thread that sets it up, enters seccomp,
>> +                              * then dies.
>> +                              */
>> +                             if (caller->no_new_privs)
>> +                                     thread->no_new_privs = 1;
>> +                             set_tsk_thread_flag(thread, TIF_SECCOMP);
>
> no_new_privs is a bitfield, and some of the other bits in there look
> like things that might not want to be read and written back from another
> thread.

Ah :/ Good catch!

> Would it be too annoying to require that the other threads already have
> no_new_privs set?

Hrm, it's pretty painful in the edge cases where you don't control the
process initialization which might setup threads you need to ensnare.

Would it be crazy to do something like below in sched.h?
- unsigned no_new_privs:1;
+ unsigned no_new_privs;

It feels like a big hammer though, but it also seems weird to wrap those
bitfields with task_lock. Any suggestions are welcome! I'll think about
this a bit more and see if there is a good way to do this transition
safely and cheaply.

thanks!
