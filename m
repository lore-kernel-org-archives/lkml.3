Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab3HUBsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 21:48:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:13362 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab3HUBsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 21:48:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,924,1367996400"; 
   d="scan'208";a="365897258"
Subject: [PATCH] LMK: Optimize lowmem_shrink
From: Leon Ma <xindong.ma@intel.com>
To: gregkh@linuxfoundation.org, ccross@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com
Cc: xindong.ma@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Aug 2013 09:41:05 +0800
Message-ID: <1377049265.22148.7.camel@leonma-sh>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Leon Ma <xindong.ma@intel.com>
Date: Mon, 19 Aug 2013 14:22:38 +0800
Subject: [PATCH] LMK: Optimize lowmem_shrink.

By comparing with selected_oom_score_adj instead of min_score_adj,
we may do less calculation.

Signed-off-by: Leon Ma <xindong.ma@intel.com>
---
 drivers/staging/android/lowmemorykiller.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
index f6c05c9..cb944c5 100644
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -126,7 +126,7 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 			return 0;
 		}
 		oom_score_adj = p->signal->oom_score_adj;
-		if (oom_score_adj < min_score_adj) {
+		if (oom_score_adj < selected_oom_score_adj) {
 			task_unlock(p);
 			continue;
 		}
@@ -134,13 +134,9 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
 		task_unlock(p);
 		if (tasksize <= 0)
 			continue;
-		if (selected) {
-			if (oom_score_adj < selected_oom_score_adj)
-				continue;
-			if (oom_score_adj == selected_oom_score_adj &&
-			    tasksize <= selected_tasksize)
-				continue;
-		}
+		if (selected && oom_score_adj == selected_oom_score_adj &&
+			tasksize <= selected_tasksize)
+			continue;
 		selected = p;
 		selected_tasksize = tasksize;
 		selected_oom_score_adj = oom_score_adj;
-- 
1.7.4.1



