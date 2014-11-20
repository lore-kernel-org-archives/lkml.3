Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbaKTRlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 12:41:11 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:35560 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757553AbaKTRlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 12:41:06 -0500
Date: Thu, 20 Nov 2014 17:41:01 +0000
From: Will Deacon <will.deacon@arm.com>
To: Andrey Konovalov <andreyknvl@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>, Kostya Serebryany <kcc@google.com>,
        "ktsan@googlegroups.com" <ktsan@googlegroups.com>
Subject: Re: Potential data race in dput and __d_lookup
Message-ID: <20141120174101.GT19126@arm.com>
References: <CAAeHK+zQZ=sJYQA=BKLS2i7hu8NyXn6GXngvDqG9WD96yd9acg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAeHK+zQZ=sJYQA=BKLS2i7hu8NyXn6GXngvDqG9WD96yd9acg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 05:20:14PM +0000, Andrey Konovalov wrote:
> Hi
> 
> We are working on a dynamic data race detector for Linux kernel called
> KernelThreadSanitizer (ktsan)
> (https://code.google.com/p/thread-sanitizer/wiki/ThreadSanitizerForKernel).
> 
> Here is a report we got while running ktsan (upstream revision
> fc14f9c1272f62c3e8d01300f52467c0d9af50f9, Linux 3.18-rc5):
> 
> ==================================================================
> ThreadSanitizer: data-race in lockref_put_or_lock
> 
> Read of size 8 by thread T575 (K814):
>  [<ffffffff8152067f>] lockref_put_or_lock+0x1f/0xe0 /lib/lockref.c:122
>  [<ffffffff8126965e>] dput+0x2e/0x2b0 /fs/dcache.c:626
>  [<     inlined    >] link_path_walk+0xddd/0x1d40 path_to_nameidata
> /fs/namei.c:677
>  [<     inlined    >] link_path_walk+0xddd/0x1d40 walk_component
> /fs/namei.c:1571
>  [<ffffffff81257d7d>] link_path_walk+0xddd/0x1d40 /fs/namei.c:1805
>  [<ffffffff8125e344>] path_openat+0xe4/0xb10 /fs/namei.c:3206
>  [<ffffffff81260911>] do_filp_open+0x51/0xd0 /fs/namei.c:3259
>  [<ffffffff81242003>] do_sys_open+0x183/0x2d0 /fs/open.c:998
>  [<     inlined    >] SyS_open+0x35/0x50 SYSC_open /fs/open.c:1016
>  [<ffffffff81242185>] SyS_open+0x35/0x50 /fs/open.c:1011
>  [<ffffffff81e39fe9>] system_call_fastpath+0x12/0x17
> /arch/x86/kernel/entry_64.S:422
> DBG: cpu = ffffe8ffffc010b0
> 
> Previous write of size 4 by thread T574 (K813):
>  [<ffffffff8126e22f>] __d_lookup+0x27f/0x2d0 /fs/dcache.c:2185
>  [<ffffffff812543c9>] lookup_fast+0x299/0x5a0 /fs/namei.c:1427
>  [<     inlined    >] link_path_walk+0x25c/0x1d40 walk_component
> /fs/namei.c:1546
>  [<ffffffff812571fc>] link_path_walk+0x25c/0x1d40 /fs/namei.c:1805
>  [<ffffffff8125e344>] path_openat+0xe4/0xb10 /fs/namei.c:3206
>  [<ffffffff81260911>] do_filp_open+0x51/0xd0 /fs/namei.c:3259
>  [<ffffffff81242003>] do_sys_open+0x183/0x2d0 /fs/open.c:998
>  [<     inlined    >] SyS_open+0x35/0x50 SYSC_open /fs/open.c:1016
>  [<ffffffff81242185>] SyS_open+0x35/0x50 /fs/open.c:1011
>  [<ffffffff81e39fe9>] system_call_fastpath+0x12/0x17
> /arch/x86/kernel/entry_64.S:422
> DBG: cpu = 0
> 
> DBG: addr: ffff8801148e91f0
> DBG: first offset: 4, second offset: 0
> DBG: T575 clock: {T575: 27630, T574: 25486}
> DBG: T574 clock: {T574: 25539}
> ==================================================================
> 
> It seems that one thread increments 'dentry->d_lockref.count', while
> other does 'lockref_put_or_lock(&dentry->d_lockref)'  without any
> synchronization.
> 
> Could you confirm if this is a real race?

I think it should be fine. d_lock is #defined as d_lockref.lock, and the
whole way the lockref works is that you can either cmpxchg the lock and the
counter, or take the lock and do what you like.

So in this case, the increment is done with the lock held, which will
cause a competing lockref_put_or_lock to fail on the cmpxchg path.

Will
