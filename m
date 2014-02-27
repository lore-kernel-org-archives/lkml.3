Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873AbaB0Sxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 13:53:32 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62300 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753585AbaB0Sx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 13:53:29 -0500
Date: Thu, 27 Feb 2014 18:53:07 +0000
From: Will Deacon <will.deacon@arm.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rkuo@codeaurora.org" <rkuo@codeaurora.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "paulus@samba.org" <paulus@samba.org>
Subject: Re: [PATCH 1/2] asm-generic: rwsem: ensure sem->cnt is only accessed
 via atomic_long_*
Message-ID: <20140227185306.GN30003@mudshark.cambridge.arm.com>
References: <1393003347-24958-1-git-send-email-will.deacon@arm.com>
 <1393478904.3884.6.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393478904.3884.6.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 05:28:24AM +0000, Davidlohr Bueso wrote:
> On Fri, 2014-02-21 at 17:22 +0000, Will Deacon wrote:
> > The asm-generic rwsem implementation directly acceses sem->cnt when
> > performing a __down_read_trylock operation. Whilst this is probably safe
> > on all architectures, we should stick to the atomic_long_* API and use
> > atomic_long_read instead.
> > 
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > ---
> >  include/asm-generic/rwsem.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/include/asm-generic/rwsem.h b/include/asm-generic/rwsem.h
> > index bb1e2cdeb9bf..75af612f54f8 100644
> > --- a/include/asm-generic/rwsem.h
> > +++ b/include/asm-generic/rwsem.h
> > @@ -41,7 +41,7 @@ static inline int __down_read_trylock(struct rw_semaphore *sem)
> >  {
> >  	long tmp;
> >  
> > -	while ((tmp = sem->count) >= 0) {
> > +	while ((tmp = atomic_long_read((atomic_long_t *)&sem->count)) >= 0) {
> 
> That's pretty ugly, how about having infinite look and just do the tmp
> assign separately from the conditional?
> 
> It also looks like a cpu_relax() could help here between iterations.

Sure, I can do these in a separate patch (this patch is just a simple fix).

> Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>

Thanks,

Will
