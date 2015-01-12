Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072AbbALSfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:35:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58464 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302AbbALSbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:31:04 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 205/216] udf: Verify i_size when loading inode
Date: Mon, 12 Jan 2015 18:29:43 +0000
Message-Id: <1421087394-2712-93-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit e159332b9af4b04d882dbcfe1bb0117f0a6d4b58 upstream.

Verify that inode size is sane when loading inode with data stored in
ICB. Otherwise we may get confused later when working with the inode and
inode size is too big.

Reported-by: Carl Henrik Lunde <chlunde@ping.uio.no>
Signed-off-by: Jan Kara <jack@suse.cz>
[ luis: backported to 3.16:
  - Adjusted exit paths as commit 6d3d5e860a11 ("udf: Make udf_read_inode()
    and udf_iget() return error") is not present in 3.16 kernel ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/udf/inode.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index a932f7740b51..bf08a9fbb97e 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1496,6 +1496,24 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
 		iinfo->i_checkpoint = le32_to_cpu(efe->checkpoint);
 	}
 
+	/* Sanity checks for files in ICB so that we don't get confused later */
+	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
+		/*
+		 * For file in ICB data is stored in allocation descriptor
+		 * so sizes should match
+		 */
+		if (iinfo->i_lenAlloc != inode->i_size) {
+			make_bad_inode(inode);
+			return;
+		}
+		/* File in ICB has to fit in there... */
+		if (inode->i_size > inode->i_sb->s_blocksize -
+					udf_file_entry_alloc_offset(inode)) {
+			make_bad_inode(inode);
+			return;
+		}
+	}
+
 	switch (fe->icbTag.fileType) {
 	case ICBTAG_FILE_TYPE_DIRECTORY:
 		inode->i_op = &udf_dir_inode_operations;
-- 
2.1.4

