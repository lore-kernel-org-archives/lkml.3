Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbaF3Maf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:30:35 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753618AbaF3Mac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:30:32 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
        Chris Mason <clm@fb.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 174/181] btrfs: fix use of uninit "ret" in end_extent_writepage()
Date: Mon, 30 Jun 2014 13:53:15 +0200
Message-Id: <648ebfef1d78290430a96a2818a7ae327ed854a2.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3e2426bd0eb980648449e7a2f5a23e3cd3c7725c upstream.

If this condition in end_extent_writepage() is false:

	if (tree->ops && tree->ops->writepage_end_io_hook)

we will then test an uninitialized "ret" at:

	ret = ret < 0 ? ret : -EIO;

The test for ret is for the case where ->writepage_end_io_hook
failed, and we'd choose that ret as the error; but if
there is no ->writepage_end_io_hook, nothing sets ret.

Initializing ret to 0 should be sufficient; if
writepage_end_io_hook wasn't set, (!uptodate) means
non-zero err was passed in, so we choose -EIO in that case.

Signed-of-by: Eric Sandeen <sandeen@redhat.com>

Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/btrfs/extent_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a3dd2806d651..b395791dd923 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2312,7 +2312,7 @@ int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
 {
 	int uptodate = (err == 0);
 	struct extent_io_tree *tree;
-	int ret;
+	int ret = 0;
 
 	tree = &BTRFS_I(page->mapping->host)->io_tree;
 
-- 
2.0.0

