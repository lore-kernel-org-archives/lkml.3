Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083Ab3GVQQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:16:13 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:56345 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932867Ab3GVQNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:13:01 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Ned Bass <bass6@llnl.gov>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 38/48] staging/lustre/lmv: fix duplicate directory entries
Date: Tue, 23 Jul 2013 00:06:59 +0800
Message-Id: <1374509230-3324-39-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ned Bass <bass6@llnl.gov>

Previously, I accidentally introduced a new way for duplicate
directory entries to be returned from readdir().  That patch fails
to properly decrement the nlupgs counter when breaking out of the
inner-for loop.  This accounting error causes an extra iteration
of the inner-for loop when processing the next cfs page and a bad
ldp_hash_end value is then saved in the lu_dirpage.  To fix this,
always decrement the nlupgs counter on entry into the inner loop.

Note: this bug only affects architectures with > 4k-sized pages, e.g.
PowerPC.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3182
Lustre-change: http://review.whamcloud.com/6405
Signed-off-by: Ned Bass <bass6@llnl.gov>
Reviewed-by: Fan Yong <fan.yong@intel.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: Bobi Jam <bobijam@gmail.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/lmv/lmv_obd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/lmv/lmv_obd.c b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
index 9e68eea..11c8d64 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_obd.c
+++ b/drivers/staging/lustre/lustre/lmv/lmv_obd.c
@@ -2157,7 +2157,7 @@ static void lmv_adjust_dirpages(struct page **pages, int ncfspgs, int nlupgs)
 		__u64			hash_end = dp->ldp_hash_end;
 		__u32			flags = dp->ldp_flags;
 
-		for (; nlupgs > 1; nlupgs--) {
+		while (--nlupgs > 0) {
 			ent = lu_dirent_start(dp);
 			for (end_dirent = ent; ent != NULL;
 			     end_dirent = ent, ent = lu_dirent_next(ent));
@@ -2191,6 +2191,7 @@ static void lmv_adjust_dirpages(struct page **pages, int ncfspgs, int nlupgs)
 
 		kunmap(pages[i]);
 	}
+	LASSERTF(nlupgs == 0, "left = %d", nlupgs);
 }
 #else
 #define lmv_adjust_dirpages(pages, ncfspgs, nlupgs) do {} while (0)
-- 
1.7.9.5

