Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab3DLXx6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 19:53:58 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41924 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab3DLXx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 19:53:57 -0400
Date: Fri, 12 Apr 2013 16:53:52 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Anatol Pomozov <anatol.pomozov@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Salman Qazi <sqazi@google.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] module: Fix race condition between load and unload module
Message-ID: <20130412235352.GA16770@kroah.com>
References: <1365805938-22826-1-git-send-email-anatol.pomozov@gmail.com>
 <CA+55aFzxxGBU3AOeNg3UEicHrx3nzWRyo5DOd=hh6SHJfYvB3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzxxGBU3AOeNg3UEicHrx3nzWRyo5DOd=hh6SHJfYvB3g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 04:47:50PM -0700, Linus Torvalds wrote:
> On Fri, Apr 12, 2013 at 3:32 PM, Anatol Pomozov
> <anatol.pomozov@gmail.com> wrote:
> >
> > Here is timeline for the crash in case if kset_find_obj() searches for
> > an object tht nobody holds and other thread is doing kobject_put()
> > on the same kobject:
> >
> > THREAD A (calls kset_find_obj())     THREAD B (calls kobject_put())
> > splin_lock()
> >                                      atomic_dec_return(kobj->kref), counter gets zero here
> >                                      ... starts kobject cleanup ....
> >                                      spin_lock() // WAIT thread A in kobj_kset_leave()
> > iterate over kset->list
> > atomic_inc(kobj->kref) (counter becomes 1)
> > spin_unlock()
> >                                      spin_lock() // taken
> >                                      // it does not know that thread A increased counter so it
> >                                      remove obj from list
> >                                      spin_unlock()
> >                                      vfree(module) // frees module object with containing kobj
> >
> > // kobj points to freed memory area!!
> > koubject_put(kobj) // OOPS!!!!
> 
> This is a much more generic bug in kobjects, and I would hate to add
> some random workaround for just one case of this bug like you do. The
> more fundamental bug needs to be fixed too.
> 
> I think the more fundamental bugfix is to just fix kobject_get() to
> return NULL if the refcount was zero, because in that case the kobject
> no longer really exists.
> 
> So instead of having
> 
>     kref_get(&kobj->kref);
> 
> it should do
> 
>     if (!atomic_inc_not_zero(&kobj->kref.refcount))
>         kobj = NULL;
> 
> and I think that should fix your race automatically, no? Proper patch
> attached (but TOTALLY UNTESTED - it seems to compile, though).
> 
> The problem is that we lose the warning for when the refcount is zero
> and somebody does a kobject_get(), but that is ok *assuming* that
> people actually check the return value of kobject_get() rather than
> just "know" that if they passed in a non-NULL kobj, they'll get it
> right back.
> 
> Greg - please take a look... I'm adding Al to the discussion too,
> because Al just *loooves* these kinds of races ;)

We "should" have some type of "higher-up" lock to prevent the
release/get races from happening, we have that in the driver core, and I
thought we had such a lock already in the module subsystem as well,
which will prevent any of this from being needed.

Rusty, don't we have a lock for this somewhere?

Linus, I think your patch will reduce the window the race could happen,
but it should still be there, although testing with it would be
interesting to see if the original problem can be triggered with it.

I'll look at it some more tomorrow, about to go to dinner now...

thanks,

greg k-h
