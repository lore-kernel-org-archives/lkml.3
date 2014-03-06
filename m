Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbaCFQJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 11:09:04 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44610 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751082AbaCFQJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 11:09:02 -0500
Date: Thu, 6 Mar 2014 16:08:18 +0000
From: Will Deacon <will.deacon@arm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Christopher Covington <cov@codeaurora.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] arm64: Fix __addr_ok and __range_ok macros
Message-ID: <20140306160817.GJ5202@mudshark.cambridge.arm.com>
References: <1394059289-3972-1-git-send-email-cov@codeaurora.org>
 <20140306082023.GA4160@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140306082023.GA4160@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 08:20:23AM +0000, Michael S. Tsirkin wrote:
> On Wed, Mar 05, 2014 at 05:41:28PM -0500, Christopher Covington wrote:
> > Without this, the following scenario is incorrectly determined
> > to be invalid.
> > 
> > addr 0x7f_ffffe000 size 8192 addr_limit 0x80_00000000
> > 
> > This behavior was observed while trying to vmsplice the stack
> > as part of a CRIU dump of a process.
> > 
> > Signed-off-by: Christopher Covington <cov@codeaurora.org>
> > ---
> >  arch/arm64/include/asm/uaccess.h | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
> > index edb3d5c..9309024 100644
> > --- a/arch/arm64/include/asm/uaccess.h
> > +++ b/arch/arm64/include/asm/uaccess.h
> > @@ -66,12 +66,12 @@ static inline void set_fs(mm_segment_t fs)
> >  #define segment_eq(a,b)	((a) == (b))
> >  
> >  /*
> > - * Return 1 if addr < current->addr_limit, 0 otherwise.
> > + * Return 1 if addr <= current->addr_limit, 0 otherwise.
> >   */
> >  #define __addr_ok(addr)							\
> >  ({									\
> >  	unsigned long flag;						\
> > -	asm("cmp %1, %0; cset %0, lo"					\
> > +	asm("cmp %1, %0; cset %0, ls"					\
> >  		: "=&r" (flag)						\
> >  		: "r" (addr), "0" (current_thread_info()->addr_limit)	\
> >  		: "cc");						\

I don't think this is correct, since __addr_ok will now return true for
TASK_SIZE_64.

> BTW can this use mov %0, #0 like arch/arm/include/asm/uaccess.h does?
> Would make it more portable ...

How/why should this be made portable?

> > @@ -83,7 +83,7 @@ static inline void set_fs(mm_segment_t fs)
> >   * Returns 1 if the range is valid, 0 otherwise.
> >   *
> >   * This is equivalent to the following test:
> > - * (u65)addr + (u65)size < (u65)current->addr_limit
> > + * (u65)addr + (u65)size <= current->addr_limit
> >   *
> >   * This needs 65-bit arithmetic.
> >   */
> > @@ -91,7 +91,7 @@ static inline void set_fs(mm_segment_t fs)
> >  ({									\
> >  	unsigned long flag, roksum;					\
> >  	__chk_user_ptr(addr);						\
> > -	asm("adds %1, %1, %3; ccmp %1, %4, #2, cc; cset %0, cc"		\
> > +	asm("adds %1, %1, %3; ccmp %1, %4, #3, cc; cset %0, ls"		\
> >  		: "=&r" (flag), "=&r" (roksum)				\
> >  		: "1" (addr), "Ir" (size),				\
> >  		  "r" (current_thread_info()->addr_limit)		\

Can't you just pass current_thread_info()->addr_limit) - 1 here and be done
with it?

Will
