Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760AbaCRVo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:44:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:57493 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbaCRVo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:44:57 -0400
Date: Tue, 18 Mar 2014 22:45:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: rb tree hrtimer lockup bug (found by perf_fuzzer)
In-Reply-To: <alpine.DEB.2.10.1403181705000.15687@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.02.1403182218170.18573@ionos.tec.linutronix.de>
References: <alpine.DEB.2.10.1403031526210.11945@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1403041620390.15963@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1403181250110.14816@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403181921010.18573@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403181523360.15687@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403182149540.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403181705000.15687@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014, Vince Weaver wrote:

> On Tue, 18 Mar 2014, Thomas Gleixner wrote:
> > 
> > > [    3.678040] BUG: unable to handle kernel NULL pointer dereference at 0000000000000018                                                                        
> > > [    3.686776] IP: [<ffffffff8106d7a8>] get_next_timer_interrupt+0x168/0x250    
> > 
> > The back trace is not really helpful. Is there anything before that
> > BUG in dmesg?
> 
> no, just normal boot messages.
> 
> I re-compiled with the frame pointer enabled and here's an updated 
> version:
> 
> [    3.722836] sd 1:0:0:0: [sda] 4096-byte physical blocks                      
> [    3.728682] sd 1:0:0:0: [sda] Write Protect is off                           
> [    3.728826] sr 0:0:0:0: Attached scsi generic sg0 type 5                     
> [    3.728992] sd 1:0:0:0: Attached scsi generic sg1 type 0                     
> [    3.745700] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA                                                          
> [    3.787096]  sda: sda1 sda2 sda3 sda4                                        
> [    3.792169] sd 1:0:0:0: [sda] Attached SCSI disk                             
> [    4.312111] ------------[ cut here ]------------                             
> [    4.317176] kernel BUG at kernel/timer.c:1084!                               

Wow. That's in the cascade code. So it looks like the timer got
corrupted without using the timer api wrong. That might be a memset or
a stray pointer. Can you apply the following patch?

That really should give us a hint.

If that fails, enable the tracer in your config and add the following
to your commandline

   trace_event=timer_* ftrace_dump_on_oops

That will spill out a lot of crap over serial, but it should tell us
which timer is corrupted.

Thanks,

	tglx

Index: linux-2.6/include/linux/debugobjects.h
===================================================================
--- linux-2.6.orig/include/linux/debugobjects.h
+++ linux-2.6/include/linux/debugobjects.h
@@ -68,6 +68,7 @@ extern void debug_object_deactivate(void
 extern void debug_object_destroy   (void *addr, struct debug_obj_descr *descr);
 extern void debug_object_free      (void *addr, struct debug_obj_descr *descr);
 extern void debug_object_assert_init(void *addr, struct debug_obj_descr *descr);
+extern void debug_object_info(void *addr, struct debug_obj_descr *descr);
 
 /*
  * Active state:
@@ -95,6 +96,8 @@ static inline void
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
@@ -377,6 +377,28 @@ void debug_object_init_on_stack(void *ad
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
+}
+
 /**
  * debug_object_activate - debug checks when an object is activated
  * @addr:	address of the object
