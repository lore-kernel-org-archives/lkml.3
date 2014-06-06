Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbaFFR5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:57:13 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45504 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752160AbaFFR5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:57:10 -0400
Message-ID: <1402077427.2207.91.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH 2/2] locking/rwsem: Disable optimistic spinning for
 PA-RISC
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>, Jason Low <jason.low2@hp.com>,
        Waiman Long <waiman.long@hp.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        John David Anglin <dave.anglin@bell.net>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        James Hogan <james.hogan@imgtec.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Vineet Gupta <vgupta@synopsys.com>
Date: Fri, 06 Jun 2014 10:57:07 -0700
In-Reply-To: <20140606175316.GV13930@laptop.programming.kicks-ass.net>
References: <1402070140-15090-1-git-send-email-davidlohr@hp.com>
	 <1402070140-15090-3-git-send-email-davidlohr@hp.com>
	 <1402070987.2207.75.camel@dabdike.int.hansenpartnership.com>
	 <20140606171145.GU13930@laptop.programming.kicks-ass.net>
	 <CA+55aFxNLRufHyLHetnst7Lq0Ya1xoAagZf=DbEDTf1ZSfKFCQ@mail.gmail.com>
	 <20140606175316.GV13930@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-06 at 19:53 +0200, Peter Zijlstra wrote:
> On Fri, Jun 06, 2014 at 10:22:21AM -0700, Linus Torvalds wrote:
> > On Fri, Jun 6, 2014 at 10:11 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > >
> > > +config ARCH_NO_ATOMIC_RMW
> > > +       def_bool y
> > > +       depends on PARISC || SPARC32 || METAG_ATOMICITY_LOCK1 || (TILE && !TILEGX) || (ARC && !ARC_HAS_LLSC)
> > 
> > Ugh. We've had these kinds of things before, and they are broken and
> > nasty to maintain.
> > 
> > Just make it
> > 
> >     config ARCH_SUPPORTS_ATOMIC_RMW
> >         bool
> > 
> > which defaults to no. And then make MUTEX_SPIN_ON_OWNER depend on that.
> 
> ---
> Subject: locking, mutex: Make optimistic spinning depend on ARCH_SUPPORTS_ATOMIC_RMW
> 
> The optimistic spin code assumes regular stores and cmpxchg() play nice;
> this is found to not be true for at least: parisc, sparc32, tile32,
> metag-lock1, arc-!llsc and hexagon.
> 
> There is further wreckage, but this in particular seemed easy to
> trigger, so blacklist this.
> 
> Opt in for known good archs.
> 
> Reported-by: Mikulas Patocka <mpatocka@redhat.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  arch/arm/Kconfig     | 1 +
>  arch/arm64/Kconfig   | 1 +
>  arch/powerpc/Kconfig | 1 +
>  arch/sparc/Kconfig   | 1 +
>  arch/x86/Kconfig     | 1 +
>  kernel/Kconfig.locks | 5 ++++-
>  6 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index a2c1a18a7275..b8a6a5078eae 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -6,6 +6,7 @@ config ARM
>  	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
>  	select ARCH_HAVE_CUSTOM_GPIO_H
>  	select ARCH_MIGHT_HAVE_PC_PARPORT
> +	select ARCH_SUPPORTS_ATOMIC_RMW
>  	select ARCH_USE_BUILTIN_BSWAP
>  	select ARCH_USE_CMPXCHG_LOCKREF
>  	select ARCH_WANT_IPC_PARSE_VERSION
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 5c30b10c0f6c..339dc07f15e2 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -3,6 +3,7 @@ config ARM64
>  	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
>  	select ARCH_USE_CMPXCHG_LOCKREF
>  	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
> +	select ARCH_SUPPORTS_ATOMIC_RMW
>  	select ARCH_WANT_OPTIONAL_GPIOLIB
>  	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION
>  	select ARCH_WANT_FRAME_POINTERS
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index e0998997943b..5bb96f282373 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -145,6 +145,7 @@ config PPC
>  	select HAVE_IRQ_EXIT_ON_IRQ_STACK
>  	select ARCH_USE_CMPXCHG_LOCKREF if PPC64
>  	select HAVE_ARCH_AUDITSYSCALL
> +	select ARCH_SUPPORTS_ATOMIC_RMW
>  
>  config GENERIC_CSUM
>  	def_bool CPU_LITTLE_ENDIAN
> diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
> index 29f2e988c56a..407c87d9879a 100644
> --- a/arch/sparc/Kconfig
> +++ b/arch/sparc/Kconfig
> @@ -78,6 +78,7 @@ config SPARC64
>  	select HAVE_C_RECORDMCOUNT
>  	select NO_BOOTMEM
>  	select HAVE_ARCH_AUDITSYSCALL
> +	select ARCH_SUPPORTS_ATOMIC_RMW

Sparc64 does, Sparc32 doesn't, so shouldn't that be

select ARCH_SUPPORTS_ATOMIC_RMW if 64BIT

?

Other than this, looks good to me (you can add reviewed by or acked by
from me to your taste).

James


