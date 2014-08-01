Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbaHALFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 07:05:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:55282 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627AbaHALFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 07:05:38 -0400
Message-ID: <1406887682.4935.239.camel@pasglop>
Subject: Re: [RFC PATCH] mm: Add helpers for locked_vm
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Davidlohr Bueso <davidlohr@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>, "Jo\"rn Engel" <joern@logfs.org>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexander Graf <agraf@suse.de>,
        Michael Ellerman <michael@ellerman.id.au>
Date: Fri, 01 Aug 2014 20:08:02 +1000
In-Reply-To: <20140730124748.GK19379@twins.programming.kicks-ass.net>
References: <1406712493-9284-1-git-send-email-aik@ozlabs.ru>
	 <1406716282.9336.16.camel@buesod1.americas.hpqcorp.net>
	 <53D8E578.7060303@ozlabs.ru>
	 <20140730124748.GK19379@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-30 at 14:47 +0200, Peter Zijlstra wrote:
> On Wed, Jul 30, 2014 at 10:30:48PM +1000, Alexey Kardashevskiy wrote:
> > 
> > No, this is not my intention here. Here I only want to increment the counter.
> 
> Full and hard nack on that. It should always be tied to actual pages, we
> should not detach this and make it 'a number'.

But this is the only way. We *cannot* go through the whole per-page
locking logic every time the guest puts a translation into the IOMMU,
this will completely kill guest performances for pass-through devices.

Worse, for performances, because populating the iommu is a hypercall,
we want to do it in "real mode" (special MMU-off environment) where we
cannot rely on most normal kernel services such as normal locks, vmalloc
space isn't accessible etc...

So we don't have a choice. Either we let guests randomly pin arbitrary
amounts of system memory, or we have a way to predictively account for
the maximum that *can* be mapped/pinned in the iommu table to enable
the fast path.

Another problem with the mlock logic is that it doesn't refcount how
many time a page has been locked, while the guest can map a given page
multiple time in the iommu.

Ben.



