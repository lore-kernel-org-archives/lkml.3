Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbaD0RKG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:10:06 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48153 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754541AbaD0RIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:08:45 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Swapnil Pimpale <spimpale@ddn.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 43/47] staging/lustre/osc: Update inode timestamp for lockless IO as well
Date: Sun, 27 Apr 2014 13:07:07 -0400
Message-Id: <1398618431-29757-44-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Swapnil Pimpale <spimpale@ddn.com>

Removed the checks for oi_lockless from osc_io_read_start() and
osc_io_write_start(). This patch also removes the unnecessary call to
cl_object_attr_get() in osc_io_write_start() before calling
cl_object_attr_set()

Signed-off-by: Swapnil Pimpale <spimpale@ddn.com>
Reviewed-on: http://review.whamcloud.com/8797
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3868
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/osc/osc_io.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/lustre/lustre/osc/osc_io.c b/drivers/staging/lustre/lustre/osc/osc_io.c
index 6744dc6..09e06eb 100644
--- a/drivers/staging/lustre/lustre/osc/osc_io.c
+++ b/drivers/staging/lustre/lustre/osc/osc_io.c
@@ -509,12 +509,11 @@ static void osc_io_setattr_end(const struct lu_env *env,
 static int osc_io_read_start(const struct lu_env *env,
 			     const struct cl_io_slice *slice)
 {
-	struct osc_io    *oio   = cl2osc_io(env, slice);
 	struct cl_object *obj   = slice->cis_obj;
 	struct cl_attr   *attr  = &osc_env_info(env)->oti_attr;
 	int rc = 0;
 
-	if (oio->oi_lockless == 0 && !slice->cis_io->ci_noatime) {
+	if (!slice->cis_io->ci_noatime) {
 		cl_object_attr_lock(obj);
 		attr->cat_atime = LTIME_S(CURRENT_TIME);
 		rc = cl_object_attr_set(env, obj, attr, CAT_ATIME);
@@ -526,24 +525,17 @@ static int osc_io_read_start(const struct lu_env *env,
 static int osc_io_write_start(const struct lu_env *env,
 			      const struct cl_io_slice *slice)
 {
-	struct osc_io    *oio   = cl2osc_io(env, slice);
 	struct cl_object *obj   = slice->cis_obj;
 	struct cl_attr   *attr  = &osc_env_info(env)->oti_attr;
-	int	      result = 0;
+	int rc = 0;
 
-	if (oio->oi_lockless == 0) {
-		OBD_FAIL_TIMEOUT(OBD_FAIL_OSC_DELAY_SETTIME, 1);
-		cl_object_attr_lock(obj);
-		result = cl_object_attr_get(env, obj, attr);
-		if (result == 0) {
-			attr->cat_mtime = attr->cat_ctime =
-				LTIME_S(CURRENT_TIME);
-			result = cl_object_attr_set(env, obj, attr,
-						    CAT_MTIME | CAT_CTIME);
-		}
-		cl_object_attr_unlock(obj);
-	}
-	return result;
+	OBD_FAIL_TIMEOUT(OBD_FAIL_OSC_DELAY_SETTIME, 1);
+	cl_object_attr_lock(obj);
+	attr->cat_mtime = attr->cat_ctime = LTIME_S(CURRENT_TIME);
+	rc = cl_object_attr_set(env, obj, attr, CAT_MTIME | CAT_CTIME);
+	cl_object_attr_unlock(obj);
+
+	return rc;
 }
 
 static int osc_fsync_ost(const struct lu_env *env, struct osc_object *obj,
-- 
1.8.5.3

