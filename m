Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625Ab3LKQ41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 11:56:27 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:51741 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab3LKQ4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 11:56:24 -0500
Date: Wed, 11 Dec 2013 08:56:20 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alex Thorlton <athorlton@sgi.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: numa: Guarantee that tlb_flush_pending updates are
 visible before page table updates
Message-ID: <20131211165620.GU4208@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1386690695-27380-1-git-send-email-mgorman@suse.de>
 <20131211132109.GB24125@suse.de>
 <20131211144446.GP4208@linux.vnet.ibm.com>
 <20131211164052.GB11295@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211164052.GB11295@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121116-7164-0000-0000-0000042309AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 04:40:52PM +0000, Mel Gorman wrote:
> On Wed, Dec 11, 2013 at 06:44:47AM -0800, Paul E. McKenney wrote:
> > On Wed, Dec 11, 2013 at 01:21:09PM +0000, Mel Gorman wrote:
> > > According to documentation on barriers, stores issued before a LOCK can
> > > complete after the lock implying that it's possible tlb_flush_pending can
> > > be visible after a page table update. As per revised documentation, this patch
> > > adds a smp_mb__before_spinlock to guarantee the correct ordering.
> > > 
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Mel Gorman <mgorman@suse.de>
> > 
> > Assuming that there is a lock acquisition after calls to
> > set_tlb_flush_pending():
> > 
> > Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > (I don't see set_tlb_flush_pending() in mainline.)
> > 
> 
> It's introduced by a patch flight that is currently sitting in Andrew's
> tree. In the case where we care about the value of tlb_flush_pending, a
> spinlock will be taken. PMD or PTE split spinlocks or the mm->page_table_lock
> depending on whether it is 3.13 or 3.12-stable and earlier kernels. I
> pushed the relevant patches to this tree and branch
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mel/linux-balancenuma.git numab-instrument-serialise-v5r1
> 
> There is no guarantee the lock will be taken if there are no pages populated
> in the region but we also do not care about flushing the TLB in that case
> either. Does it matter that there is no guarantee a lock will be taken
> after smp_mb__before_spinlock, just very likely that it will be?

If you do smp_mb__before_spinlock() without a lock acquisition, no harm
will be done, other than possibly a bit of performance loss.  So you
should be OK.

							Thanx, Paul

