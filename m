Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbaKQWnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 17:43:22 -0500
Received: from www.linutronix.de ([62.245.132.108]:35948 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaKQWnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 17:43:20 -0500
Date: Mon, 17 Nov 2014 23:43:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jens Axboe <axboe@kernel.dk>, Ingo Molnar <mingo@kernel.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <alpine.DEB.2.11.1411172303070.3909@nanos>
Message-ID: <alpine.DEB.2.11.1411172335100.3909@nanos>
References: <20141114213124.GB3344@redhat.com> <CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com> <alpine.DEB.2.11.1411142326510.3909@nanos> <CA+55aFxExBiRpPemPECKP9wMnR4F4J=ne8UoHKcXjntGB_OEgA@mail.gmail.com>
 <CA+55aFyBnd_Hbe46UpeRktS+ePkAdL5k7vEChUMEx3-e8O1Usg@mail.gmail.com> <alpine.DEB.2.11.1411172303070.3909@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2014, Thomas Gleixner wrote:
> On Mon, 17 Nov 2014, Linus Torvalds wrote:
> >  	llist_for_each_entry_safe(csd, csd_next, entry, llist) {
> > -		csd->func(csd->info);
> > +		smp_call_func_t func = csd->func;
> > +		void *info = csd->info;
> >  		csd_unlock(csd);
> > +
> > +		func(info);
> 
> No, that won't work for synchronous calls:
> 
>     CPU 0      	    		CPU 1
> 
>     csd_lock(csd);
>     queue_csd();
>     ipi();
> 				func = csd->func;
> 				info = csd->info;
> 				csd_unlock(csd);
>     csd_lock_wait();    
> 				func(info);
>    
> The csd_lock_wait() side will succeed and therefor assume that the
> call has been completed while the function has not been called at
> all. Interesting explosions to follow.
> 
> The proper solution is to revert that commit and properly analyze the
> problem which Jens was trying to solve and work from there.

So a combo of both (Jens and yours) might do the trick. Patch below.

I think what Jens was trying to solve is:

     CPU 0      	    		CPU 1
 
     csd_lock(csd);
     queue_csd();
     ipi();
 				csd->func(csd->info);
     wait_for_completion(csd);
				   complete(csd);
     reuse_csd(csd);		
				csd_unlock(csd);

Thanks,

	tglx	

Index: linux/kernel/smp.c
===================================================================
--- linux.orig/kernel/smp.c
+++ linux/kernel/smp.c
@@ -126,7 +126,7 @@ static void csd_lock(struct call_single_
 
 static void csd_unlock(struct call_single_data *csd)
 {
-	WARN_ON((csd->flags & CSD_FLAG_WAIT) && !(csd->flags & CSD_FLAG_LOCK));
+	WARN_ON(!(csd->flags & CSD_FLAG_LOCK));
 
 	/*
 	 * ensure we're all done before releasing data:
@@ -250,8 +250,23 @@ static void flush_smp_call_function_queu
 	}
 
 	llist_for_each_entry_safe(csd, csd_next, entry, llist) {
-		csd->func(csd->info);
-		csd_unlock(csd);
+
+		/*
+		 * For synchronous calls we are not allowed to unlock
+		 * before the callback returned. For the async case
+		 * its the responsibility of the caller to keep
+		 * csd->info consistent while the callback runs.
+		 */
+		if (csd->flags & CSD_FLAG_WAIT) {
+			csd->func(csd->info);
+			csd_unlock(csd);
+		} else {
+			smp_call_func_t func = csd->func;
+			void *info = csd->info;
+
+			csd_unlock(csd);
+			func(info);
+		}
 	}
 
 	/*
