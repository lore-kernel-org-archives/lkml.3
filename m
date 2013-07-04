Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab3GDFgb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 01:36:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:24897 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754938Ab3GDFgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 01:36:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,992,1363158000"; 
   d="scan'208";a="360319279"
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.de, hpa@linux.intel.com, tim.c.chen@linux.intel.com
Cc: linux-kernel@vger.kernel.org, andi.kleen@intel.com, a.p.zijlstra@chello.nl,
        mingo@elte.hu
Subject: [PATCH 2/3] clockesource: set override clocksource
Date: Thu,  4 Jul 2013 13:34:15 +0800
Message-Id: <1372916056-24301-3-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1372916056-24301-1-git-send-email-alex.shi@intel.com>
References: <1372916056-24301-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shrink the mutex region. And save a clocksource_select action if set
clocksource is same as current clocksource.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/time/clocksource.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 021c159..9d6c333 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -885,13 +885,15 @@ static ssize_t sysfs_override_clocksource(struct device *dev,
 {
 	size_t ret;
 
-	mutex_lock(&clocksource_mutex);
-
 	ret = sysfs_get_uname(buf, override_name, count);
-	if (ret >= 0)
-		clocksource_select();
+	if (ret >= 0) {
+		if (!strcmp(curr_clocksource->name, override_name))
+			return ret;
 
-	mutex_unlock(&clocksource_mutex);
+		mutex_lock(&clocksource_mutex);
+		clocksource_select();
+		mutex_unlock(&clocksource_mutex);
+	}
 
 	return ret;
 }
-- 
1.7.12

