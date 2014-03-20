Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbaCTKrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 06:47:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:40172 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaCTKrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 06:47:40 -0400
Date: Thu, 20 Mar 2014 11:47:47 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: rb tree hrtimer lockup bug (found by perf_fuzzer)
In-Reply-To: <alpine.DEB.2.10.1403191300540.18754@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.02.1403201056020.18573@ionos.tec.linutronix.de>
References: <alpine.DEB.2.10.1403031526210.11945@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1403041620390.15963@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1403181250110.14816@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403181921010.18573@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403181523360.15687@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403182149540.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403181705000.15687@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403182218170.18573@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403190941170.18343@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403191456120.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403191039560.18652@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403191552570.18573@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403191300540.18754@vincent-weaver-1.um.maine.edu>
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
> > Good, we have at least a point where we can gather useful
> > information. The timer belongs to a delayed work. The work itself is
> > tracked via debug objects as well. So we can get that as well. Delta
> > patch below.
> 
> with that patch applied:
> 
> [    4.314095] Invalid timer base: tmr ffff880117738150 tmr->base           (null) base ffffffff81a3edc0
> [    4.324216] ------------[ cut here ]------------
> [    4.329326] WARNING: CPU: 0 PID: 0 at lib/debugobjects.c:261 debug_print_object+0x8c/0xb0()
> [    4.338495] ODEBUG: Info active (active state 0) object type: timer_list hint:           (null) delayed_work_timer_fn+0x0/0x20

Do you have DEBUG_OBJECTS_WORK and DEBUG_OBJECTS_FREE enabled?

If yes, then I'm completely puzzled why we find the timer in the
tracking objects, but not the delayed work itself.

Find a more brute force method to get this decoded below. Full patch
this time, please zap the old one. That should spill out the recent
debug object calls and we can just hope, that we get enough history to
find this horror.

Please add "ftrace_dump_on_oops" to the kernel command line. No other
trace related options required.

Btw, can you send me your .config file, so I might try to reproduce.

Thanks,

	tglx

---------

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
@@ -255,9 +256,9 @@ static void debug_print_object(struct de
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
@@ -326,6 +327,11 @@ __debug_object_init(void *addr, struct d
 		debug_object_is_on_stack(addr, onstack);
 	}
 
+	if (!obj->hint)
+		obj->hint = descr->debug_hint ?	descr->debug_hint(addr) : NULL;
+
+	trace_printk("Object init: %s %p %pS\n", descr->name, addr, obj->hint);
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
@@ -403,6 +445,10 @@ int debug_object_activate(void *addr, st
 
 	obj = lookup_object(addr, db);
 	if (obj) {
+
+		trace_printk("Object activate: %s %p %pS\n", descr->name, addr,
+			     obj->hint);
+
 		switch (obj->state) {
 		case ODEBUG_STATE_INIT:
 		case ODEBUG_STATE_INACTIVE:
@@ -425,6 +471,9 @@ int debug_object_activate(void *addr, st
 			ret = 0;
 			break;
 		}
+		if (!obj->hint)
+			obj->hint = descr->debug_hint ?	descr->debug_hint(addr) : NULL;
+
 		raw_spin_unlock_irqrestore(&db->lock, flags);
 		return ret;
 	}
@@ -463,6 +512,10 @@ void debug_object_deactivate(void *addr,
 
 	obj = lookup_object(addr, db);
 	if (obj) {
+
+		trace_printk("Object deactivate: %s %p %pS\n",
+			     descr->name, addr, obj->hint);
+
 		switch (obj->state) {
 		case ODEBUG_STATE_INIT:
 		case ODEBUG_STATE_INACTIVE:
@@ -513,6 +566,9 @@ void debug_object_destroy(void *addr, st
 	if (!obj)
 		goto out_unlock;
 
+	trace_printk("Object destroy: %s %p, %pS\n", descr->name, addr,
+		     obj->hint);
+
 	switch (obj->state) {
 	case ODEBUG_STATE_NONE:
 	case ODEBUG_STATE_INIT:
@@ -559,6 +615,8 @@ void debug_object_free(void *addr, struc
 	if (!obj)
 		goto out_unlock;
 
+	trace_printk("Object free: %s %p %pS\n", descr->name, addr, obj->hint);
+
 	switch (obj->state) {
 	case ODEBUG_STATE_ACTIVE:
 		debug_print_object(obj, "free");
@@ -711,6 +769,8 @@ repeat:
 		/* Now free them */
 		hlist_for_each_entry_safe(obj, tmp, &freelist, node) {
 			hlist_del(&obj->node);
+			trace_printk("Tracking Object free: %s %p %pS\n",
+				     descr->name, addr, obj->hint);
 			free_object(obj);
 		}
 
