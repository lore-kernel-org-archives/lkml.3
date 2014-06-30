Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbaF3Msh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:48:37 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753907AbaF3Maj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:30:39 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Liu Bo <bo.li.liu@oracle.com>,
        Chris Mason <clm@fb.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 168/181] Btrfs: mark mapping with error flag to report errors to userspace
Date: Mon, 30 Jun 2014 13:53:09 +0200
Message-Id: <ee863114590f5931103d704563462b054f65e52f.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Bo <bo.li.liu@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5dca6eea91653e9949ce6eb9e9acab6277e2f2c4 upstream.

According to commit 865ffef3797da2cac85b3354b5b6050dc9660978
(fs: fix fsync() error reporting),
it's not stable to just check error pages because pages can be
truncated or invalidated, we should also mark mapping with error
flag so that a later fsync can catch the error.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/btrfs/extent_io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 0d611d1e2e34..a3dd2806d651 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2326,6 +2326,8 @@ int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
 	if (!uptodate) {
 		ClearPageUptodate(page);
 		SetPageError(page);
+		ret = ret < 0 ? ret : -EIO;
+		mapping_set_error(page->mapping, ret);
 	}
 	return 0;
 }
-- 
2.0.0

