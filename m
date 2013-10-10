Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab3JJDOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 23:14:53 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:40814 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab3JJDOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 23:14:52 -0400
MIME-Version: 1.0
In-Reply-To: <20131009072838.GY3081@twins.programming.kicks-ass.net>
References: <cover.1380748401.git.tim.c.chen@linux.intel.com>
	<1380753493.11046.82.camel@schen9-DESK>
	<20131003073212.GC5775@gmail.com>
	<1381186674.11046.105.camel@schen9-DESK>
	<20131009061551.GD7664@gmail.com>
	<20131009072838.GY3081@twins.programming.kicks-ass.net>
Date: Wed, 9 Oct 2013 20:14:51 -0700
X-Google-Sender-Auth: im7pU3fwU8xq0ke7VWKvLN0CWsU
Message-ID: <CA+55aFwECx-zQpzDunhNCd2PEbkQ7KYOfuPyzKM1X-SJ-88ZXA@mail.gmail.com>
Subject: Re: [PATCH v8 0/9] rwsem performance optimizations
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Tim Chen <tim.c.chen@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 9, 2013 at 12:28 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> The workload that I got the report from was a virus scanner, it would
> spawn nr_cpus threads and {mmap file, scan content, munmap} through your
> filesystem.

So I suspect we could make the mmap_sem write area *much* smaller for
the normal cases.

Look at do_mmap_pgoff(), for example: it is run entirely under
mmap_sem, but 99% of what it does doesn't actually need the lock.

The part that really needs the lock is

        addr = get_unmapped_area(file, addr, len, pgoff, flags);
        addr = mmap_region(file, addr, len, vm_flags, pgoff);

but we hold it over all the other stuff too.

In fact, even if we moved the mmap_sem down into do_mmap(), and moved
code around a bit to only hold it over those functions, it would still
cover unnecessarily much. For example, while merging is common, not
merging is pretty common too, and we do that

        vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);

allocation under the lock. We could easily do things like preallocate
it outside the lock.

Right now mmap_sem covers pretty much the whole system call (we do do
some security checks outside of it).

I think the main issue is that nobody has ever cared deeply enough to
see how far this could be pushed. I suspect there is some low-hanging
fruit for anybody who is willing to handle the pain..

            Linus
