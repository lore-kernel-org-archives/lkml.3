Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756AbaIRFyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 01:54:21 -0400
Received: from mail.kernel.org ([198.145.19.201]:43998 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757711AbaIRFyC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 01:54:02 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 3/3] f2fs: use more free segments until SSR is activated
Date: Wed, 17 Sep 2014 22:53:57 -0700
Message-Id: <1411019637-2381-3-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1411019637-2381-1-git-send-email-jaegeuk@kernel.org>
References: <1411019637-2381-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, f2fs activates SSR if the # of free segments reaches to the # of
overprovisioned segments.
In this case, SSR starts to use dirty segments only, so that the overprovisoned
space cannot be selected for new data.
This means that we have no chance to utilizae the overprovisioned space at all.

This patch fixes that by allowing LFS allocations until the # of free segments
reaches to the last threshold, reserved space.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/segment.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index d317b61..a0e9207 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -437,8 +437,9 @@ static inline int reserved_sections(struct f2fs_sb_info *sbi)
 
 static inline bool need_SSR(struct f2fs_sb_info *sbi)
 {
-	return (prefree_segments(sbi) / sbi->segs_per_sec)
-			+ free_sections(sbi) < overprovision_sections(sbi);
+	int node_secs = get_blocktype_secs(sbi, F2FS_DIRTY_NODES);
+	return (prefree_segments(sbi) / sbi->segs_per_sec) +
+		free_sections(sbi) < (reserved_sections(sbi) + node_secs);
 }
 
 static inline bool has_not_enough_free_secs(struct f2fs_sb_info *sbi, int freed)
-- 
1.8.5.2 (Apple Git-48)

