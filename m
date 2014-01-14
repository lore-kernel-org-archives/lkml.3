Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbaANVGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 16:06:05 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:60973 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaANVGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 16:06:02 -0500
MIME-Version: 1.0
In-Reply-To: <20140114192118.GA31411@redhat.com>
References: <1389645028-17157-1-git-send-email-wad@chromium.org>
	<1389645028-17157-2-git-send-email-wad@chromium.org>
	<20140114192118.GA31411@redhat.com>
Date: Tue, 14 Jan 2014 15:06:02 -0600
Message-ID: <CABqD9hYB7d4=cpCaXZms5v8+=SJnYnkmL8biPE5Jz0YQuJ20MQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] sys, seccomp: add PR_SECCOMP_EXT and SECCOMP_EXT_ACT_TSYNC
From: Will Drewry <wad@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Nicolas Schichan <nschichan@freebox.fr>,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>, holt@sgi.com,
        Alexander Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 1:21 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 01/13, Will Drewry wrote:
>>
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
>
> perhaps we take task_lock() to serialize with another caller of
> seccomp_sync_threads()...

Sorry for the patch being unclear!  The task_lock is meant to protect
against the assignment of a seccomp.filter pointer which was meant to
protect against the target task calling seccomp_attach_filter while
another task is changing its filter pointer.

> If yes, then perhaps you can use ->siglock instead of tasklist_lock
> and do not use task_lock(). It would be even better to rely on rcu,
> but:

Exactly. The siglock seems like it makes more sense.

>> +                     get_seccomp_filter(caller);
>> +                     /*
>> +                      * Drop the task reference to the shared ancestor since
>> +                      * current's path will hold a reference.  (This also
>> +                      * allows a put before the assignment.)
>> +                      */
>> +                     put_seccomp_filter(thread);
>> +                     thread->seccomp.filter = caller->seccomp.filter;
>
> As I said, I do not understand this patch yet, but this looks suspicious.
>
> Why we can't race with this thread doing clone(CLONE_THREAD) ? We do
> not the the new thread yet, but its ->seccomp can be already copied
> by copy_process(), no?

Yeah I missed that. That said, I think the worst of it would be that
the new thread
gets the old filter.  It should still get_seccomp_filter() its own
reference to the filter.
I'm not clear if it's possible to ensure that there is no pathological
condition where
a thread races and is created without being synchronized.  I'll see if
the siglock helps
here and walk the clone() code again to see what else I missed.

thanks!
