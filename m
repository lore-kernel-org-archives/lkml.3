Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab3FDXEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:04:49 -0400
Received: from 1wt.eu ([62.212.114.60]:35606 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444Ab3FDWmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:54 -0400
Message-Id: <20130604172135.902744046@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:45 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Jim Trigg <jtrigg@spamcop.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 135/184] udf: Fix bitmap overflow on large filesystems with
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 small block size

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
Cc: Jim Trigg <jtrigg@spamcop.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/udf/udf_sb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index d113b72..efa82c9 100644
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
1.7.12.2.21.g234cd45.dirty



