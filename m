Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370Ab3FJU7C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 16:59:02 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:41359 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab3FJU7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 16:59:00 -0400
Date: Mon, 10 Jun 2013 13:57:51 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, torvalds@linux-foundation.org
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
Message-ID: <20130610205751.GP5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130609193657.GA13392@linux.vnet.ibm.com>
 <1370897278.9844.115.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370897278.9844.115.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061020-3620-0000-0000-0000030A7669
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 04:47:58PM -0400, Steven Rostedt wrote:
> On Sun, 2013-06-09 at 12:36 -0700, Paul E. McKenney wrote:
> 
> > --- a/arch/x86/include/asm/spinlock_types.h
> > +++ b/arch/x86/include/asm/spinlock_types.h
> > @@ -7,12 +7,18 @@
> >  
> >  #include <linux/types.h>
> >  
> > -#if (CONFIG_NR_CPUS < 256)
> > +#if (CONFIG_NR_CPUS < 128)
> >  typedef u8  __ticket_t;
> >  typedef u16 __ticketpair_t;
> > -#else
> > +#define TICKET_T_CMP_GE(a, b) (UCHAR_MAX / 2 >= (unsigned char)((a) - (b)))
> > +#elif (CONFIG_NR_CPUS < 32768)
> >  typedef u16 __ticket_t;
> >  typedef u32 __ticketpair_t;
> > +#define TICKET_T_CMP_GE(a, b) (USHRT_MAX / 2 >= (unsigned short)((a) - (b)))
> > +#else
> > +typedef u32 __ticket_t;
> > +typedef u64 __ticketpair_t;
> > +#define TICKET_T_CMP_GE(a, b) (UINT_MAX / 2 >= (unsigned int)((a) - (b)))
> >  #endif
> >  
> >  #define TICKET_SHIFT	(sizeof(__ticket_t) * 8)
> > @@ -21,7 +27,11 @@ typedef struct arch_spinlock {
> >  	union {
> >  		__ticketpair_t head_tail;
> >  		struct __raw_tickets {
> > +#ifdef __BIG_ENDIAN__
> 
> Is there such a thing as a BIG_ENDIAN x86 box? This is in
> arch/x86/include/asm/spinlock_types.h

Nope.  Preparation work for moving this to common code.

Good point though, I should have skipped this #ifdef until I got everything
into common code.

							Thanx, Paul

> -- Steve
> 
> > +			__ticket_t tail, head;
> > +#else /* #ifdef __BIG_ENDIAN__ */
> >  			__ticket_t head, tail;
> > +#endif /* #else #ifdef __BIG_ENDIAN__ */
> >  		} tickets;
> >  	};
> >  } arch_spinlock_t;
> 
> 

