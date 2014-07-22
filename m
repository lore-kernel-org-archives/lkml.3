Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166AbaGVXQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 19:16:19 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:40815 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbaGVXQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 19:16:18 -0400
Date: Tue, 22 Jul 2014 16:16:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Bart Van Assche <bvanassche@acm.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] spin_lock_*(): Always evaluate second argument
In-Reply-To: <20140722133716.cff957eff4eff1cc9c1d9968@linux-foundation.org>
Message-ID: <alpine.DEB.2.02.1407221612330.10592@chino.kir.corp.google.com>
References: <53CE1019.10708@acm.org> <20140722133716.cff957eff4eff1cc9c1d9968@linux-foundation.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2014, Andrew Morton wrote:

> > Evaluating a macro argument only if certain configuration options
> > have been selected is confusing and error-prone. Hence always
> > evaluate the second argument of spin_lock_nested() and
> > spin_lock_nest_lock().
> > 
> > An intentional side effect of this patch is that it avoids that
> > the following warning is reported for netif_addr_lock_nested()
> > when building with CONFIG_DEBUG_LOCK_ALLOC=n and with W=1:
> > 
> > ...
> >
> > --- a/include/linux/spinlock.h
> > +++ b/include/linux/spinlock.h
> > @@ -197,8 +197,10 @@ static inline void do_raw_spin_unlock(raw_spinlock_t *lock) __releases(lock)
> >  		 _raw_spin_lock_nest_lock(lock, &(nest_lock)->dep_map);	\
> >  	 } while (0)
> >  #else
> > -# define raw_spin_lock_nested(lock, subclass)		_raw_spin_lock(lock)
> > -# define raw_spin_lock_nest_lock(lock, nest_lock)	_raw_spin_lock(lock)
> > +# define raw_spin_lock_nested(lock, subclass)		\
> > +	((void)(subclass), _raw_spin_lock(lock))
> > +# define raw_spin_lock_nest_lock(lock, nest_lock)	\
> > +	((void)(nest_lock), _raw_spin_lock(lock))
> >  #endif
> >  
> 
> Did you try converting these to static inline functions?  That should
> squish the warning and makes the code nicer instead of nastier...
> 

Not sure how that would be done since _raw_spin_lock isn't declared in 
this scope.

Taking a second look, however, I think the patch doesn't need to modify 
raw_spin_lock_nest_lock() for the problem being reported and evaluating 
the parameter of type struct lockdep_map * probably is meaningless.

Bart, is it possible to just get away with the raw_spin_lock_nested() 
change?
