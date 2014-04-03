Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbaDCNiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 09:38:10 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:54724 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbaDCNiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 09:38:07 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: jack@suse.cz
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Jianyu Zhan <nasa4836@gmail.com>
Subject: Re: [PATCH] blkdev: use an efficient way to check merge flags
Date: Thu,  3 Apr 2014 21:37:57 +0800
Message-Id: <1396532277-14226-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 1.9.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jan,

I've just renewed the patch as you suggusted. Actually it isn't quite 
performance sensitive, but the point is one less branch leads to
less penalty caused by branch prediction failure. Ok, this may be 
way too paranoid.:-)

A bitwise flag comparison could be done using a more efficient bit-ops
way, by mimicking GCC logic of optimizing such bitwise comparison.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 include/linux/blkdev.h | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1e1fa3f..f2b79fc 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -655,16 +655,18 @@ static inline bool rq_mergeable(struct request *rq)
 static inline bool blk_check_merge_flags(unsigned int flags1,
 					 unsigned int flags2)
 {
-	if ((flags1 & REQ_DISCARD) != (flags2 & REQ_DISCARD))
-		return false;
-
-	if ((flags1 & REQ_SECURE) != (flags2 & REQ_SECURE))
-		return false;
-
-	if ((flags1 & REQ_WRITE_SAME) != (flags2 & REQ_WRITE_SAME))
-		return false;
-
-	return true;
+	/*
+	 * Check whether all tree flags are the same in both
+	 * flags.
+	 *
+	 * Replace original three-if's comparision with a
+	 * more efficient method, by mimicking the GCC logic of
+	 * optimizing such bitwise comparion. This makes GCC
+	 * to spit out most compact and least brach code.
+	 */
+	return ((flags1 ^ flags2) &
+		(REQ_DISCARD | REQ_SECURE | REQ_WRITE_SAME))
+		== 0;
 }
 
 static inline bool blk_write_same_mergeable(struct bio *a, struct bio *b)
-- 
1.9.0.GIT

