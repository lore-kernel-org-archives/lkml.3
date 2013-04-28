Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab3D1LQx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 07:16:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:51987 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373Ab3D1LQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 07:16:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,566,1363158000"; 
   d="scan'208";a="329014921"
From: Haicheng Li <haicheng.li@linux.intel.com>
To: linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>,
        Haicheng Li <haicheng.li@linux.intel.com>
Subject: [PATCH 1/2] f2fs: fix inconsistent using of NM_WOUT_THRESHOLD
Date: Sun, 28 Apr 2013 19:16:06 +0800
Message-Id: <1367147767-22155-1-git-send-email-haicheng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

try_to_free_nats() is usually called with parameter nr_shrink as
	"nm_i->nat_cnt - NM_WOUT_THRESHOLD"
by flush_nat_entries() during checkpointing process.

However, this is inconsistent with the actual threshold check as
	"if (nm_i->nat_cnt < 2 * NM_WOUT_THRESHOLD)"
, which will ignore the free_nats requests when
	NM_WOUT_THRESHOLD < nm_i->nat_cnt < 2 * NM_WOUT_THRESHOLD

So fix the threshold check condition.

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
---
 fs/f2fs/node.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index e275218..2a73526 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -236,7 +236,7 @@ static int try_to_free_nats(struct f2fs_sb_info *sbi, int nr_shrink)
 {
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 
-	if (nm_i->nat_cnt < 2 * NM_WOUT_THRESHOLD)
+	if (nm_i->nat_cnt <= NM_WOUT_THRESHOLD)
 		return 0;
 
 	write_lock(&nm_i->nat_tree_lock);
-- 
1.7.9.5

