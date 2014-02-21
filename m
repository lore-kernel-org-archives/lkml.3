Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbaBUMVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:21:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755106AbaBUMVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:21:08 -0500
Date: Fri, 21 Feb 2014 09:21:02 -0300
From: Rafael Aquini <aquini@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Mateusz Guzik <mguzik@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kref: oops on zero or negative refcount
Message-ID: <20140221122101.GA10170@localhost.localdomain>
References: <1392918299-673-1-git-send-email-mguzik@redhat.com>
 <20140220181440.GA31506@redhat.com>
 <530646C8.1070206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530646C8.1070206@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 01:17:44PM -0500, Rik van Riel wrote:
> On 02/20/2014 01:14 PM, Dave Jones wrote:
> > On Thu, Feb 20, 2014 at 06:44:59PM +0100, Mateusz Guzik wrote:
> >  > In use after free situations, it is possible for one thread to write to
> >  > memory that has just been reallocated to a new user. This could open up
> >  > potential security issues.
> >  > 
> >  > diff --git a/include/linux/kref.h b/include/linux/kref.h
> >  > index 484604d..c3f8a0a 100644
> >  > --- a/include/linux/kref.h
> >  > +++ b/include/linux/kref.h
> >  > @@ -43,8 +43,10 @@ static inline void kref_get(struct kref *kref)
> >  >  	/* If refcount was 0 before incrementing then we have a race
> >  >  	 * condition when this kref is freeing by some other thread right now.
> >  >  	 * In this case one should use kref_get_unless_zero()
> >  > +	 *
> >  > +	 * Terminate the current thread to stop potential security exploits.
> >  >  	 */
> >  > -	WARN_ON_ONCE(atomic_inc_return(&kref->refcount) < 2);
> >  > +	BUG_ON(atomic_inc_return(&kref->refcount) < 2);
> > 
> > This isn't "terminating the thread", this is "lock up the box".
> 
> Only if kref_get holds a lock while encountering a refcount
> underflow, right?
>

Yes, and in a quick glance through the tree it seems we have several
codesites where we can find such condition likely to happen,
unfortunately.


