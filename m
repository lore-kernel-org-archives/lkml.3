Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641AbaBEUSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:18:22 -0500
Received: from mail.windriver.com ([147.11.1.11]:55564 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258AbaBEUHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:51 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Jan Kara <jack@suse.cz>, Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 188/213] udf: Fix bitmap overflow on large filesystems with small block size
Date: Wed, 5 Feb 2014 15:02:23 -0500
Message-ID: <1391630568-49251-189-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 89b1f39eb4189de745fae554b0d614d87c8d5c63 upstream.

For large UDF filesystems with 512-byte blocks the number of necessary
bitmap blocks is larger than 2^16 so s_nr_groups in udf_bitmap overflows
(the number will overflow for filesystems larger than 128 GB with
512-byte blocks). That results in ENOSPC errors despite the filesystem
has plenty of free space.

Fix the problem by changing s_nr_groups' type to 'int'. That is enough
even for filesystems 2^32 blocks (UDF maximum) and 512-byte blocksize.

Reported-and-tested-by: v10lator@myway.de
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/udf/udf_sb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index d113b72c2768..efa82c91ec18 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -78,7 +78,7 @@ struct udf_virtual_data {
 struct udf_bitmap {
 	__u32			s_extLength;
 	__u32			s_extPosition;
-	__u16			s_nr_groups;
+	int			s_nr_groups;
 	struct buffer_head 	**s_block_bitmap;
 };
 
-- 
1.8.5.2

