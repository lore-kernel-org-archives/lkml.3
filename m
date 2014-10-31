Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728AbaJaT5k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 15:57:40 -0400
Received: from skprod2.natinst.com ([130.164.80.23]:56814 "EHLO ni.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756538AbaJaT5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 15:57:38 -0400
From: Ben Shelton <ben.shelton@ni.com>
To: linux-mtd@lists.infradead.org
Cc: dedekind1@gmail.com, adrian.hunter@intel.com, linux-kernel@vger.kernel.org,
        Subodh Nijsure <snijsure@grid-net.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Ben Shelton <ben.shelton@ni.com>
Subject: [PATCH 4/4] UBIFS: add ubifs_err() to print error reason
Date: Fri, 31 Oct 2014 13:50:31 -0500
Message-Id: <1414781431-2911-5-git-send-email-ben.shelton@ni.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414781431-2911-1-git-send-email-ben.shelton@ni.com>
References: <1414781431-2911-1-git-send-email-ben.shelton@ni.com>
X-MIMETrack: Itemize by SMTP Server on US-AUS-MGWOut2/AUS/H/NIC(Release 8.5.3FP6|November
 21, 2013) at 10/31/2014 01:51:14 PM,
	Serialize by Router on US-AUS-MGWOut2/AUS/H/NIC(Release 8.5.3FP6|November
 21, 2013) at 10/31/2014 01:51:14 PM,
	Serialize complete at 10/31/2014 01:51:14 PM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-31_08:2014-10-31,2014-10-31,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Subodh Nijsure <snijsure@grid-net.com>

This patch adds ubifs_err() output to some error paths to tell the user
what's going on.

Signed-off-by: Subodh Nijsure <snijsure@grid-net.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Ben Shelton <ben.shelton@ni.com>
Acked-by: Brad Mouring <brad.mouring@ni.com>
Acked-by: Terry Wilcox <terry.wilcox@ni.com>
Acked-by: Gratian Crisan <gratian.crisan@ni.com>
---
 fs/ubifs/xattr.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
index f844841..2b99e49 100644
--- a/fs/ubifs/xattr.c
+++ b/fs/ubifs/xattr.c
@@ -100,24 +100,32 @@ static const struct file_operations empty_fops;
 static int create_xattr(struct ubifs_info *c, struct inode *host,
 			const struct qstr *nm, const void *value, int size)
 {
-	int err;
+	int err, xattr_name_list_size;
 	struct inode *inode;
 	struct ubifs_inode *ui, *host_ui = ubifs_inode(host);
 	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1,
 				.new_ino_d = ALIGN(size, 8), .dirtied_ino = 1,
 				.dirtied_ino_d = ALIGN(host_ui->data_len, 8) };
 
-	if (host_ui->xattr_cnt >= MAX_XATTRS_PER_INODE)
+	if (host_ui->xattr_cnt >= MAX_XATTRS_PER_INODE) {
+		ubifs_err("ubifs xattr_cnt %d exceeds MAX_XATTR_PER_NODE (%d)",
+			  host_ui->xattr_cnt, MAX_XATTRS_PER_INODE);
 		return -ENOSPC;
+	}
 	/*
 	 * Linux limits the maximum size of the extended attribute names list
 	 * to %XATTR_LIST_MAX. This means we should not allow creating more
 	 * extended attributes if the name list becomes larger. This limitation
 	 * is artificial for UBIFS, though.
 	 */
-	if (host_ui->xattr_names + host_ui->xattr_cnt +
-					nm->len + 1 > XATTR_LIST_MAX)
+	xattr_name_list_size = host_ui->xattr_names + host_ui->xattr_cnt +
+					nm->len + 1;
+
+	if (xattr_name_list_size > XATTR_LIST_MAX) {
+		ubifs_err("xattr name list too large %d > %d",
+			  xattr_name_list_size, XATTR_LIST_MAX);
 		return -ENOSPC;
+	}
 
 	err = ubifs_budget_space(c, &req);
 	if (err)
@@ -652,5 +660,9 @@ int ubifs_init_security(struct inode *dentry, struct inode *inode,
 					   &ubifs_initxattrs, 0);
 	mutex_unlock(&inode->i_mutex);
 
+	if (err)
+		ubifs_err("cannot initialize extended attribute, error %d",
+			  err);
+
 	return err;
 }
-- 
2.1.1

