Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab3CLDjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 23:39:14 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:53387 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427Ab3CLDjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 23:39:13 -0400
Date: Mon, 11 Mar 2013 20:39:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Shaohua Li <shli@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] atomic: improve
 atomic_inc_unless_negative/atomic_dec_unless_positive
Message-ID: <20130312033906.GA3725@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1362843501-31159-1-git-send-email-tom.leiming@gmail.com>
 <CAFTL4hyO7HxGYOL=Fvq-g3LY37PY2f+xR6+stA7-wNkh3wkV=Q@mail.gmail.com>
 <CACVXFVMu9FNTghOQjNryY59S6xkRqg9DR5=OshngUDEZ5Fb=4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVMu9FNTghOQjNryY59S6xkRqg9DR5=OshngUDEZ5Fb=4w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031203-9360-0000-0000-00001147F617
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 10:15:42AM +0800, Ming Lei wrote:
> On Tue, Mar 12, 2013 at 7:59 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > 2013/3/9 Ming Lei <tom.leiming@gmail.com>:
> >> Generally, both atomic_inc_unless_negative() and
> >> atomic_dec_unless_positive() need at least two atomic_cmpxchg()
> >> to complete the atomic operation. In fact, the 1st atomic_cmpxchg()
> >> is just used to read current value of the atomic variable at most times.
> >>
> >> Considered memory barrier, bus lock, cache walking, etc. things may be
> >> involved in atomic_cmpxchg(), it is much expensive than atomic_read(),
> >> which is just the simple below:
> >>
> >>         (*(volatile int *)&(v)->counter)
> >>
> >> so this patch can save one extra atomic_cmpxchg() for the two
> >> helpers under general situation, and should improve them a bit.
> >>
> >> Cc: Andrew Morton <akpm@linux-foundation.org>
> >> Cc: Shaohua Li <shli@kernel.org>
> >> Cc: Al Viro <viro@zeniv.linux.org.uk>
> >> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> >> ---
> >>  include/linux/atomic.h |   28 ++++++++++++++++++----------
> >>  1 file changed, 18 insertions(+), 10 deletions(-)
> >>
> >> diff --git a/include/linux/atomic.h b/include/linux/atomic.h
> >> index 5b08a85..aa951d8 100644
> >> --- a/include/linux/atomic.h
> >> +++ b/include/linux/atomic.h
> >> @@ -63,26 +63,34 @@ static inline int atomic_inc_not_zero_hint(atomic_t *v, int hint)
> >>  #ifndef atomic_inc_unless_negative
> >>  static inline int atomic_inc_unless_negative(atomic_t *p)
> >>  {
> >> -       int v, v1;
> >> -       for (v = 0; v >= 0; v = v1) {
> >> -               v1 = atomic_cmpxchg(p, v, v + 1);
> >> -               if (likely(v1 == v))
> >> +       int v, t;
> >> +
> >> +       v = atomic_read(p);
> >> +       while (1) {
> >> +               if (unlikely(v < 0))
> >> +                       return 0;
> >
> > But atomic_read() lacks the full memory barrier that is needed for
> > proper atomicity here.
> >
> > For example if the initial value of p is -1 and another CPU just did
> > an atomic_inc() that resulted in the new value to be 0, the above
> > atomic_read() might return -1 because there is no guarantee it's
> > seeing the recent update on the remote CPU.
> 
> Yes, you are right. Also looks memory barrier is needed around
> atomic_inc() too.

The atomic_inc() primitive makes no guarantees about ordering (see
Documentation/atomic_ops.txt), so, yes, if the caller needs ordering
around an atomic_inc(), the caller must supply the needed memory
barriers, for example, by using smp_mb__before_atomic_inc() or
smp_mb__after_atomic_inc().

> But I have a question, why a memory barrier can guarantee that
> remote CPU can see the recent update?  I understand that memory
> barrier only orders consecutive memory access, and but here
> not see this kind of pattern. Sorry for a possibly stupid question.

Atomic operations that return a value are required to act as full memory
barriers.  This means that code relying on ordering provided by these
atomic operations must also do ordering, either by using an explicit
memory barrier or by relying on guarantees from atomic operations.

For example:

	CPU 0					CPU 1

	X = 1;					r1 = Z;
	if (atomic_inc_unless_negative(&Y)	smp_mb();
		do_something();
	Z = 1;					r2 = X;

Assuming X and Z are initially zero, if r1==1, we are guaranteed
that r2==1.  However, CPU 1 needs its smp_mb() in order to pair with
the barrier implicit in atomic_inc_unless_negative().

Make sense?

							Thanx, Paul

