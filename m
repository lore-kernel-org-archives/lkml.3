Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934278AbaCSN6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:58:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:33832 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933380AbaCSN6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:58:24 -0400
Date: Wed, 19 Mar 2014 14:58:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: rb tree hrtimer lockup bug (found by perf_fuzzer)
In-Reply-To: <alpine.DEB.2.10.1403190941170.18343@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.02.1403191456120.18573@ionos.tec.linutronix.de>
References: <alpine.DEB.2.10.1403031526210.11945@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1403041620390.15963@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1403181250110.14816@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403181921010.18573@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403181523360.15687@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403182149540.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403181705000.15687@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403182218170.18573@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1403190941170.18343@vincent-weaver-1.um.maine.edu>
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
> On Tue, 18 Mar 2014, Thomas Gleixner wrote:
> your patch didn't seem to print anything additional the first time throug.
> 
> I then tried the trace command you suggested, but I'm getting an empty
> ftrace buffer which possibly means I don't have enough ftrace kernel 
> options enabled.
> 
> Here's the most recent boot crash.
> 
> [    5.367069] ODEBUG: Info active (active state 0) object type: timer_list hint:           (null)

Stupid me. We get the hint from the wreckaged object ....

A hopefully better approach is the delta patch below.

Thanks,

	tglx
------------------->
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
Index: linux-2.6/lib/debugobjects.c
===================================================================
--- linux-2.6.orig/lib/debugobjects.c
+++ linux-2.6/lib/debugobjects.c
@@ -255,9 +255,9 @@ static void debug_print_object(struct de
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
@@ -326,6 +326,9 @@ __debug_object_init(void *addr, struct d
 		debug_object_is_on_stack(addr, onstack);
 	}
 
+	if (!obj->hint)
+		obj->hint = descr->debug_hint ?	descr->debug_hint(addr) : NULL;
+
 	switch (obj->state) {
 	case ODEBUG_STATE_NONE:
 	case ODEBUG_STATE_INIT:
@@ -447,6 +450,8 @@ int debug_object_activate(void *addr, st
 			ret = 0;
 			break;
 		}
+		if (!obj->hint)
+			obj->hint = descr->debug_hint ?	descr->debug_hint(addr) : NULL;
 		raw_spin_unlock_irqrestore(&db->lock, flags);
 		return ret;
 	}
