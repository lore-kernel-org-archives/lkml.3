Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbaD0RKH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:10:07 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48150 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754539AbaD0RIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:08:44 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 45/47] staging/lustre: pass fsync() range through RPC/IO stack
Date: Sun, 27 Apr 2014 13:07:09 -0400
Message-Id: <1398618431-29757-46-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Dilger <andreas.dilger@intel.com>

The Linux VFS and Lustre OST_SYNC RPC are both capable of specifying
fsync() on a sub-extent of the file {start, end} instead of the full
file.  This allows less than the full amount of data to be flushed,
reducing or possibly eliminating the work needed before the syscall
can return.

However, the handling of sub-extent of the file for fsync was lost
with the move to CLIO on the client and OSD API on the server.  They
were ignoring the passed {start, end} and using {0, OBD_OBJECT_EOF}
instead.

Return the ability to pass a sub-extent for fsync() from the client,
to the specific stripes/OSTs that need the sync operation, and pass
it down to the OSD.  The ZFS OSD doesn't handle this yet, but there
is room for improvement in a separate patch.

Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-on: http://review.whamcloud.com/8626
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4388
Reviewed-by: Bobi Jam <bobijam@gmail.com>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/include/dt_object.h | 9 +++++----
 drivers/staging/lustre/lustre/llite/file.c        | 5 ++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/lustre/lustre/include/dt_object.h b/drivers/staging/lustre/lustre/include/dt_object.h
index 9304c26..9b7921d 100644
--- a/drivers/staging/lustre/lustre/include/dt_object.h
+++ b/drivers/staging/lustre/lustre/include/dt_object.h
@@ -441,7 +441,8 @@ struct dt_object_operations {
 					struct dt_object *dt,
 					struct lustre_capa *old,
 					__u64 opc);
-	int (*do_object_sync)(const struct lu_env *, struct dt_object *);
+	int (*do_object_sync)(const struct lu_env *env, struct dt_object *obj,
+			      __u64 start, __u64 end);
 	/**
 	 * Get object info of next level. Currently, only get inode from osd.
 	 * This is only used by quota b=16542
@@ -900,13 +901,13 @@ static inline int dt_object_lock(const struct lu_env *env,
 int dt_lookup_dir(const struct lu_env *env, struct dt_object *dir,
 		  const char *name, struct lu_fid *fid);
 
-static inline int dt_object_sync(const struct lu_env *env,
-				 struct dt_object *o)
+static inline int dt_object_sync(const struct lu_env *env, struct dt_object *o,
+				 __u64 start, __u64 end)
 {
 	LASSERT(o);
 	LASSERT(o->do_ops);
 	LASSERT(o->do_ops->do_object_sync);
-	return o->do_ops->do_object_sync(env, o);
+	return o->do_ops->do_object_sync(env, o, start, end);
 }
 
 int dt_declare_version_set(const struct lu_env *env, struct dt_object *o,
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 4d8f6a0..79accc5 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -2570,7 +2570,7 @@ static int ll_flush(struct file *file, fl_owner_t id)
 
 /**
  * Called to make sure a portion of file has been written out.
- * if @local_only is not true, it will send OST_SYNC RPCs to ost.
+ * if @mode is not CL_FSYNC_LOCAL, it will send OST_SYNC RPCs to OST.
  *
  * Return how many pages have been written.
  */
@@ -2667,8 +2667,7 @@ int ll_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	if (S_ISREG(inode->i_mode)) {
 		struct ll_file_data *fd = LUSTRE_FPRIVATE(file);
 
-		err = cl_sync_file_range(inode, 0, OBD_OBJECT_EOF,
-				CL_FSYNC_ALL, 0);
+		err = cl_sync_file_range(inode, start, end, CL_FSYNC_ALL, 0);
 		if (rc == 0 && err < 0)
 			rc = err;
 		if (rc < 0)
-- 
1.8.5.3

