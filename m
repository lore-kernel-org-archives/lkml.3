Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbaD0RIy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:08:54 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48159 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497AbaD0RIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:08:50 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Bobi Jam <bobijam.xu@intel.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 47/47] staging/lustre/llite: prevent buffer overflow in fiemap
Date: Sun, 27 Apr 2014 13:07:11 -0400
Message-Id: <1398618431-29757-48-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bobi Jam <bobijam.xu@intel.com>

lov_fiemap() does not take consider its @vallen parameter, which is
the max buffer size the caller can hold for the fiemap extents.

This patch fixes this and limits the max mapped fiemap extent count
to fit in the preallocted buffer.

This patch also fixes a memory out of bound write issue when the
fiemap call is only for detecting the number of existing extent.

Signed-off-by: Bobi Jam <bobijam.xu@intel.com>
Reviewed-on: http://review.whamcloud.com/9834
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4619
Reviewed-by: Fan Yong <fan.yong@intel.com>
Reviewed-by: Patrick Farrell <paf@cray.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/llite/file.c  | 15 +++++++++------
 drivers/staging/lustre/lustre/lov/lov_obd.c |  3 ++-
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 79accc5..562e337 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -1721,12 +1721,12 @@ out:
  * Make the FIEMAP get_info call and returns the result.
  */
 static int ll_do_fiemap(struct inode *inode, struct ll_user_fiemap *fiemap,
-			int num_bytes)
+			size_t num_bytes)
 {
 	struct obd_export *exp = ll_i2dtexp(inode);
 	struct lov_stripe_md *lsm = NULL;
 	struct ll_fiemap_info_key fm_key = { .name = KEY_FIEMAP, };
-	int vallen = num_bytes;
+	__u32 vallen = num_bytes;
 	int rc;
 
 	/* Checks for fiemap flags */
@@ -3080,15 +3080,18 @@ static int ll_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	fiemap->fm_extent_count = fieinfo->fi_extents_max;
 	fiemap->fm_start = start;
 	fiemap->fm_length = len;
-	memcpy(&fiemap->fm_extents[0], fieinfo->fi_extents_start,
-	       sizeof(struct ll_fiemap_extent));
+	if (extent_count > 0)
+		memcpy(&fiemap->fm_extents[0], fieinfo->fi_extents_start,
+		       sizeof(struct ll_fiemap_extent));
 
 	rc = ll_do_fiemap(inode, fiemap, num_bytes);
 
 	fieinfo->fi_flags = fiemap->fm_flags;
 	fieinfo->fi_extents_mapped = fiemap->fm_mapped_extents;
-	memcpy(fieinfo->fi_extents_start, &fiemap->fm_extents[0],
-	       fiemap->fm_mapped_extents * sizeof(struct ll_fiemap_extent));
+	if (extent_count > 0)
+		memcpy(fieinfo->fi_extents_start, &fiemap->fm_extents[0],
+		       fiemap->fm_mapped_extents *
+		       sizeof(struct ll_fiemap_extent));
 
 	OBD_FREE_LARGE(fiemap, num_bytes);
 	return rc;
diff --git a/drivers/staging/lustre/lustre/lov/lov_obd.c b/drivers/staging/lustre/lustre/lov/lov_obd.c
index dbd971a..12e778c 100644
--- a/drivers/staging/lustre/lustre/lov/lov_obd.c
+++ b/drivers/staging/lustre/lustre/lov/lov_obd.c
@@ -2248,11 +2248,12 @@ static int lov_fiemap(struct lov_obd *lov, __u32 keylen, void *key,
 	if (fm_end_offset == -EINVAL)
 		GOTO(out, rc = -EINVAL);
 
+	if (fiemap_count_to_size(fiemap->fm_extent_count) > *vallen)
+		fiemap->fm_extent_count = fiemap_size_to_count(*vallen);
 	if (fiemap->fm_extent_count == 0) {
 		get_num_extents = 1;
 		count_local = 0;
 	}
-
 	/* Check each stripe */
 	for (cur_stripe = start_stripe, i = 0; i < stripe_count;
 	     i++, cur_stripe = (cur_stripe + 1) % lsm->lsm_stripe_count) {
-- 
1.8.5.3

