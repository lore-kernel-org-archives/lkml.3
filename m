Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab3IMAjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 20:39:04 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:45925 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab3IMAjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 20:39:01 -0400
From: Jin Xu <jinuxstyle@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jinuxstyle@gmail.com
Subject: [PATCH] f2fs: optimize the victim searching loop slightly
Date: Fri, 13 Sep 2013 08:38:54 +0800
Message-Id: <1379032734-7677-1-git-send-email-jinuxstyle@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the MAX_VICTIM_SEARCH has been enlarged from 20 to 4096,
the victim searching overhead will be increased much than before,
especially for SSR that searches victim for use quiet often.
This patch intends to reduce the overhead a little bit by:
- make the get_gc_cost a inline routine to reduce function call
  overhead
- reduce multiplication and division operations
- reduce unnecessary comparison operation

Signed-off-by: Jin Xu <jinuxstyle@gmail.com>
---
 fs/f2fs/gc.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index a78b8e3..14187bf 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -221,8 +221,8 @@ static unsigned int get_cb_cost(struct f2fs_sb_info *sbi, unsigned int segno)
 	return UINT_MAX - ((100 * (100 - u) * age) / (100 + u));
 }
 
-static unsigned int get_gc_cost(struct f2fs_sb_info *sbi, unsigned int segno,
-					struct victim_sel_policy *p)
+static inline unsigned int get_gc_cost(struct f2fs_sb_info *sbi,
+			unsigned int segno, struct victim_sel_policy *p)
 {
 	if (p->alloc_mode == SSR)
 		return get_seg_entry(sbi, segno)->ckpt_valid_blocks;
@@ -278,7 +278,11 @@ static int get_victim_by_default(struct f2fs_sb_info *sbi,
 			}
 			break;
 		}
-		p.offset = ((segno / p.ofs_unit) * p.ofs_unit) + p.ofs_unit;
+
+		p.offset = segno + p.ofs_unit;
+		if (p.ofs_unit > 1)
+			p.offset -= segno % p.ofs_unit;
+
 		secno = GET_SECNO(sbi, segno);
 
 		if (sec_usage_check(sbi, secno))
@@ -291,10 +295,9 @@ static int get_victim_by_default(struct f2fs_sb_info *sbi,
 		if (p.min_cost > cost) {
 			p.min_segno = segno;
 			p.min_cost = cost;
-		}
-
-		if (cost == max_cost)
+		} else if (unlikely(cost == max_cost)) {
 			continue;
+		}
 
 		if (nsearched++ >= p.max_search) {
 			sbi->last_victim[p.gc_mode] = segno;
-- 
1.7.9.5

