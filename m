Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbaILLVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 07:21:20 -0400
Received: from mga14.intel.com ([192.55.52.115]:30449 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbaILLVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 07:21:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,512,1406617200"; 
   d="scan'208";a="477102173"
From: Huang Ying <ying.huang@intel.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Huang Ying <ying.huang@intel.com>, huang.ying.caritas@gmail.com
Subject: [PATCH] f2fs: Fix a race condition in next_free_nid
Date: Fri, 12 Sep 2014 19:21:11 +0800
Message-Id: <1410520871-22731-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The nm_i->fcnt checking is executed before spin_lock, so if another
thread delete the last free_nid from the list, the wrong nid may be
gotten.  So fix the race condition by moving the nm_i->fnct checking
into spin_lock.

Signed-off-by: Huang, Ying <ying.huang@intel.com>
---
 fs/f2fs/node.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/f2fs/node.h
+++ b/fs/f2fs/node.h
@@ -115,9 +115,11 @@ static inline int next_free_nid(struct f
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 	struct free_nid *fnid;
 
-	if (nm_i->fcnt <= 0)
-		return -1;
 	spin_lock(&nm_i->free_nid_list_lock);
+	if (nm_i->fcnt <= 0) {
+		spin_unlock(&nm_i->free_nid_list_lock);
+		return -1;
+	}
 	fnid = list_entry(nm_i->free_nid_list.next, struct free_nid, list);
 	*nid = fnid->nid;
 	spin_unlock(&nm_i->free_nid_list_lock);
