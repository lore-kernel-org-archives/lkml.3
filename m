Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702AbaCYVwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 17:52:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:55602 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbaCYVwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 17:52:38 -0400
Date: Tue, 25 Mar 2014 22:52:43 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: rb tree hrtimer lockup bug (found by perf_fuzzer)
In-Reply-To: <alpine.DEB.2.10.1403251702110.19541@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.02.1403252220110.4094@ionos.tec.linutronix.de>
References: <alpine.DEB.2.10.1403031526210.11945@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403191552570.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403191300540.18754@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403201056020.18573@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403201045560.21603@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403201609540.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403201724430.23339@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403210956000.18573@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403211610430.30801@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403221118060.18573@ionos.tec.linutronix.de> <alpine.DEB.2.02.1403221419000.18573@ionos.tec.linutronix.de> <alpine.DEB.2.02.1403231613230.18573@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1403240017430.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403251702110.19541@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2014, Vince Weaver wrote:
> On Mon, 24 Mar 2014, Thomas Gleixner wrote:
> 
> > But I tooks some time to tweak the debugobjects patch further in the
> > hope that it helps.
> 
> I've attached the log from your most recent patch, it's pretty long.
> 
> I'll try without the trace_printk too.
> 
> It's been busy here which is why I've been slow to try the patch, but 
> hopefully I'll have some more time to look at things tomorrow.

Ok, that trace makes a lot more sense but it does us not yet give
enough data as the delayed work function is assigned after the
debugobjects init call. Patch for that below.

What's clear from the trace is that the timer gets set up correctly,
but when it expires the function callback is NULL. The timer is set up
to 1sec and it's started in the context of init-1. So it's probably an
initcall of some sort.

Do you happen to have the full bootlog up to the crash handy?

Adding "initcall_debug" to the kernel command line might give us a
further hint what is adding the delayed_work, but I guess once we see
the function in the trace we have a good chance to find the place
right away. Then we have to figure out what scribbles over it .....

Thanks,

	tglx


Index: linux-2.6/include/linux/workqueue.h
===================================================================
--- linux-2.6.orig/include/linux/workqueue.h
+++ linux-2.6/include/linux/workqueue.h
@@ -213,19 +213,19 @@ static inline unsigned int work_static(s
 	do {								\
 		static struct lock_class_key __key;			\
 									\
+		PREPARE_WORK((_work), (_func));				\
 		__init_work((_work), _onstack);				\
 		(_work)->data = (atomic_long_t) WORK_DATA_INIT();	\
 		lockdep_init_map(&(_work)->lockdep_map, #_work, &__key, 0); \
 		INIT_LIST_HEAD(&(_work)->entry);			\
-		PREPARE_WORK((_work), (_func));				\
 	} while (0)
 #else
 #define __INIT_WORK(_work, _func, _onstack)				\
 	do {								\
+		PREPARE_WORK((_work), (_func));				\
 		__init_work((_work), _onstack);				\
 		(_work)->data = (atomic_long_t) WORK_DATA_INIT();	\
 		INIT_LIST_HEAD(&(_work)->entry);			\
-		PREPARE_WORK((_work), (_func));				\
 	} while (0)
 #endif
 


