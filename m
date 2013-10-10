Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab3JJFEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 01:04:07 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:13722 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab3JJFEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 01:04:05 -0400
Message-ID: <1381381437.2297.32.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v8 0/9] rwsem performance optimizations
From: Davidlohr Bueso <davidlohr@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Date: Wed, 09 Oct 2013 22:03:57 -0700
In-Reply-To: <CA+55aFwECx-zQpzDunhNCd2PEbkQ7KYOfuPyzKM1X-SJ-88ZXA@mail.gmail.com>
References: <cover.1380748401.git.tim.c.chen@linux.intel.com>
	 <1380753493.11046.82.camel@schen9-DESK> <20131003073212.GC5775@gmail.com>
	 <1381186674.11046.105.camel@schen9-DESK> <20131009061551.GD7664@gmail.com>
	 <20131009072838.GY3081@twins.programming.kicks-ass.net>
	 <CA+55aFwECx-zQpzDunhNCd2PEbkQ7KYOfuPyzKM1X-SJ-88ZXA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-09 at 20:14 -0700, Linus Torvalds wrote:
> On Wed, Oct 9, 2013 at 12:28 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > The workload that I got the report from was a virus scanner, it would
> > spawn nr_cpus threads and {mmap file, scan content, munmap} through your
> > filesystem.
> 
> So I suspect we could make the mmap_sem write area *much* smaller for
> the normal cases.
> 
> Look at do_mmap_pgoff(), for example: it is run entirely under
> mmap_sem, but 99% of what it does doesn't actually need the lock.
> 
> The part that really needs the lock is
> 
>         addr = get_unmapped_area(file, addr, len, pgoff, flags);
>         addr = mmap_region(file, addr, len, vm_flags, pgoff);
> 
> but we hold it over all the other stuff too.
> 

True. By looking at the callers, we're always doing:

down_write(&mm->mmap_sem);
do_mmap_pgoff()
...
up_write(&mm->mmap_sem);

That goes for shm, aio, and of course mmap_pgoff().

While I know you hate two level locking, one way to go about this is to
take the lock inside do_mmap_pgoff() after the initial checks (flags,
page align, etc.) and return with the lock held, leaving the caller to
unlock it. 

> In fact, even if we moved the mmap_sem down into do_mmap(), and moved
> code around a bit to only hold it over those functions, it would still
> cover unnecessarily much. For example, while merging is common, not
> merging is pretty common too, and we do that
> 
>         vma = kmem_cache_zalloc(vm_area_cachep, GFP_KERNEL);
> 
> allocation under the lock. We could easily do things like preallocate
> it outside the lock.
> 

AFAICT there are also checks that should be done at the beginning of the
function, such as checking for MAP_LOCKED and VM_LOCKED flags before
calling get_unmapped_area().

Thanks,
Davidlohr

