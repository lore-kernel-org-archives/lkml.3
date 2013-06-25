Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab3FYTEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:04:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40972 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab3FYSdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:33:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joshua Covington <joshuacov@googlemail.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 39/95] range: Do not add new blank slot with add_range_with_merge
Date: Tue, 25 Jun 2013 11:32:26 -0700
Message-Id: <20130625182158.043248359@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit 0541881502a1276149889fe468662ff6a8fc8f6d upstream.

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
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/range.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

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


