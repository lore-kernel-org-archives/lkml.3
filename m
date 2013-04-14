Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750886Ab3DNE4x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 00:56:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55771 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab3DNE4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 00:56:52 -0400
Date: Sun, 14 Apr 2013 05:56:50 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Salman Qazi <sqazi@google.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] module: Fix race condition between load and unload module
Message-ID: <20130414045650.GG4068@ZenIV.linux.org.uk>
References: <1365805938-22826-1-git-send-email-anatol.pomozov@gmail.com>
 <CA+55aFzxxGBU3AOeNg3UEicHrx3nzWRyo5DOd=hh6SHJfYvB3g@mail.gmail.com>
 <20130414033539.GE4068@ZenIV.linux.org.uk>
 <CAOMFOmVAbg3AVy95Q_O3ADf-kdaAGkBhNtqF6uc=TGZXWsXawA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMFOmVAbg3AVy95Q_O3ADf-kdaAGkBhNtqF6uc=TGZXWsXawA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 13, 2013 at 09:42:06PM -0700, Anatol Pomozov wrote:

> > in kobject_cleanup().  Why don't we require kobject_del() before the final
> > kobject_put(), if the sucker had been added?  FWIW, I thought it *was*
> > required all along...
> 
> But kobject_release/kobject_cleanup function is called as a result of
> atomic decrement_compare. Until we perform the atomic operation we
> don't know whether it is final kobject_put() or not.
> 
> kobject_put() {
>     if (atomic_sub_and_test(kobj->kref->refcount)) {
>         // refcounter is decremented to 0 so cleanup sysfs
>         kobject_release(kobj)
>     }
> }

Yes, of course, but WTF do we play with kobject_del() on that path at all?
Let the caller do it when it decides that object shouldn't be possible to
see anymore.  Which is not the same thing as "the last reference is gone"...

Sigh...  kobject model sucks, film at 11... ;-/
