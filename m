Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab3GVQKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:10:21 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:62985 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab3GVQKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:10:18 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "John L. Hammond" <john.hammond@intel.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 06/48] staging/lustre/llite: check alloc in ll_file_data_get, ll_dir_ioctl
Date: Tue, 23 Jul 2013 00:06:27 +0800
Message-Id: <1374509230-3324-7-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

In ll_file_data_get() and ll_dir_ioctl() return error on failed
allocations.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2753
Lustre-change: http://review.whamcloud.com/5845
Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-by: Sebastien Buisson <sebastien.buisson@bull.net>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/dir.c  |    2 ++
 drivers/staging/lustre/lustre/llite/file.c |    2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
index 1084999..bfc914e 100644
--- a/drivers/staging/lustre/lustre/llite/dir.c
+++ b/drivers/staging/lustre/lustre/llite/dir.c
@@ -1561,6 +1561,8 @@ out_rmdir:
 			RETURN(rc);
 
 		OBD_ALLOC_LARGE(lmm, lmmsize);
+		if (lmm == NULL)
+			RETURN(-ENOMEM);
 		if (copy_from_user(lmm, lum, lmmsize))
 			GOTO(free_lmm, rc = -EFAULT);
 
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index efe66d9..927b3a0 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -55,6 +55,8 @@ struct ll_file_data *ll_file_data_get(void)
 	struct ll_file_data *fd;
 
 	OBD_SLAB_ALLOC_PTR_GFP(fd, ll_file_data_slab, __GFP_IO);
+	if (fd == NULL)
+		return NULL;
 	fd->fd_write_failed = false;
 	return fd;
 }
-- 
1.7.9.5

