Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032AbbAGC0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:26:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757689AbbAGCSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 21:18:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Carl Henrik Lunde <chlunde@ping.uio.no>, Jan Kara <jack@suse.cz>
Subject: [PATCH 3.17 63/73] udf: Verify i_size when loading inode
Date: Tue,  6 Jan 2015 18:16:24 -0800
Message-Id: <20150107021559.441223730@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107021557.521276020@linuxfoundation.org>
References: <20150107021557.521276020@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit e159332b9af4b04d882dbcfe1bb0117f0a6d4b58 upstream.

Verify that inode size is sane when loading inode with data stored in
ICB. Otherwise we may get confused later when working with the inode and
inode size is too big.

Reported-by: Carl Henrik Lunde <chlunde@ping.uio.no>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/udf/inode.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1489,6 +1489,20 @@ reread:
 	}
 	inode->i_generation = iinfo->i_unique;
 
+	/* Sanity checks for files in ICB so that we don't get confused later */
+	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
+		/*
+		 * For file in ICB data is stored in allocation descriptor
+		 * so sizes should match
+		 */
+		if (iinfo->i_lenAlloc != inode->i_size)
+			goto out;
+		/* File in ICB has to fit in there... */
+		if (inode->i_size > inode->i_sb->s_blocksize -
+					udf_file_entry_alloc_offset(inode))
+			goto out;
+	}
+
 	switch (fe->icbTag.fileType) {
 	case ICBTAG_FILE_TYPE_DIRECTORY:
 		inode->i_op = &udf_dir_inode_operations;


