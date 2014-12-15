Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925AbaLOH1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 02:27:52 -0500
Received: from mail.kernel.org ([198.145.19.201]:34451 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbaLOH1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 02:27:45 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5/7] f2fs: fix small discards not to issue redundantly
Date: Sun, 14 Dec 2014 23:27:36 -0800
Message-Id: <1418628458-82740-5-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1418628458-82740-1-git-send-email-jaegeuk@kernel.org>
References: <1418628458-82740-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ckpt_valid_map and cur_valid_map are synced by seg_info_to_raw_sit.

In the case of small discards, the candidates are selected before sync,
while fitrim selects candidates after sync.

So, for small discards, we need to add candidates only just being obsoleted.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/segment.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index de9c070..335418c 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -525,7 +525,8 @@ static void add_discard_addrs(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 	bool force = (cpc->reason == CP_DISCARD);
 	int i;
 
-	if (!force && !test_opt(sbi, DISCARD))
+	if (!force && (!test_opt(sbi, DISCARD) ||
+			SM_I(sbi)->nr_discards >= SM_I(sbi)->max_discards))
 		return;
 
 	if (force && !se->valid_blocks) {
@@ -553,7 +554,8 @@ static void add_discard_addrs(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 
 	/* SIT_VBLOCK_MAP_SIZE should be multiple of sizeof(unsigned long) */
 	for (i = 0; i < entries; i++)
-		dmap[i] = ~(cur_map[i] | ckpt_map[i]);
+		dmap[i] = force ? ~ckpt_map[i] :
+				(cur_map[i] ^ ckpt_map[i]) & ckpt_map[i];
 
 	while (force || SM_I(sbi)->nr_discards <= SM_I(sbi)->max_discards) {
 		start = __find_rev_next_bit(dmap, max_blocks, end + 1);
@@ -1759,7 +1761,7 @@ void flush_sit_entries(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 			se = get_seg_entry(sbi, segno);
 
 			/* add discard candidates */
-			if (SM_I(sbi)->nr_discards < SM_I(sbi)->max_discards) {
+			if (cpc->reason != CP_DISCARD) {
 				cpc->trim_start = segno;
 				add_discard_addrs(sbi, cpc);
 			}
-- 
2.1.1

