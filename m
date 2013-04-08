Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936556Ab3DHKVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:21:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42673 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935492Ab3DHJv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:51:27 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 020/102] udf: Fix bitmap overflow on large filesystems with small block size
Date: Mon,  8 Apr 2013 10:49:35 +0100
Message-Id: <1365414657-29191-21-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/udf/udf_sb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index 42ad69a..9e8e08e 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -82,7 +82,7 @@ struct udf_virtual_data {
 struct udf_bitmap {
 	__u32			s_extLength;
 	__u32			s_extPosition;
-	__u16			s_nr_groups;
+	int			s_nr_groups;
 	struct buffer_head 	**s_block_bitmap;
 };
 
-- 
1.8.1.2

