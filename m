Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446AbaAISyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 13:54:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756157AbaAISy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:54:26 -0500
Date: Thu, 9 Jan 2014 19:52:54 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH v2 1/1] mm: fix the theoretical compound_lock() vs
 prep_new_page() race
Message-ID: <20140109185254.GC1141@redhat.com>
References: <20140103195519.GA26555@redhat.com>
 <20140103195547.GB26555@redhat.com>
 <20140103130023.fdbf96fc95c702bf63871b56@linux-foundation.org>
 <20140104164347.GA31359@redhat.com>
 <20140108115400.GD27046@suse.de>
 <20140108161338.GA10434@redhat.com>
 <20140108180202.GL27046@suse.de>
 <20140108190443.GA17282@redhat.com>
 <20140109112736.GR27046@suse.de>
 <20140109140447.GA25391@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109140447.GA25391@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 03:04:47PM +0100, Oleg Nesterov wrote:
> OK. Even if I am right, we can probably make another fix.

I think the confusion here was to think this was related to the futex
code, it isn't. This was just a generic theoretical problem found
doing the futex cleanups but it's not related to the futex code.

> put_compound_page() and __get_page_tail() can do yet another PageTail()
> check _before_ compound_lock().

The above alternate fix looks good to me too.

Only thing to sort out is in the common code (not just x86) then we
may need a smp_mb() between PageTail check and the bit_spin_lock... We
just can't risk writing the bit_spin_lock before reading PageTail. Not
sure if the branch that skips the bit_spin_lock helps on some arch and
we can depend on that but I doubt.

smp_mb and smp_rmb are not noops like smp_wmb on x86 so the other
patch would be more efficient on x86 if we have to add a smp_mb()
before compound_lock(), but then the put/get_page slow path is only
taken when releasing or getting tail pages after gup_fast.

And regardless of gup_fast, like Linus said, for increased NUMA
fairness we could move the compound lock from page->flags to an hashed
array of proper spinlocks sized in function of ram. The contention on
these locks is so low that I doubt we can run into lock starvation,
but because the contention is so low, the array would be fine as well,
and it would be more theoretically correct for NUMA usages than the
bit spinlock. So this problem also goes away if we convert the
bit_spin_lock to an hashed array of spin_lock.

So in the longer term it doesn't matter how we fix it now, and we
should document it in the fix that the additional PageTail check
should be dropped after converting the bit_spin_lock to an array of
hashed spinlocks (or the smp_wmb() if we go with the previous fix).

I personally prefer to keep the complexity in one place so adding to
get/put_page but the other way is a bit more efficient for x86 maybe
(until we have smp_mb__before_spin_lock/bit_spin_lock at least).

> Although personally I'd prefer this patch. And if we change get/put
> I think it would be  better to do this on top of
> 
> 	"[PATCH -mm 6/7] mm: thp: introduce get_lock_thp_head()"
> 	http://marc.info/?l=linux-kernel&m=138739438800899

Not against the cleanups of course, but about the order, it gets
harder to backport it for distros if applied after the cleanups.

Thanks!
Andrea
