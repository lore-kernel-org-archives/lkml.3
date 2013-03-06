Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab3CFNaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 08:30:19 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:43971 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649Ab3CFNaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 08:30:15 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>
Subject: [PATCH -v2] gfs2: fix bitmap declaration
Date: Wed,  6 Mar 2013 22:29:57 +0900
Message-Id: <1362576597-18501-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bitmap accessed by bitops like set_bit_le and clear_bit_le must
be aligned to the size of an "unsigned long".  But there are bitmaps
that are declared as char array.

This converts these bitmaps to properly declared ones.  And this also
changes the unit of the local macro JID_BITMAP_OFFSET from bytes to bits
in order to reduce the conversion of the unit.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com
Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: David Teigland <teigland@redhat.com>
---
* Change from v1
- fix wrong offsets caused by the change of type of the 'lvb_bits'
  (detected by kbuild test)

 fs/gfs2/lock_dlm.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index 9802de0..4180269 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -461,10 +461,11 @@ static void gdlm_cancel(struct gfs2_glock *gl)
  * that jid N needs recovery.
  */
 
-#define JID_BITMAP_OFFSET 8 /* 4 byte generation number + 4 byte unused */
+/* 4 byte generation number + 4 byte unused */
+#define JID_BITMAP_OFFSET (8 * BITS_PER_BYTE)
 
 static void control_lvb_read(struct lm_lockstruct *ls, uint32_t *lvb_gen,
-			     char *lvb_bits)
+			     void *lvb_bits)
 {
 	uint32_t gen;
 	memcpy(lvb_bits, ls->ls_control_lvb, GDLM_LVB_SIZE);
@@ -473,7 +474,7 @@ static void control_lvb_read(struct lm_lockstruct *ls, uint32_t *lvb_gen,
 }
 
 static void control_lvb_write(struct lm_lockstruct *ls, uint32_t lvb_gen,
-			      char *lvb_bits)
+			      void *lvb_bits)
 {
 	uint32_t gen;
 	memcpy(ls->ls_control_lvb, lvb_bits, GDLM_LVB_SIZE);
@@ -481,13 +482,14 @@ static void control_lvb_write(struct lm_lockstruct *ls, uint32_t lvb_gen,
 	memcpy(ls->ls_control_lvb, &gen, sizeof(uint32_t));
 }
 
-static int all_jid_bits_clear(char *lvb)
+static int all_jid_bits_clear(void *lvb)
 {
-	int i;
-	for (i = JID_BITMAP_OFFSET; i < GDLM_LVB_SIZE; i++) {
-		if (lvb[i])
-			return 0;
-	}
+	unsigned long next_bit = find_next_bit_le(lvb,
+			GDLM_LVB_SIZE * BITS_PER_BYTE, JID_BITMAP_OFFSET);
+
+	if (next_bit < GDLM_LVB_SIZE * BITS_PER_BYTE)
+		return 0;
+
 	return 1;
 }
 
@@ -580,7 +582,7 @@ static void gfs2_control_func(struct work_struct *work)
 {
 	struct gfs2_sbd *sdp = container_of(work, struct gfs2_sbd, sd_control_work.work);
 	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
-	char lvb_bits[GDLM_LVB_SIZE];
+	DECLARE_BITMAP(lvb_bits, GDLM_LVB_SIZE * BITS_PER_BYTE);
 	uint32_t block_gen, start_gen, lvb_gen, flags;
 	int recover_set = 0;
 	int write_lvb = 0;
@@ -664,10 +666,10 @@ static void gfs2_control_func(struct work_struct *work)
 
 			ls->ls_recover_result[i] = 0;
 
-			if (!test_bit_le(i, lvb_bits + JID_BITMAP_OFFSET))
+			if (!test_bit_le(JID_BITMAP_OFFSET + i, lvb_bits))
 				continue;
 
-			__clear_bit_le(i, lvb_bits + JID_BITMAP_OFFSET);
+			__clear_bit_le(JID_BITMAP_OFFSET + i, lvb_bits);
 			write_lvb = 1;
 		}
 	}
@@ -691,7 +693,7 @@ static void gfs2_control_func(struct work_struct *work)
 				continue;
 			if (ls->ls_recover_submit[i] < start_gen) {
 				ls->ls_recover_submit[i] = 0;
-				__set_bit_le(i, lvb_bits + JID_BITMAP_OFFSET);
+				__set_bit_le(JID_BITMAP_OFFSET + i, lvb_bits);
 			}
 		}
 		/* even if there are no bits to set, we need to write the
@@ -725,7 +727,7 @@ static void gfs2_control_func(struct work_struct *work)
 	 */
 
 	for (i = 0; i < recover_size; i++) {
-		if (test_bit_le(i, lvb_bits + JID_BITMAP_OFFSET)) {
+		if (test_bit_le(JID_BITMAP_OFFSET + i, lvb_bits)) {
 			fs_info(sdp, "recover generation %u jid %d\n",
 				start_gen, i);
 			gfs2_recover_set(sdp, i);
@@ -758,7 +760,7 @@ static void gfs2_control_func(struct work_struct *work)
 static int control_mount(struct gfs2_sbd *sdp)
 {
 	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
-	char lvb_bits[GDLM_LVB_SIZE];
+	DECLARE_BITMAP(lvb_bits, GDLM_LVB_SIZE * BITS_PER_BYTE);
 	uint32_t start_gen, block_gen, mount_gen, lvb_gen;
 	int mounted_mode;
 	int retries = 0;
@@ -949,7 +951,7 @@ static int dlm_recovery_wait(void *word)
 static int control_first_done(struct gfs2_sbd *sdp)
 {
 	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
-	char lvb_bits[GDLM_LVB_SIZE];
+	DECLARE_BITMAP(lvb_bits, GDLM_LVB_SIZE * BITS_PER_BYTE);
 	uint32_t start_gen, block_gen;
 	int error;
 
-- 
1.8.1.2

