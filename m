Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab3KZCF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 21:05:57 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:33042 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab3KZCFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 21:05:52 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Patrick Farrell <paf@cray.com>,
        Cheng Shao <cheng_shao@xyratex.com>, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 03/16] staging/lustre/nfs: writing to new files will return ENOENT
Date: Tue, 26 Nov 2013 10:04:57 +0800
Message-Id: <1385431510-18988-4-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385431510-18988-1-git-send-email-bergwolf@gmail.com>
References: <1385431510-18988-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick Farrell <paf@cray.com>

This happend with SLES11SP2 Lustre client, which in turn acts as an
NFS server, exporting a subtree of an Lustre fs through NFS.

We detected that whenever we are writing to a new file using, fx,
'echo blah > newfile', it will return ENOENT error. We found
out that this was caused by the anonymous dentry. In SLESS11SP2,
anonymous dentries are assigned '/' as the name, instead of an
empty string. When MDT handles the intent_open call, it will look
up the obj by the name if it is not an empty string, and thus
couldn't find it.

As MDS_OPEN_BY_FID is always set on this request, we never need
to send the name in this request.  The fid is already available
and should be used in case the file has been renamed.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3544
Lustre-change: http://review.whamcloud.com/6920
Signed-off-by: Cheng Shao <cheng_shao@xyratex.com>
Signed-off-by: Patrick Farrell <paf@cray.com>
Reviewed-by: Bob Glossman <bob.glossman@intel.com>
Reviewed-by: Alexey Shvetsov <alexxy@gentoo.org>
Reviewed-by: Lai Siyao <lai.siyao@intel.com>
Reviewed-by: James Simmons <uja.ornl@gmail.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/file.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 82248e9..f36c5d8 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -368,8 +368,6 @@ static int ll_intent_file_open(struct file *file, void *lmm,
 {
 	struct ll_sb_info *sbi = ll_i2sbi(file->f_dentry->d_inode);
 	struct dentry *parent = file->f_dentry->d_parent;
-	const char *name = file->f_dentry->d_name.name;
-	const int len = file->f_dentry->d_name.len;
 	struct md_op_data *op_data;
 	struct ptlrpc_request *req;
 	__u32 opc = LUSTRE_OPC_ANY;
@@ -394,8 +392,9 @@ static int ll_intent_file_open(struct file *file, void *lmm,
 	}
 
 	op_data  = ll_prep_md_op_data(NULL, parent->d_inode,
-				      file->f_dentry->d_inode, name, len,
+				      file->f_dentry->d_inode, NULL, 0,
 				      O_RDWR, opc, NULL);
+
 	if (IS_ERR(op_data))
 		return PTR_ERR(op_data);
 
-- 
1.7.9.5

