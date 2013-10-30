Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab3J3Lav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 07:30:51 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:43840 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab3J3Lau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 07:30:50 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 1/4] staging/lustre/llite: cache jobid in lu_env
Date: Wed, 30 Oct 2013 19:30:33 +0800
Message-Id: <1383132636-8952-1-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We will switch to find jobid from /proc/self/environ and we need an
extra memory copy to do it, so let's cache it in lu_env.
It is then copied from lu_env to ll_inode_info upon every read/write.

Reviewed-by: Niu Yawei <yawei.niu@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/file.c         |    2 ++
 .../staging/lustre/lustre/llite/llite_internal.h   |   22 ++++++++++++++++++++
 drivers/staging/lustre/lustre/llite/llite_mmap.c   |    1 +
 drivers/staging/lustre/lustre/llite/vvp_io.c       |    8 -------
 4 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index bc534db..2fa0107 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -846,6 +846,8 @@ ll_file_io_generic(const struct lu_env *env, struct vvp_io_args *args,
 	struct cl_io	 *io;
 	ssize_t	       result;
 
+	ll_io_set_jobid(env, lli);
+
 restart:
 	io = ccc_env_thread_io(env);
 	ll_io_init(io, file, iot == CIT_WRITE);
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index 47e443d..3cac141 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -968,6 +968,7 @@ struct vvp_thread_info {
 	struct ra_io_arg     vti_ria;
 	struct kiocb	 vti_kiocb;
 	struct ll_cl_context vti_io_ctx;
+	char		     vti_jobid[JOBSTATS_JOBID_SIZE];
 };
 
 static inline struct vvp_thread_info *vvp_env_info(const struct lu_env *env)
@@ -980,6 +981,27 @@ static inline struct vvp_thread_info *vvp_env_info(const struct lu_env *env)
 	return info;
 }
 
+static inline char *vvp_env_jobid(const struct lu_env *env)
+{
+	return vvp_env_info(env)->vti_jobid;
+}
+
+#define LL_JOBID_NOT_FOUND 0x1
+static inline void ll_io_set_jobid(const struct lu_env *env, struct ll_inode_info *lli)
+{
+	char *jobid = vvp_env_jobid(env);
+
+	if (jobid[0] == '\0') {
+		lustre_get_jobid(jobid);
+
+		if (jobid[0] == '\0')
+			jobid[0] = LL_JOBID_NOT_FOUND;
+	}
+
+	if (jobid[0] != LL_JOBID_NOT_FOUND)
+		memcpy(lli->lli_jobid, jobid, JOBSTATS_JOBID_SIZE);
+}
+
 static inline struct vvp_io_args *vvp_env_args(const struct lu_env *env,
 					       enum vvp_io_subtype type)
 {
diff --git a/drivers/staging/lustre/lustre/llite/llite_mmap.c b/drivers/staging/lustre/lustre/llite/llite_mmap.c
index caed642..f64f915 100644
--- a/drivers/staging/lustre/lustre/llite/llite_mmap.c
+++ b/drivers/staging/lustre/lustre/llite/llite_mmap.c
@@ -205,6 +205,7 @@ static int ll_page_mkwrite0(struct vm_area_struct *vma, struct page *vmpage,
 	 * while truncate is on-going. */
 	inode = ccc_object_inode(io->ci_obj);
 	lli = ll_i2info(inode);
+	ll_io_set_jobid(env, lli);
 	down_read(&lli->lli_trunc_sem);
 
 	result = cl_io_loop(env, io);
diff --git a/drivers/staging/lustre/lustre/llite/vvp_io.c b/drivers/staging/lustre/lustre/llite/vvp_io.c
index 3ff664c..efcce29 100644
--- a/drivers/staging/lustre/lustre/llite/vvp_io.c
+++ b/drivers/staging/lustre/lustre/llite/vvp_io.c
@@ -1117,7 +1117,6 @@ int vvp_io_init(const struct lu_env *env, struct cl_object *obj,
 	result = 0;
 	if (io->ci_type == CIT_READ || io->ci_type == CIT_WRITE) {
 		size_t count;
-		struct ll_inode_info *lli = ll_i2info(inode);
 
 		count = io->u.ci_rw.crw_count;
 		/* "If nbyte is 0, read() will return 0 and have no other
@@ -1128,13 +1127,6 @@ int vvp_io_init(const struct lu_env *env, struct cl_object *obj,
 			cio->cui_tot_count = count;
 			cio->cui_tot_nrsegs = 0;
 		}
-		/* for read/write, we store the jobid in the inode, and
-		 * it'll be fetched by osc when building RPC.
-		 *
-		 * it's not accurate if the file is shared by different
-		 * jobs.
-		 */
-		lustre_get_jobid(lli->lli_jobid);
 	} else if (io->ci_type == CIT_SETATTR) {
 		if (!cl_io_is_trunc(io))
 			io->ci_lockreq = CILR_MANDATORY;
-- 
1.7.9.5

