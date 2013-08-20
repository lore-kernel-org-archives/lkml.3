Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab3HTCmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:42:32 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:34371 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab3HTCmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:42:25 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Rik van Riel <riel@surriel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH tip/core/rcu 3/9] debugobjects: Make debug_object_activate() return status
Date: Mon, 19 Aug 2013 19:42:08 -0700
Message-Id: <1376966534-30775-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1376966534-30775-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130820024148.GA30283@linux.vnet.ibm.com>
 <1376966534-30775-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082002-1542-0000-0000-000000A78BDB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

In order to better respond to things like duplicate invocations
of call_rcu(), RCU needs to see the status of a call to
debug_object_activate().  This would allow RCU to leak the callback in
order to avoid adding freelist-reuse mischief to the duplicate invoations.
This commit therefore makes debug_object_activate() return status,
zero for success and -EINVAL for failure.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/debugobjects.h |  6 +++---
 lib/debugobjects.c           | 20 ++++++++++++++------
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/include/linux/debugobjects.h b/include/linux/debugobjects.h
index 0e5f578..98ffcbd 100644
--- a/include/linux/debugobjects.h
+++ b/include/linux/debugobjects.h
@@ -63,7 +63,7 @@ struct debug_obj_descr {
 extern void debug_object_init      (void *addr, struct debug_obj_descr *descr);
 extern void
 debug_object_init_on_stack(void *addr, struct debug_obj_descr *descr);
-extern void debug_object_activate  (void *addr, struct debug_obj_descr *descr);
+extern int debug_object_activate  (void *addr, struct debug_obj_descr *descr);
 extern void debug_object_deactivate(void *addr, struct debug_obj_descr *descr);
 extern void debug_object_destroy   (void *addr, struct debug_obj_descr *descr);
 extern void debug_object_free      (void *addr, struct debug_obj_descr *descr);
@@ -85,8 +85,8 @@ static inline void
 debug_object_init      (void *addr, struct debug_obj_descr *descr) { }
 static inline void
 debug_object_init_on_stack(void *addr, struct debug_obj_descr *descr) { }
-static inline void
-debug_object_activate  (void *addr, struct debug_obj_descr *descr) { }
+static inline int
+debug_object_activate  (void *addr, struct debug_obj_descr *descr) { return 0; }
 static inline void
 debug_object_deactivate(void *addr, struct debug_obj_descr *descr) { }
 static inline void
diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 37061ed..bf2c8b1 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -381,19 +381,21 @@ void debug_object_init_on_stack(void *addr, struct debug_obj_descr *descr)
  * debug_object_activate - debug checks when an object is activated
  * @addr:	address of the object
  * @descr:	pointer to an object specific debug description structure
+ * Returns 0 for success, -EINVAL for check failed.
  */
-void debug_object_activate(void *addr, struct debug_obj_descr *descr)
+int debug_object_activate(void *addr, struct debug_obj_descr *descr)
 {
 	enum debug_obj_state state;
 	struct debug_bucket *db;
 	struct debug_obj *obj;
 	unsigned long flags;
+	int ret;
 	struct debug_obj o = { .object = addr,
 			       .state = ODEBUG_STATE_NOTAVAILABLE,
 			       .descr = descr };
 
 	if (!debug_objects_enabled)
-		return;
+		return 0;
 
 	db = get_bucket((unsigned long) addr);
 
@@ -405,23 +407,26 @@ void debug_object_activate(void *addr, struct debug_obj_descr *descr)
 		case ODEBUG_STATE_INIT:
 		case ODEBUG_STATE_INACTIVE:
 			obj->state = ODEBUG_STATE_ACTIVE;
+			ret = 0;
 			break;
 
 		case ODEBUG_STATE_ACTIVE:
 			debug_print_object(obj, "activate");
 			state = obj->state;
 			raw_spin_unlock_irqrestore(&db->lock, flags);
-			debug_object_fixup(descr->fixup_activate, addr, state);
-			return;
+			ret = debug_object_fixup(descr->fixup_activate, addr, state);
+			return ret ? -EINVAL : 0;
 
 		case ODEBUG_STATE_DESTROYED:
 			debug_print_object(obj, "activate");
+			ret = -EINVAL;
 			break;
 		default:
+			ret = 0;
 			break;
 		}
 		raw_spin_unlock_irqrestore(&db->lock, flags);
-		return;
+		return ret;
 	}
 
 	raw_spin_unlock_irqrestore(&db->lock, flags);
@@ -431,8 +436,11 @@ void debug_object_activate(void *addr, struct debug_obj_descr *descr)
 	 * true or not.
 	 */
 	if (debug_object_fixup(descr->fixup_activate, addr,
-			   ODEBUG_STATE_NOTAVAILABLE))
+			   ODEBUG_STATE_NOTAVAILABLE)) {
 		debug_print_object(&o, "activate");
+		return -EINVAL;
+	}
+	return 0;
 }
 
 /**
-- 
1.8.1.5

