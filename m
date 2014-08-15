Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaHOQti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:49:38 -0400
Received: from linuxhacker.ru ([217.76.32.60]:41242 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbaHOQso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:48:44 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Frank Zago <fzago@cray.com>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 07/10] staging/lustre/llite: optimize ll_fid2path()
Date: Fri, 15 Aug 2014 12:48:12 -0400
Message-Id: <1408121295-29115-8-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408121295-29115-1-git-send-email-green@linuxhacker.ru>
References: <1408121295-29115-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Zago <fzago@cray.com>

The only parameter from userspace that matters is the length of the
buffer. We don't need to allocate then import the whole structure. By
importing only that length, we can save a memory allocation.

Add sparse annotations to that function.

Signed-off-by: frank zago <fzago@cray.com>
Reviewed-on: http://review.whamcloud.com/11167
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-5389
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/llite/file.c         | 34 ++++++++++------------
 .../staging/lustre/lustre/llite/llite_internal.h   |  2 +-
 2 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 084fb92..d3874e1 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -1702,37 +1702,35 @@ out:
 	return rc;
 }
 
-int ll_fid2path(struct inode *inode, void *arg)
+int ll_fid2path(struct inode *inode, void __user *arg)
 {
-	struct obd_export	*exp = ll_i2mdexp(inode);
-	struct getinfo_fid2path	*gfout, *gfin;
-	int			 outsize, rc;
+	struct obd_export *exp = ll_i2mdexp(inode);
+	const struct getinfo_fid2path __user *gfin = arg;
+	struct getinfo_fid2path *gfout;
+	u32 pathlen;
+	size_t outsize;
+	int rc;
 
 	if (!capable(CFS_CAP_DAC_READ_SEARCH) &&
 	    !(ll_i2sbi(inode)->ll_flags & LL_SBI_USER_FID2PATH))
 		return -EPERM;
 
-	/* Need to get the buflen */
-	OBD_ALLOC_PTR(gfin);
-	if (gfin == NULL)
-		return -ENOMEM;
-	if (copy_from_user(gfin, arg, sizeof(*gfin))) {
-		OBD_FREE_PTR(gfin);
+	/* Only need to get the buflen */
+	if (get_user(pathlen, &gfin->gf_pathlen))
 		return -EFAULT;
-	}
 
-	outsize = sizeof(*gfout) + gfin->gf_pathlen;
+	outsize = sizeof(*gfout) + pathlen;
+
 	OBD_ALLOC(gfout, outsize);
-	if (gfout == NULL) {
-		OBD_FREE_PTR(gfin);
+	if (gfout == NULL)
 		return -ENOMEM;
-	}
-	memcpy(gfout, gfin, sizeof(*gfout));
-	OBD_FREE_PTR(gfin);
+
+	if (copy_from_user(gfout, arg, sizeof(*gfout)))
+		GOTO(gf_free, rc = -EFAULT);
 
 	/* Call mdc_iocontrol */
 	rc = obd_iocontrol(OBD_IOC_FID2PATH, exp, outsize, gfout, NULL);
-	if (rc)
+	if (rc != 0)
 		GOTO(gf_free, rc);
 
 	if (copy_to_user(arg, gfout, outsize))
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index 684405e..b42d879 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -775,7 +775,7 @@ int ll_dir_getstripe(struct inode *inode, struct lov_mds_md **lmmp,
 		     int *lmm_size, struct ptlrpc_request **request);
 int ll_fsync(struct file *file, loff_t start, loff_t end, int data);
 int ll_merge_lvb(const struct lu_env *env, struct inode *inode);
-int ll_fid2path(struct inode *inode, void *arg);
+int ll_fid2path(struct inode *inode, void __user *arg);
 int ll_data_version(struct inode *inode, __u64 *data_version, int extent_lock);
 int ll_hsm_release(struct inode *inode);
 
-- 
1.9.3

