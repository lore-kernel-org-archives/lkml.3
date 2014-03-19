Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965344AbaCSPFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 11:05:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:34354 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964911AbaCSPFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 11:05:22 -0400
Date: Wed, 19 Mar 2014 16:05:29 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: rb tree hrtimer lockup bug (found by perf_fuzzer)
In-Reply-To: <alpine.DEB.2.10.1403191039560.18652@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.02.1403191552570.18573@ionos.tec.linutronix.de>
References: <alpine.DEB.2.10.1403031526210.11945@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1403041620390.15963@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1403181250110.14816@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403181921010.18573@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403181523360.15687@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403182149540.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403181705000.15687@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403182218170.18573@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403190941170.18343@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403191456120.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403191039560.18652@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2014, Vince Weaver wrote:
> On Wed, 19 Mar 2014, Thomas Gleixner wrote:
> 
> > On Wed, 19 Mar 2014, Vince Weaver wrote:
> > > On Tue, 18 Mar 2014, Thomas Gleixner wrote:
> > > your patch didn't seem to print anything additional the first time throug.
> > > 
> > > I then tried the trace command you suggested, but I'm getting an empty
> > > ftrace buffer which possibly means I don't have enough ftrace kernel 
> > > options enabled.
> > > 
> > > Here's the most recent boot crash.
> > > 
> > > [    5.367069] ODEBUG: Info active (active state 0) object type: timer_list hint:           (null)
> > 
> > Stupid me. We get the hint from the wreckaged object ....
> > 
> > A hopefully better approach is the delta patch below.
> 
> with that applied on top:
> 
> [    5.342681] Invalid timer base: tmr ffff880117740150 tmr->base           (null) base ffff880118618000
> [    5.352786] ------------[ cut here ]------------
> [    5.357911] WARNING: CPU: 4 PID: 0 at lib/debugobjects.c:260 debug_print_object+0x8c/0xb0()
> [    5.367023] ODEBUG: Info active (active state 0) object type: timer_list hint:           (null) delayed_work_timer_fn+0x0/0x20

Good, we have at least a point where we can gather useful
information. The timer belongs to a delayed work. The work itself is
tracked via debug objects as well. So we can get that as well. Delta
patch below.

Thanks,

	tglx
------

Index: linux-2.6/lib/debugobjects.c
===================================================================
--- linux-2.6.orig/lib/debugobjects.c
+++ linux-2.6/lib/debugobjects.c
@@ -14,6 +14,7 @@
 #include <linux/debugfs.h>
 #include <linux/slab.h>
 #include <linux/hash.h>
+#include <linux/workqueue.h>
 
 #define ODEBUG_HASH_BITS	14
 #define ODEBUG_HASH_SIZE	(1 << ODEBUG_HASH_BITS)
@@ -400,6 +401,20 @@ void debug_object_info(void *addr, struc
 		debug_print_object(obj, "Info");
 
 	raw_spin_unlock_irqrestore(&db->lock, flags);
+
+	addr = container_of(addr, struct delayed_work, timer);
+
+	db = get_bucket((unsigned long) addr);
+
+	raw_spin_lock_irqsave(&db->lock, flags);
+
+	obj = lookup_object(addr, db);
+	if (!obj)
+		pr_err("Object unknown %p\n", addr);
+	else
+		debug_print_object(obj, "Info");
+
+	raw_spin_unlock_irqrestore(&db->lock, flags);
 }
 
 /**
@@ -452,6 +467,7 @@ int debug_object_activate(void *addr, st
 		}
 		if (!obj->hint)
 			obj->hint = descr->debug_hint ?	descr->debug_hint(addr) : NULL;
+
 		raw_spin_unlock_irqrestore(&db->lock, flags);
 		return ret;
 	}




