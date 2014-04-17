Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbaDQOBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 10:01:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57987 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbaDQOAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 10:00:54 -0400
Date: Thu, 17 Apr 2014 16:00:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de,
        monstr@monstr.eu, dhowells@redhat.com, broonie@linaro.org,
        benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 00/18] Cross-architecture definitions of relaxed MMIO
 accessors
Message-ID: <20140417140036.GK11096@twins.programming.kicks-ass.net>
References: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 02:44:03PM +0100, Will Deacon wrote:
> Hello,
> 
> This RFC series attempts to define a portable (i.e. cross-architecture)
> definition of the {readX,writeX}_relaxed MMIO accessor functions. These
> functions are already in widespread use amongst drivers (mainly those supporting
> devices embedded in ARM SoCs), but lack any well-defined semantics and,
> subsequently, any portable definitions to allow these drivers to be compiled for
> other architectures.
> 
> The two main motivations for this series are:
> 
>  (1) To promote use of the _relaxed MMIO accessors on weakly-ordered
>      architectures, where they can bring significant performance improvements
>      over their non-relaxed counterparts.
> 
>  (2) To allow COMPILE_TEST to build drivers using the relaxed accessors across
>      all architectures.
> 
> The proposed semantics largely match exactly those provided by the ARM
> implementation (i.e. no weaker), with one exception (see below).
> 
> Informally:
> 
>   - Relaxed accesses to the same device are ordered with respect to each other.
> 
>   - Relaxed accesses are *not* guaranteed to be ordered with respect to normal
>     memory accesses (e.g. DMA buffers -- this is what gives us the performance
>     boost over the non-relaxed versions).
> 
>   - Relaxed accesses are not guaranteed to be ordered with respect to
>     LOCK/UNLOCK operations.
> 
> In actual fact, the relaxed accessors *are* ordered with respect to LOCK/UNLOCK
> operations on ARM[64], but I have added this constraint for the benefit of
> PowerPC, which has expensive I/O barriers in the spin_unlock path for the
> non-relaxed accessors.
> 
> A corollary to this is that mmiowb() probably needs rethinking. As it currently
> stands, an mmiowb() is required to order MMIO writes to a device from multiple
> CPUs, even if that device is protected by a lock. However, this isn't often used
> in practice, leading to PowerPC implementing both mmiowb() *and* synchronising
> I/O in spin_unlock.
> 
> I would propose making the non-relaxed I/O accessors ordered with respect to
> LOCK/UNLOCK, leaving mmiowb() to be used with the relaxed accessors, if
> required, but would welcome thoughts/suggestions on this topic.

So the non-relaxed ops already imply the expensive I/O barrier (mmiowb?)
and therefore, PPC can drop it from spin_unlock()?

Also, I read mmiowb() as MMIO-write-barrier(), what do we have to
order/contain mmio-reads?

I have _0_ experience with MMIO, so I've no idea if ordering/containing
reads is silly or not. 
