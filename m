Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbbAMQeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:34:05 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:33132 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbbAMQeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:34:00 -0500
Date: Tue, 13 Jan 2015 16:33:54 +0000
From: Will Deacon <will.deacon@arm.com>
To: paulmck@linux.vnet.ibm.com, peterz@infradead.org
Cc: torvalds@linux-foundation.org, oleg@redhat.com, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Behaviour of smp_mb__{before,after}_spin* and acquire/release
Message-ID: <20150113163353.GE31784@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

I started dusting off a series I've been working to implement a relaxed
atomic API in Linux (i.e. things like atomic_read(v, ACQUIRE)) but I'm
having trouble making sense of the ordering semantics we have in mainline
today:

  1. Does smp_mb__before_spinlock actually have to order prior loads
     against later loads and stores? Documentation/memory-barriers.txt
     says it does, but that doesn't match the comment (or implementation)
     in include/linux/spinlock.h

  2. Does smp_mb__after_unlock_lock order smp_store_release against
     smp_load_acquire? Again, Documentation/memory-barriers.txt puts
     these operations into the RELEASE and ACQUIRE classes respectively,
     but since smp_mb__after_unlock_lock is a NOP everywhere other than
     PowerPC, I don't think this is enforced by the current code. Most
     architectures follow the pattern used by asm-generic/barrier.h:

       release: smp_mb(); STORE
       acquire: LOAD; smp_mb();

     which doesn't provide any release -> acquire ordering afaict.

My plan for the atomics was to add acquire, release, acquire + release
and unordered variants, where the acquire/release semantics would
actually be sequentially consistent. That allows us to implement the
existing atomics easily in terms of the new API, but it's different
to what we're doing for the smp_load_acquire and smp_store_release
functions above.

Cheers,

Will
