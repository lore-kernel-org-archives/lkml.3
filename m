Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbaAOTYC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 14:24:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbaAOTYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 14:24:00 -0500
Date: Wed, 15 Jan 2014 20:04:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Will Drewry <wad@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Nicolas Schichan <nschichan@freebox.fr>,
        Kees Cook <keescook@chromium.org>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>, holt@sgi.com,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 2/2] sys, seccomp: add PR_SECCOMP_EXT and
	SECCOMP_EXT_ACT_TSYNC
Message-ID: <20140115190445.GA18166@redhat.com>
References: <1389645028-17157-1-git-send-email-wad@chromium.org> <1389645028-17157-2-git-send-email-wad@chromium.org> <20140114192118.GA31411@redhat.com> <CABqD9hYB7d4=cpCaXZms5v8+=SJnYnkmL8biPE5Jz0YQuJ20MQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABqD9hYB7d4=cpCaXZms5v8+=SJnYnkmL8biPE5Jz0YQuJ20MQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14, Will Drewry wrote:
>
> On Tue, Jan 14, 2014 at 1:21 PM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> >> +                     get_seccomp_filter(caller);
> >> +                     /*
> >> +                      * Drop the task reference to the shared ancestor since
> >> +                      * current's path will hold a reference.  (This also
> >> +                      * allows a put before the assignment.)
> >> +                      */
> >> +                     put_seccomp_filter(thread);
> >> +                     thread->seccomp.filter = caller->seccomp.filter;
> >
> > As I said, I do not understand this patch yet, but this looks suspicious.
> >
> > Why we can't race with this thread doing clone(CLONE_THREAD) ? We do
> > not the the new thread yet, but its ->seccomp can be already copied
> > by copy_process(), no?
>
> Yeah I missed that. That said, I think the worst of it would be that
> the new thread
> gets the old filter.

Yes, but this means you can trust SECCOMP_EXT_ACT_TSYNC.

> I'll see if
> the siglock helps
> here and walk the clone() code again to see what else I missed.

No, siglock itself can't help to avoid this race. Unless you move
copy_process()->get_seccomp_filter() under the same lock, and in
this case it should also re-copy ->seccomp. Not nice.

But note task_lock() (or any other per-thread locking) is wrong.
Just look at the code above. We hold task_lock(thread) but not
task_lock(caller). What if another thread calls seccomp_sync_threads()
and changes caller->seccomp right after get_seccomp_filter(caller).

And even get_seccomp_filter() itself becomes racy. I think the
locking is seriously broken in this series.

Oleg.

