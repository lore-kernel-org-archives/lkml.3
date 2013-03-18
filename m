Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643Ab3CRFwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 01:52:32 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:34368 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536Ab3CRFw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 01:52:29 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-2e-5146ab9c14e2
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH 12/19] f2fs: scan next nat page to reuse free nids in there
Date: Mon, 18 Mar 2013 14:51:43 +0900
Message-id: <1363585903-8362-1-git-send-email-jaegeuk.kim@samsung.com>
X-Mailer: git-send-email 1.8.1.3.566.gaa39828
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t8zY905q90CDY4c4ba4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK6Px6V+Wgp0cFedW
	H2BvYHzL1sXIySEhYCJx/vtUKFtM4sK99UA2F4eQwDJGid/nd7HAFPV+mMMIkZjOKLHp4ysW
	CKeNSaJ5zzvmLkYODjYBbYnN+w1AGkQEmCUWTD0P1sAsMIFR4v+i92CThAW8JV73vmcFsVkE
	VCX6ju5iBLF5BdwkXl1+wgyxTVdi9f/n7CDNEgL32STO3HzFBtEgIPFt8iEWkGUSArISmw5A
	1UtKHFxxg2UCo+ACRoZVjKKpBckFxUnpRaZ6xYm5xaV56XrJ+bmbGCFBOHEH4/0D1ocYk4HG
	TWSWEk3OBwZxXkm8obGZkYWpiamxkbmlGWnCSuK86i3WgUIC6YklqdmpqQWpRfFFpTmpxYcY
	mTg4pRoYc0ol31afSVQO0n3WJLDc7aVjs63i/6YlLgmhzY/Yyh1KP/2t+GgndH1KghLn8ZYN
	+ep3vM5LxOdsm/ZEKmytTeBk04e+apzv6qNipEXrq7oS/M87rP3pVH76h7xdHKsu37KiwBud
	p+bq+rr/9S+5vvhkyQs+l8tm1Qe9t1rVH/qs11vVdlyJpTgj0VCLuag4EQDeb2zkWAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jQd05q90CDX6cZbe4vusvk8WlRe4W
	e/aeZLG4vGsOmwOLx+4Fn5k8+rasYvT4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjGj8elfloKdHBXnVh9gb2B8y9bFyMkhIWAi0fthDiOELSZx4d56oDgXh5DA
	dEaJTR9fsUA4bUwSzXveMXcxcnCwCWhLbN5vANIgIsAssWDqeUaQGmaBCYwS/xe9ZwFJCAt4
	S7zufc8KYrMIqEr0Hd0FtoFXwE3i1eUnzBDbdCVW/3/OPoGRewEjwypG0dSC5ILipPRcQ73i
	xNzi0rx0veT83E2M4BB/JrWDcWWDxSFGAQ5GJR5eAx7XQCHWxLLiytxDjBIczEoivA0hboFC
	vCmJlVWpRfnxRaU5qcWHGJOBtk9klhJNzgfGX15JvKGxiZmRpZGZhZGJuTlpwkrivAdarQOF
	BNITS1KzU1MLUotgtjBxcEo1MCr0niqol1vFI37mYpvR6k2LVxkIsTIvbvwz9UHynFRLu4Ne
	wo4rPb67ZMZxm/4KyykTOrREfWKBANPjbkHtrp1+oYUOl0+cnH7v3sYLyi7LvuXWr9WfFRy8
	w/vb1nlSVq1lpg4XcxdduddibFZ6vHh9vMkFEevN7LvXmob98pihGVRnKyHor8RSnJFoqMVc
	VJwIADMG9ue1AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we build new free nids, let's scan the just next NAT page instead of
skipping a couple of previously scanned pages in order to reuse free nids in
there.
Otherwise, we can use too much wide range of nids even though several nids were
deallocated, and also their node pages can be cached in the node_inode's address
space.
This means that we can retain lots of clean pages in the main memory, which
induces mm's reclaiming overhead.

Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
---
 fs/f2fs/node.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 90221cc..94951d9 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1317,7 +1317,8 @@ static void build_free_nids(struct f2fs_sb_info *sbi)
 			break;
 	}
 
-	nm_i->next_scan_nid = nid;
+	/* go to the next nat page in order to reuse free nids first */
+	nm_i->next_scan_nid = nm_i->init_scan_nid + NAT_ENTRY_PER_BLOCK;
 
 	/* find free nids from current sum_pages */
 	mutex_lock(&curseg->curseg_mutex);
-- 
1.8.1.3.566.gaa39828

