Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262AbaHWNQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 09:16:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbaHWNQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 09:16:55 -0400
Date: Sat, 23 Aug 2014 15:14:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Julien Tinnes <jln@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3.patch
	added to -mm tree
Message-ID: <20140823131412.GA31685@redhat.com>
References: <20140822192241.GA26512@redhat.com> <20140822201550.GA25918@moon> <20140823115302.GA27587@redhat.com> <20140823122214.GF25918@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140823122214.GF25918@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23, Cyrill Gorcunov wrote:
>
> On Sat, Aug 23, 2014 at 01:53:02PM +0200, Oleg Nesterov wrote:
> > >
> > > It should protect from allocation/devetion/mergin of another vma. IOW when
> > > I lookup for vma I need to be sure it exist and won't disappear at least
> > > while I validate it.
> >
> > plus you need mmap_sem (at least for reading) when you update mm_struct,
> > this is clear.
> >
> > My question was why the whole function should be called under mmap_sem?
> > It could take it only around find_vma() + check(RLIMIT_STACK) ?
>
> Stricktly speaking yes, but don't forget we might need to update
> exe::file as well which requires lock to be taken.

For reading? I see prctl_set_mm_exe_file_locked() in this patch, probably
this function was added by another patch. But, if this function calls
set_mm_exe_file() (I guess it does?) then down_read() is not enough?
set_mm_exe_file() can race with itself.

And this still doesn't answer my question. As I said, I understand that
we need mmap_sem to update mm_struct, and this is what prctl_set_mm_map()
does at the end. And it also calls prctl_set_mm_exe_file_locked(),
validate_prctl_map_locked() doesn't do this.

> So it is simplier
> to take the read-lock for the whole function.

Still can't understand why validate_prctl_map_locked() should be called
under this lock. OK, I won't insist.

> > In fact I do not think we need this vma_stack/RLIMIT_STACK check at all.
> > It buys nithing and looks strange. RLIMIT_STACK is mostly for self-debugging,
> > to catch the, say, unlimited recursion. An application can trivially
> > create a stack region of arbitrary size. I'd seriously suggest to remove it.
>
> Look, allocate stack for self is not a problem (we do this for our parasite
> code which executes inside dumpee address space) but RLIMIT_STACK check is
> present in ipc shmem so I think we still need this check in a sake of
> consistency.

But for what? Ignoring the (I think buggy) check in do_shmat() ->start_stack
is simply unused, we only report it via /proc/. The same for, say, mm->start_code.

It seems that only start_brk/end_data/brk need some validation. Perhaps something
else, I didn't try to verify. So why do we need these confusing checks?

> > > > > +	if (prctl_map.auxv_size) {
> > > > > +		/* Last entry must be AT_NULL as specification requires */
> > > > > +		user_auxv[AT_VECTOR_SIZE - 2] = AT_NULL;
> > > > > +		user_auxv[AT_VECTOR_SIZE - 1] = AT_NULL;
> > > > > +
> > > > > +		task_lock(current);
> > > > > +		memcpy(mm->saved_auxv, user_auxv, sizeof(user_auxv));
> > > > > +		task_unlock(current);
> > > >
> > > > Again, could you explain this task_lock() ?
> > >
> > > It is used for serialization access to saved_auxv, ie when we fill it
> > > with new data the other reader (via procfs interface) should wait until
> > > we finish.
> >
> > But proc_pid_auxv() doesn't take this lock? And even if it did, this lock
> > can't help. task_lock() is per-thread, and multiple threads (including
> > CLONE_VM tasks, vfork() for example) can share the same ->mm.
> >
> > This certainly doesn't look right.
>
> It takes this lock

Where? Another patch I missed ? ;)

> but indeed this won't help much.

Yes, it can't help at all.

> Looks like I need
> to use cred_guard_mutex instead of task_lock here, no?

Please don't. First of all, it can't help because proc_pid_auxv() doesn't hold
this lock. It does mm_access() which drops this lock after return. And to remind,
we are going to remove mm_access/lock_trace from sys_read() paths in proc.

Oleg.

