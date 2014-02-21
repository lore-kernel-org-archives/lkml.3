Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbaBUMFo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:05:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215AbaBUMFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:05:43 -0500
Date: Fri, 21 Feb 2014 13:05:38 +0100
From: Mateusz Guzik <mguzik@redhat.com>
To: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] kref: oops on zero or negative refcount
Message-ID: <20140221120538.GB8729@mguzik.brq.redhat.com>
References: <1392918299-673-1-git-send-email-mguzik@redhat.com>
 <20140220181440.GA31506@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140220181440.GA31506@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 01:14:40PM -0500, Dave Jones wrote:
> On Thu, Feb 20, 2014 at 06:44:59PM +0100, Mateusz Guzik wrote:
>  > In use after free situations, it is possible for one thread to write to
>  > memory that has just been reallocated to a new user. This could open up
>  > potential security issues.
>  > 
>  > diff --git a/include/linux/kref.h b/include/linux/kref.h
>  > index 484604d..c3f8a0a 100644
>  > --- a/include/linux/kref.h
>  > +++ b/include/linux/kref.h
>  > @@ -43,8 +43,10 @@ static inline void kref_get(struct kref *kref)
>  >  	/* If refcount was 0 before incrementing then we have a race
>  >  	 * condition when this kref is freeing by some other thread right now.
>  >  	 * In this case one should use kref_get_unless_zero()
>  > +	 *
>  > +	 * Terminate the current thread to stop potential security exploits.
>  >  	 */
>  > -	WARN_ON_ONCE(atomic_inc_return(&kref->refcount) < 2);
>  > +	BUG_ON(atomic_inc_return(&kref->refcount) < 2);
> 
> This isn't "terminating the thread", this is "lock up the box".
> 

Well, extent of damage caused by non-panicking BUG_ON (if any) depends
on the state when kref_get was executed.

However, since this condition is already a sign of big trouble (and a
potential exploitation attempt), I think a WARN_ON_ONCE is not
sufficient.

That said, can you elaborate on your concers? You just don't like that
comment, don't want that BUG_ON (want a panic instead) or maybe you
don't like the change at all (or something else)?

Thanks,
-- 
Mateusz Guzik
