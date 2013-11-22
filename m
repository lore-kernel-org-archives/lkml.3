Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab3KVUsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 15:48:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755856Ab3KVUsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 15:48:07 -0500
Date: Fri, 22 Nov 2013 21:49:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, keescook@chromium.org,
        mhocko@suse.cz, snanda@chromium.org, dserrg@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] check_unsafe_exec: kill the dead -EAGAIN and
	clear_in_exec logic
Message-ID: <20131122204917.GA20520@redhat.com>
References: <20131122175442.GA31453@redhat.com> <528FBE22.5030208@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528FBE22.5030208@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22, KOSAKI Motohiro wrote:
>
> (11/22/2013 12:54 PM), Oleg Nesterov wrote:
> > fs_struct->in_exec == T means that this ->fs is used by a single
> > process (thread group), and one of the treads does do_execve().
> >
> > To avoid the mt-exec races this code has the following complications:
> >
> > 	1. check_unsafe_exec() returns -EBUSY if ->in_exec was
> > 	   already set by another thread.
> >
> > 	2. do_execve_common() records "clear_in_exec" to ensure
> > 	   that the error path can only clear ->in_exec if it was
> > 	   set by current.
> >
> > However, after 9b1bf12d5d51 "signals: move cred_guard_mutex from
> > task_struct to signal_struct" we do not need these complications:
> >
> > 	1. We can't race with our sub-thread, this is called under
> > 	   per-process ->cred_guard_mutex. And we can't race with
> > 	   another CLONE_FS task, we already checked that this fs
> > 	   is not shared.
> >
> > 	   We can remove the  dead -EAGAIN logic.
> >
> > 	2. "out_unmark:" in do_execve_common() is either called
> > 	   under ->cred_guard_mutex, or after de_thread() which
> > 	   kills other threads, so we can't race with sub-thread
> > 	   which could set ->in_exec. And if ->fs is shared with
> > 	   another process ->in_exec should be false anyway.
> >
> > 	   We can clear in_exec unconditionally.
> >
> > This also means that check_unsafe_exec() can be void.
> >
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
> I have found no problem in this patch. However, I have a very basic question.
> Why do we need to keep fs->in_exec?

To ensure that a sub-thread can't create a new process with the same
->fs while we are doing exec without LSM_UNSAFE_SHARE, I guess. This
is only for security/ code.

> If it is correct,
> can't we move it it to signal->in_exec?

Yes, perhaps, I am thinking about more cleanups too. But not that this
will add the subtle change. CLONE_THREAD doesn't require CLONE_FS, so
copy_fs() can fail even it the caller doesn't share ->fs with the execing
thread. And we still need fs->lock to set signal->in_exec, this looks
a bit strange.

> I am not expert in this area and I may overlook something.

Neither me ;) So this patch tries to not change the current logic.

I feel that perhaps we can do more cleanups, but I am not really sure
and this needs a separate change.

Oleg.

