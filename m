Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849AbaEPPge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 11:36:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932283AbaEPPgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 11:36:32 -0400
Date: Fri, 16 May 2014 17:35:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kthreads: kill CLONE_KERNEL, change
	kernel_thread(kernel_init) to avoid CLONE_SIGHAND
Message-ID: <20140516153530.GA30751@redhat.com>
References: <20140413195617.GA31819@redhat.com> <53761FDB.10806@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53761FDB.10806@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16, Sasha Levin wrote:
>
> On 04/13/2014 03:56 PM, Oleg Nesterov wrote:
> > 1. Remove CLONE_KERNEL, it has no users and it is dangerous.
> >
> >    The (old) comment says "List of flags we want to share for kernel
> >    threads" but this is not true, we do not want to share ->sighand by
> >    default. This flag can only be used if the caller is sure that both
> >    parent/child will never play with signals (say, allow_signal/etc).
> >
> > 2. Change rest_init() to clone kernel_init() without CLONE_SIGHAND.
> >
> >    In this case CLONE_SIGHAND does not really hurt, and it looks like
> >    optimization because copy_sighand() can avoid kmem_cache_alloc().
> >
> >    But in fact this only adds the minor pessimization. kernel_init()
> >    is going to exec the init process, and de_thread() will need to
> >    unshare ->sighand and do kmem_cache_alloc(sighand_cachep) anyway,
> >    but it needs to do more work and take tasklist_lock and siglock.
> >
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
>
> Hi Oleg,
>
> This patch triggers a hang during boot in my KVM guest.

Hmm... How??? ;)

> There are no
> messages or anything, it just hangs right before init is supposed to
> start up.

Do you mean kernel_init() hangs somewhere in run_init_process() paths?

> I've narrowed it down a bit, and it's the removal of CLONE_SIGHAND
> that's bothering it.

This must not be possible, I bet there is something else which should
be fixed.

> Removing CLONE_FS and CLONE_FILES doesn't
> cause the hang on boot.

kernel_thread(kernel_init) doesn't use CLONE_FILES ?

Oleg.

