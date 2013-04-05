Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161801Ab3DEKYE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 06:24:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062Ab3DEKYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 06:24:00 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: David Teigland <teigland@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/6] GFS2: use kmalloc for lvb bitmap
Date: Fri,  5 Apr 2013 10:57:11 +0100
Message-Id: <1365155836-3069-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1365155836-3069-1-git-send-email-swhiteho@redhat.com>
References: <1365155836-3069-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Teigland <teigland@redhat.com>

The temp lvb bitmap was on the stack, which could
be an alignment problem for __set_bit_le.  Use
kmalloc for it instead.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 156e42e..5c29216 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -588,6 +588,7 @@ struct lm_lockstruct {
 	struct dlm_lksb ls_control_lksb; /* control_lock */
 	char ls_control_lvb[GDLM_LVB_SIZE]; /* control_lock lvb */
 	struct completion ls_sync_wait; /* {control,mounted}_{lock,unlock} */
+	char *ls_lvb_bits;
 
 	spinlock_t ls_recover_spin; /* protects following fields */
 	unsigned long ls_recover_flags; /* DFL_ */
diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index 9802de0..b15bb45 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -580,7 +580,6 @@ static void gfs2_control_func(struct work_struct *work)
 {
 	struct gfs2_sbd *sdp = container_of(work, struct gfs2_sbd, sd_control_work.work);
 	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
-	char lvb_bits[GDLM_LVB_SIZE];
 	uint32_t block_gen, start_gen, lvb_gen, flags;
 	int recover_set = 0;
 	int write_lvb = 0;
@@ -634,7 +633,7 @@ static void gfs2_control_func(struct work_struct *work)
 		return;
 	}
 
-	control_lvb_read(ls, &lvb_gen, lvb_bits);
+	control_lvb_read(ls, &lvb_gen, ls->ls_lvb_bits);
 
 	spin_lock(&ls->ls_recover_spin);
 	if (block_gen != ls->ls_recover_block ||
@@ -664,10 +663,10 @@ static void gfs2_control_func(struct work_struct *work)
 
 			ls->ls_recover_result[i] = 0;
 
-			if (!test_bit_le(i, lvb_bits + JID_BITMAP_OFFSET))
+			if (!test_bit_le(i, ls->ls_lvb_bits + JID_BITMAP_OFFSET))
 				continue;
 
-			__clear_bit_le(i, lvb_bits + JID_BITMAP_OFFSET);
+			__clear_bit_le(i, ls->ls_lvb_bits + JID_BITMAP_OFFSET);
 			write_lvb = 1;
 		}
 	}
@@ -691,7 +690,7 @@ static void gfs2_control_func(struct work_struct *work)
 				continue;
 			if (ls->ls_recover_submit[i] < start_gen) {
 				ls->ls_recover_submit[i] = 0;
-				__set_bit_le(i, lvb_bits + JID_BITMAP_OFFSET);
+				__set_bit_le(i, ls->ls_lvb_bits + JID_BITMAP_OFFSET);
 			}
 		}
 		/* even if there are no bits to set, we need to write the
@@ -705,7 +704,7 @@ static void gfs2_control_func(struct work_struct *work)
 	spin_unlock(&ls->ls_recover_spin);
 
 	if (write_lvb) {
-		control_lvb_write(ls, start_gen, lvb_bits);
+		control_lvb_write(ls, start_gen, ls->ls_lvb_bits);
 		flags = DLM_LKF_CONVERT | DLM_LKF_VALBLK;
 	} else {
 		flags = DLM_LKF_CONVERT;
@@ -725,7 +724,7 @@ static void gfs2_control_func(struct work_struct *work)
 	 */
 
 	for (i = 0; i < recover_size; i++) {
-		if (test_bit_le(i, lvb_bits + JID_BITMAP_OFFSET)) {
+		if (test_bit_le(i, ls->ls_lvb_bits + JID_BITMAP_OFFSET)) {
 			fs_info(sdp, "recover generation %u jid %d\n",
 				start_gen, i);
 			gfs2_recover_set(sdp, i);
@@ -758,7 +757,6 @@ static void gfs2_control_func(struct work_struct *work)
 static int control_mount(struct gfs2_sbd *sdp)
 {
 	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
-	char lvb_bits[GDLM_LVB_SIZE];
 	uint32_t start_gen, block_gen, mount_gen, lvb_gen;
 	int mounted_mode;
 	int retries = 0;
@@ -857,7 +855,7 @@ locks_done:
 	 * lvb_gen will be non-zero.
 	 */
 
-	control_lvb_read(ls, &lvb_gen, lvb_bits);
+	control_lvb_read(ls, &lvb_gen, ls->ls_lvb_bits);
 
 	if (lvb_gen == 0xFFFFFFFF) {
 		/* special value to force mount attempts to fail */
@@ -887,7 +885,7 @@ locks_done:
 	 * and all lvb bits to be clear (no pending journal recoveries.)
 	 */
 
-	if (!all_jid_bits_clear(lvb_bits)) {
+	if (!all_jid_bits_clear(ls->ls_lvb_bits)) {
 		/* journals need recovery, wait until all are clear */
 		fs_info(sdp, "control_mount wait for journal recovery\n");
 		goto restart;
@@ -949,7 +947,6 @@ static int dlm_recovery_wait(void *word)
 static int control_first_done(struct gfs2_sbd *sdp)
 {
 	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
-	char lvb_bits[GDLM_LVB_SIZE];
 	uint32_t start_gen, block_gen;
 	int error;
 
@@ -991,8 +988,8 @@ restart:
 	memset(ls->ls_recover_result, 0, ls->ls_recover_size*sizeof(uint32_t));
 	spin_unlock(&ls->ls_recover_spin);
 
-	memset(lvb_bits, 0, sizeof(lvb_bits));
-	control_lvb_write(ls, start_gen, lvb_bits);
+	memset(ls->ls_lvb_bits, 0, GDLM_LVB_SIZE);
+	control_lvb_write(ls, start_gen, ls->ls_lvb_bits);
 
 	error = mounted_lock(sdp, DLM_LOCK_PR, DLM_LKF_CONVERT);
 	if (error)
@@ -1022,6 +1019,12 @@ static int set_recover_size(struct gfs2_sbd *sdp, struct dlm_slot *slots,
 	uint32_t old_size, new_size;
 	int i, max_jid;
 
+	if (!ls->ls_lvb_bits) {
+		ls->ls_lvb_bits = kzalloc(GDLM_LVB_SIZE, GFP_NOFS);
+		if (!ls->ls_lvb_bits)
+			return -ENOMEM;
+	}
+
 	max_jid = 0;
 	for (i = 0; i < num_slots; i++) {
 		if (max_jid < slots[i].slot - 1)
@@ -1057,6 +1060,7 @@ static int set_recover_size(struct gfs2_sbd *sdp, struct dlm_slot *slots,
 
 static void free_recover_size(struct lm_lockstruct *ls)
 {
+	kfree(ls->ls_lvb_bits);
 	kfree(ls->ls_recover_submit);
 	kfree(ls->ls_recover_result);
 	ls->ls_recover_submit = NULL;
@@ -1205,6 +1209,7 @@ static int gdlm_mount(struct gfs2_sbd *sdp, const char *table)
 	ls->ls_recover_size = 0;
 	ls->ls_recover_submit = NULL;
 	ls->ls_recover_result = NULL;
+	ls->ls_lvb_bits = NULL;
 
 	error = set_recover_size(sdp, NULL, 0);
 	if (error)
-- 
1.7.4

