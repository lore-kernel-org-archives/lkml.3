Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbbATJez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 04:34:55 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:54918 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbbATJew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 04:34:52 -0500
Date: Tue, 20 Jan 2015 10:34:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Will Deacon <will.deacon@arm.com>
Cc: paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org, oleg@redhat.com,
        benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: Behaviour of smp_mb__{before,after}_spin* and acquire/release
Message-ID: <20150120093443.GA11596@twins.programming.kicks-ass.net>
References: <20150113163353.GE31784@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150113163353.GE31784@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 04:33:54PM +0000, Will Deacon wrote:
> Hi Paul,
> 
> I started dusting off a series I've been working to implement a relaxed
> atomic API in Linux (i.e. things like atomic_read(v, ACQUIRE)) but I'm
> having trouble making sense of the ordering semantics we have in mainline
> today:

>   2. Does smp_mb__after_unlock_lock order smp_store_release against
>      smp_load_acquire? Again, Documentation/memory-barriers.txt puts
>      these operations into the RELEASE and ACQUIRE classes respectively,
>      but since smp_mb__after_unlock_lock is a NOP everywhere other than
>      PowerPC, I don't think this is enforced by the current code. 

Yeah, wasn't Paul going to talk to Ben about that? PPC is the only arch
that has the weak ACQUIRE/RELEASE for its spinlocks.

>      Most
>      architectures follow the pattern used by asm-generic/barrier.h:
> 
>        release: smp_mb(); STORE
>        acquire: LOAD; smp_mb();
> 
>      which doesn't provide any release -> acquire ordering afaict.

Only when combined on the same address, if the LOAD observes the result
of the STORE we can guarantee the rest of the ordering. And if you
build a locking primitive with them (or circular lists or whatnot) you
have that extra condition.

But yes, I see your argument that this implementation is weak like the
PPC.
