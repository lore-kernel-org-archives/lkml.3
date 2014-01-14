Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaANVKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 16:10:05 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:61399 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbaANVKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 16:10:02 -0500
MIME-Version: 1.0
In-Reply-To: <CABqD9hbCt97rW72b6pf1Gst-A9uN2Ap+q2fZgjqaYn3pg8toeQ@mail.gmail.com>
References: <1389645028-17157-1-git-send-email-wad@chromium.org>
 <1389645028-17157-2-git-send-email-wad@chromium.org> <52D47890.2060901@mit.edu>
 <CABqD9haytfoxeahQKL7G7uZJdKAhvYpqzGshC9a-U60==jYMFA@mail.gmail.com>
 <CALCETrWEn7E_VukkZvYsgDhSp7HHrOPBF4D6B-PuRnGuw1y+VQ@mail.gmail.com> <CABqD9hbCt97rW72b6pf1Gst-A9uN2Ap+q2fZgjqaYn3pg8toeQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 14 Jan 2014 13:09:41 -0800
Message-ID: <CALCETrWWMQ=9ORyU_Ey=ev4uG51Zi6LArUgQB30tgHpYTRxS_g@mail.gmail.com>
Subject: Re: [PATCH 2/2] sys, seccomp: add PR_SECCOMP_EXT and SECCOMP_EXT_ACT_TSYNC
To: Will Drewry <wad@chromium.org>
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

On Tue, Jan 14, 2014 at 12:59 PM, Will Drewry <wad@chromium.org> wrote:
> On Tue, Jan 14, 2014 at 2:24 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Tue, Jan 14, 2014 at 10:59 AM, Will Drewry <wad@chromium.org> wrote:
>>> On Mon, Jan 13, 2014 at 5:36 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>>> On 01/13/2014 12:30 PM, Will Drewry wrote:
>>>>> Applying restrictive seccomp filter programs to large or diverse
>>>>> codebases often requires handling threads which may be started early in
>>>>> the process lifetime (e.g., by code that is linked in).  While it is
>>>>> possible to apply permissive programs prior to process start up, it is
>>>>> difficult to further restrict the kernel ABI to those threads after that
>>>>> point.
>>>>>
>>>>> This change adds a new seccomp "extension" for synchronizing thread
>>>>> group seccomp filters and a prctl() for accessing that functionality.
>>>>> The need for the added prctl() is due to the lack of reserved arguments
>>>>> in PR_SET_SECCOMP.
>>>>>
>>>>> When prctl(PR_SECCOMP_EXT, SECCOMP_EXT_ACT_TSYNC, 0, 0) is called, it
>>>>> will attempt to synchronize all threads in current's threadgroup to its
>>>>> seccomp filter program.  This is possible iff all threads are using a
>>>>> filter that is an ancestor to the filter current is attempting to
>>>>> synchronize to. NULL filters (where the task is running as
>>>>> SECCOMP_MODE_NONE) are also treated as ancestors allowing threads to be
>>>>> transitioned into SECCOMP_MODE_FILTER.  On success, 0 is returned.  On
>>>>> failure, the pid of one of the failing threads will be returned.
>>>>>
>>>>> Suggested-by: Julien Tinnes <jln@chromium.org>
>>>>> Signed-off-by: Will Drewry <wad@chromium.org>
>>>>> ---
>>>>>  include/linux/seccomp.h      |    7 +++
>>>>>  include/uapi/linux/prctl.h   |    6 ++
>>>>>  include/uapi/linux/seccomp.h |    6 ++
>>>>>  kernel/seccomp.c             |  128 ++++++++++++++++++++++++++++++++++++++++++
>>>>>  kernel/sys.c                 |    3 +
>>>>>  5 files changed, 150 insertions(+)
>>>>>
>>>>> diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
>>>>> index 85c0895..3163db6 100644
>>>>> --- a/include/linux/seccomp.h
>>>>> +++ b/include/linux/seccomp.h
>>>>> @@ -77,6 +77,8 @@ static inline int seccomp_mode(struct seccomp *s)
>>>>>  extern void put_seccomp_filter(struct task_struct *tsk);
>>>>>  extern void get_seccomp_filter(struct task_struct *tsk);
>>>>>  extern u32 seccomp_bpf_load(int off);
>>>>> +extern long prctl_seccomp_ext(unsigned long, unsigned long,
>>>>> +                           unsigned long, unsigned long);
>>>>>  #else  /* CONFIG_SECCOMP_FILTER */
>>>>>  static inline void put_seccomp_filter(struct task_struct *tsk)
>>>>>  {
>>>>> @@ -86,5 +88,10 @@ static inline void get_seccomp_filter(struct task_struct *tsk)
>>>>>  {
>>>>>       return;
>>>>>  }
>>>>> +static inline long prctl_seccomp_ext(unsigned long arg2, unsigned long arg3,
>>>>> +                                  unsigned long arg4, unsigned long arg5)
>>>>> +{
>>>>> +     return -EINVAL;
>>>>> +}
>>>>>  #endif /* CONFIG_SECCOMP_FILTER */
>>>>>  #endif /* _LINUX_SECCOMP_H */
>>>>> diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
>>>>> index 289760f..5dcd5d3 100644
>>>>> --- a/include/uapi/linux/prctl.h
>>>>> +++ b/include/uapi/linux/prctl.h
>>>>> @@ -149,4 +149,10 @@
>>>>>
>>>>>  #define PR_GET_TID_ADDRESS   40
>>>>>
>>>>> +/*
>>>>> + * Access seccomp extensions
>>>>> + * See Documentation/prctl/seccomp_filter.txt for more details.
>>>>> + */
>>>>> +#define PR_SECCOMP_EXT       41
>>>>> +
>>>>>  #endif /* _LINUX_PRCTL_H */
>>>>> diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
>>>>> index ac2dc9f..49b5279 100644
>>>>> --- a/include/uapi/linux/seccomp.h
>>>>> +++ b/include/uapi/linux/seccomp.h
>>>>> @@ -10,6 +10,12 @@
>>>>>  #define SECCOMP_MODE_STRICT  1 /* uses hard-coded filter. */
>>>>>  #define SECCOMP_MODE_FILTER  2 /* uses user-supplied filter. */
>>>>>
>>>>> +/* Valid extension types as arg2 for prctl(PR_SECCOMP_EXT) */
>>>>> +#define SECCOMP_EXT_ACT              1
>>>>> +
>>>>> +/* Valid extension actions as arg3 to prctl(PR_SECCOMP_EXT, SECCOMP_EXT_ACT) */
>>>>> +#define SECCOMP_EXT_ACT_TSYNC        1 /* attempt to synchronize thread filters */
>>>>> +
>>>>>  /*
>>>>>   * All BPF programs must return a 32-bit value.
>>>>>   * The bottom 16-bits are for optional return data.
>>>>> diff --git a/kernel/seccomp.c b/kernel/seccomp.c
>>>>> index 71512e4..8a0de7b 100644
>>>>> --- a/kernel/seccomp.c
>>>>> +++ b/kernel/seccomp.c
>>>>> @@ -24,6 +24,7 @@
>>>>>  #ifdef CONFIG_SECCOMP_FILTER
>>>>>  #include <asm/syscall.h>
>>>>>  #include <linux/filter.h>
>>>>> +#include <linux/pid.h>
>>>>>  #include <linux/ptrace.h>
>>>>>  #include <linux/security.h>
>>>>>  #include <linux/slab.h>
>>>>> @@ -220,6 +221,108 @@ static u32 seccomp_run_filters(int syscall)
>>>>>       return ret;
>>>>>  }
>>>>>
>>>>> +/* Returns 1 if the candidate is an ancestor. */
>>>>> +static int is_ancestor(struct seccomp_filter *candidate,
>>>>> +                    struct seccomp_filter *child)
>>>>> +{
>>>>> +     /* NULL is the root ancestor. */
>>>>> +     if (candidate == NULL)
>>>>> +             return 1;
>>>>> +     for (; child; child = child->prev)
>>>>> +             if (child == candidate)
>>>>> +                     return 1;
>>>>> +     return 0;
>>>>> +}
>>>>> +
>>>>> +/**
>>>>> + * seccomp_sync_threads: sets all threads to use current's filter
>>>>> + *
>>>>> + * Returns 0 on success or the pid of a thread which was either not
>>>>> + * in the correct seccomp mode or it did not have an ancestral
>>>>> + * seccomp filter. current must be in seccomp.mode=2 already.
>>>>> + */
>>>>> +static pid_t seccomp_sync_threads(void)
>>>>> +{
>>>>> +     struct task_struct *thread, *caller;
>>>>> +     pid_t failed = 0;
>>>>> +     thread = caller = current;
>>>>> +
>>>>> +     read_lock(&tasklist_lock);
>>>>> +     if (thread_group_empty(caller))
>>>>> +             goto done;
>>>>> +     while_each_thread(caller, thread) {
>>>>> +             task_lock(thread);
>>>>> +             /*
>>>>> +              * All threads must not be in SECCOMP_MODE_STRICT to
>>>>> +              * be eligible for synchronization.
>>>>> +              */
>>>>> +             if ((thread->seccomp.mode == SECCOMP_MODE_DISABLED ||
>>>>> +                  thread->seccomp.mode == SECCOMP_MODE_FILTER) &&
>>>>> +                 is_ancestor(thread->seccomp.filter,
>>>>> +                             caller->seccomp.filter)) {
>>>>> +                     /* Get a task reference for the new leaf node. */
>>>>> +                     get_seccomp_filter(caller);
>>>>> +                     /*
>>>>> +                      * Drop the task reference to the shared ancestor since
>>>>> +                      * current's path will hold a reference.  (This also
>>>>> +                      * allows a put before the assignment.)
>>>>> +                      */
>>>>> +                     put_seccomp_filter(thread);
>>>>> +                     thread->seccomp.filter = caller->seccomp.filter;
>>>>> +                     /* Opt the other thread into seccomp if needed.
>>>>> +                      * As threads are considered to be trust-realm
>>>>> +                      * equivalent (see ptrace_may_access), it is safe to
>>>>> +                      * allow one thread to transition the other.
>>>>> +                      */
>>>>> +                     if (thread->seccomp.mode == SECCOMP_MODE_DISABLED) {
>>>>> +                             thread->seccomp.mode = SECCOMP_MODE_FILTER;
>>>>> +                             /*
>>>>> +                              * Don't let an unprivileged task work around
>>>>> +                              * the no_new_privs restriction by creating
>>>>> +                              * a thread that sets it up, enters seccomp,
>>>>> +                              * then dies.
>>>>> +                              */
>>>>> +                             if (caller->no_new_privs)
>>>>> +                                     thread->no_new_privs = 1;
>>>>> +                             set_tsk_thread_flag(thread, TIF_SECCOMP);
>>>>
>>>> no_new_privs is a bitfield, and some of the other bits in there look
>>>> like things that might not want to be read and written back from another
>>>> thread.
>>>
>>> Ah :/ Good catch!
>>>
>>>> Would it be too annoying to require that the other threads already have
>>>> no_new_privs set?
>>>
>>> Hrm, it's pretty painful in the edge cases where you don't control the
>>> process initialization which might setup threads you need to ensnare.
>>>
>>> Would it be crazy to do something like below in sched.h?
>>> - unsigned no_new_privs:1;
>>> + unsigned no_new_privs;
>>
>> set_bit, etc. would also work.  (Although there isn't a 32-bit set_bit
>> AFAIK, or at least there isn't one that works on 64-bit BE archs.)
>
> I wasn't sure if I could use set_bit() in a way that wouldn't get me
> banned from submitting patches forever :)

You'd at least have to get rid of the bitfield -- set_bit on a
bitfield would be... bad. :)

>
>> Also, is 'unsigned' actually safe for this purpose, on all supported
>> archs/compilers?  I'm pretty sure it's okay by C++11 rules, but those
>> don't apply here.  Maybe some day the kernel will move to C11 and life
>> will be good.
>>
>>>
>>> It feels like a big hammer though, but it also seems weird to wrap those
>>> bitfields with task_lock. Any suggestions are welcome! I'll think about
>>> this a bit more and see if there is a good way to do this transition
>>> safely and cheaply.
>>
>> Hmm.  I bet you could move no_new_privs somewhere else in task_lock
>> where there's a bit free.  It could also go in 'struct creds', but I
>> think that's even worse from your perspective.
>>
>> Here's another dumb idea:  Add an accessor task_no_new_privs(struct
>> task_struct *) and move no_new_privs into struct seccomp (i.e. make it
>> a bit in the seccomp mode).  It kind of sucks on !CONFIG_SECCOMP, but
>> it's free if CONFIG_SECCOMP.
>
> That'd certainly be fine with me. I was considering adding a
> "needs_transition" bit to struct seccomp, but moving nnp there could be tidy.
> I'd need to make sure reading it locklessly still makes sense, but I really
> don't want to put a lock on the syscall path...

You may be able to cheat a bit: I don't think that reading
no_new_privs needs to be fast -- it only matters in a small set of
security-related syscalls and in execve.

Have you considered RCU for the seccomp state?

--Andy
