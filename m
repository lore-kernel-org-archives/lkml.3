Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933995AbaLBTaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:30:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47029 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933836AbaLBT07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:26:59 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Mason <clm@fb.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 031/121] Btrfs: fix kfree on list_head in btrfs_lookup_csums_range error cleanup
Date: Tue,  2 Dec 2014 11:18:30 -0800
Message-Id: <1417548000-1794-32-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <clm@fb.com>

commit 6e5aafb27419f32575b27ef9d6a31e5d54661aca upstream.

If we hit any errors in btrfs_lookup_csums_range, we'll loop through all
the csums we allocate and free them.  But the code was using list_entry
incorrectly, and ended up trying to free the on-stack list_head instead.

This bug came from commit 0678b6185

btrfs: Don't BUG_ON kzalloc error in btrfs_lookup_csums_range()

Signed-off-by: Chris Mason <clm@fb.com>
Reported-by: Erik Berg <btrfs@slipsprogrammoer.no>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/btrfs/file-item.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index bb91764..40b09dc 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -423,7 +423,7 @@ int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 	ret = 0;
 fail:
 	while (ret < 0 && !list_empty(&tmplist)) {
-		sums = list_entry(&tmplist, struct btrfs_ordered_sum, list);
+		sums = list_entry(tmplist.next, struct btrfs_ordered_sum, list);
 		list_del(&sums->list);
 		kfree(sums);
 	}
-- 
1.9.1

