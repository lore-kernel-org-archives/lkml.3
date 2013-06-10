Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab3FJG3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 02:29:20 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:24299 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3FJG3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 02:29:17 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Joshua Covington <joshuacov@googlemail.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        <stable@vger.kernel.org>
Subject: [PATCH v2 2/2] x86, range: Do not add new blank slot with add_range_with_merge
Date: Sun,  9 Jun 2013 23:29:02 -0700
Message-Id: <1370845742-18919-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Reported-by: Joshua Covington <joshuacov@googlemail.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: <stable@vger.kernel.org> v3.9

---
 arch/x86/kernel/cpu/mtrr/cleanup.c |    2 +-
 kernel/range.c                     |   21 +++++++++++----------
 2 files changed, 12 insertions(+), 11 deletions(-)

Index: linux-2.6/kernel/range.c
===================================================================
--- linux-2.6.orig/kernel/range.c
+++ linux-2.6/kernel/range.c
@@ -32,9 +32,8 @@ int add_range_with_merge(struct range *r
 	if (start >= end)
 		return nr_range;
 
-	/* Try to merge it with old one: */
+	/* get new start/end: */
 	for (i = 0; i < nr_range; i++) {
-		u64 final_start, final_end;
 		u64 common_start, common_end;
 
 		if (!range[i].end)
@@ -45,14 +44,16 @@ int add_range_with_merge(struct range *r
 		if (common_start > common_end)
 			continue;
 
-		final_start = min(range[i].start, start);
-		final_end = max(range[i].end, end);
-
-		/* clear it and add it back for further merge */
-		range[i].start = 0;
-		range[i].end =  0;
-		return add_range_with_merge(range, az, nr_range,
-			final_start, final_end);
+		/* new start/end, will add it back at last */
+		start = min(range[i].start, start);
+		end = max(range[i].end, end);
+
+		memmove(&range[i], &range[i + 1],
+			(nr_range - (i + 1)) * sizeof(range[i]));
+		range[nr_range - 1].start = 0;
+		range[nr_range - 1].end   = 0;
+		nr_range--;
+		i--;
 	}
 
 	/* Need to add it: */
