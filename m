Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679AbaB1MNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 07:13:36 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48635 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751296AbaB1MNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 07:13:35 -0500
Date: Fri, 28 Feb 2014 12:13:15 +0000
From: Will Deacon <will.deacon@arm.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rkuo@codeaurora.org" <rkuo@codeaurora.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "paulus@samba.org" <paulus@samba.org>
Subject: Re: [PATCH 1/2] asm-generic: rwsem: ensure sem->cnt is only accessed
 via atomic_long_*
Message-ID: <20140228121314.GC674@mudshark.cambridge.arm.com>
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
> Other than that:
> 
> Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>

Actually, we should make that cmpxchg an atomic_long_cmpxchg, so the extra
diff ends up looking like below. It's ugly adding a cpu_relax(), since you
only want it when the cmpxchg fails (and we don't have such logic in the
asm-generic __atomic_add_unless, for example).

Will

--->8

diff --git a/include/asm-generic/rwsem.h b/include/asm-generic/rwsem.h
index 603a0a11e592..2b6401f9e428 100644
--- a/include/asm-generic/rwsem.h
+++ b/include/asm-generic/rwsem.h
@@ -40,14 +40,16 @@ static inline void __down_read(struct rw_semaphore *sem)
 static inline int __down_read_trylock(struct rw_semaphore *sem)
 {
        long tmp;
+       atomic_long_t *cnt = (atomic_long_t *)&sem->count;
 
-       while ((tmp = atomic_long_read((atomic_long_t *)&sem->count)) >= 0) {
-               if (tmp == cmpxchg(&sem->count, tmp,
-                                  tmp + RWSEM_ACTIVE_READ_BIAS)) {
-                       return 1;
-               }
-       }
-       return 0;
+       do {
+               tmp = atomic_long_read(cnt);
+               if (tmp < 0)
+                       return 0;
+       } while (tmp != atomic_long_cmpxchg(cnt, tmp,
+                                           tmp + RWSEM_ACTIVE_READ_BIAS));
+
+       return 1;
 }
 
 /*

