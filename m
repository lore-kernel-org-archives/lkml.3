Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbaKROQP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:16:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755144AbaKROK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:28 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chris Mason <clm@fb.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 203/206] Btrfs: fix kfree on list_head in btrfs_lookup_csums_range error cleanup
Date: Tue, 18 Nov 2014 15:09:18 +0100
Message-Id: <af38815938285cb19a5f489cc4e65e4862c149fa.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Mason <clm@fb.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 6e5aafb27419f32575b27ef9d6a31e5d54661aca upstream.

If we hit any errors in btrfs_lookup_csums_range, we'll loop through all
the csums we allocate and free them.  But the code was using list_entry
incorrectly, and ended up trying to free the on-stack list_head instead.

This bug came from commit 0678b6185

btrfs: Don't BUG_ON kzalloc error in btrfs_lookup_csums_range()

Signed-off-by: Chris Mason <clm@fb.com>
Reported-by: Erik Berg <btrfs@slipsprogrammoer.no>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/btrfs/file-item.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index d4731e9808ea..ced6aa4ca3c3 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -420,7 +420,7 @@ int btrfs_lookup_csums_range(struct btrfs_root *root, u64 start, u64 end,
 	ret = 0;
 fail:
 	while (ret < 0 && !list_empty(&tmplist)) {
-		sums = list_entry(&tmplist, struct btrfs_ordered_sum, list);
+		sums = list_entry(tmplist.next, struct btrfs_ordered_sum, list);
 		list_del(&sums->list);
 		kfree(sums);
 	}
-- 
2.1.3

