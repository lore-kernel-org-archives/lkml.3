Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754237Ab3EFPQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 11:16:25 -0400
Received: from mga03.intel.com ([143.182.124.21]:31012 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753714Ab3EFPQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 11:16:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,622,1363158000"; 
   d="scan'208";a="298322404"
From: Haicheng Li <haicheng.li@linux.intel.com>
To: linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>,
        Haicheng Li <haicheng.li@linux.intel.com>
Subject: [PATCH 1/4] f2fs: bugfix for alloc_nid_failed()
Date: Mon,  6 May 2013 23:15:41 +0800
Message-Id: <1367853344-28938-2-git-send-email-haicheng.li@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367853344-28938-1-git-send-email-haicheng.li@linux.intel.com>
References: <1367853344-28938-1-git-send-email-haicheng.li@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Directly drop the free_nid cache when nm_i->fcnt > 2 * MAX_FREE_NIDS

Since there is NOT nmi->free_nid_list_lock spinlock protection between
a sequential calling of alloc_nid() and alloc_nid_failed(), some other
threads may already add new free_nid to the free_nid_list during this
period.

We need to make sure nmi->fcnt is never > 2 * MAX_FREE_NIDS.

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
---
 fs/f2fs/node.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 7209d63..532ac57 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1439,8 +1439,12 @@ void alloc_nid_failed(struct f2fs_sb_info *sbi, nid_t nid)
 	spin_lock(&nm_i->free_nid_list_lock);
 	i = __lookup_free_nid_list(nid, &nm_i->free_nid_list);
 	BUG_ON(!i || i->state != NID_ALLOC);
-	i->state = NID_NEW;
-	nm_i->fcnt++;
+	if (nm_i->fcnt > 2 * MAX_FREE_NIDS)
+		__del_from_free_nid_list(i);
+	else {
+		i->state = NID_NEW;
+		nm_i->fcnt++;
+	}
 	spin_unlock(&nm_i->free_nid_list_lock);
 }
 
-- 
1.7.9.5

