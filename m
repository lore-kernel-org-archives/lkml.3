Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbaHWMWT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 08:22:19 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:58111 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaHWMWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 08:22:17 -0400
Date: Sat, 23 Aug 2014 16:22:14 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
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
Message-ID: <20140823122214.GF25918@moon>
References: <20140822192241.GA26512@redhat.com>
 <20140822201550.GA25918@moon>
 <20140823115302.GA27587@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140823115302.GA27587@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2014 at 01:53:02PM +0200, Oleg Nesterov wrote:
> >
> > It should protect from allocation/devetion/mergin of another vma. IOW when
> > I lookup for vma I need to be sure it exist and won't disappear at least
> > while I validate it.
> 
> plus you need mmap_sem (at least for reading) when you update mm_struct,
> this is clear.
> 
> My question was why the whole function should be called under mmap_sem?
> It could take it only around find_vma() + check(RLIMIT_STACK) ?

Stricktly speaking yes, but don't forget we might need to update
exe::file as well which requires lock to be taken. So it is simplier
to take the read-lock for the whole function.

> In fact I do not think we need this vma_stack/RLIMIT_STACK check at all.
> It buys nithing and looks strange. RLIMIT_STACK is mostly for self-debugging,
> to catch the, say, unlimited recursion. An application can trivially
> create a stack region of arbitrary size. I'd seriously suggest to remove it.

Look, allocate stack for self is not a problem (we do this for our parasite
code which executes inside dumpee address space) but RLIMIT_STACK check is
present in ipc shmem so I think we still need this check in a sake of
consistency. (note this code doesn't require any special caps so I need
to use as much checks/tests as possible).

> 
> > > > +	if (prctl_map.auxv_size) {
> > > > +		/* Last entry must be AT_NULL as specification requires */
> > > > +		user_auxv[AT_VECTOR_SIZE - 2] = AT_NULL;
> > > > +		user_auxv[AT_VECTOR_SIZE - 1] = AT_NULL;
> > > > +
> > > > +		task_lock(current);
> > > > +		memcpy(mm->saved_auxv, user_auxv, sizeof(user_auxv));
> > > > +		task_unlock(current);
> > >
> > > Again, could you explain this task_lock() ?
> >
> > It is used for serialization access to saved_auxv, ie when we fill it
> > with new data the other reader (via procfs interface) should wait until
> > we finish.
> 
> But proc_pid_auxv() doesn't take this lock? And even if it did, this lock
> can't help. task_lock() is per-thread, and multiple threads (including
> CLONE_VM tasks, vfork() for example) can share the same ->mm.
> 
> This certainly doesn't look right.

It takes this lock but indeed this won't help much. Looks like I need
to use cred_guard_mutex instead of task_lock here, no?
