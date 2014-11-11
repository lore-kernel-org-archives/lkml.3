Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614AbaKKAkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 19:40:36 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:44885 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbaKKAkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 19:40:33 -0500
Date: Mon, 10 Nov 2014 16:37:16 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andreas Krebbel <Andreas.Krebbel@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: compiler bug gcc4.6/4.7 with ACCESS_ONCE and workarounds
Message-ID: <20141111003716.GQ4901@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1415360716-9670-2-git-send-email-borntraeger@de.ibm.com>
 <54611D86.4040306@de.ibm.com>
 <CA+55aFyEigSL64RJH8AO86gFBBB84+dgk7eEUPx=CaLwJMcO_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyEigSL64RJH8AO86gFBBB84+dgk7eEUPx=CaLwJMcO_w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111100-0033-0000-0000-000002A19818
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 01:07:33PM -0800, Linus Torvalds wrote:
> On Mon, Nov 10, 2014 at 12:18 PM, Christian Borntraeger
> <borntraeger@de.ibm.com> wrote:
> >
> > Now: I can reproduces belows miscompile on gcc46 and gcc 47
> > gcc 45 seems ok, gcc 48 is fixed.  This makes blacklisting
> > a bit hard, especially since it is not limited to s390, but
> > covers all architectures.
> > In essence ACCESS_ONCE will not work reliably on aggregate
> > types with gcc 4.6 and gcc 4.7.
> > In Linux we seem to use ACCESS_ONCE mostly on scalar types,
> > below code is an example were we dont - and break.
> 
> Hmm. I think we should see how painful it would be to make it a rule
> that ACCESS_ONCE() only works on scalar types.

For whatever it is worth, I have been assuming that ACCESS_ONCE() was
only ever supposed to work on scalar types.  And one of the reasons
that I have been giving the pre-EV56 Alpha guys a hard time is because
I would like us to be able to continue using ACCESS_ONCE() on 8-bit and
16-bit quantities as well.

> Even in the actual code you show as an example, the "fix" is really to
> use the "unsigned long val" member of the union for the ACCESS_ONCE().
> And that seems to be true in many other cases too.
> 
> So before blacklisting any compilers, let's first see if
> 
>  (a) we can actually make it a real rule that we only use ACCESS_ONCE on scalars
>  (b) we can somehow enforce this with a compiler warning/error for mis-uses
> 
> For example, the attached patch works for some cases, but shows how we
> use ACCESS_ONCE() on pointers to pte_t's etc, so it doesn't come even
> close to compiling the whole kernel. But I wonder how painful that
> would be to change.. The places where it complains are actually
> somewhat debatable to begin with, like:
> 
>  - handle_pte_fault(.. pte_t *pte ..):
> 
>         entry = ACCESS_ONCE(*pte);
> 
> and the thing is, "pte" is actually possibly an 8-byte entity on
> x86-32, and that ACCESS_ONCE() fundamentally will be two 32-byte
> reads.
> 
> So there is a very valid argument for saying "well, you shouldn't do
> that, then", and that we might be better off cleaning up our
> ACCESS_ONCE() uses, than to just blindly blacklist compilers.
> 
> NOTE! I'm not at all advocating the attached patch. I'm sending it out
> white-space damaged on purpose, it's more of a "hey, something like
> this might be the direction we want to go in", with the spinlock.h
> part of the patch also acting as an example of the kind of changes the
> "ACCESS_ONCE() only works on scalars" rule would require.
> 
> So I do agree with Heiko that we generally don't want to work around
> compiler bugs if we can avoid it. But sometimes the compiler bugs do
> end up saying "your'e doing something very fragile". Maybe we should
> try to be less fragile here.
> 
> And in your example, the whole
> 
>         old = ACCESS_ONCE(*ic);
> 
> *could* just be a
> 
>         old->val = ACCESS_ONCE(ic->val);
> 
> the same way the x86 spinlock.h changes below.
> 
> I did *not* try to see how many other cases we have. It's possible
> that your "don't use ACCESS_ONCE, use a barrier() instead" ends up
> being a valid workaround. For the pte case, that may well be the
> solution, for example (because what we really care about is not so
> much "it's an atomic access" but "it's still the same that we
> originally assumed").  Sometimes we want ACCESS_ONCE() because we
> really want an atomic value (and we just don't care if it's old or
> new), but sometimes it's really because we don't want the compiler to
> re-load it and possibly see two different values - one that we check,
> and one that we actually use (and then a barrier() would generally be
> perfectly sufficient)
> 
> Adding some more people to the discussion just to see if anybody else
> has comments about ACCESS_ONCE() on aggregate types.
> 
> (Btw, it's not just aggregate types, even non-aggregate types like
> "long long" are not necessarily safe, to give the same 64-bit on
> x86-32 example. So adding an assert that it's smaller or equal in size
> to a "long" might also not be unreasonable)

Good point on "long long" on 32-bit systems.

Another reason to avoid trying to do anything that even smells atomic on
non-machine-sized/aligned variables is that the compiler guys' current
reaction to this sort of situation is "No problem!!!  The compiler can
just invent a lock to guard all such accesses!"  I don't think that we
want to go there.

>                    Linus
> 
> ---
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index d5ad7b1118fc..63e82f1dfc1a 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -378,7 +378,11 @@ void ftrace_likely_update(struct
> ftrace_branch_data *f, int val, int expect);
>   * use is to mediate communication between process-level code and irq/NMI
>   * handlers, all running on the same CPU.
>   */
> -#define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
> +#define get_scalar_volatile_pointer(x) ({ \
> +       typeof(x) *__p = &(x); \
> +       volatile typeof(x) *__vp = __p; \
> +       (void)(long)*__p; __vp; })
> +#define ACCESS_ONCE(x) (*get_scalar_volatile_pointer(x))

I know you said that this was to be experimental, but it happily loads
from a "long long" on 32-bit x86 running gcc version 4.6.3, and does it
32 bits at a time.  How about something like the following instead?

#define get_scalar_volatile_pointer(x) ({ \
	typeof(x) *__p = &(x); \
	BUILD_BUG_ON(sizeof(x) != sizeof(char) && \
		     sizeof(x) != sizeof(short) && \
		     sizeof(x) != sizeof(int) && \
		     sizeof(x) != sizeof(long)); \
	volatile typeof(x) *__vp = __p; \
	(void)(long)*__p; __vp; })
#define ACCESS_ONCE(x) (*get_scalar_volatile_pointer(x))

							Thanx, Paul

> 
>  /* Ignore/forbid kprobes attach on very low level functions marked by
> this attribute: */
>  #ifdef CONFIG_KPROBES
> diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
> index 9295016485c9..b7e6825af5e3 100644
> --- a/arch/x86/include/asm/spinlock.h
> +++ b/arch/x86/include/asm/spinlock.h
> @@ -105,7 +105,7 @@ static __always_inline int
> arch_spin_trylock(arch_spinlock_t *lock)
>  {
>         arch_spinlock_t old, new;
> 
> -       old.tickets = ACCESS_ONCE(lock->tickets);
> +       old.head_tail = ACCESS_ONCE(lock->head_tail);
>         if (old.tickets.head != (old.tickets.tail & ~TICKET_SLOWPATH_FLAG))
>                 return 0;
> 
> @@ -162,16 +162,14 @@ static __always_inline void
> arch_spin_unlock(arch_spinlock_t *lock)
> 
>  static inline int arch_spin_is_locked(arch_spinlock_t *lock)
>  {
> -       struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
> -
> -       return tmp.tail != tmp.head;
> +       struct arch_spinlock tmp = { .head_tail =
> ACCESS_ONCE(lock->head_tail) };
> +       return tmp.tickets.tail != tmp.tickets.head;
>  }
> 
>  static inline int arch_spin_is_contended(arch_spinlock_t *lock)
>  {
> -       struct __raw_tickets tmp = ACCESS_ONCE(lock->tickets);
> -
> -       return (__ticket_t)(tmp.tail - tmp.head) > TICKET_LOCK_INC;
> +       struct arch_spinlock tmp = { .head_tail =
> ACCESS_ONCE(lock->head_tail) };
> +       return (__ticket_t)(tmp.tickets.tail - tmp.tickets.head) >
> TICKET_LOCK_INC;
>  }
>  #define arch_spin_is_contended arch_spin_is_contended
> 

