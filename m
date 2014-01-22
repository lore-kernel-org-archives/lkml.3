Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbaAVNiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 08:38:14 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:37113 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734AbaAVNiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 08:38:09 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH v2 RESEND 8/8] staging/lustre/ptlrpc: flock deadlock detection does not work
Date: Wed, 22 Jan 2014 21:36:19 +0800
Message-Id: <1390397779-30975-9-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1390397779-30975-1-git-send-email-bergwolf@gmail.com>
References: <1390397779-30975-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andriy Skulysh <Andriy_Skulysh@xyratex.com>

Flock deadlocks are checked on the first attempt to grant
the flock only. If we try again to grant it after its
blocking lock is cancelled, we don't check for deadlocks
which also may exist.

Perform deadlock detection during reprocess

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-1715
Lustre-change: http://review.whamcloud.com/3553
Signed-off-by: Andriy Skulysh <Andriy_Skulysh@xyratex.com>
Reviewed-by: Vitaly Fertman <vitaly_fertman@xyratex.com>
Reviewed-by: Bruce Korb <bruce_korb@xyratex.com>
Reviewed-by: Keith Mannthey <keith.mannthey@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/include/lustre/lustre_idl.h      |    5 ++-
 .../lustre/lustre/include/lustre_dlm_flags.h       |   14 +++++--
 drivers/staging/lustre/lustre/ldlm/ldlm_flock.c    |   41 ++++++++++++++++++--
 drivers/staging/lustre/lustre/llite/llite_lib.c    |    4 +-
 .../lustre/lustre/obdclass/lprocfs_status.c        |    1 +
 drivers/staging/lustre/lustre/ptlrpc/wiretest.c    |    2 +
 6 files changed, 58 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
index ac7fb37..05c77c0 100644
--- a/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
+++ b/drivers/staging/lustre/lustre/include/lustre/lustre_idl.h
@@ -1304,6 +1304,8 @@ extern void lustre_swab_ptlrpc_body(struct ptlrpc_body *pb);
 #define OBD_CONNECT_LIGHTWEIGHT 0x1000000000000ULL/* lightweight connection */
 #define OBD_CONNECT_SHORTIO     0x2000000000000ULL/* short io */
 #define OBD_CONNECT_PINGLESS	0x4000000000000ULL/* pings not required */
+#define OBD_CONNECT_FLOCK_DEAD	0x8000000000000ULL/* flock deadlock detection */
+
 /* XXX README XXX:
  * Please DO NOT add flag values here before first ensuring that this same
  * flag value is not in use on some other branch.  Please clear any such
@@ -1341,7 +1343,8 @@ extern void lustre_swab_ptlrpc_body(struct ptlrpc_body *pb);
 				OBD_CONNECT_EINPROGRESS | \
 				OBD_CONNECT_LIGHTWEIGHT | OBD_CONNECT_UMASK | \
 				OBD_CONNECT_LVB_TYPE | OBD_CONNECT_LAYOUTLOCK |\
-				OBD_CONNECT_PINGLESS | OBD_CONNECT_MAX_EASIZE)
+				OBD_CONNECT_PINGLESS | OBD_CONNECT_MAX_EASIZE |\
+				OBD_CONNECT_FLOCK_DEAD)
 #define OST_CONNECT_SUPPORTED  (OBD_CONNECT_SRVLOCK | OBD_CONNECT_GRANT | \
 				OBD_CONNECT_REQPORTAL | OBD_CONNECT_VERSION | \
 				OBD_CONNECT_TRUNCLOCK | OBD_CONNECT_INDEX | \
diff --git a/drivers/staging/lustre/lustre/include/lustre_dlm_flags.h b/drivers/staging/lustre/lustre/include/lustre_dlm_flags.h
index 75716f1..73fb38e 100644
--- a/drivers/staging/lustre/lustre/include/lustre_dlm_flags.h
+++ b/drivers/staging/lustre/lustre/include/lustre_dlm_flags.h
@@ -35,10 +35,10 @@
 #ifndef LDLM_ALL_FLAGS_MASK
 
 /** l_flags bits marked as "all_flags" bits */
-#define LDLM_FL_ALL_FLAGS_MASK          0x00FFFFFFC08F132FULL
+#define LDLM_FL_ALL_FLAGS_MASK          0x00FFFFFFC08F932FULL
 
 /** l_flags bits marked as "ast" bits */
-#define LDLM_FL_AST_MASK                0x0000000080000000ULL
+#define LDLM_FL_AST_MASK                0x0000000080008000ULL
 
 /** l_flags bits marked as "blocked" bits */
 #define LDLM_FL_BLOCKED_MASK            0x000000000000000EULL
@@ -56,7 +56,7 @@
 #define LDLM_FL_LOCAL_ONLY_MASK         0x00FFFFFF00000000ULL
 
 /** l_flags bits marked as "on_wire" bits */
-#define LDLM_FL_ON_WIRE_MASK            0x00000000C08F132FULL
+#define LDLM_FL_ON_WIRE_MASK            0x00000000C08F932FULL
 
 /** extent, mode, or resource changed */
 #define LDLM_FL_LOCK_CHANGED            0x0000000000000001ULL // bit   0
@@ -114,6 +114,12 @@
 #define ldlm_set_has_intent(_l)         LDLM_SET_FLAG((  _l), 1ULL << 12)
 #define ldlm_clear_has_intent(_l)       LDLM_CLEAR_FLAG((_l), 1ULL << 12)
 
+/** flock deadlock detected */
+#define LDLM_FL_FLOCK_DEADLOCK          0x0000000000008000ULL /* bit  15 */
+#define ldlm_is_flock_deadlock(_l)      LDLM_TEST_FLAG((_l), 1ULL << 15)
+#define ldlm_set_flock_deadlock(_l)     LDLM_SET_FLAG((_l), 1ULL << 15)
+#define ldlm_clear_flock_deadlock(_l)   LDLM_CLEAR_FLAG((_l), 1ULL << 15)
+
 /** discard (no writeback) on cancel */
 #define LDLM_FL_DISCARD_DATA            0x0000000000010000ULL // bit  16
 #define ldlm_is_discard_data(_l)        LDLM_TEST_FLAG(( _l), 1ULL << 16)
@@ -390,6 +396,7 @@ static int hf_lustre_ldlm_fl_ast_sent            = -1;
 static int hf_lustre_ldlm_fl_replay              = -1;
 static int hf_lustre_ldlm_fl_intent_only         = -1;
 static int hf_lustre_ldlm_fl_has_intent          = -1;
+static int hf_lustre_ldlm_fl_flock_deadlock      = -1;
 static int hf_lustre_ldlm_fl_discard_data        = -1;
 static int hf_lustre_ldlm_fl_no_timeout          = -1;
 static int hf_lustre_ldlm_fl_block_nowait        = -1;
@@ -431,6 +438,7 @@ const value_string lustre_ldlm_flags_vals[] = {
 	{LDLM_FL_REPLAY,              "LDLM_FL_REPLAY"},
 	{LDLM_FL_INTENT_ONLY,         "LDLM_FL_INTENT_ONLY"},
 	{LDLM_FL_HAS_INTENT,          "LDLM_FL_HAS_INTENT"},
+	{LDLM_FL_FLOCK_DEADLOCK,      "LDLM_FL_FLOCK_DEADLOCK"},
 	{LDLM_FL_DISCARD_DATA,        "LDLM_FL_DISCARD_DATA"},
 	{LDLM_FL_NO_TIMEOUT,          "LDLM_FL_NO_TIMEOUT"},
 	{LDLM_FL_BLOCK_NOWAIT,        "LDLM_FL_BLOCK_NOWAIT"},
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c b/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
index c9aae13..986bf38 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
@@ -205,6 +205,26 @@ ldlm_flock_deadlock(struct ldlm_lock *req, struct ldlm_lock *bl_lock)
 	return 0;
 }
 
+static void ldlm_flock_cancel_on_deadlock(struct ldlm_lock *lock,
+					  struct list_head *work_list)
+{
+	CDEBUG(D_INFO, "reprocess deadlock req=%p\n", lock);
+
+	if ((exp_connect_flags(lock->l_export) &
+				OBD_CONNECT_FLOCK_DEAD) == 0) {
+		CERROR(
+		      "deadlock found, but client doesn't support flock canceliation\n");
+	} else {
+		LASSERT(lock->l_completion_ast);
+		LASSERT((lock->l_flags & LDLM_FL_AST_SENT) == 0);
+		lock->l_flags |= LDLM_FL_AST_SENT | LDLM_FL_CANCEL_ON_BLOCK |
+			LDLM_FL_FLOCK_DEADLOCK;
+		ldlm_flock_blocking_unlink(lock);
+		ldlm_resource_unlink_lock(lock);
+		ldlm_add_ast_work_item(lock, NULL, work_list);
+	}
+}
+
 /**
  * Process a granting attempt for flock lock.
  * Must be called under ns lock held.
@@ -272,6 +292,7 @@ reprocess:
 			}
 		}
 	} else {
+		int reprocess_failed = 0;
 		lockmode_verify(mode);
 
 		/* This loop determines if there are existing locks
@@ -293,8 +314,15 @@ reprocess:
 			if (!ldlm_flocks_overlap(lock, req))
 				continue;
 
-			if (!first_enq)
-				return LDLM_ITER_CONTINUE;
+			if (!first_enq) {
+				reprocess_failed = 1;
+				if (ldlm_flock_deadlock(req, lock)) {
+					ldlm_flock_cancel_on_deadlock(req,
+							work_list);
+					return LDLM_ITER_CONTINUE;
+				}
+				continue;
+			}
 
 			if (*flags & LDLM_FL_BLOCK_NOWAIT) {
 				ldlm_flock_destroy(req, mode, *flags);
@@ -330,6 +358,8 @@ reprocess:
 			*flags |= LDLM_FL_BLOCK_GRANTED;
 			return LDLM_ITER_STOP;
 		}
+		if (reprocess_failed)
+			return LDLM_ITER_CONTINUE;
 	}
 
 	if (*flags & LDLM_FL_TEST_LOCK) {
@@ -646,7 +676,10 @@ granted:
 	/* ldlm_lock_enqueue() has already placed lock on the granted list. */
 	list_del_init(&lock->l_res_link);
 
-	if (flags & LDLM_FL_TEST_LOCK) {
+	if (lock->l_flags & LDLM_FL_FLOCK_DEADLOCK) {
+		LDLM_DEBUG(lock, "client-side enqueue deadlock received");
+		rc = -EDEADLK;
+	} else if (flags & LDLM_FL_TEST_LOCK) {
 		/* fcntl(F_GETLK) request */
 		/* The old mode was saved in getlk->fl_type so that if the mode
 		 * in the lock changes we can decref the appropriate refcount.*/
@@ -672,7 +705,7 @@ granted:
 		ldlm_process_flock_lock(lock, &noreproc, 1, &err, NULL);
 	}
 	unlock_res_and_lock(lock);
-	return 0;
+	return rc;
 }
 EXPORT_SYMBOL(ldlm_flock_completion_ast);
 
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index 3e4c292..b0b6941 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -206,7 +206,9 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 				  OBD_CONNECT_EINPROGRESS |
 				  OBD_CONNECT_JOBSTATS | OBD_CONNECT_LVB_TYPE |
 				  OBD_CONNECT_LAYOUTLOCK |
-				  OBD_CONNECT_PINGLESS | OBD_CONNECT_MAX_EASIZE;
+				  OBD_CONNECT_PINGLESS |
+				  OBD_CONNECT_MAX_EASIZE |
+				  OBD_CONNECT_FLOCK_DEAD;
 
 	if (sbi->ll_flags & LL_SBI_SOM_PREVIEW)
 		data->ocd_connect_flags |= OBD_CONNECT_SOM;
diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
index ec3b605..6e7d2e5 100644
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
@@ -98,6 +98,7 @@ static const char * const obd_connect_names[] = {
 	"lightweight_conn",
 	"short_io",
 	"pingless",
+	"flock_deadlock",
 	"unknown",
 	NULL
 };
diff --git a/drivers/staging/lustre/lustre/ptlrpc/wiretest.c b/drivers/staging/lustre/lustre/ptlrpc/wiretest.c
index 3aa4459..3c88460 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/wiretest.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/wiretest.c
@@ -1152,6 +1152,8 @@ void lustre_assert_wire_constants(void)
 		 OBD_CONNECT_SHORTIO);
 	LASSERTF(OBD_CONNECT_PINGLESS == 0x4000000000000ULL, "found 0x%.16llxULL\n",
 		 OBD_CONNECT_PINGLESS);
+	LASSERTF(OBD_CONNECT_FLOCK_DEAD == 0x8000000000000ULL,
+		 "found 0x%.16llxULL\n", OBD_CONNECT_FLOCK_DEAD);
 	LASSERTF(OBD_CKSUM_CRC32 == 0x00000001UL, "found 0x%.8xUL\n",
 		(unsigned)OBD_CKSUM_CRC32);
 	LASSERTF(OBD_CKSUM_ADLER == 0x00000002UL, "found 0x%.8xUL\n",
-- 
1.7.9.5

