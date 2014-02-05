Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbaBEUcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:32:55 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:58766 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435AbaBEUct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:32:49 -0500
Date: Wed, 5 Feb 2014 12:32:43 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Steven Rostedt <rostedt@goodmis.org>
cc: Vladimir Davydov <vdavydov@parallels.com>, akpm@linux-foundation.org,
        penberg@kernel.org, cl@linux.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl
Subject: Re: [PATCH v3] slub: fix false-positive lockdep warning in
 free_partial()
In-Reply-To: <20140205195837.GA6857@home.goodmis.org>
Message-ID: <alpine.DEB.2.02.1402051231250.5616@chino.kir.corp.google.com>
References: <52F1F25F.20402@parallels.com> <1391588133-15469-1-git-send-email-vdavydov@parallels.com> <20140205195837.GA6857@home.goodmis.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Feb 2014, Steven Rostedt wrote:

> > Commit c65c1877bd68 ("slub: use lockdep_assert_held") requires
> > remove_partial() to be called with n->list_lock held, but free_partial()
> > called from kmem_cache_close() on cache destruction does not follow this
> > rule, leading to a warning:
> > 
> >   WARNING: CPU: 0 PID: 2787 at mm/slub.c:1536 __kmem_cache_shutdown+0x1b2/0x1f0()
> >   Modules linked in:
> >   CPU: 0 PID: 2787 Comm: modprobe Tainted: G        W    3.14.0-rc1-mm1+ #1
> >   Hardware name:
> >    0000000000000600 ffff88003ae1dde8 ffffffff816d9583 0000000000000600
> >    0000000000000000 ffff88003ae1de28 ffffffff8107c107 0000000000000000
> >    ffff880037ab2b00 ffff88007c240d30 ffffea0001ee5280 ffffea0001ee52a0
> >   Call Trace:
> >    [<ffffffff816d9583>] dump_stack+0x51/0x6e
> >    [<ffffffff8107c107>] warn_slowpath_common+0x87/0xb0
> >    [<ffffffff8107c145>] warn_slowpath_null+0x15/0x20
> >    [<ffffffff811c7fe2>] __kmem_cache_shutdown+0x1b2/0x1f0
> >    [<ffffffff811908d3>] kmem_cache_destroy+0x43/0xf0
> >    [<ffffffffa013a123>] xfs_destroy_zones+0x103/0x110 [xfs]
> >    [<ffffffffa0192b54>] exit_xfs_fs+0x38/0x4e4 [xfs]
> >    [<ffffffff811036fa>] SyS_delete_module+0x19a/0x1f0
> >    [<ffffffff816dfcd8>] ? retint_swapgs+0x13/0x1b
> >    [<ffffffff810d2125>] ? trace_hardirqs_on_caller+0x105/0x1d0
> >    [<ffffffff81359efe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> >    [<ffffffff816e8539>] system_call_fastpath+0x16/0x1b
> > 
> > Although this cannot actually result in a race, because on cache
> > destruction there should not be any concurrent frees or allocations from
> > the cache, let's add spin_lock/unlock to free_partial() just to keep
> > lockdep happy.
> 
> Really? We are adding a spin lock for a case where it is not needed just to
> quiet lockdep?
> 
> Now if it really isn't needed, then why don't we do the following instead of
> adding the overhead of taking a lock?
> 

There's an extremely small overhead of taking this lock, the cache has 
been destroyed and is the process of being torn down, there will be 
absolutely no contention on n->list_lock.
