Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932632AbaFPWcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 18:32:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:24933 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932171AbaFPWcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 18:32:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,489,1400050800"; 
   d="scan'208";a="529464374"
Message-ID: <1402958398.15603.46.camel@rage>
Subject: Re: [patch 1/5] futex: Make unlock_pi more robust
From: Darren Hart <darren@dvhart.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Davidlohr Bueso <davidlohr@hp.com>,
        Kees Cook <kees@outflux.net>, wad@chromium.org
Date: Mon, 16 Jun 2014 15:39:58 -0700
In-Reply-To: <alpine.DEB.2.10.1406170002050.5170@nanos>
References: <20140611202744.676528190@linutronix.de>
	  <20140611204237.016987332@linutronix.de> <1402935528.15603.14.camel@rage>
	 <alpine.DEB.2.10.1406170002050.5170@nanos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-17 at 00:15 +0200, Thomas Gleixner wrote:
> On Mon, 16 Jun 2014, Darren Hart wrote:
> > On Wed, 2014-06-11 at 20:45 +0000, Thomas Gleixner wrote:
> > >  static int futex_unlock_pi(u32 __user *uaddr, unsigned int flags)
> > > @@ -2417,57 +2401,47 @@ retry:
> > >                 return -EPERM;
> > >  
> > >         ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &key,
> > > VERIFY_WRITE);
> > > -       if (unlikely(ret != 0))
> > > -               goto out;
> > > +       if (ret)
> > > +               return ret;
> > 
> > Looks like you're also trying to move away from a single exit point to
> > multiple exit points. I prefer the single exit (which you've probably
> > noticed :-), but it's a subjective thing, and so long as we are not
> > duplicating cleanup logic, I guess it's fine either way. This change was
> > not mentioned in the commit message though.
> 
> I really did not think about mentioning that :)
>  
> > > +        * Check waiters first. We do not trust user space values at
> > > +        * all and we at least want to know if user space fiddled
> > > +        * with the futex value instead of blindly unlocking.
> > > +        */
> > > +       match = futex_top_waiter(hb, &key);
> > > +       if (match) {
> > > +               ret = wake_futex_pi(uaddr, uval, match);
> > >                 /*
> > > -                * The atomic access to the futex value
> > > -                * generated a pagefault, so retry the
> > > -                * user-access and the wakeup:
> > > +                * The atomic access to the futex value generated a
> > > +                * pagefault, so retry the user-access and the wakeup:
> > >                  */
> > >                 if (ret == -EFAULT)
> > >                         goto pi_faulted;
> > >                 goto out_unlock;
> > >         }
> > > +
> > >         /*
> > > -        * No waiters - kernel unlocks the futex:
> > > +        * We have no kernel internal state, i.e. no waiters in the
> > > +        * kernel. Waiters which are about to queue themself are stuck
> > 
> > themselves
> > 
> > > +        * on hb->lock. So we can safely ignore them. We do neither
> > > +        * preserve the WAITERS bit not the OWNER_DIED one. We are the
> > 
> > We preserve neither the WAITERS bit nor the OWNER_DIED bit.
> > (the above use of "do" and "not" is incorrect and could easily be
> > misinterpreted).
> > 
> > > +        * owner.
> > 
> > In wake_futex_pi we verify ownership by matching pi_state->owner ==
> > current, but here the only test is the TID value, which is set by
> > userspace - which we don't trust...
> > 
> > I'm trying to determine if it matters in this case... if there are no
> > waiters, is the pi_state still around? If so, it does indeed matter, and
> > we should be verifying.
> 
> Erm. The whole point of this patch is to do:
> 
>      - Find existing state first and handle it.hehheh
> 
>      - If no state exists and TID == current, take it
> 
>      - Otherwise create state

Right, by 5/5 I realized that, duh, if there are no waiters, you can't
find a pi_state to check, so we have no choice here. Sorry, should have
come back and said as much. We can drop this concern.

> This all happens under hb->lock. So how should something create new
> state after we looked up existing state?
>  
> > >          */
> > > -       ret = unlock_futex_pi(uaddr, uval);
> > > -       if (ret == -EFAULT)
> > > +       if (cmpxchg_futex_value_locked(&curval, uaddr, uval, 0))
> > >                 goto pi_faulted;
> > >  
> > 
> > This refactoring seems like it would be best done as a prequel patch so
> > as not to confuse cleanup with functional change. At least that is what
> > you and others have beaten into me over the years ;-)
> 
> Well, yes and no. I'll hapilly discuss that without after clarifying
> the issue below.
> 
> > > +       /*
> > > +        * If uval has changed, let user space handle it.
> > > +        */
> > > +       ret = (curval == uval) ? 0 : -EAGAIN;
> > > +
> > >  out_unlock:
> > >         spin_unlock(&hb->lock);
> > >         put_futex_key(&key);
> > > -
> > > -out:
> > >         return ret;
> > >  
> > 
> > By dropping this you won't return ret, but rather fall through into
> > pi_faulted... which certainly isn't what you wanted.
> 
> By dropping the now unused "out" label I'm not longer returning ret?
>  

Sigh. Nevermind.

> The resulting code is:
> 
> out_unlock:
> 	spin_unlock(&hb->lock);
> 	put_futex_key(&key);
> 	return ret;
> 
> If you can explain me how that "return ret" falls through to
> pi_faulted magically, then I'm definitely agreeing with you on this:
> 
> > The need for better test coverage is very evident now :-)
> 
>   -ENOTENOUGHSLEEP or -ENOTENOUGHCOFFEE or -ENOGLASSES perhaps?
> 
> I'm omitting some other politicially incorrect speculations for now.

Guilty as charged, on all counts I'm afraid.

So, my only reservation is the possible splitting out of the refactoring
bit. But that's minor. Either way:

Reviewed-by: Darren Hart <darren@dvhart.com>


-- 
Darren Hart
Intel Open Source Technology Center


