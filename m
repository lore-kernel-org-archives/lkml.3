Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758772AbaGXJqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:46:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54620 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758085AbaGXJqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:46:46 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 014/128] btrfs: fix use of uninit "ret" in end_extent_writepage()
Date: Thu, 24 Jul 2014 10:44:23 +0100
Message-Id: <1406195177-8656-15-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Sandeen <sandeen@redhat.com>

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
Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/extent_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 479d5aecd708..4a96d26bc6fd 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2387,7 +2387,7 @@ int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
 {
 	int uptodate = (err == 0);
 	struct extent_io_tree *tree;
-	int ret;
+	int ret = 0;
 
 	tree = &BTRFS_I(page->mapping->host)->io_tree;
 
-- 
1.9.1

