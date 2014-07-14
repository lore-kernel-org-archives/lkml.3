Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145AbaGNOxL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:53:11 -0400
Received: from mail.kernel.org ([198.145.19.201]:38805 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755867AbaGNOwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:52:54 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, stable@vger.kernel.org
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 3.15 2/2] f2fs: check bdi->dirty_exceeded when trying to skip data writes
Date: Mon, 14 Jul 2014 07:52:51 -0700
Message-Id: <1405349571-20058-2-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.0.1.472.g6f92e5f
In-Reply-To: <1405349571-20058-1-git-send-email-jaegeuk@kernel.org>
References: <1405349571-20058-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit dd6b9bf5883c3ca9c17bac80ccd8615fe5a452a3 upstream.

If we don't check the current backing device status, balance_dirty_pages can
fall into infinite pausing routine.

This can be occurred when a lot of directories make a small number of dirty
dentry pages including files.

Reported-by: Brian Chadwick <brianchad@westnet.com.au>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/node.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index a9c0495..5696bde 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -42,6 +42,8 @@ bool available_free_memory(struct f2fs_sb_info *sbi, int type)
 		mem_size = (nm_i->nat_cnt * sizeof(struct nat_entry)) >> 12;
 		res = mem_size < ((val.totalram * nm_i->ram_thresh / 100) >> 2);
 	} else if (type == DIRTY_DENTS) {
+		if (sbi->sb->s_bdi->dirty_exceeded)
+			return false;
 		mem_size = get_pages(sbi, F2FS_DIRTY_DENTS);
 		res = mem_size < ((val.totalram * nm_i->ram_thresh / 100) >> 1);
 	}
-- 
2.0.1.472.g6f92e5f

