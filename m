Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab3EMLDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 07:03:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:2297 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793Ab3EMLDH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 07:03:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,662,1363158000"; 
   d="scan'208";a="336222356"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-pm@vger.kernel.org
Cc: Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] PM / Runtime: honor device autosuspend in pm_generic_runtime_idle()
Date: Mon, 13 May 2013 14:05:27 +0300
Message-Id: <1368443127-9636-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the device is using autosuspend we should honor that and call
pm_runtime_autosuspend() instead of pm_runtime_suspend(). Failing to do so
causes the device to be suspended immediately even though it expects to be
suspended only when the autosuspend delay is expired.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/base/power/generic_ops.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/base/power/generic_ops.c b/drivers/base/power/generic_ops.c
index bfd898b..19786ca 100644
--- a/drivers/base/power/generic_ops.c
+++ b/drivers/base/power/generic_ops.c
@@ -29,7 +29,10 @@ int pm_generic_runtime_idle(struct device *dev)
 			return ret;
 	}
 
-	pm_runtime_suspend(dev);
+	if (dev->power.use_autosuspend)
+		pm_runtime_autosuspend(dev);
+	else
+		pm_runtime_suspend(dev);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(pm_generic_runtime_idle);
-- 
1.7.10.4

