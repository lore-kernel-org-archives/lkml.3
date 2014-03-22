Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512AbaCVUWB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 16:22:01 -0400
Received: from www.linutronix.de ([62.245.132.108]:55934 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaCVUWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 16:22:00 -0400
Date: Sat, 22 Mar 2014 21:22:07 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: rb tree hrtimer lockup bug (found by perf_fuzzer)
In-Reply-To: <alpine.DEB.2.02.1403221118060.18573@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.02.1403221419000.18573@ionos.tec.linutronix.de>
References: <alpine.DEB.2.10.1403031526210.11945@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403182218170.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403190941170.18343@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403191456120.18573@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403191039560.18652@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403191552570.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403191300540.18754@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403201056020.18573@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403201045560.21603@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403201609540.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403201724430.23339@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403210956000.18573@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403211610430.30801@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403221118060.18573@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2014, Thomas Gleixner wrote:
> On Fri, 21 Mar 2014, Vince Weaver wrote:
> 
> > On Fri, 21 Mar 2014, Thomas Gleixner wrote:
> > > 
> > > I'm a complete idiot. I was staring at oaddr and did not notice that
> > > descr->name is the real culprit. Sorry. Delta patch below.
> > 
> > OK.  The log was much longer this time, attached.
> 
> Hmmm.
> 
> [    2.739858] NULL pointer dereference at           (null)
> [    2.747390] IP: [<          (null)>]           (null)
> [    2.752970] PGD 0
> [    2.755287] Oops: 0010 [#1] SMP
> 
> So this time the CPU branched to NULL. So let me recap.
> 
> First you had the explosion in the hrtimer code. After enabling debug
> stuff it went to the timer_list and now it looks different again.
> 
> So that looks more like a random memory corruption.
> 
> Nasty to debug. And of course it does not reproduce here. I'll throw
> your config at more machines in the hope that something will trigger
> it.

I've refined the trace_printk stuff in the hope to get a bit more info
out of it.

Thanks,

	tglx

------------>

Index: linux-2.6/include/linux/debugobjects.h
===================================================================
--- linux-2.6.orig/include/linux/debugobjects.h
+++ linux-2.6/include/linux/debugobjects.h
@@ -30,6 +30,7 @@ struct debug_obj {
 	unsigned int		astate;
 	void			*object;
 	struct debug_obj_descr	*descr;
+	void			*hint;
 };
 
 /**
@@ -68,6 +69,7 @@ extern void debug_object_deactivate(void
 extern void debug_object_destroy   (void *addr, struct debug_obj_descr *descr);
 extern void debug_object_free      (void *addr, struct debug_obj_descr *descr);
 extern void debug_object_assert_init(void *addr, struct debug_obj_descr *descr);
+extern void debug_object_info(void *addr, struct debug_obj_descr *descr);
 
 /*
  * Active state:
@@ -95,6 +97,8 @@ static inline void
 debug_object_free      (void *addr, struct debug_obj_descr *descr) { }
 static inline void
 debug_object_assert_init(void *addr, struct debug_obj_descr *descr) { }
+static inline void
+debug_object_info(void *addr, struct debug_obj_descr *descr) { }
 
 static inline void debug_objects_early_init(void) { }
 static inline void debug_objects_mem_init(void) { }
Index: linux-2.6/kernel/timer.c
===================================================================
--- linux-2.6.orig/kernel/timer.c
+++ linux-2.6/kernel/timer.c
@@ -1081,7 +1081,12 @@ static int cascade(struct tvec_base *bas
 	 * don't have to detach them individually.
 	 */
 	list_for_each_entry_safe(timer, tmp, &tv_list, entry) {
-		BUG_ON(tbase_get_base(timer->base) != base);
+		if (tbase_get_base(timer->base) != base) {
+			pr_err("Invalid timer base: tmr %p tmr->base %p base %p\n",
+			       timer, timer->base, base);
+			debug_object_info(timer, &timer_debug_descr);
+			BUG();
+		}
 		/* No accounting, while moving them */
 		__internal_add_timer(base, timer);
 	}
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
@@ -140,6 +141,7 @@ alloc_object(void *addr, struct debug_bu
 		obj->descr  = descr;
 		obj->state  = ODEBUG_STATE_NONE;
 		obj->astate = 0;
+		obj->hint = NULL;
 		hlist_del(&obj->node);
 
 		hlist_add_head(&obj->node, &b->list);
@@ -255,9 +257,9 @@ static void debug_print_object(struct de
 			descr->debug_hint(obj->object) : NULL;
 		limit++;
 		WARN(1, KERN_ERR "ODEBUG: %s %s (active state %u) "
-				 "object type: %s hint: %pS\n",
+				 "object type: %s hint: %pS %pS\n",
 			msg, obj_states[obj->state], obj->astate,
-			descr->name, hint);
+		     descr->name, hint, obj->hint);
 	}
 	debug_objects_warnings++;
 }
@@ -326,6 +328,10 @@ __debug_object_init(void *addr, struct d
 		debug_object_is_on_stack(addr, onstack);
 	}
 
+	obj->hint = descr->debug_hint ? descr->debug_hint(addr) : NULL;
+	trace_printk("%s %p %p %pS\n", descr->name, addr, obj->hint,
+		     obj->hint);
+
 	switch (obj->state) {
 	case ODEBUG_STATE_NONE:
 	case ODEBUG_STATE_INIT:
@@ -377,6 +383,42 @@ void debug_object_init_on_stack(void *ad
 	__debug_object_init(addr, descr, 1);
 }
 
+void debug_object_info(void *addr, struct debug_obj_descr *descr)
+{
+	struct debug_bucket *db;
+	struct debug_obj *obj;
+	unsigned long flags;
+
+	if (!debug_objects_enabled)
+		return;
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
+}
+
 /**
  * debug_object_activate - debug checks when an object is activated
  * @addr:	address of the object
@@ -403,6 +445,11 @@ int debug_object_activate(void *addr, st
 
 	obj = lookup_object(addr, db);
 	if (obj) {
+
+		obj->hint = descr->debug_hint ?	descr->debug_hint(addr) : NULL;
+		trace_printk("%s %p %p %pS\n", descr->name, addr,
+			     obj->hint, obj->hint);
+
 		switch (obj->state) {
 		case ODEBUG_STATE_INIT:
 		case ODEBUG_STATE_INACTIVE:
@@ -425,6 +472,7 @@ int debug_object_activate(void *addr, st
 			ret = 0;
 			break;
 		}
+
 		raw_spin_unlock_irqrestore(&db->lock, flags);
 		return ret;
 	}
@@ -463,6 +511,10 @@ void debug_object_deactivate(void *addr,
 
 	obj = lookup_object(addr, db);
 	if (obj) {
+		obj->hint = descr->debug_hint ?	descr->debug_hint(addr) : NULL;
+		trace_printk("%s %p %p %pS\n", descr->name, addr,
+			     obj->hint, obj->hint);
+
 		switch (obj->state) {
 		case ODEBUG_STATE_INIT:
 		case ODEBUG_STATE_INACTIVE:
@@ -513,6 +565,10 @@ void debug_object_destroy(void *addr, st
 	if (!obj)
 		goto out_unlock;
 
+	obj->hint = descr->debug_hint ?	descr->debug_hint(addr) : NULL;
+	trace_printk("%s %p %p %pS\n", descr->name, addr,
+		     obj->hint, obj->hint);
+
 	switch (obj->state) {
 	case ODEBUG_STATE_NONE:
 	case ODEBUG_STATE_INIT:
@@ -559,6 +615,10 @@ void debug_object_free(void *addr, struc
 	if (!obj)
 		goto out_unlock;
 
+	obj->hint = descr->debug_hint ?	descr->debug_hint(addr) : NULL;
+	trace_printk("%s %p %p %pS\n", descr->name, addr,
+		     obj->hint, obj->hint);
+
 	switch (obj->state) {
 	case ODEBUG_STATE_ACTIVE:
 		debug_print_object(obj, "free");
