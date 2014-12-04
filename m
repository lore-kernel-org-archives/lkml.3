Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbaLDOlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 09:41:23 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:38658 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753696AbaLDOlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 09:41:21 -0500
Date: Thu, 4 Dec 2014 06:41:11 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 1/9] kernel: Provide READ_ONCE and ASSIGN_ONCE
Message-ID: <20141204144111.GN25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1417645821-54731-1-git-send-email-borntraeger@de.ibm.com>
 <1417645821-54731-2-git-send-email-borntraeger@de.ibm.com>
 <20141204000749.GX25340@linux.vnet.ibm.com>
 <5480285F.1070501@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5480285F.1070501@de.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120414-0021-0000-0000-000006A707B4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 10:24:47AM +0100, Christian Borntraeger wrote:
> Am 04.12.2014 um 01:07 schrieb Paul E. McKenney:
> > On Wed, Dec 03, 2014 at 11:30:13PM +0100, Christian Borntraeger wrote:
> >> ACCESS_ONCE does not work reliably on non-scalar types. For
> >> example gcc 4.6 and 4.7 might remove the volatile tag for such
> >> accesses during the SRA (scalar replacement of aggregates) step
> >> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145)
> >>
> >> Let's provide READ_ONCE/ASSIGN_ONCE that will do all accesses via
> >> scalar types as suggested by Linus Torvalds. Accesses larger than
> >> the machines word size cannot be guaranteed to be atomic. These
> >> macros will use memcpy and emit a build warning.
> >>
> >> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> > 
> > With or without some nits below addressed:
> > 
> > Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> >> ---
> >>  include/linux/compiler.h | 64 ++++++++++++++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 64 insertions(+)
> >>
> >> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> >> index d5ad7b1..947710e 100644
> >> --- a/include/linux/compiler.h
> >> +++ b/include/linux/compiler.h
> >> @@ -186,6 +186,70 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
> >>  # define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __LINE__)
> >>  #endif
> >>
> >> +#include <linux/types.h>
> >> +
> >> +void data_access_exceeds_word_size(void)
> >> +__compiletime_warning("data access exceeds word size and won't be atomic");
> >> +
> >> +static __always_inline void __read_once_size(volatile void *p, void *res, int size)
> >> +{
> >> +	switch (size) {
> >> +	case 1: *(u8 *)res = *(volatile u8 *)p; break;
> >> +	case 2: *(u16 *)res = *(volatile u16 *)p; break;
> >> +	case 4: *(u32 *)res = *(volatile u32 *)p; break;
> >> +#ifdef CONFIG_64BIT
> >> +	case 8: *(u64 *)res = *(volatile u64 *)p; break;
> >> +#endif
> > 
> > You could get rid of the #ifdef above by doing "case sizeof(long)"
> > and switching the casts from u64 to unsigned long.
> 
> Wouldnt that cause a compile warning because we have two case statements
> with the same size?

Indeed it would!  Color me blind and oblivious.

> >> +	default:
> >> +		barrier();
> >> +		__builtin_memcpy((void *)res, (const void *)p, size);
> >> +		data_access_exceeds_word_size();
> >> +		barrier();
> >> +	}
> >> +}
> >> +
> >> +static __always_inline void __assign_once_size(volatile void *p, void *res, int size)
> >> +{
> >> +	switch (size) {
> >> +	case 1: *(volatile u8 *)p = *(u8 *)res; break;
> >> +	case 2: *(volatile u16 *)p = *(u16 *)res; break;
> >> +	case 4: *(volatile u32 *)p = *(u32 *)res; break;
> >> +#ifdef CONFIG_64BIT
> >> +	case 8: *(volatile u64 *)p = *(u64 *)res; break;
> >> +#endif
> > 
> > Ditto.
> > 
> >> +	default:
> >> +		barrier();
> >> +		__builtin_memcpy((void *)p, (const void *)res, size);
> >> +		data_access_exceeds_word_size();
> >> +		barrier();
> >> +	}
> >> +}
> >> +
> >> +/*
> >> + * Prevent the compiler from merging or refetching reads or writes. The compiler
> >> + * is also forbidden from reordering successive instances of READ_ONCE,
> >> + * ASSIGN_ONCE and ACCESS_ONCE (see below), but only when the compiler is aware
> >> + * of some particular ordering.  One way to make the compiler aware of ordering
> >> + * is to put the two invocations of READ_ONCE, ASSIGN_ONCE or ACCESS_ONCE() in
> >> + * different C statements.
> >> + *
> >> + * In contrast to ACCESS_ONCE these two macros will also work on aggregate data
> >> + * types like structs or unions. If the size of the accessed data type exceeds
> >> + * the word size of the machine (e.g. 32bit or 64bit), the access might happen
> >> + * in multiple chunks, though.
> > 
> > This last sentence might be more clear if it was something like the
> > following:
> > 
> > 	If the size of the accessed data type exceeeds the word size of
> > 	the machine (e.g., 32 bits or 64 bits), ACCESS_ONCE() might
> > 	carry out the access in multiple chunks, but READ_ONCE() and
> > 	ASSIGN_ONCE() will give a link-time error.
> 
> The code in v4 now combines Linus (memcpy) and your (error) suggestion. We do a memcpy and a compile time _warning_
> 
> So I will do 
> 
>  * In contrast to ACCESS_ONCE these two macros will also work on aggregate
>  * data types like structs or unions. If the size of the accessed data
>  * type exceeds the word size of the machine (e.g., 32 bits or 64 bits)
>  * READ_ONCE() and ASSIGN_ONCE()  will fall back to memcpy and print a
>  * compile-time warning.

Very good!

							Thanx, Paul

> >> + *
> >> + * These macros do absolutely -nothing- to prevent the CPU from reordering,
> >> + * merging, or refetching absolutely anything at any time.  Their main intended
> >> + * use is to mediate communication between process-level code and irq/NMI
> >> + * handlers, all running on the same CPU.
> > 
> > This last sentence is now obsolete.  How about something like this?
> > 
> > 	Their two major use cases are: (1) Mediating communication
> > 	between process-level code and irq/NMI handlers, all running
> > 	on the same CPU, and (2) Ensuring that the compiler does not
> > 	fold, spindle, or otherwise mutilate accesses that either do
> > 	not require ordering or that interact with an explicit memory
> > 	barrier or atomic instruction that provides the required ordering.
> 
> sounds good. Will change.
> 
> Thanks
> 
> > 
> >> + */
> >> +
> >> +#define READ_ONCE(p) \
> >> +      ({ typeof(p) __val; __read_once_size(&p, &__val, sizeof(__val)); __val; })
> >> +
> >> +#define ASSIGN_ONCE(val, p) \
> >> +      ({ typeof(p) __val; __val = val; __assign_once_size(&p, &__val, sizeof(__val)); __val; })
> >> +
> >>  #endif /* __KERNEL__ */
> >>
> >>  #endif /* __ASSEMBLY__ */
> >> -- 
> >> 1.9.3
> >>
> 

