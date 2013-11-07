Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab3KGNhL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 08:37:11 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53515 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab3KGNhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 08:37:06 -0500
Date: Thu, 7 Nov 2013 14:36:25 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Victor Kaplansky <VICTORK@il.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>,
        Russell King <linux@arm.linux.org.uk>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [RFC] arch: Introduce new TSO memory barrier smp_tmb()
Message-ID: <20131107133625.GU10651@twins.programming.kicks-ass.net>
References: <CA+55aFyD_kCkAHQwHCUBrumO-pH6LaZikTNvyWDW_tWsHdqk6Q@mail.gmail.com>
 <20131104105059.GL3947@linux.vnet.ibm.com>
 <20131104112254.GK28601@twins.programming.kicks-ass.net>
 <20131104162732.GN3947@linux.vnet.ibm.com>
 <20131104191127.GW16117@laptop.programming.kicks-ass.net>
 <20131104205344.GW3947@linux.vnet.ibm.com>
 <20131106123946.GJ10651@twins.programming.kicks-ass.net>
 <CAMuHMdXZjQJvT7R4ODbDNBgAVwPUBPjB6UoR66_sNuFx7opUDw@mail.gmail.com>
 <20131106135736.GK10651@twins.programming.kicks-ass.net>
 <20131107111741.GD13139@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131107111741.GD13139@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 11:17:41AM +0000, Will Deacon wrote:
> Hi Peter,
> 
> Couple of minor fixes on the arm64 side...
> 
> On Wed, Nov 06, 2013 at 01:57:36PM +0000, Peter Zijlstra wrote:
> > --- a/arch/arm64/include/asm/barrier.h
> > +++ b/arch/arm64/include/asm/barrier.h
> > @@ -35,11 +35,59 @@
> >  #define smp_mb()       barrier()
> >  #define smp_rmb()      barrier()
> >  #define smp_wmb()      barrier()
> > +
> > +#define smp_store_release(p, v)                                                \
> > +do {                                                                   \
> > +       compiletime_assert_atomic_type(*p);                             \
> > +       smp_mb();                                                       \
> > +       ACCESS_ONCE(*p) = (v);                                          \
> > +} while (0)
> > +
> > +#define smp_load_acquire(p)                                            \
> > +({                                                                     \
> > +       typeof(*p) ___p1 = ACCESS_ONCE(*p);                             \
> > +       compiletime_assert_atomic_type(*p);                             \
> > +       smp_mb();                                                       \
> > +       ___p1;                                                          \
> > +})
> > +
> >  #else
> > +
> >  #define smp_mb()       asm volatile("dmb ish" : : : "memory")
> >  #define smp_rmb()      asm volatile("dmb ishld" : : : "memory")
> >  #define smp_wmb()      asm volatile("dmb ishst" : : : "memory")
> > -#endif
> 
> Why are you getting rid of this #endif?

oops..

> > +#define smp_store_release(p, v)                                                \
> > +do {                                                                   \
> > +       compiletime_assert_atomic_type(*p);                             \
> > +       switch (sizeof(*p)) {                                           \
> > +       case 4:                                                         \
> > +               asm volatile ("stlr %w1, [%0]"                          \
> > +                               : "=Q" (*p) : "r" (v) : "memory");      \
> > +               break;                                                  \
> > +       case 8:                                                         \
> > +               asm volatile ("stlr %1, [%0]"                           \
> > +                               : "=Q" (*p) : "r" (v) : "memory");      \
> > +               break;                                                  \
> > +       }                                                               \
> > +} while (0)
> > +
> > +#define smp_load_acquire(p)                                            \
> > +({                                                                     \
> > +       typeof(*p) ___p1;                                               \
> > +       compiletime_assert_atomic_type(*p);                             \
> > +       switch (sizeof(*p)) {                                           \
> > +       case 4:                                                         \
> > +               asm volatile ("ldar %w0, [%1]"                          \
> > +                       : "=r" (___p1) : "Q" (*p) : "memory");          \
> > +               break;                                                  \
> > +       case 8:                                                         \
> > +               asm volatile ("ldar %0, [%1]"                           \
> > +                       : "=r" (___p1) : "Q" (*p) : "memory");          \
> > +               break;                                                  \
> > +       }                                                               \
> > +       ___p1;                                                          \
> > +})
> 
> You don't need the square brackets when using the "Q" constraint (otherwise
> it will expand to something like [[x0]], which gas won't accept).
> 
> With those changes, for the general idea and arm/arm64 parts:
> 
>   Acked-by: Will Deacon <will.deacon@arm.com>

Thanks, I did that split-up I talked about yesterday, I was going to
compile them for all archs I have a compiler for before posting again.



---
--- a/arch/arm64/include/asm/barrier.h
+++ b/arch/arm64/include/asm/barrier.h
@@ -62,11 +62,11 @@ do {									\
 	compiletime_assert_atomic_type(*p);				\
 	switch (sizeof(*p)) {						\
 	case 4:								\
-		asm volatile ("stlr %w1, [%0]"				\
+		asm volatile ("stlr %w1, %0"				\
 				: "=Q" (*p) : "r" (v) : "memory");	\
 		break;							\
 	case 8:								\
-		asm volatile ("stlr %1, [%0]"				\
+		asm volatile ("stlr %1, %0"				\
 				: "=Q" (*p) : "r" (v) : "memory");	\
 		break;							\
 	}								\
@@ -78,17 +78,19 @@ do {									\
 	compiletime_assert_atomic_type(*p);				\
 	switch (sizeof(*p)) {						\
 	case 4:								\
-		asm volatile ("ldar %w0, [%1]"				\
+		asm volatile ("ldar %w0, %1"				\
 			: "=r" (___p1) : "Q" (*p) : "memory");		\
 		break;							\
 	case 8:								\
-		asm volatile ("ldar %0, [%1]"				\
+		asm volatile ("ldar %0, %1"				\
 			: "=r" (___p1) : "Q" (*p) : "memory");		\
 		break;							\
 	}								\
 	___p1;								\
 })
 
+#endif
+
 #define read_barrier_depends()		do { } while(0)
 #define smp_read_barrier_depends()	do { } while(0)
 
