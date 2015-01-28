Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965490AbbA1EjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:39:25 -0500
Received: from mail.kernel.org ([198.145.29.136]:40818 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965144AbbA1EYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:24:44 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chris Mason <clm@fb.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 135/177] Btrfs: fix kfree on list_head in btrfs_lookup_csums_range error cleanup
Date: Wed, 28 Jan 2015 12:09:53 +0800
Message-Id: <1422418236-12852-226-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Mason <clm@fb.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 6e5aafb27419f32575b27ef9d6a31e5d54661aca upstream.

If we hit any errors in btrfs_lookup_csums_range, we'll loop through all
the csums we allocate and free them.  But the code was using list_entry
incorrectly, and ended up trying to free the on-stack list_head instead.

This bug came from commit 0678b6185

btrfs: Don't BUG_ON kzalloc error in btrfs_lookup_csums_range()

Signed-off-by: Chris Mason <clm@fb.com>
Reported-by: Erik Berg <btrfs@slipsprogrammoer.no>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 fs/btrfs/file-item.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index 5d158d3..6eab2dd 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -393,7 +393,7 @@ int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
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

