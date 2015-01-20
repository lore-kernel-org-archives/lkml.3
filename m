Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbbATKoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:44:04 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:38841 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491AbbATKoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:44:01 -0500
Date: Tue, 20 Jan 2015 10:43:59 +0000
From: Will Deacon <will.deacon@arm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: Behaviour of smp_mb__{before,after}_spin* and acquire/release
Message-ID: <20150120104359.GC24303@arm.com>
References: <20150113163353.GE31784@arm.com>
 <20150113184510.GA31525@redhat.com>
 <20150114113147.GG4050@arm.com>
 <20150120034040.GN9719@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120034040.GN9719@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Tue, Jan 20, 2015 at 03:40:40AM +0000, Paul E. McKenney wrote:
> On Wed, Jan 14, 2015 at 11:31:47AM +0000, Will Deacon wrote:
> > On Tue, Jan 13, 2015 at 06:45:10PM +0000, Oleg Nesterov wrote:
> > > On 01/13, Will Deacon wrote:
> > > >
> > > >   1. Does smp_mb__before_spinlock actually have to order prior loads
> > > >      against later loads and stores? Documentation/memory-barriers.txt
> > > >      says it does, but that doesn't match the comment
> > > 
> > > The comment says that smp_mb__before_spinlock() + spin_lock() should
> > > only serialize STOREs with LOADs. This is because it was added to ensure
> > > that the setting of condition can't race with ->state check in ttwu().
> > 
> > Yup, that makes sense. The comment is consistent with the code, and I think
> > the code is doing what it's supposed to do.
> > 
> > > But since we use wmb() it obviously serializes STOREs with STORES. I do
> > > not know if this should be documented, but we already have another user
> > > which seems to rely on this fact: set_tlb_flush_pending().
> > 
> > In which case, it's probably a good idea to document that too.
> > 
> > > As for "prior loads", this doesn't look true...
> > 
> > Agreed. I'd propose something like the diff below, but it also depends on
> > my second question since none of this is true for smp_load_acquire.
> 
> OK, finally getting to this, apologies for the delay...

No problem, it's hardly urgent :)

> It does look like I was momentarily confusing the memory ordering implied
> by lock acquisition with that by smp_lock_acquire().  Your patch looks good,
> would you be willing to resend with commit log and Signed-off-by?

Hey, if you get confused by it then what hope do the rest of us have?

Patch below, thanks.

Will

--->8

>From bf5921b5105db177517d7a951dc0e64e3bb0dd51 Mon Sep 17 00:00:00 2001
From: Will Deacon <will.deacon@arm.com>
Date: Tue, 20 Jan 2015 10:32:01 +0000
Subject: [PATCH] documentation: memory-barriers: fix smp_mb__before_spinlock()
 semantics

Our current documentation claims that, when followed by an ACQUIRE,
smp_mb__before_spinlock() orders prior loads against subsequent loads
and stores, which isn't actually true.

Fix the documentation to state that this sequence orders only prior
stores against subsequent loads and stores.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 Documentation/memory-barriers.txt | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 70a09f8a0383..9c0e3c45a807 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -1724,10 +1724,9 @@ for each construct.  These operations all imply certain barriers:
 
      Memory operations issued before the ACQUIRE may be completed after
      the ACQUIRE operation has completed.  An smp_mb__before_spinlock(),
-     combined with a following ACQUIRE, orders prior loads against
-     subsequent loads and stores and also orders prior stores against
-     subsequent stores.  Note that this is weaker than smp_mb()!  The
-     smp_mb__before_spinlock() primitive is free on many architectures.
+     combined with a following ACQUIRE, orders prior stores against
+     subsequent loads and stores. Note that this is weaker than smp_mb()!
+     The smp_mb__before_spinlock() primitive is free on many architectures.
 
  (2) RELEASE operation implication:
 
-- 
2.1.4

