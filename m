Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224AbaGXK3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:29:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54582 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083AbaGXJqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:46:39 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Liu Bo <bo.li.liu@oracle.com>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 008/128] Btrfs: mark mapping with error flag to report errors to userspace
Date: Thu, 24 Jul 2014 10:44:17 +0100
Message-Id: <1406195177-8656-9-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Bo <bo.li.liu@oracle.com>

commit 5dca6eea91653e9949ce6eb9e9acab6277e2f2c4 upstream.

According to commit 865ffef3797da2cac85b3354b5b6050dc9660978
(fs: fix fsync() error reporting),
it's not stable to just check error pages because pages can be
truncated or invalidated, we should also mark mapping with error
flag so that a later fsync can catch the error.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/extent_io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 6c80e0801e58..479d5aecd708 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2401,6 +2401,8 @@ int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
 	if (!uptodate) {
 		ClearPageUptodate(page);
 		SetPageError(page);
+		ret = ret < 0 ? ret : -EIO;
+		mapping_set_error(page->mapping, ret);
 	}
 	return 0;
 }
-- 
1.9.1

