Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab3J3UAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 16:00:52 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42044 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab3J3UAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 16:00:51 -0400
Date: Wed, 30 Oct 2013 20:00:31 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: list_lru: fix almost infinite loop causing
	effective livelock
Message-ID: <20131030200030.GO16735@n2100.arm.linux.org.uk>
References: <20131030141616.GB16735@n2100.arm.linux.org.uk> <CA+55aFzmpzjt-o=R95i_EvvyKvYhwG00o6i324johxJ1bjSMiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzmpzjt-o=R95i_EvvyKvYhwG00o6i324johxJ1bjSMiQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 12:49:05PM -0700, Linus Torvalds wrote:
> On Wed, Oct 30, 2013 at 7:16 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> >
> > So, if *nr_to_walk was zero when this function was entered, that means
> > we're wanting to operate on (~0UL)+1 objects - which might as well be
> > infinite.
> >
> > Clearly this is not correct behaviour.  If we think about the behaviour
> > of this function when *nr_to_walk is 1, then clearly it's wrong - we
> > decrement first and then test for zero - which results in us doing
> > nothing at all.  A post-decrement would give the desired behaviour -
> > we'd try to walk one object and one object only if *nr_to_walk were
> > one.
> >
> > It also gives the correct behaviour for zero - we exit at this point.
> 
> Good analysis.
> 
> HOWEVER.
> 
> I actually think even your version is very dangerous, because we pass
> in the *address* to that count, and the only real reason to do that is
> because we might call it in a loop, and we want the function to update
> that count.
> 
> And even your version still underflows from 0 to really-large-count.
> It *returns* when underflow happens, but you end up with the counter
> updated to a large value, and then anybody who uses it later would be
> screwed.

Yes, you're right... my failing case thankfully doesn't make use of the
counter again which is probably why I didn't think about that aspect.

> So I think we should either change that "unsigned long" to just
> "long", and then check for "<= 0" (like list_lru_walk() already does),
> or we should do
> 
>     if (!*nr_to_walk)
>         break;
>     --*nr_to_walk;
> 
> to make sure that we never do that underflow.
> 
> I will modify your patch to do the latter, since it's the smaller
> change, but I suspect we should think about making that thing signed.

Thanks... :)
