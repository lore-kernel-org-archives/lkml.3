Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713Ab3GVQLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:11:19 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:40055 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932667Ab3GVQLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:11:12 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Bruce Korb <bruce_korb@xyratex.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 16/48] staging/lustre/dlmlock: compress out unused space
Date: Tue, 23 Jul 2013 00:06:37 +0800
Message-Id: <1374509230-3324-17-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bruce Korb <bruce_korb@xyratex.com>

* lustre/include/lustre_dlm.h: Remove all bit fields and the unused
  weighing callback procedure.  respell LDLM_AST_DISCARD_DATA as
  LDLM_FL_AST_DISCARD_DATA to match other flags.
* .gitignore: ignore emacs temporary files
* autogen.sh: rebuild the lock bits, if autogen is available.
* contrib/bit-masks/lustre_dlm_flags.def: define the ldlm_lock flags
* contrib/bit-masks/lustre_dlm_flags.tpl: template for emitting text
* contrib/bit-masks/Makefile: construct the .c and .h files
  The .c file is for constructing a crash extension and is not
  preserved.
* contrib/bit-masks/.gitignore: ignore built products
* lustre/contrib/wireshark/packet-lustre.c: use built files instead
  of local versions of the defines.

In the rest of the modified sources, replace flag field references
with bit mask references.

* lustre/osc/osc_lock.c: removed osc_lock_weigh, too

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2771
Lustre-change: http://review.whamcloud.com/5312
Signed-off-by: Bruce Korb <bruce_korb@xyratex.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Reviewed-by: Keith Mannthey <Keith.Mannthey@intel.com>
Reviewed-by: Keith Mannthey <keith.mannthey@intel.com>
Reviewed-by: <bruce.korb@gmail.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/include/lustre_dlm.h |  198 +--------
 .../lustre/lustre/include/lustre_dlm_flags.h       |  460 ++++++++++++++++++++
 drivers/staging/lustre/lustre/ldlm/l_lock.c        |    8 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_flock.c    |    2 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lock.c     |   48 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c    |    4 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_request.c  |    7 +-
 drivers/staging/lustre/lustre/ldlm/ldlm_resource.c |    4 +-
 drivers/staging/lustre/lustre/llite/dir.c          |   15 +-
 drivers/staging/lustre/lustre/llite/file.c         |   19 +-
 drivers/staging/lustre/lustre/mdc/mdc_locks.c      |    9 +-
 drivers/staging/lustre/lustre/mgc/mgc_request.c    |    8 +-
 drivers/staging/lustre/lustre/osc/osc_lock.c       |  124 ++----
 13 files changed, 573 insertions(+), 333 deletions(-)
 create mode 100644 drivers/staging/lustre/lustre/include/lustre_dlm_flags.h

diff --git a/drivers/staging/lustre/lustre/include/lustre_dlm.h b/drivers/staging/lustre/lustre/include/lustre_dlm.h
index 25437b7..66db562 100644
--- a/drivers/staging/lustre/lustre/include/lustre_dlm.h
+++ b/drivers/staging/lustre/lustre/include/lustre_dlm.h
@@ -57,6 +57,8 @@
 #include <interval_tree.h> /* for interval_node{}, ldlm_extent */
 #include <lu_ref.h>
 
+#include "lustre_dlm_flags.h"
+
 struct obd_ops;
 struct obd_device;
 
@@ -96,161 +98,6 @@ typedef enum {
 } ldlm_side_t;
 
 /**
- * Declaration of flags sent through the wire.
- **/
-#define LDLM_FL_LOCK_CHANGED   0x000001 /* extent, mode, or resource changed */
-
-/**
- * If the server returns one of these flags, then the lock was put on that list.
- * If the client sends one of these flags (during recovery ONLY!), it wants the
- * lock added to the specified list, no questions asked.
- */
-#define LDLM_FL_BLOCK_GRANTED  0x000002
-#define LDLM_FL_BLOCK_CONV     0x000004
-#define LDLM_FL_BLOCK_WAIT     0x000008
-
-/* Used to be LDLM_FL_CBPENDING 0x000010 moved to non-wire flags */
-
-#define LDLM_FL_AST_SENT       0x000020 /* blocking or cancel packet was
-					 * queued for sending. */
-/* Used to be LDLM_FL_WAIT_NOREPROC 0x000040   moved to non-wire flags */
-/* Used to be LDLM_FL_CANCEL	0x000080   moved to non-wire flags */
-
-/**
- * Lock is being replayed.  This could probably be implied by the fact that one
- * of BLOCK_{GRANTED,CONV,WAIT} is set, but that is pretty dangerous.
- */
-#define LDLM_FL_REPLAY	 0x000100
-
-#define LDLM_FL_INTENT_ONLY    0x000200 /* Don't grant lock, just do intent. */
-
-/* Used to be LDLM_FL_LOCAL_ONLY 0x000400  moved to non-wire flags */
-/* Used to be LDLM_FL_FAILED     0x000800  moved to non-wire flags */
-
-#define LDLM_FL_HAS_INTENT     0x001000 /* lock request has intent */
-
-/* Used to be LDLM_FL_CANCELING  0x002000  moved to non-wire flags */
-/* Used to be LDLM_FL_LOCAL      0x004000  moved to non-wire flags */
-
-#define LDLM_FL_DISCARD_DATA   0x010000 /* discard (no writeback) on cancel */
-
-#define LDLM_FL_NO_TIMEOUT     0x020000 /* Blocked by group lock - wait
-					 * indefinitely */
-
-/** file & record locking */
-#define LDLM_FL_BLOCK_NOWAIT   0x040000 /* Server told not to wait if blocked.
-					 * For AGL, OST will not send glimpse
-					 * callback. */
-#define LDLM_FL_TEST_LOCK      0x080000 // return blocking lock
-
-/* Used to be LDLM_FL_LVB_READY  0x100000 moved to non-wire flags */
-/* Used to be LDLM_FL_KMS_IGNORE 0x200000 moved to non-wire flags */
-/* Used to be LDLM_FL_NO_LRU     0x400000 moved to non-wire flags */
-
-/* Immediatelly cancel such locks when they block some other locks. Send
- * cancel notification to original lock holder, but expect no reply. This is
- * for clients (like liblustre) that cannot be expected to reliably response
- * to blocking AST. */
-#define LDLM_FL_CANCEL_ON_BLOCK 0x800000
-
-/* Flags flags inherited from parent lock when doing intents. */
-#define LDLM_INHERIT_FLAGS     (LDLM_FL_CANCEL_ON_BLOCK)
-
-/* Used to be LDLM_FL_CP_REQD	0x1000000 moved to non-wire flags */
-/* Used to be LDLM_FL_CLEANED	0x2000000 moved to non-wire flags */
-/* Used to be LDLM_FL_ATOMIC_CB      0x4000000 moved to non-wire flags */
-/* Used to be LDLM_FL_BL_AST	 0x10000000 moved to non-wire flags */
-/* Used to be LDLM_FL_BL_DONE	0x20000000 moved to non-wire flags */
-
-/* measure lock contention and return -EUSERS if locking contention is high */
-#define LDLM_FL_DENY_ON_CONTENTION 0x40000000
-
-/* These are flags that are mapped into the flags and ASTs of blocking locks */
-#define LDLM_AST_DISCARD_DATA  0x80000000 /* Add FL_DISCARD to blocking ASTs */
-
-/* Flags sent in AST lock_flags to be mapped into the receiving lock. */
-#define LDLM_AST_FLAGS	 (LDLM_FL_DISCARD_DATA)
-
-/*
- * --------------------------------------------------------------------------
- * NOTE! Starting from this point, that is, LDLM_FL_* flags with values above
- * 0x80000000 will not be sent over the wire.
- * --------------------------------------------------------------------------
- */
-
-/**
- * Declaration of flags not sent through the wire.
- **/
-
-/**
- * Used for marking lock as a target for -EINTR while cp_ast sleep
- * emulation + race with upcoming bl_ast.
- */
-#define LDLM_FL_FAIL_LOC       0x100000000ULL
-
-/**
- * Used while processing the unused list to know that we have already
- * handled this lock and decided to skip it.
- */
-#define LDLM_FL_SKIPPED	0x200000000ULL
-/* this lock is being destroyed */
-#define LDLM_FL_CBPENDING      0x400000000ULL
-/* not a real flag, not saved in lock */
-#define LDLM_FL_WAIT_NOREPROC  0x800000000ULL
-/* cancellation callback already run */
-#define LDLM_FL_CANCEL	 0x1000000000ULL
-#define LDLM_FL_LOCAL_ONLY     0x2000000000ULL
-/* don't run the cancel callback under ldlm_cli_cancel_unused */
-#define LDLM_FL_FAILED	 0x4000000000ULL
-/* lock cancel has already been sent */
-#define LDLM_FL_CANCELING      0x8000000000ULL
-/* local lock (ie, no srv/cli split) */
-#define LDLM_FL_LOCAL	  0x10000000000ULL
-/* XXX FIXME: This is being added to b_size as a low-risk fix to the fact that
- * the LVB filling happens _after_ the lock has been granted, so another thread
- * can match it before the LVB has been updated.  As a dirty hack, we set
- * LDLM_FL_LVB_READY only after we've done the LVB poop.
- * this is only needed on LOV/OSC now, where LVB is actually used and callers
- * must set it in input flags.
- *
- * The proper fix is to do the granting inside of the completion AST, which can
- * be replaced with a LVB-aware wrapping function for OSC locks.  That change is
- * pretty high-risk, though, and would need a lot more testing. */
-#define LDLM_FL_LVB_READY      0x20000000000ULL
-/* A lock contributes to the known minimum size (KMS) calculation until it has
- * finished the part of its cancelation that performs write back on its dirty
- * pages.  It can remain on the granted list during this whole time.  Threads
- * racing to update the KMS after performing their writeback need to know to
- * exclude each other's locks from the calculation as they walk the granted
- * list. */
-#define LDLM_FL_KMS_IGNORE     0x40000000000ULL
-/* completion AST to be executed */
-#define LDLM_FL_CP_REQD	0x80000000000ULL
-/* cleanup_resource has already handled the lock */
-#define LDLM_FL_CLEANED	0x100000000000ULL
-/* optimization hint: LDLM can run blocking callback from current context
- * w/o involving separate thread. in order to decrease cs rate */
-#define LDLM_FL_ATOMIC_CB      0x200000000000ULL
-
-/* It may happen that a client initiates two operations, e.g. unlink and
- * mkdir, such that the server sends a blocking AST for conflicting
- * locks to this client for the first operation, whereas the second
- * operation has canceled this lock and is waiting for rpc_lock which is
- * taken by the first operation. LDLM_FL_BL_AST is set by
- * ldlm_callback_handler() in the lock to prevent the Early Lock Cancel
- * (ELC) code from cancelling it.
- *
- * LDLM_FL_BL_DONE is to be set by ldlm_cancel_callback() when lock
- * cache is dropped to let ldlm_callback_handler() return EINVAL to the
- * server. It is used when ELC RPC is already prepared and is waiting
- * for rpc_lock, too late to send a separate CANCEL RPC. */
-#define LDLM_FL_BL_AST	  0x400000000000ULL
-#define LDLM_FL_BL_DONE	 0x800000000000ULL
-/* Don't put lock into the LRU list, so that it is not canceled due to aging.
- * Used by MGC locks, they are cancelled only at unmount or by callback. */
-#define LDLM_FL_NO_LRU		0x1000000000000ULL
-
-/**
  * The blocking callback is overloaded to perform two functions.  These flags
  * indicate which operation should be performed.
  */
@@ -720,8 +567,6 @@ typedef int (*ldlm_completion_callback)(struct ldlm_lock *lock, __u64 flags,
 					void *data);
 /** Type for glimpse callback function of a lock. */
 typedef int (*ldlm_glimpse_callback)(struct ldlm_lock *lock, void *data);
-/** Type for weight callback function of a lock. */
-typedef unsigned long (*ldlm_weigh_callback)(struct ldlm_lock *lock);
 
 /** Work list for sending GL ASTs to multiple locks. */
 struct ldlm_glimpse_work {
@@ -890,9 +735,6 @@ struct ldlm_lock {
 	 */
 	ldlm_glimpse_callback	l_glimpse_ast;
 
-	/** XXX apparently unused "weight" handler. To be removed? */
-	ldlm_weigh_callback	l_weigh_ast;
-
 	/**
 	 * Lock export.
 	 * This is a pointer to actual client export for locks that were granted
@@ -919,11 +761,11 @@ struct ldlm_lock {
 	ldlm_policy_data_t	l_policy_data;
 
 	/**
-	 * Lock state flags.
-	 * Like whenever we receive any blocking requests for this lock, etc.
-	 * Protected by lr_lock.
+	 * Lock state flags. Protected by lr_lock.
+	 * \see lustre_dlm_flags.h where the bits are defined.
 	 */
 	__u64			l_flags;
+
 	/**
 	 * Lock r/w usage counters.
 	 * Protected by lr_lock.
@@ -952,34 +794,6 @@ struct ldlm_lock {
 	/** Originally requested extent for the extent lock. */
 	struct ldlm_extent	l_req_extent;
 
-	unsigned int		l_failed:1,
-	/**
-	 * Set for locks that were removed from class hash table and will be
-	 * destroyed when last reference to them is released. Set by
-	 * ldlm_lock_destroy_internal().
-	 *
-	 * Protected by lock and resource locks.
-	 */
-				l_destroyed:1,
-	/*
-	 * it's set in lock_res_and_lock() and unset in unlock_res_and_lock().
-	 *
-	 * NB: compared with check_res_locked(), checking this bit is cheaper.
-	 * Also, spin_is_locked() is deprecated for kernel code; one reason is
-	 * because it works only for SMP so user needs to add extra macros like
-	 * LASSERT_SPIN_LOCKED for uniprocessor kernels.
-	 */
-				l_res_locked:1,
-	/*
-	 * It's set once we call ldlm_add_waiting_lock_res_locked()
-	 * to start the lock-timeout timer and it will never be reset.
-	 *
-	 * Protected by lock_res_and_lock().
-	 */
-				l_waited:1,
-	/** Flag whether this is a server namespace lock. */
-				l_ns_srv:1;
-
 	/*
 	 * Client-side-only members.
 	 */
@@ -1230,7 +1044,6 @@ struct ldlm_enqueue_info {
 	void *ei_cb_bl;  /** blocking lock callback */
 	void *ei_cb_cp;  /** lock completion callback */
 	void *ei_cb_gl;  /** lock glimpse callback */
-	void *ei_cb_wg;  /** lock weigh callback */
 	void *ei_cbdata; /** Data to be passed into callbacks. */
 };
 
@@ -1328,7 +1141,6 @@ struct ldlm_callback_suite {
 	ldlm_completion_callback lcs_completion;
 	ldlm_blocking_callback   lcs_blocking;
 	ldlm_glimpse_callback    lcs_glimpse;
-	ldlm_weigh_callback      lcs_weigh;
 };
 
 /* ldlm_lockd.c */
diff --git a/drivers/staging/lustre/lustre/include/lustre_dlm_flags.h b/drivers/staging/lustre/lustre/include/lustre_dlm_flags.h
new file mode 100644
index 0000000..8c34d9d
--- /dev/null
+++ b/drivers/staging/lustre/lustre/include/lustre_dlm_flags.h
@@ -0,0 +1,460 @@
+/*  -*- buffer-read-only: t -*- vi: set ro:
+ *
+ * DO NOT EDIT THIS FILE   (lustre_dlm_flags.h)
+ *
+ * It has been AutoGen-ed
+ * From the definitions    lustre_dlm_flags.def
+ * and the template file   lustre_dlm_flags.tpl
+ *
+ * lustre is free software: you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation, either version 3 of the License, or
+ * (at your option) any later version.
+ *
+ * lustre is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ * See the GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+/**
+ * \file lustre_dlm_flags.h
+ * The flags and collections of flags (masks) for \see struct ldlm_lock.
+ * This file is derived from flag definitions in lustre_dlm_flags.def.
+ * The format is defined in the lustre_dlm_flags.tpl template file.
+ *
+ * \addtogroup LDLM Lustre Distributed Lock Manager
+ * @{
+ *
+ * \name flags
+ * The flags and collections of flags (masks) for \see struct ldlm_lock.
+ * @{
+ */
+#ifndef LDLM_ALL_FLAGS_MASK
+
+/** l_flags bits marked as "all_flags" bits */
+#define LDLM_FL_ALL_FLAGS_MASK          0x007FFFFFC08F132FULL
+
+/** l_flags bits marked as "ast" bits */
+#define LDLM_FL_AST_MASK                0x0000000080000000ULL
+
+/** l_flags bits marked as "blocked" bits */
+#define LDLM_FL_BLOCKED_MASK            0x000000000000000EULL
+
+/** l_flags bits marked as "gone" bits */
+#define LDLM_FL_GONE_MASK               0x0006004000000000ULL
+
+/** l_flags bits marked as "hide_lock" bits */
+#define LDLM_FL_HIDE_LOCK_MASK          0x0000206400000000ULL
+
+/** l_flags bits marked as "inherit" bits */
+#define LDLM_FL_INHERIT_MASK            0x0000000000800000ULL
+
+/** l_flags bits marked as "local_only" bits */
+#define LDLM_FL_LOCAL_ONLY_MASK         0x007FFFFF00000000ULL
+
+/** l_flags bits marked as "on_wire" bits */
+#define LDLM_FL_ON_WIRE_MASK            0x00000000C08F132FULL
+
+/** extent, mode, or resource changed */
+#define LDLM_FL_LOCK_CHANGED            0x0000000000000001ULL // bit   0
+#define ldlm_is_lock_changed(_l)        LDLM_TEST_FLAG(( _l), 1ULL <<  0)
+#define ldlm_set_lock_changed(_l)       LDLM_SET_FLAG((  _l), 1ULL <<  0)
+#define ldlm_clear_lock_changed(_l)     LDLM_CLEAR_FLAG((_l), 1ULL <<  0)
+
+/**
+ * Server placed lock on granted list, or a recovering client wants the
+ * lock added to the granted list, no questions asked. */
+#define LDLM_FL_BLOCK_GRANTED           0x0000000000000002ULL // bit   1
+#define ldlm_is_block_granted(_l)       LDLM_TEST_FLAG(( _l), 1ULL <<  1)
+#define ldlm_set_block_granted(_l)      LDLM_SET_FLAG((  _l), 1ULL <<  1)
+#define ldlm_clear_block_granted(_l)    LDLM_CLEAR_FLAG((_l), 1ULL <<  1)
+
+/**
+ * Server placed lock on conv list, or a recovering client wants the lock
+ * added to the conv list, no questions asked. */
+#define LDLM_FL_BLOCK_CONV              0x0000000000000004ULL // bit   2
+#define ldlm_is_block_conv(_l)          LDLM_TEST_FLAG(( _l), 1ULL <<  2)
+#define ldlm_set_block_conv(_l)         LDLM_SET_FLAG((  _l), 1ULL <<  2)
+#define ldlm_clear_block_conv(_l)       LDLM_CLEAR_FLAG((_l), 1ULL <<  2)
+
+/**
+ * Server placed lock on wait list, or a recovering client wants the lock
+ * added to the wait list, no questions asked. */
+#define LDLM_FL_BLOCK_WAIT              0x0000000000000008ULL // bit   3
+#define ldlm_is_block_wait(_l)          LDLM_TEST_FLAG(( _l), 1ULL <<  3)
+#define ldlm_set_block_wait(_l)         LDLM_SET_FLAG((  _l), 1ULL <<  3)
+#define ldlm_clear_block_wait(_l)       LDLM_CLEAR_FLAG((_l), 1ULL <<  3)
+
+/** blocking or cancel packet was queued for sending. */
+#define LDLM_FL_AST_SENT                0x0000000000000020ULL // bit   5
+#define ldlm_is_ast_sent(_l)            LDLM_TEST_FLAG(( _l), 1ULL <<  5)
+#define ldlm_set_ast_sent(_l)           LDLM_SET_FLAG((  _l), 1ULL <<  5)
+#define ldlm_clear_ast_sent(_l)         LDLM_CLEAR_FLAG((_l), 1ULL <<  5)
+
+/**
+ * Lock is being replayed.  This could probably be implied by the fact that
+ * one of BLOCK_{GRANTED,CONV,WAIT} is set, but that is pretty dangerous. */
+#define LDLM_FL_REPLAY                  0x0000000000000100ULL // bit   8
+#define ldlm_is_replay(_l)              LDLM_TEST_FLAG(( _l), 1ULL <<  8)
+#define ldlm_set_replay(_l)             LDLM_SET_FLAG((  _l), 1ULL <<  8)
+#define ldlm_clear_replay(_l)           LDLM_CLEAR_FLAG((_l), 1ULL <<  8)
+
+/** Don't grant lock, just do intent. */
+#define LDLM_FL_INTENT_ONLY             0x0000000000000200ULL // bit   9
+#define ldlm_is_intent_only(_l)         LDLM_TEST_FLAG(( _l), 1ULL <<  9)
+#define ldlm_set_intent_only(_l)        LDLM_SET_FLAG((  _l), 1ULL <<  9)
+#define ldlm_clear_intent_only(_l)      LDLM_CLEAR_FLAG((_l), 1ULL <<  9)
+
+/** lock request has intent */
+#define LDLM_FL_HAS_INTENT              0x0000000000001000ULL // bit  12
+#define ldlm_is_has_intent(_l)          LDLM_TEST_FLAG(( _l), 1ULL << 12)
+#define ldlm_set_has_intent(_l)         LDLM_SET_FLAG((  _l), 1ULL << 12)
+#define ldlm_clear_has_intent(_l)       LDLM_CLEAR_FLAG((_l), 1ULL << 12)
+
+/** discard (no writeback) on cancel */
+#define LDLM_FL_DISCARD_DATA            0x0000000000010000ULL // bit  16
+#define ldlm_is_discard_data(_l)        LDLM_TEST_FLAG(( _l), 1ULL << 16)
+#define ldlm_set_discard_data(_l)       LDLM_SET_FLAG((  _l), 1ULL << 16)
+#define ldlm_clear_discard_data(_l)     LDLM_CLEAR_FLAG((_l), 1ULL << 16)
+
+/** Blocked by group lock - wait indefinitely */
+#define LDLM_FL_NO_TIMEOUT              0x0000000000020000ULL // bit  17
+#define ldlm_is_no_timeout(_l)          LDLM_TEST_FLAG(( _l), 1ULL << 17)
+#define ldlm_set_no_timeout(_l)         LDLM_SET_FLAG((  _l), 1ULL << 17)
+#define ldlm_clear_no_timeout(_l)       LDLM_CLEAR_FLAG((_l), 1ULL << 17)
+
+/**
+ * Server told not to wait if blocked. For AGL, OST will not send glimpse
+ * callback. */
+#define LDLM_FL_BLOCK_NOWAIT            0x0000000000040000ULL // bit  18
+#define ldlm_is_block_nowait(_l)        LDLM_TEST_FLAG(( _l), 1ULL << 18)
+#define ldlm_set_block_nowait(_l)       LDLM_SET_FLAG((  _l), 1ULL << 18)
+#define ldlm_clear_block_nowait(_l)     LDLM_CLEAR_FLAG((_l), 1ULL << 18)
+
+/** return blocking lock */
+#define LDLM_FL_TEST_LOCK               0x0000000000080000ULL // bit  19
+#define ldlm_is_test_lock(_l)           LDLM_TEST_FLAG(( _l), 1ULL << 19)
+#define ldlm_set_test_lock(_l)          LDLM_SET_FLAG((  _l), 1ULL << 19)
+#define ldlm_clear_test_lock(_l)        LDLM_CLEAR_FLAG((_l), 1ULL << 19)
+
+/**
+ * Immediatelly cancel such locks when they block some other locks. Send
+ * cancel notification to original lock holder, but expect no reply. This
+ * is for clients (like liblustre) that cannot be expected to reliably
+ * response to blocking AST. */
+#define LDLM_FL_CANCEL_ON_BLOCK         0x0000000000800000ULL // bit  23
+#define ldlm_is_cancel_on_block(_l)     LDLM_TEST_FLAG(( _l), 1ULL << 23)
+#define ldlm_set_cancel_on_block(_l)    LDLM_SET_FLAG((  _l), 1ULL << 23)
+#define ldlm_clear_cancel_on_block(_l)  LDLM_CLEAR_FLAG((_l), 1ULL << 23)
+
+/**
+ * measure lock contention and return -EUSERS if locking contention is high */
+#define LDLM_FL_DENY_ON_CONTENTION        0x0000000040000000ULL // bit  30
+#define ldlm_is_deny_on_contention(_l)    LDLM_TEST_FLAG(( _l), 1ULL << 30)
+#define ldlm_set_deny_on_contention(_l)   LDLM_SET_FLAG((  _l), 1ULL << 30)
+#define ldlm_clear_deny_on_contention(_l) LDLM_CLEAR_FLAG((_l), 1ULL << 30)
+
+/**
+ * These are flags that are mapped into the flags and ASTs of blocking
+ * locks Add FL_DISCARD to blocking ASTs */
+#define LDLM_FL_AST_DISCARD_DATA        0x0000000080000000ULL // bit  31
+#define ldlm_is_ast_discard_data(_l)    LDLM_TEST_FLAG(( _l), 1ULL << 31)
+#define ldlm_set_ast_discard_data(_l)   LDLM_SET_FLAG((  _l), 1ULL << 31)
+#define ldlm_clear_ast_discard_data(_l) LDLM_CLEAR_FLAG((_l), 1ULL << 31)
+
+/**
+ * Used for marking lock as a target for -EINTR while cp_ast sleep emulation
+ * + race with upcoming bl_ast. */
+#define LDLM_FL_FAIL_LOC                0x0000000100000000ULL // bit  32
+#define ldlm_is_fail_loc(_l)            LDLM_TEST_FLAG(( _l), 1ULL << 32)
+#define ldlm_set_fail_loc(_l)           LDLM_SET_FLAG((  _l), 1ULL << 32)
+#define ldlm_clear_fail_loc(_l)         LDLM_CLEAR_FLAG((_l), 1ULL << 32)
+
+/**
+ * Used while processing the unused list to know that we have already
+ * handled this lock and decided to skip it. */
+#define LDLM_FL_SKIPPED                 0x0000000200000000ULL // bit  33
+#define ldlm_is_skipped(_l)             LDLM_TEST_FLAG(( _l), 1ULL << 33)
+#define ldlm_set_skipped(_l)            LDLM_SET_FLAG((  _l), 1ULL << 33)
+#define ldlm_clear_skipped(_l)          LDLM_CLEAR_FLAG((_l), 1ULL << 33)
+
+/** this lock is being destroyed */
+#define LDLM_FL_CBPENDING               0x0000000400000000ULL // bit  34
+#define ldlm_is_cbpending(_l)           LDLM_TEST_FLAG(( _l), 1ULL << 34)
+#define ldlm_set_cbpending(_l)          LDLM_SET_FLAG((  _l), 1ULL << 34)
+#define ldlm_clear_cbpending(_l)        LDLM_CLEAR_FLAG((_l), 1ULL << 34)
+
+/** not a real flag, not saved in lock */
+#define LDLM_FL_WAIT_NOREPROC           0x0000000800000000ULL // bit  35
+#define ldlm_is_wait_noreproc(_l)       LDLM_TEST_FLAG(( _l), 1ULL << 35)
+#define ldlm_set_wait_noreproc(_l)      LDLM_SET_FLAG((  _l), 1ULL << 35)
+#define ldlm_clear_wait_noreproc(_l)    LDLM_CLEAR_FLAG((_l), 1ULL << 35)
+
+/** cancellation callback already run */
+#define LDLM_FL_CANCEL                  0x0000001000000000ULL // bit  36
+#define ldlm_is_cancel(_l)              LDLM_TEST_FLAG(( _l), 1ULL << 36)
+#define ldlm_set_cancel(_l)             LDLM_SET_FLAG((  _l), 1ULL << 36)
+#define ldlm_clear_cancel(_l)           LDLM_CLEAR_FLAG((_l), 1ULL << 36)
+
+/** whatever it might mean */
+#define LDLM_FL_LOCAL_ONLY              0x0000002000000000ULL // bit  37
+#define ldlm_is_local_only(_l)          LDLM_TEST_FLAG(( _l), 1ULL << 37)
+#define ldlm_set_local_only(_l)         LDLM_SET_FLAG((  _l), 1ULL << 37)
+#define ldlm_clear_local_only(_l)       LDLM_CLEAR_FLAG((_l), 1ULL << 37)
+
+/** don't run the cancel callback under ldlm_cli_cancel_unused */
+#define LDLM_FL_FAILED                  0x0000004000000000ULL // bit  38
+#define ldlm_is_failed(_l)              LDLM_TEST_FLAG(( _l), 1ULL << 38)
+#define ldlm_set_failed(_l)             LDLM_SET_FLAG((  _l), 1ULL << 38)
+#define ldlm_clear_failed(_l)           LDLM_CLEAR_FLAG((_l), 1ULL << 38)
+
+/** lock cancel has already been sent */
+#define LDLM_FL_CANCELING               0x0000008000000000ULL // bit  39
+#define ldlm_is_canceling(_l)           LDLM_TEST_FLAG(( _l), 1ULL << 39)
+#define ldlm_set_canceling(_l)          LDLM_SET_FLAG((  _l), 1ULL << 39)
+#define ldlm_clear_canceling(_l)        LDLM_CLEAR_FLAG((_l), 1ULL << 39)
+
+/** local lock (ie, no srv/cli split) */
+#define LDLM_FL_LOCAL                   0x0000010000000000ULL // bit  40
+#define ldlm_is_local(_l)               LDLM_TEST_FLAG(( _l), 1ULL << 40)
+#define ldlm_set_local(_l)              LDLM_SET_FLAG((  _l), 1ULL << 40)
+#define ldlm_clear_local(_l)            LDLM_CLEAR_FLAG((_l), 1ULL << 40)
+
+/**
+ * XXX FIXME: This is being added to b_size as a low-risk fix to the
+ * fact that the LVB filling happens _after_ the lock has been granted,
+ * so another thread can match it before the LVB has been updated.  As a
+ * dirty hack, we set LDLM_FL_LVB_READY only after we've done the LVB poop.
+ * this is only needed on LOV/OSC now, where LVB is actually used and
+ * callers must set it in input flags.
+ *
+ * The proper fix is to do the granting inside of the completion AST,
+ * which can be replaced with a LVB-aware wrapping function for OSC locks.
+ * That change is pretty high-risk, though, and would need a lot more
+ * testing. */
+#define LDLM_FL_LVB_READY               0x0000020000000000ULL // bit  41
+#define ldlm_is_lvb_ready(_l)           LDLM_TEST_FLAG(( _l), 1ULL << 41)
+#define ldlm_set_lvb_ready(_l)          LDLM_SET_FLAG((  _l), 1ULL << 41)
+#define ldlm_clear_lvb_ready(_l)        LDLM_CLEAR_FLAG((_l), 1ULL << 41)
+
+/**
+ * A lock contributes to the known minimum size (KMS) calculation until it
+ * has finished the part of its cancelation that performs write back on its
+ * dirty pages.  It can remain on the granted list during this whole time.
+ * Threads racing to update the KMS after performing their writeback need
+ * to know to exclude each other's locks from the calculation as they walk
+ * the granted list. */
+#define LDLM_FL_KMS_IGNORE              0x0000040000000000ULL // bit  42
+#define ldlm_is_kms_ignore(_l)          LDLM_TEST_FLAG(( _l), 1ULL << 42)
+#define ldlm_set_kms_ignore(_l)         LDLM_SET_FLAG((  _l), 1ULL << 42)
+#define ldlm_clear_kms_ignore(_l)       LDLM_CLEAR_FLAG((_l), 1ULL << 42)
+
+/** completion AST to be executed */
+#define LDLM_FL_CP_REQD                 0x0000080000000000ULL // bit  43
+#define ldlm_is_cp_reqd(_l)             LDLM_TEST_FLAG(( _l), 1ULL << 43)
+#define ldlm_set_cp_reqd(_l)            LDLM_SET_FLAG((  _l), 1ULL << 43)
+#define ldlm_clear_cp_reqd(_l)          LDLM_CLEAR_FLAG((_l), 1ULL << 43)
+
+/** cleanup_resource has already handled the lock */
+#define LDLM_FL_CLEANED                 0x0000100000000000ULL // bit  44
+#define ldlm_is_cleaned(_l)             LDLM_TEST_FLAG(( _l), 1ULL << 44)
+#define ldlm_set_cleaned(_l)            LDLM_SET_FLAG((  _l), 1ULL << 44)
+#define ldlm_clear_cleaned(_l)          LDLM_CLEAR_FLAG((_l), 1ULL << 44)
+
+/**
+ * optimization hint: LDLM can run blocking callback from current context
+ * w/o involving separate thread. in order to decrease cs rate */
+#define LDLM_FL_ATOMIC_CB               0x0000200000000000ULL // bit  45
+#define ldlm_is_atomic_cb(_l)           LDLM_TEST_FLAG(( _l), 1ULL << 45)
+#define ldlm_set_atomic_cb(_l)          LDLM_SET_FLAG((  _l), 1ULL << 45)
+#define ldlm_clear_atomic_cb(_l)        LDLM_CLEAR_FLAG((_l), 1ULL << 45)
+
+/**
+ * It may happen that a client initiates two operations, e.g. unlink and
+ * mkdir, such that the server sends a blocking AST for conflicting locks
+ * to this client for the first operation, whereas the second operation
+ * has canceled this lock and is waiting for rpc_lock which is taken by
+ * the first operation. LDLM_FL_BL_AST is set by ldlm_callback_handler() in
+ * the lock to prevent the Early Lock Cancel (ELC) code from cancelling it.
+ *
+ * LDLM_FL_BL_DONE is to be set by ldlm_cancel_callback() when lock cache is
+ * dropped to let ldlm_callback_handler() return EINVAL to the server. It
+ * is used when ELC RPC is already prepared and is waiting for rpc_lock,
+ * too late to send a separate CANCEL RPC. */
+#define LDLM_FL_BL_AST                  0x0000400000000000ULL // bit  46
+#define ldlm_is_bl_ast(_l)              LDLM_TEST_FLAG(( _l), 1ULL << 46)
+#define ldlm_set_bl_ast(_l)             LDLM_SET_FLAG((  _l), 1ULL << 46)
+#define ldlm_clear_bl_ast(_l)           LDLM_CLEAR_FLAG((_l), 1ULL << 46)
+
+/** whatever it might mean */
+#define LDLM_FL_BL_DONE                 0x0000800000000000ULL // bit  47
+#define ldlm_is_bl_done(_l)             LDLM_TEST_FLAG(( _l), 1ULL << 47)
+#define ldlm_set_bl_done(_l)            LDLM_SET_FLAG((  _l), 1ULL << 47)
+#define ldlm_clear_bl_done(_l)          LDLM_CLEAR_FLAG((_l), 1ULL << 47)
+
+/**
+ * Don't put lock into the LRU list, so that it is not canceled due
+ * to aging.  Used by MGC locks, they are cancelled only at unmount or
+ * by callback. */
+#define LDLM_FL_NO_LRU                  0x0001000000000000ULL // bit  48
+#define ldlm_is_no_lru(_l)              LDLM_TEST_FLAG(( _l), 1ULL << 48)
+#define ldlm_set_no_lru(_l)             LDLM_SET_FLAG((  _l), 1ULL << 48)
+#define ldlm_clear_no_lru(_l)           LDLM_CLEAR_FLAG((_l), 1ULL << 48)
+
+/**
+ * Set for locks that failed and where the server has been notified.
+ *
+ * Protected by lock and resource locks. */
+#define LDLM_FL_FAIL_NOTIFIED           0x0002000000000000ULL // bit  49
+#define ldlm_is_fail_notified(_l)       LDLM_TEST_FLAG(( _l), 1ULL << 49)
+#define ldlm_set_fail_notified(_l)      LDLM_SET_FLAG((  _l), 1ULL << 49)
+#define ldlm_clear_fail_notified(_l)    LDLM_CLEAR_FLAG((_l), 1ULL << 49)
+
+/**
+ * Set for locks that were removed from class hash table and will
+ * be destroyed when last reference to them is released. Set by
+ * ldlm_lock_destroy_internal().
+ *
+ * Protected by lock and resource locks. */
+#define LDLM_FL_DESTROYED               0x0004000000000000ULL // bit  50
+#define ldlm_is_destroyed(_l)           LDLM_TEST_FLAG(( _l), 1ULL << 50)
+#define ldlm_set_destroyed(_l)          LDLM_SET_FLAG((  _l), 1ULL << 50)
+#define ldlm_clear_destroyed(_l)        LDLM_CLEAR_FLAG((_l), 1ULL << 50)
+
+/** flag whether this is a server namespace lock */
+#define LDLM_FL_SERVER_LOCK             0x0008000000000000ULL // bit  51
+#define ldlm_is_server_lock(_l)         LDLM_TEST_FLAG(( _l), 1ULL << 51)
+#define ldlm_set_server_lock(_l)        LDLM_SET_FLAG((  _l), 1ULL << 51)
+#define ldlm_clear_server_lock(_l)      LDLM_CLEAR_FLAG((_l), 1ULL << 51)
+
+/**
+ * It's set in lock_res_and_lock() and unset in unlock_res_and_lock().
+ *
+ * NB: compared with check_res_locked(), checking this bit is cheaper.
+ * Also, spin_is_locked() is deprecated for kernel code; one reason is
+ * because it works only for SMP so user needs to add extra macros like
+ * LASSERT_SPIN_LOCKED for uniprocessor kernels. */
+#define LDLM_FL_RES_LOCKED              0x0010000000000000ULL // bit  52
+#define ldlm_is_res_locked(_l)          LDLM_TEST_FLAG(( _l), 1ULL << 52)
+#define ldlm_set_res_locked(_l)         LDLM_SET_FLAG((  _l), 1ULL << 52)
+#define ldlm_clear_res_locked(_l)       LDLM_CLEAR_FLAG((_l), 1ULL << 52)
+
+/**
+ * It's set once we call ldlm_add_waiting_lock_res_locked() to start the
+ * lock-timeout timer and it will never be reset.
+ *
+ * Protected by lock and resource locks. */
+#define LDLM_FL_WAITED                  0x0020000000000000ULL // bit  53
+#define ldlm_is_waited(_l)              LDLM_TEST_FLAG(( _l), 1ULL << 53)
+#define ldlm_set_waited(_l)             LDLM_SET_FLAG((  _l), 1ULL << 53)
+#define ldlm_clear_waited(_l)           LDLM_CLEAR_FLAG((_l), 1ULL << 53)
+
+/** Flag whether this is a server namespace lock. */
+#define LDLM_FL_NS_SRV                  0x0040000000000000ULL // bit  54
+#define ldlm_is_ns_srv(_l)              LDLM_TEST_FLAG(( _l), 1ULL << 54)
+#define ldlm_set_ns_srv(_l)             LDLM_SET_FLAG((  _l), 1ULL << 54)
+#define ldlm_clear_ns_srv(_l)           LDLM_CLEAR_FLAG((_l), 1ULL << 54)
+
+/** test for ldlm_lock flag bit set */
+#define LDLM_TEST_FLAG(_l, _b)        (((_l)->l_flags & (_b)) != 0)
+
+/** set a ldlm_lock flag bit */
+#define LDLM_SET_FLAG(_l, _b)         (((_l)->l_flags |= (_b))
+
+/** clear a ldlm_lock flag bit */
+#define LDLM_CLEAR_FLAG(_l, _b)       (((_l)->l_flags &= ~(_b))
+
+/** Mask of flags inherited from parent lock when doing intents. */
+#define LDLM_INHERIT_FLAGS            LDLM_FL_INHERIT_MASK
+
+/** Mask of Flags sent in AST lock_flags to map into the receiving lock. */
+#define LDLM_AST_FLAGS                LDLM_FL_AST_MASK
+
+/** @} subgroup */
+/** @} group */
+#ifdef WIRESHARK_COMPILE
+static int hf_lustre_ldlm_fl_lock_changed        = -1;
+static int hf_lustre_ldlm_fl_block_granted       = -1;
+static int hf_lustre_ldlm_fl_block_conv          = -1;
+static int hf_lustre_ldlm_fl_block_wait          = -1;
+static int hf_lustre_ldlm_fl_ast_sent            = -1;
+static int hf_lustre_ldlm_fl_replay              = -1;
+static int hf_lustre_ldlm_fl_intent_only         = -1;
+static int hf_lustre_ldlm_fl_has_intent          = -1;
+static int hf_lustre_ldlm_fl_discard_data        = -1;
+static int hf_lustre_ldlm_fl_no_timeout          = -1;
+static int hf_lustre_ldlm_fl_block_nowait        = -1;
+static int hf_lustre_ldlm_fl_test_lock           = -1;
+static int hf_lustre_ldlm_fl_cancel_on_block     = -1;
+static int hf_lustre_ldlm_fl_deny_on_contention  = -1;
+static int hf_lustre_ldlm_fl_ast_discard_data    = -1;
+static int hf_lustre_ldlm_fl_fail_loc            = -1;
+static int hf_lustre_ldlm_fl_skipped             = -1;
+static int hf_lustre_ldlm_fl_cbpending           = -1;
+static int hf_lustre_ldlm_fl_wait_noreproc       = -1;
+static int hf_lustre_ldlm_fl_cancel              = -1;
+static int hf_lustre_ldlm_fl_local_only          = -1;
+static int hf_lustre_ldlm_fl_failed              = -1;
+static int hf_lustre_ldlm_fl_canceling           = -1;
+static int hf_lustre_ldlm_fl_local               = -1;
+static int hf_lustre_ldlm_fl_lvb_ready           = -1;
+static int hf_lustre_ldlm_fl_kms_ignore          = -1;
+static int hf_lustre_ldlm_fl_cp_reqd             = -1;
+static int hf_lustre_ldlm_fl_cleaned             = -1;
+static int hf_lustre_ldlm_fl_atomic_cb           = -1;
+static int hf_lustre_ldlm_fl_bl_ast              = -1;
+static int hf_lustre_ldlm_fl_bl_done             = -1;
+static int hf_lustre_ldlm_fl_no_lru              = -1;
+static int hf_lustre_ldlm_fl_fail_notified       = -1;
+static int hf_lustre_ldlm_fl_destroyed           = -1;
+static int hf_lustre_ldlm_fl_server_lock         = -1;
+static int hf_lustre_ldlm_fl_res_locked          = -1;
+static int hf_lustre_ldlm_fl_waited              = -1;
+static int hf_lustre_ldlm_fl_ns_srv              = -1;
+
+const value_string lustre_ldlm_flags_vals[] = {
+  {LDLM_FL_LOCK_CHANGED,        "LDLM_FL_LOCK_CHANGED"},
+  {LDLM_FL_BLOCK_GRANTED,       "LDLM_FL_BLOCK_GRANTED"},
+  {LDLM_FL_BLOCK_CONV,          "LDLM_FL_BLOCK_CONV"},
+  {LDLM_FL_BLOCK_WAIT,          "LDLM_FL_BLOCK_WAIT"},
+  {LDLM_FL_AST_SENT,            "LDLM_FL_AST_SENT"},
+  {LDLM_FL_REPLAY,              "LDLM_FL_REPLAY"},
+  {LDLM_FL_INTENT_ONLY,         "LDLM_FL_INTENT_ONLY"},
+  {LDLM_FL_HAS_INTENT,          "LDLM_FL_HAS_INTENT"},
+  {LDLM_FL_DISCARD_DATA,        "LDLM_FL_DISCARD_DATA"},
+  {LDLM_FL_NO_TIMEOUT,          "LDLM_FL_NO_TIMEOUT"},
+  {LDLM_FL_BLOCK_NOWAIT,        "LDLM_FL_BLOCK_NOWAIT"},
+  {LDLM_FL_TEST_LOCK,           "LDLM_FL_TEST_LOCK"},
+  {LDLM_FL_CANCEL_ON_BLOCK,     "LDLM_FL_CANCEL_ON_BLOCK"},
+  {LDLM_FL_DENY_ON_CONTENTION,  "LDLM_FL_DENY_ON_CONTENTION"},
+  {LDLM_FL_AST_DISCARD_DATA,    "LDLM_FL_AST_DISCARD_DATA"},
+  {LDLM_FL_FAIL_LOC,            "LDLM_FL_FAIL_LOC"},
+  {LDLM_FL_SKIPPED,             "LDLM_FL_SKIPPED"},
+  {LDLM_FL_CBPENDING,           "LDLM_FL_CBPENDING"},
+  {LDLM_FL_WAIT_NOREPROC,       "LDLM_FL_WAIT_NOREPROC"},
+  {LDLM_FL_CANCEL,              "LDLM_FL_CANCEL"},
+  {LDLM_FL_LOCAL_ONLY,          "LDLM_FL_LOCAL_ONLY"},
+  {LDLM_FL_FAILED,              "LDLM_FL_FAILED"},
+  {LDLM_FL_CANCELING,           "LDLM_FL_CANCELING"},
+  {LDLM_FL_LOCAL,               "LDLM_FL_LOCAL"},
+  {LDLM_FL_LVB_READY,           "LDLM_FL_LVB_READY"},
+  {LDLM_FL_KMS_IGNORE,          "LDLM_FL_KMS_IGNORE"},
+  {LDLM_FL_CP_REQD,             "LDLM_FL_CP_REQD"},
+  {LDLM_FL_CLEANED,             "LDLM_FL_CLEANED"},
+  {LDLM_FL_ATOMIC_CB,           "LDLM_FL_ATOMIC_CB"},
+  {LDLM_FL_BL_AST,              "LDLM_FL_BL_AST"},
+  {LDLM_FL_BL_DONE,             "LDLM_FL_BL_DONE"},
+  {LDLM_FL_NO_LRU,              "LDLM_FL_NO_LRU"},
+  {LDLM_FL_FAIL_NOTIFIED,       "LDLM_FL_FAIL_NOTIFIED"},
+  {LDLM_FL_DESTROYED,           "LDLM_FL_DESTROYED"},
+  {LDLM_FL_SERVER_LOCK,         "LDLM_FL_SERVER_LOCK"},
+  {LDLM_FL_RES_LOCKED,          "LDLM_FL_RES_LOCKED"},
+  {LDLM_FL_WAITED,              "LDLM_FL_WAITED"},
+  {LDLM_FL_NS_SRV,              "LDLM_FL_NS_SRV"},
+  { 0, NULL }
+};
+#endif /*  WIRESHARK_COMPILE */
+#endif /* LDLM_ALL_FLAGS_MASK */
diff --git a/drivers/staging/lustre/lustre/ldlm/l_lock.c b/drivers/staging/lustre/lustre/ldlm/l_lock.c
index 853409a..32f4d52 100644
--- a/drivers/staging/lustre/lustre/ldlm/l_lock.c
+++ b/drivers/staging/lustre/lustre/ldlm/l_lock.c
@@ -51,12 +51,12 @@
 struct ldlm_resource *lock_res_and_lock(struct ldlm_lock *lock)
 {
 	/* on server-side resource of lock doesn't change */
-	if (!lock->l_ns_srv)
+	if ((lock->l_flags & LDLM_FL_NS_SRV) == 0)
 		spin_lock(&lock->l_lock);
 
 	lock_res(lock->l_resource);
 
-	lock->l_res_locked = 1;
+	lock->l_flags |= LDLM_FL_RES_LOCKED;
 	return lock->l_resource;
 }
 EXPORT_SYMBOL(lock_res_and_lock);
@@ -67,10 +67,10 @@ EXPORT_SYMBOL(lock_res_and_lock);
 void unlock_res_and_lock(struct ldlm_lock *lock)
 {
 	/* on server-side resource of lock doesn't change */
-	lock->l_res_locked = 0;
+	lock->l_flags &= ~LDLM_FL_RES_LOCKED;
 
 	unlock_res(lock->l_resource);
-	if (!lock->l_ns_srv)
+	if ((lock->l_flags & LDLM_FL_NS_SRV) == 0)
 		spin_unlock(&lock->l_lock);
 }
 EXPORT_SYMBOL(unlock_res_and_lock);
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c b/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
index f100a84..aca1073 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
@@ -639,7 +639,7 @@ ldlm_flock_completion_ast(struct ldlm_lock *lock, __u64 flags, void *data)
 granted:
 	OBD_FAIL_TIMEOUT(OBD_FAIL_LDLM_CP_CB_WAIT, 10);
 
-	if (lock->l_destroyed) {
+	if (lock->l_flags & LDLM_FL_DESTROYED) {
 		LDLM_DEBUG(lock, "client-side enqueue waking up: destroyed");
 		RETURN(0);
 	}
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
index 0b3ea88..c10ba9c 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lock.c
@@ -199,7 +199,7 @@ void ldlm_lock_put(struct ldlm_lock *lock)
 			   "final lock_put on destroyed lock, freeing it.");
 
 		res = lock->l_resource;
-		LASSERT(lock->l_destroyed);
+		LASSERT(lock->l_flags & LDLM_FL_DESTROYED);
 		LASSERT(list_empty(&lock->l_res_link));
 		LASSERT(list_empty(&lock->l_pending_chain));
 
@@ -254,7 +254,7 @@ int ldlm_lock_remove_from_lru(struct ldlm_lock *lock)
 	int rc;
 
 	ENTRY;
-	if (lock->l_ns_srv) {
+	if (lock->l_flags & LDLM_FL_NS_SRV) {
 		LASSERT(list_empty(&lock->l_lru));
 		RETURN(0);
 	}
@@ -305,7 +305,7 @@ void ldlm_lock_touch_in_lru(struct ldlm_lock *lock)
 	struct ldlm_namespace *ns = ldlm_lock_to_ns(lock);
 
 	ENTRY;
-	if (lock->l_ns_srv) {
+	if (lock->l_flags & LDLM_FL_NS_SRV) {
 		LASSERT(list_empty(&lock->l_lru));
 		EXIT;
 		return;
@@ -353,12 +353,12 @@ int ldlm_lock_destroy_internal(struct ldlm_lock *lock)
 		LBUG();
 	}
 
-	if (lock->l_destroyed) {
+	if (lock->l_flags & LDLM_FL_DESTROYED) {
 		LASSERT(list_empty(&lock->l_lru));
 		EXIT;
 		return 0;
 	}
-	lock->l_destroyed = 1;
+	lock->l_flags |= LDLM_FL_DESTROYED;
 
 	if (lock->l_export && lock->l_export->exp_lock_hash) {
 		/* NB: it's safe to call cfs_hash_del() even lock isn't
@@ -596,7 +596,7 @@ struct ldlm_lock *__ldlm_handle2lock(const struct lustre_handle *handle,
 
 	/* It's unlikely but possible that someone marked the lock as
 	 * destroyed after we did handle2object on it */
-	if (flags == 0 && !lock->l_destroyed) {
+	if (flags == 0 && ((lock->l_flags & LDLM_FL_DESTROYED)== 0)) {
 		lu_ref_add(&lock->l_reference, "handle", current);
 		RETURN(lock);
 	}
@@ -606,7 +606,7 @@ struct ldlm_lock *__ldlm_handle2lock(const struct lustre_handle *handle,
 	LASSERT(lock->l_resource != NULL);
 
 	lu_ref_add_atomic(&lock->l_reference, "handle", current);
-	if (unlikely(lock->l_destroyed)) {
+	if (unlikely(lock->l_flags & LDLM_FL_DESTROYED)) {
 		unlock_res_and_lock(lock);
 		CDEBUG(D_INFO, "lock already destroyed: lock %p\n", lock);
 		LDLM_LOCK_PUT(lock);
@@ -695,7 +695,7 @@ void ldlm_add_bl_work_item(struct ldlm_lock *lock, struct ldlm_lock *new,
 		lock->l_flags |= LDLM_FL_AST_SENT;
 		/* If the enqueuing client said so, tell the AST recipient to
 		 * discard dirty data, rather than writing back. */
-		if (new->l_flags & LDLM_AST_DISCARD_DATA)
+		if (new->l_flags & LDLM_FL_AST_DISCARD_DATA)
 			lock->l_flags |= LDLM_FL_DISCARD_DATA;
 		LASSERT(list_empty(&lock->l_bl_ast));
 		list_add(&lock->l_bl_ast, work_list);
@@ -873,7 +873,7 @@ void ldlm_lock_decref_internal(struct ldlm_lock *lock, __u32 mode)
 	    (lock->l_flags & LDLM_FL_CBPENDING)) {
 		/* If we received a blocked AST and this was the last reference,
 		 * run the callback. */
-		if (lock->l_ns_srv && lock->l_export)
+		if ((lock->l_flags & LDLM_FL_NS_SRV) && lock->l_export)
 			CERROR("FL_CBPENDING set on non-local lock--just a "
 			       "warning\n");
 
@@ -1069,7 +1069,7 @@ static void ldlm_granted_list_add_lock(struct ldlm_lock *lock,
 	ldlm_resource_dump(D_INFO, res);
 	LDLM_DEBUG(lock, "About to add lock:");
 
-	if (lock->l_destroyed) {
+	if (lock->l_flags & LDLM_FL_DESTROYED) {
 		CDEBUG(D_OTHER, "Lock destroyed, not adding to resource\n");
 		return;
 	}
@@ -1203,9 +1203,7 @@ static struct ldlm_lock *search_queue(struct list_head *queue,
 		      policy->l_inodebits.bits))
 			continue;
 
-		if (!unref &&
-		    (lock->l_destroyed || lock->l_flags & LDLM_FL_FAILED ||
-		     lock->l_failed))
+		if (!unref && (lock->l_flags & LDLM_FL_GONE_MASK))
 			continue;
 
 		if ((flags & LDLM_FL_LOCAL_ONLY) &&
@@ -1227,8 +1225,8 @@ static struct ldlm_lock *search_queue(struct list_head *queue,
 
 void ldlm_lock_fail_match_locked(struct ldlm_lock *lock)
 {
-	if (!lock->l_failed) {
-		lock->l_failed = 1;
+	if ((lock->l_flags & LDLM_FL_FAIL_NOTIFIED) == 0) {
+		lock->l_flags |= LDLM_FL_FAIL_NOTIFIED;
 		wake_up_all(&lock->l_waitq);
 	}
 }
@@ -1352,6 +1350,8 @@ ldlm_mode_t ldlm_lock_match(struct ldlm_namespace *ns, __u64 flags,
 		ldlm_lock2handle(lock, lockh);
 		if ((flags & LDLM_FL_LVB_READY) &&
 		    (!(lock->l_flags & LDLM_FL_LVB_READY))) {
+			__u64 wait_flags = LDLM_FL_LVB_READY |
+				LDLM_FL_DESTROYED | LDLM_FL_FAIL_NOTIFIED;
 			struct l_wait_info lwi;
 			if (lock->l_completion_ast) {
 				int err = lock->l_completion_ast(lock,
@@ -1373,8 +1373,7 @@ ldlm_mode_t ldlm_lock_match(struct ldlm_namespace *ns, __u64 flags,
 
 			/* XXX FIXME see comment on CAN_MATCH in lustre_dlm.h */
 			l_wait_event(lock->l_waitq,
-				     lock->l_flags & LDLM_FL_LVB_READY ||
-				     lock->l_destroyed || lock->l_failed,
+				     lock->l_flags & wait_flags,
 				     &lwi);
 			if (!(lock->l_flags & LDLM_FL_LVB_READY)) {
 				if (flags & LDLM_FL_TEST_LOCK)
@@ -1431,8 +1430,7 @@ ldlm_mode_t ldlm_revalidate_lock_handle(struct lustre_handle *lockh,
 	lock = ldlm_handle2lock(lockh);
 	if (lock != NULL) {
 		lock_res_and_lock(lock);
-		if (lock->l_destroyed || lock->l_flags & LDLM_FL_FAILED ||
-		    lock->l_failed)
+		if (lock->l_flags & LDLM_FL_GONE_MASK)
 			GOTO(out, mode);
 
 		if (lock->l_flags & LDLM_FL_CBPENDING &&
@@ -1583,12 +1581,12 @@ struct ldlm_lock *ldlm_lock_create(struct ldlm_namespace *ns,
 	lock->l_req_mode = mode;
 	lock->l_ast_data = data;
 	lock->l_pid = current_pid();
-	lock->l_ns_srv = !!ns_is_server(ns);
+	if (ns_is_server(ns))
+		lock->l_flags |= LDLM_FL_NS_SRV;
 	if (cbs) {
 		lock->l_blocking_ast = cbs->lcs_blocking;
 		lock->l_completion_ast = cbs->lcs_completion;
 		lock->l_glimpse_ast = cbs->lcs_glimpse;
-		lock->l_weigh_ast = cbs->lcs_weigh;
 	}
 
 	lock->l_tree_node = NULL;
@@ -1693,7 +1691,7 @@ ldlm_error_t ldlm_lock_enqueue(struct ldlm_namespace *ns,
 
 	/* Some flags from the enqueue want to make it into the AST, via the
 	 * lock's l_flags. */
-	lock->l_flags |= *flags & LDLM_AST_DISCARD_DATA;
+	lock->l_flags |= *flags & LDLM_FL_AST_DISCARD_DATA;
 
 	/* This distinction between local lock trees is very important; a client
 	 * namespace only has information about locks taken by that client, and
@@ -2046,15 +2044,15 @@ void ldlm_lock_cancel(struct ldlm_lock *lock)
 		LBUG();
 	}
 
-	if (lock->l_waited)
+	if (lock->l_flags & LDLM_FL_WAITED)
 		ldlm_del_waiting_lock(lock);
 
 	/* Releases cancel callback. */
 	ldlm_cancel_callback(lock);
 
 	/* Yes, second time, just in case it was added again while we were
-	   running with no res lock in ldlm_cancel_callback */
-	if (lock->l_waited)
+	 * running with no res lock in ldlm_cancel_callback */
+	if (lock->l_flags & LDLM_FL_WAITED)
 		ldlm_del_waiting_lock(lock);
 
 	ldlm_resource_unlink_lock(lock);
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c b/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c
index f79b244..d18936a 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_lockd.c
@@ -198,7 +198,7 @@ static void ldlm_handle_cp_callback(struct ptlrpc_request *req,
 			schedule_timeout_and_set_state(
 				TASK_INTERRUPTIBLE, to);
 			if (lock->l_granted_mode == lock->l_req_mode ||
-			    lock->l_destroyed)
+			    lock->l_flags & LDLM_FL_DESTROYED)
 				break;
 		}
 	}
@@ -238,7 +238,7 @@ static void ldlm_handle_cp_callback(struct ptlrpc_request *req,
 	}
 
 	lock_res_and_lock(lock);
-	if (lock->l_destroyed ||
+	if ((lock->l_flags & LDLM_FL_DESTROYED) ||
 	    lock->l_granted_mode == lock->l_req_mode) {
 		/* bug 11300: the lock has already been granted */
 		unlock_res_and_lock(lock);
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_request.c b/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
index ab41fea..c900706 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_request.c
@@ -160,7 +160,7 @@ static int ldlm_completion_tail(struct ldlm_lock *lock)
 	long delay;
 	int  result;
 
-	if (lock->l_destroyed || lock->l_flags & LDLM_FL_FAILED) {
+	if (lock->l_flags & (LDLM_FL_DESTROYED | LDLM_FL_FAILED)) {
 		LDLM_DEBUG(lock, "client-side enqueue: destroyed");
 		result = -EIO;
 	} else {
@@ -888,9 +888,8 @@ int ldlm_cli_enqueue(struct obd_export *exp, struct ptlrpc_request **reqp,
 	} else {
 		const struct ldlm_callback_suite cbs = {
 			.lcs_completion = einfo->ei_cb_cp,
-			.lcs_blocking   = einfo->ei_cb_bl,
-			.lcs_glimpse    = einfo->ei_cb_gl,
-			.lcs_weigh      = einfo->ei_cb_wg
+			.lcs_blocking	= einfo->ei_cb_bl,
+			.lcs_glimpse	= einfo->ei_cb_gl
 		};
 		lock = ldlm_lock_create(ns, res_id, einfo->ei_type,
 					einfo->ei_mode, &cbs, einfo->ei_cbdata,
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c b/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
index 17eab79..616cb17 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_resource.c
@@ -1283,7 +1283,7 @@ void ldlm_resource_add_lock(struct ldlm_resource *res, struct list_head *head,
 
 	LDLM_DEBUG(lock, "About to add this lock:\n");
 
-	if (lock->l_destroyed) {
+	if (lock->l_flags & LDLM_FL_DESTROYED) {
 		CDEBUG(D_OTHER, "Lock destroyed, not adding to resource\n");
 		return;
 	}
@@ -1308,7 +1308,7 @@ void ldlm_resource_insert_lock_after(struct ldlm_lock *original,
 	ldlm_resource_dump(D_INFO, res);
 	LDLM_DEBUG(new, "About to insert this lock after %p:\n", original);
 
-	if (new->l_destroyed) {
+	if (new->l_flags & LDLM_FL_DESTROYED) {
 		CDEBUG(D_OTHER, "Lock destroyed, not adding to resource\n");
 		goto out;
 	}
diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
index bfc914e..a94e463 100644
--- a/drivers/staging/lustre/lustre/llite/dir.c
+++ b/drivers/staging/lustre/lustre/llite/dir.c
@@ -356,15 +356,12 @@ struct page *ll_get_dir_page(struct inode *dir, __u64 hash,
 	rc = md_lock_match(ll_i2sbi(dir)->ll_md_exp, LDLM_FL_BLOCK_GRANTED,
 			   ll_inode2fid(dir), LDLM_IBITS, &policy, mode, &lockh);
 	if (!rc) {
-		struct ldlm_enqueue_info einfo = {.ei_type = LDLM_IBITS,
-						  .ei_mode = mode,
-						  .ei_cb_bl =
-						  ll_md_blocking_ast,
-						  .ei_cb_cp =
-						  ldlm_completion_ast,
-						  .ei_cb_gl = NULL,
-						  .ei_cb_wg = NULL,
-						  .ei_cbdata = NULL};
+		struct ldlm_enqueue_info einfo = {
+			.ei_type = LDLM_IBITS,
+			.ei_mode = mode,
+			.ei_cb_bl = ll_md_blocking_ast,
+			.ei_cb_cp = ldlm_completion_ast,
+		};
 		struct lookup_intent it = { .it_op = IT_READDIR };
 		struct ptlrpc_request *request;
 		struct md_op_data *op_data;
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 50ef6a5..d51f1ee 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -2290,9 +2290,11 @@ int ll_file_flock(struct file *file, int cmd, struct file_lock *file_lock)
 {
 	struct inode *inode = file->f_dentry->d_inode;
 	struct ll_sb_info *sbi = ll_i2sbi(inode);
-	struct ldlm_enqueue_info einfo = { .ei_type = LDLM_FLOCK,
-					   .ei_cb_cp =ldlm_flock_completion_ast,
-					   .ei_cbdata = file_lock };
+	struct ldlm_enqueue_info einfo = {
+		.ei_type	= LDLM_FLOCK,
+		.ei_cb_cp	= ldlm_flock_completion_ast,
+		.ei_cbdata	= file_lock,
+	};
 	struct md_op_data *op_data;
 	struct lustre_handle lockh = {0};
 	ldlm_policy_data_t flock = {{0}};
@@ -3116,11 +3118,12 @@ int ll_layout_refresh(struct inode *inode, __u32 *gen)
 	struct lookup_intent   it;
 	struct lustre_handle   lockh;
 	ldlm_mode_t	       mode;
-	struct ldlm_enqueue_info einfo = { .ei_type = LDLM_IBITS,
-					   .ei_mode = LCK_CR,
-					   .ei_cb_bl = ll_md_blocking_ast,
-					   .ei_cb_cp = ldlm_completion_ast,
-					   .ei_cbdata = NULL };
+	struct ldlm_enqueue_info einfo = {
+		.ei_type = LDLM_IBITS,
+		.ei_mode = LCK_CR,
+		.ei_cb_bl = ll_md_blocking_ast,
+		.ei_cb_cp = ldlm_completion_ast,
+	};
 	int rc;
 	ENTRY;
 
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
index 9532134..ab88a46 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
@@ -1102,9 +1102,12 @@ int mdc_intent_lock(struct obd_export *exp, struct md_op_data *op_data,
 	 * this and use the request from revalidate.  In this case, revalidate
 	 * never dropped its reference, so the refcounts are all OK */
 	if (!it_disposition(it, DISP_ENQ_COMPLETE)) {
-		struct ldlm_enqueue_info einfo =
-			{ LDLM_IBITS, it_to_lock_mode(it), cb_blocking,
-			  ldlm_completion_ast, NULL, NULL, NULL };
+		struct ldlm_enqueue_info einfo = {
+			.ei_type	= LDLM_IBITS,
+			.ei_mode	= it_to_lock_mode(it),
+			.ei_cb_bl	= cb_blocking,
+			.ei_cb_cp	= ldlm_completion_ast,
+		};
 
 		/* For case if upper layer did not alloc fid, do it now. */
 		if (!fid_is_sane(&op_data->op_fid2) && it->it_op & IT_CREAT) {
diff --git a/drivers/staging/lustre/lustre/mgc/mgc_request.c b/drivers/staging/lustre/lustre/mgc/mgc_request.c
index c6c84d9..5167767 100644
--- a/drivers/staging/lustre/lustre/mgc/mgc_request.c
+++ b/drivers/staging/lustre/lustre/mgc/mgc_request.c
@@ -900,8 +900,12 @@ static int mgc_enqueue(struct obd_export *exp, struct lov_stripe_md *lsm,
 		       struct lustre_handle *lockh)
 {
 	struct config_llog_data *cld = (struct config_llog_data *)data;
-	struct ldlm_enqueue_info einfo = { type, mode, mgc_blocking_ast,
-			 ldlm_completion_ast, NULL, NULL, NULL };
+	struct ldlm_enqueue_info einfo = {
+		.ei_type	= type,
+		.ei_mode	= mode,
+		.ei_cb_bl	= mgc_blocking_ast,
+		.ei_cb_cp	= ldlm_completion_ast,
+	};
 	struct ptlrpc_request *req;
 	int short_limit = cld_is_sptlrpc(cld);
 	int rc;
diff --git a/drivers/staging/lustre/lustre/osc/osc_lock.c b/drivers/staging/lustre/lustre/osc/osc_lock.c
index 640bc3d..98478d2 100644
--- a/drivers/staging/lustre/lustre/osc/osc_lock.c
+++ b/drivers/staging/lustre/lustre/osc/osc_lock.c
@@ -89,35 +89,49 @@ static struct ldlm_lock *osc_handle_ptr(struct lustre_handle *handle)
  */
 static int osc_lock_invariant(struct osc_lock *ols)
 {
-	struct ldlm_lock *lock	= osc_handle_ptr(&ols->ols_handle);
-	struct ldlm_lock *olock       = ols->ols_lock;
-	int	       handle_used = lustre_handle_is_used(&ols->ols_handle);
-
-	return
-		ergo(osc_lock_is_lockless(ols),
-		     ols->ols_locklessable && ols->ols_lock == NULL)  ||
-		(ergo(olock != NULL, handle_used) &&
-		 ergo(olock != NULL,
-		      olock->l_handle.h_cookie == ols->ols_handle.cookie) &&
-		 /*
-		  * Check that ->ols_handle and ->ols_lock are consistent, but
-		  * take into account that they are set at the different time.
-		  */
-		 ergo(handle_used,
-		      ergo(lock != NULL && olock != NULL, lock == olock) &&
-		      ergo(lock == NULL, olock == NULL)) &&
-		 ergo(ols->ols_state == OLS_CANCELLED,
-		      olock == NULL && !handle_used) &&
-		 /*
-		  * DLM lock is destroyed only after we have seen cancellation
-		  * ast.
-		  */
-		 ergo(olock != NULL && ols->ols_state < OLS_CANCELLED,
-		      !olock->l_destroyed) &&
-		 ergo(ols->ols_state == OLS_GRANTED,
-		      olock != NULL &&
-		      olock->l_req_mode == olock->l_granted_mode &&
-		      ols->ols_hold));
+	struct ldlm_lock *lock	      = osc_handle_ptr(&ols->ols_handle);
+	struct ldlm_lock *olock	      = ols->ols_lock;
+	int		  handle_used = lustre_handle_is_used(&ols->ols_handle);
+
+	if (ergo(osc_lock_is_lockless(ols),
+		 ols->ols_locklessable && ols->ols_lock == NULL))
+		return 1;
+
+	/*
+	 * If all the following "ergo"s are true, return 1, otherwise 0
+	 */
+	if (! ergo(olock != NULL, handle_used))
+		return 0;
+
+	if (! ergo(olock != NULL,
+		   olock->l_handle.h_cookie == ols->ols_handle.cookie))
+		return 0;
+
+	if (! ergo(handle_used,
+		   ergo(lock != NULL && olock != NULL, lock == olock) &&
+		   ergo(lock == NULL, olock == NULL)))
+		return 0;
+	/*
+	 * Check that ->ols_handle and ->ols_lock are consistent, but
+	 * take into account that they are set at the different time.
+	 */
+	if (! ergo(ols->ols_state == OLS_CANCELLED,
+		   olock == NULL && !handle_used))
+		return 0;
+	/*
+	 * DLM lock is destroyed only after we have seen cancellation
+	 * ast.
+	 */
+	if (! ergo(olock != NULL && ols->ols_state < OLS_CANCELLED,
+		   ((olock->l_flags & LDLM_FL_DESTROYED) == 0)))
+		return 0;
+
+	if (! ergo(ols->ols_state == OLS_GRANTED,
+		   olock != NULL &&
+		   olock->l_req_mode == olock->l_granted_mode &&
+		   ols->ols_hold))
+		return 0;
+	return 1;
 }
 
 /*****************************************************************************
@@ -261,7 +275,7 @@ static __u64 osc_enq2ldlm_flags(__u32 enqflags)
 	if (enqflags & CEF_ASYNC)
 		result |= LDLM_FL_HAS_INTENT;
 	if (enqflags & CEF_DISCARD_DATA)
-		result |= LDLM_AST_DISCARD_DATA;
+		result |= LDLM_FL_AST_DISCARD_DATA;
 	return result;
 }
 
@@ -896,55 +910,6 @@ static unsigned long osc_lock_weigh(const struct lu_env *env,
 	return cl_object_header(slice->cls_obj)->coh_pages;
 }
 
-/**
- * Get the weight of dlm lock for early cancellation.
- *
- * XXX: it should return the pages covered by this \a dlmlock.
- */
-static unsigned long osc_ldlm_weigh_ast(struct ldlm_lock *dlmlock)
-{
-	struct cl_env_nest       nest;
-	struct lu_env	   *env;
-	struct osc_lock	 *lock;
-	struct cl_lock	  *cll;
-	unsigned long	    weight;
-	ENTRY;
-
-	might_sleep();
-	/*
-	 * osc_ldlm_weigh_ast has a complex context since it might be called
-	 * because of lock canceling, or from user's input. We have to make
-	 * a new environment for it. Probably it is implementation safe to use
-	 * the upper context because cl_lock_put don't modify environment
-	 * variables. But in case of ..
-	 */
-	env = cl_env_nested_get(&nest);
-	if (IS_ERR(env))
-		/* Mostly because lack of memory, tend to eliminate this lock*/
-		RETURN(0);
-
-	LASSERT(dlmlock->l_resource->lr_type == LDLM_EXTENT);
-	lock = osc_ast_data_get(dlmlock);
-	if (lock == NULL) {
-		/* cl_lock was destroyed because of memory pressure.
-		 * It is much reasonable to assign this type of lock
-		 * a lower cost.
-		 */
-		GOTO(out, weight = 0);
-	}
-
-	cll = lock->ols_cl.cls_lock;
-	cl_lock_mutex_get(env, cll);
-	weight = cl_lock_weigh(env, cll);
-	cl_lock_mutex_put(env, cll);
-	osc_ast_data_put(env, lock);
-	EXIT;
-
-out:
-	cl_env_nested_put(&nest, env);
-	return weight;
-}
-
 static void osc_lock_build_einfo(const struct lu_env *env,
 				 const struct cl_lock *clock,
 				 struct osc_lock *lock,
@@ -966,7 +931,6 @@ static void osc_lock_build_einfo(const struct lu_env *env,
 	einfo->ei_cb_bl  = osc_ldlm_blocking_ast;
 	einfo->ei_cb_cp  = osc_ldlm_completion_ast;
 	einfo->ei_cb_gl  = osc_ldlm_glimpse_ast;
-	einfo->ei_cb_wg  = osc_ldlm_weigh_ast;
 	einfo->ei_cbdata = lock; /* value to be put into ->l_ast_data */
 }
 
-- 
1.7.9.5

