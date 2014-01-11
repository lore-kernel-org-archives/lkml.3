Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbaAMMYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 07:24:51 -0500
Received: from 82-68-191-81.dsl.posilan.com ([82.68.191.81]:48348 "EHLO
	rainbowdash.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751605AbaAMMYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 07:24:45 -0500
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: linux-kernel@lists.codethink.co.uk
Cc: Ben Dooks <ben.dooks@codethink.co.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pm@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] power: clock_ops.c: report clock errors from clk_enable()
Date: Sat, 11 Jan 2014 13:05:40 +0000
Message-Id: <1389445540-21426-3-git-send-email-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389445540-21426-1-git-send-email-ben.dooks@codethink.co.uk>
References: <1389445540-21426-1-git-send-email-ben.dooks@codethink.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If clk_enable() fails, then print a message so that the user can see
what is happening instead of silently failing to enable the clock.

Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-pm@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Reviewed-by: Ian Molton <ian.molton@codethink.co.uk>
---
 drivers/base/power/clock_ops.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/base/power/clock_ops.c b/drivers/base/power/clock_ops.c
index 9bb95ab..b94b3ec 100644
--- a/drivers/base/power/clock_ops.c
+++ b/drivers/base/power/clock_ops.c
@@ -33,6 +33,21 @@ struct pm_clock_entry {
 };
 
 /**
+ * pm_clk_enable - Enable a clock, reporting any errors
+ * @dev: The device for the given clock
+ * @clk: The clock being enabled.
+ */
+static inline int __pm_clk_enable(struct device *dev, struct clk *clk)
+{
+	int ret = clk_enable(clk);
+	if (ret != 0)
+		dev_err(dev, "%s: failed to enable clk %p, error %d\n",
+			__func__, clk, ret);
+
+	return ret;
+}
+
+/**
  * pm_clk_acquire - Acquire a device clock.
  * @dev: Device whose clock is to be acquired.
  * @ce: PM clock entry corresponding to the clock.
@@ -263,7 +278,7 @@ int pm_clk_resume(struct device *dev)
 
 	list_for_each_entry(ce, &psd->clock_list, node) {
 		if (ce->status < PCE_STATUS_ERROR) {
-			ret = clk_enable(ce->clk);
+			ret = __pm_clk_enable(dev, ce->clk);
 			if (ret == 0)
 				ce->status = PCE_STATUS_ENABLED;
 		}
@@ -381,7 +396,7 @@ int pm_clk_resume(struct device *dev)
 	spin_lock_irqsave(&psd->lock, flags);
 
 	list_for_each_entry(ce, &psd->clock_list, node)
-		clk_enable(ce->clk);
+		__pm_clk_enable(dev, ce->clk);
 
 	spin_unlock_irqrestore(&psd->lock, flags);
 
-- 
1.8.5.2

