Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbaFBG7Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 02:59:24 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:46722 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbaFBG7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 02:59:23 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        inderpal.s@samsung.com, nm@ti.com, chander.kashyap@linaro.org,
        pavel@ucw.cz, len.brown@intel.com, sudeep.holla@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V5 2/8] opp: call of_node_{get|put}() from of_init_opp_table()
Date: Mon,  2 Jun 2014 12:29:05 +0530
Message-Id: <a847fce95faef6ae74005d5641acdbe8ad1dcb5a.1401691974.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
In-Reply-To: <4139797fe7501ba99adf63ec8e5cf9fa9b24c197.1401191054.git.viresh.kumar@linaro.org>
References: <4139797fe7501ba99adf63ec8e5cf9fa9b24c197.1401191054.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All callers of of_init_opp_table() are required to take reference of
dev->of_node, by initiating calls to of_node_{get|put}(), before and after
calling of_init_opp_table().

Its better to call these from within of_init_opp_table(), no fun adding
redundant code to every caller.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
V4->V5: do of_node_put() on errors as well

 drivers/base/power/opp.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index 89ced95..28696af 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -643,13 +643,21 @@ int of_init_opp_table(struct device *dev)
 {
 	const struct property *prop;
 	const __be32 *val;
-	int nr;
+	int nr, ret = 0;
 
-	prop = of_find_property(dev->of_node, "operating-points", NULL);
-	if (!prop)
+	if (!of_node_get(dev->of_node))
 		return -ENODEV;
-	if (!prop->value)
-		return -ENODATA;
+
+	prop = of_find_property(dev->of_node, "operating-points", NULL);
+	if (!prop) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	if (!prop->value) {
+		ret = -ENODATA;
+		goto out;
+	}
 
 	/*
 	 * Each OPP is a set of tuples consisting of frequency and
@@ -658,7 +666,8 @@ int of_init_opp_table(struct device *dev)
 	nr = prop->length / sizeof(u32);
 	if (nr % 2) {
 		dev_err(dev, "%s: Invalid OPP list\n", __func__);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	val = prop->value;
@@ -672,6 +681,8 @@ int of_init_opp_table(struct device *dev)
 		nr -= 2;
 	}
 
+out:
+	of_node_put(dev->of_node);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(of_init_opp_table);
-- 
2.0.0.rc2

