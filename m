Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbaCMPyJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 11:54:09 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:48984 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753238AbaCMPyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 11:54:07 -0400
Date: Thu, 13 Mar 2014 15:53:40 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: Will Deacon <Will.Deacon@arm.com>, Peter Zijlstra <peterz@infradead.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] arm64: Fix __addr_ok and __range_ok macros
Message-ID: <20140313155340.GL30339@arm.com>
References: <1394059289-3972-1-git-send-email-cov@codeaurora.org>
 <20140313112019.GD30339@arm.com>
 <5321B56D.1030004@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5321B56D.1030004@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 01:41:01PM +0000, Christopher Covington wrote:
> On 03/13/2014 07:20 AM, Catalin Marinas wrote:
> > On Wed, Mar 05, 2014 at 10:41:28PM +0000, Christopher Covington wrote:
> >> @@ -83,7 +83,7 @@ static inline void set_fs(mm_segment_t fs)
> >>   * Returns 1 if the range is valid, 0 otherwise.
> >>   *
> >>   * This is equivalent to the following test:
> >> - * (u65)addr + (u65)size < (u65)current->addr_limit
> >> + * (u65)addr + (u65)size <= current->addr_limit
> >>   *
> >>   * This needs 65-bit arithmetic.
> >>   */
> >> @@ -91,7 +91,7 @@ static inline void set_fs(mm_segment_t fs)
> >>  ({									\
> >>  	unsigned long flag, roksum;					\
> >>  	__chk_user_ptr(addr);						\
> >> -	asm("adds %1, %1, %3; ccmp %1, %4, #2, cc; cset %0, cc"		\
> >> +	asm("adds %1, %1, %3; ccmp %1, %4, #3, cc; cset %0, ls"		\
> >>  		: "=&r" (flag), "=&r" (roksum)				\
> >>  		: "1" (addr), "Ir" (size),				\
> >>  		  "r" (current_thread_info()->addr_limit)		\
> > 
> > Just trying to understand: if adds does not set the C flag, we go on and
> > do the ccmp. If addr + size <= addr_limit, "cset ls" sets the flag
> > variable. If addr + size actually sets the C flag, we need to make sure
> > that "cset ls" doesn't trigger, which would mean to set C flag and clear
> > Z flag. So why do you change the ccmp flags from #2 to #3? It looks to
> > me like #2 is enough.
> 
> #2 is indeed sufficient. I'll respin using it.
> 
> I think Will's suggested approach could also work but I figure since I've
> taken the time to understand the assembly I might as well fix the problem
> there rather than adding another step in the calculation for developers and
> compilers to parse. (I don't know if this code is performance critical, but I
> nevertheless wanted to see how the compiler handled Will's approach.
> Unfortunately my initial implementation resulted in unaligned opcode errors
> and I haven't yet dug in.)

If it's only one condition change, I would prefer the inline asm fix. I
haven't done any benchmarks with a C-only implementation to assess the
impact.

For __addr_ok() I think the compiler should be good enough as we don't
need 65-bit arithmetics but we can leave it as it is.

-- 
Catalin
