Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab3DNDfo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 23:35:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55700 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab3DNDfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 23:35:43 -0400
Date: Sun, 14 Apr 2013 04:35:39 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Anatol Pomozov <anatol.pomozov@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Salman Qazi <sqazi@google.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] module: Fix race condition between load and unload module
Message-ID: <20130414033539.GE4068@ZenIV.linux.org.uk>
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

Unless I'm misreading what's going on, we have the following to thank for that:
        /* remove from sysfs if the caller did not do it */
        if (kobj->state_in_sysfs) {
                pr_debug("kobject: '%s' (%p): auto cleanup kobject_del\n",
                         kobject_name(kobj), kobj);
                kobject_del(kobj);
        }
in kobject_cleanup().  Why don't we require kobject_del() before the final
kobject_put(), if the sucker had been added?  FWIW, I thought it *was*
required all along...
