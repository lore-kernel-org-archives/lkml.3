Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964998AbaCUJCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 05:02:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:48159 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760462AbaCUJCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 05:02:47 -0400
Date: Fri, 21 Mar 2014 10:02:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: rb tree hrtimer lockup bug (found by perf_fuzzer)
In-Reply-To: <alpine.DEB.2.10.1403201724430.23339@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.02.1403210956000.18573@ionos.tec.linutronix.de>
References: <alpine.DEB.2.10.1403031526210.11945@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1403181523360.15687@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403182149540.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403181705000.15687@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.02.1403182218170.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403190941170.18343@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403191456120.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403191039560.18652@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.02.1403191552570.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403191300540.18754@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403201056020.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403201045560.21603@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.02.1403201609540.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403201724430.23339@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2014, Vince Weaver wrote:

> On Thu, 20 Mar 2014, Thomas Gleixner wrote:
> > 
> > Yeah, it causes the explosion in the debug object code. This should
> > have been:
> > 
> > +                       trace_printk("Tracking Object free: %s %p %pS\n",
> > +                                    descr->name, obj->object, obj->hint);
> 
> attached are the results with the corrected patch.

I'm a complete idiot. I was staring at oaddr and did not notice that
descr->name is the real culprit. Sorry. Delta patch below.

Thanks,

	tglx

Index: linux-2.6/lib/debugobjects.c
===================================================================
--- linux-2.6.orig/lib/debugobjects.c
+++ linux-2.6/lib/debugobjects.c
@@ -769,6 +769,7 @@ repeat:
 		/* Now free them */
 		hlist_for_each_entry_safe(obj, tmp, &freelist, node) {
 			hlist_del(&obj->node);
+			descr = obj->descr;
 			trace_printk("Tracking Object free: %s %p %pS\n",
 				     descr->name, obj->object, obj->hint);
 			free_object(obj);


