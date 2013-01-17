Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427Ab3AQCga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 21:36:30 -0500
Received: from amsterdam.lcs.mit.edu ([18.26.4.9]:46436 "EHLO
	amsterdam.lcs.mit.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757865Ab3AQCg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:36:29 -0500
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Anton Altaparmakov <anton@tuxera.com>
Cc: Nickolai Zeldovich <nickolai@csail.mit.edu>,
        linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] ntfs: do not dereference a null ctx on error
Date: Wed, 16 Jan 2013 21:28:29 -0500
Message-Id: <1358389709-20561-1-git-send-email-nickolai@csail.mit.edu>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In ntfs_mft_data_extend_allocation_nolock(), if an error condition occurs
prior to 'ctx' being set to a non-NULL value, avoid dereferencing the NULL
'ctx' pointer by jumping to later cleanup code.

Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---
 fs/ntfs/mft.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
index 3014a36..e6ea11c 100644
--- a/fs/ntfs/mft.c
+++ b/fs/ntfs/mft.c
@@ -1822,13 +1822,13 @@ static int ntfs_mft_data_extend_allocation_nolock(ntfs_volume *vol)
 	if (IS_ERR(mrec)) {
 		ntfs_error(vol->sb, "Failed to map mft record.");
 		ret = PTR_ERR(mrec);
-		goto undo_alloc;
+		goto undo_alloc_noctx;
 	}
 	ctx = ntfs_attr_get_search_ctx(mft_ni, mrec);
 	if (unlikely(!ctx)) {
 		ntfs_error(vol->sb, "Failed to get search context.");
 		ret = -ENOMEM;
-		goto undo_alloc;
+		goto undo_alloc_noctx;
 	}
 	ret = ntfs_attr_lookup(mft_ni->type, mft_ni->name, mft_ni->name_len,
 			CASE_SENSITIVE, rl[1].vcn, NULL, 0, ctx);
@@ -1988,8 +1988,8 @@ undo_alloc:
 				"context.%s", es);
 		NVolSetErrors(vol);
 	}
-	if (ctx)
-		ntfs_attr_put_search_ctx(ctx);
+	ntfs_attr_put_search_ctx(ctx);
+undo_alloc_noctx:
 	if (!IS_ERR(mrec))
 		unmap_mft_record(mft_ni);
 	up_write(&mft_ni->runlist.lock);
-- 
1.7.10.4

