Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbaHWLzr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 07:55:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbaHWLzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 07:55:45 -0400
Date: Sat, 23 Aug 2014 13:53:02 +0200
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
Message-ID: <20140823115302.GA27587@redhat.com>
References: <20140822192241.GA26512@redhat.com> <20140822201550.GA25918@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140822201550.GA25918@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23, Cyrill Gorcunov wrote:
>
> On Fri, Aug 22, 2014 at 09:22:41PM +0200, Oleg Nesterov wrote:
> > Hi Cyrill,
> >
> > I think the patch is fine but I can't understand the usage of mmap_sem
> > and alloc_lock,
> >
> > > +	stack_vma = find_vma(mm, (unsigned long)prctl_map->start_stack);
> >
> > OK, find_vma() needs mmap_sem. But otherwise, why this should be called
> > under down_read(&mm->mmap_sem) ? What this lock tries to protect?
>
> It should protect from allocation/devetion/mergin of another vma. IOW when
> I lookup for vma I need to be sure it exist and won't disappear at least
> while I validate it.

plus you need mmap_sem (at least for reading) when you update mm_struct,
this is clear.

My question was why the whole function should be called under mmap_sem?
It could take it only around find_vma() + check(RLIMIT_STACK) ?

In fact I do not think we need this vma_stack/RLIMIT_STACK check at all.
It buys nithing and looks strange. RLIMIT_STACK is mostly for self-debugging,
to catch the, say, unlimited recursion. An application can trivially
create a stack region of arbitrary size. I'd seriously suggest to remove it.

> > > +	if (prctl_map.auxv_size) {
> > > +		/* Last entry must be AT_NULL as specification requires */
> > > +		user_auxv[AT_VECTOR_SIZE - 2] = AT_NULL;
> > > +		user_auxv[AT_VECTOR_SIZE - 1] = AT_NULL;
> > > +
> > > +		task_lock(current);
> > > +		memcpy(mm->saved_auxv, user_auxv, sizeof(user_auxv));
> > > +		task_unlock(current);
> >
> > Again, could you explain this task_lock() ?
>
> It is used for serialization access to saved_auxv, ie when we fill it
> with new data the other reader (via procfs interface) should wait until
> we finish.

But proc_pid_auxv() doesn't take this lock? And even if it did, this lock
can't help. task_lock() is per-thread, and multiple threads (including
CLONE_VM tasks, vfork() for example) can share the same ->mm.

This certainly doesn't look right.

Oleg.

