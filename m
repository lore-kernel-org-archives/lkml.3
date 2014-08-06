Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbaHFNT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 09:19:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41129 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbaHFNTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 09:19:24 -0400
From: Mel Gorman <mgorman@suse.de>
To: Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        Nicolas Pitre <nico@linaro.org>
Cc: Mike Galbraith <mgalbraith@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 1/4] cpuidle: menu: Use shifts when calculating averages where possible
Date: Wed,  6 Aug 2014 14:19:18 +0100
Message-Id: <1407331161-4642-2-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1407331161-4642-1-git-send-email-mgorman@suse.de>
References: <1407331161-4642-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use do_div even though the divisor will usually be a power-of-two
unless there are unusual outliers. Use shifts where possible

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 drivers/cpuidle/governors/menu.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index c4f80c1..801b2ee 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -31,7 +31,8 @@
  * The default values do not overflow.
  */
 #define BUCKETS 12
-#define INTERVALS 8
+#define INTERVAL_SHIFT 3
+#define INTERVALS (1UL << INTERVAL_SHIFT)
 #define RESOLUTION 1024
 #define DECAY 8
 #define MAX_INTERESTING 50000
@@ -228,7 +229,10 @@ again:
 				max = value;
 		}
 	}
-	do_div(avg, divisor);
+	if (divisor == INTERVALS)
+		avg >>= INTERVAL_SHIFT;
+	else
+		do_div(avg, divisor);
 
 	/* Then try to determine standard deviation */
 	stddev = 0;
@@ -239,7 +243,11 @@ again:
 			stddev += diff * diff;
 		}
 	}
-	do_div(stddev, divisor);
+	if (divisor == INTERVALS)
+		stddev >>= INTERVAL_SHIFT;
+	else
+		do_div(stddev, divisor);
+
 	/*
 	 * The typical interval is obtained when standard deviation is small
 	 * or standard deviation is small compared to the average interval.
-- 
1.8.4.5

