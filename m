Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaAOTdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 14:33:40 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:44167 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaAOTdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 14:33:38 -0500
MIME-Version: 1.0
In-Reply-To: <20140115190445.GA18166@redhat.com>
References: <1389645028-17157-1-git-send-email-wad@chromium.org>
	<1389645028-17157-2-git-send-email-wad@chromium.org>
	<20140114192118.GA31411@redhat.com>
	<CABqD9hYB7d4=cpCaXZms5v8+=SJnYnkmL8biPE5Jz0YQuJ20MQ@mail.gmail.com>
	<20140115190445.GA18166@redhat.com>
Date: Wed, 15 Jan 2014 13:33:37 -0600
Message-ID: <CABqD9hYgn28EcF=AbyKSv-+pZH+yzV1L_P9dTnrezNRd220YtA@mail.gmail.com>
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

On Wed, Jan 15, 2014 at 1:04 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 01/14, Will Drewry wrote:
>>
>> On Tue, Jan 14, 2014 at 1:21 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>>
>> >> +                     get_seccomp_filter(caller);
>> >> +                     /*
>> >> +                      * Drop the task reference to the shared ancestor since
>> >> +                      * current's path will hold a reference.  (This also
>> >> +                      * allows a put before the assignment.)
>> >> +                      */
>> >> +                     put_seccomp_filter(thread);
>> >> +                     thread->seccomp.filter = caller->seccomp.filter;
>> >
>> > As I said, I do not understand this patch yet, but this looks suspicious.
>> >
>> > Why we can't race with this thread doing clone(CLONE_THREAD) ? We do
>> > not the the new thread yet, but its ->seccomp can be already copied
>> > by copy_process(), no?
>>
>> Yeah I missed that. That said, I think the worst of it would be that
>> the new thread
>> gets the old filter.
>
> Yes, but this means you can trust SECCOMP_EXT_ACT_TSYNC.
>
>> I'll see if
>> the siglock helps
>> here and walk the clone() code again to see what else I missed.
>
> No, siglock itself can't help to avoid this race. Unless you move
> copy_process()->get_seccomp_filter() under the same lock, and in
> this case it should also re-copy ->seccomp. Not nice.

Yeah - not at all.  I'll rethink it. I was too excited about how easy
is_ancestor works, but the locking is really the hard part.

> But note task_lock() (or any other per-thread locking) is wrong.
> Just look at the code above. We hold task_lock(thread) but not
> task_lock(caller). What if another thread calls seccomp_sync_threads()
> and changes caller->seccomp right after get_seccomp_filter(caller).

Yup - I was thinking of tasklist_lock as a non-multi-reader lock,
which is wrong.
The task_lock(current) would clearly cover that case, but I need to walk through
all the interactions paying more attention to the lock being used.

> And even get_seccomp_filter() itself becomes racy. I think the
> locking is seriously broken in this series.

It certainly needs to be better applied :)

thanks!
