Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089Ab3FRQws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:52:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59887 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112Ab3FRQwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:52:46 -0400
Date: Tue, 18 Jun 2013 09:52:11 -0700
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-0541881502a1276149889fe468662ff6a8fc8f6d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, joshuacov@googlemail.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, joshuacov@googlemail.com,
        hpa@linux.intel.com
In-Reply-To: <1371154622-8929-3-git-send-email-yinghai@kernel.org>
References: <1371154622-8929-3-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] range:
  Do not add new blank slot with add_range_with_merge
Git-Commit-ID: 0541881502a1276149889fe468662ff6a8fc8f6d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 18 Jun 2013 09:52:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0541881502a1276149889fe468662ff6a8fc8f6d
Gitweb:     http://git.kernel.org/tip/0541881502a1276149889fe468662ff6a8fc8f6d
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 13 Jun 2013 13:17:02 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 18 Jun 2013 11:32:10 -0500

range: Do not add new blank slot with add_range_with_merge

Joshua reported: Commit cd7b304dfaf1 (x86, range: fix missing merge
during add range) broke mtrr cleanup on his setup in 3.9.5.
corresponding commit in upstream is fbe06b7bae7c.

The reason is add_range_with_merge could generate blank spot.

We could avoid that by searching new expanded start/end, that
new range should include all connected ranges in range array.
At last add the new expanded start/end to the range array.
Also move up left array so do not add new blank slot in the
range array.

-v2: move left array to avoid enhance add_range()
-v3: include fix from Joshua about memmove declaring when
     DYN_DEBUG is used.

Reported-by: Joshua Covington <joshuacov@googlemail.com>
Tested-by: Joshua Covington <joshuacov@googlemail.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1371154622-8929-3-git-send-email-yinghai@kernel.org
Cc: <stable@vger.kernel.org> v3.9
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 kernel/range.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/kernel/range.c b/kernel/range.c
index eb911db..322ea8e 100644
--- a/kernel/range.c
+++ b/kernel/range.c
@@ -4,7 +4,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/sort.h>
-
+#include <linux/string.h>
 #include <linux/range.h>
 
 int add_range(struct range *range, int az, int nr_range, u64 start, u64 end)
@@ -32,9 +32,8 @@ int add_range_with_merge(struct range *range, int az, int nr_range,
 	if (start >= end)
 		return nr_range;
 
-	/* Try to merge it with old one: */
+	/* get new start/end: */
 	for (i = 0; i < nr_range; i++) {
-		u64 final_start, final_end;
 		u64 common_start, common_end;
 
 		if (!range[i].end)
@@ -45,14 +44,16 @@ int add_range_with_merge(struct range *range, int az, int nr_range,
 		if (common_start > common_end)
 			continue;
 
-		final_start = min(range[i].start, start);
-		final_end = max(range[i].end, end);
+		/* new start/end, will add it back at last */
+		start = min(range[i].start, start);
+		end = max(range[i].end, end);
 
-		/* clear it and add it back for further merge */
-		range[i].start = 0;
-		range[i].end =  0;
-		return add_range_with_merge(range, az, nr_range,
-			final_start, final_end);
+		memmove(&range[i], &range[i + 1],
+			(nr_range - (i + 1)) * sizeof(range[i]));
+		range[nr_range - 1].start = 0;
+		range[nr_range - 1].end   = 0;
+		nr_range--;
+		i--;
 	}
 
 	/* Need to add it: */
