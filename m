Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaDOPib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 11:38:31 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:41430 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbaDOPi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 11:38:29 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: devicetree@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] of: Clean up of_update_property
Date: Tue, 15 Apr 2014 08:38:17 -0700
Message-Id: <1397576297-4785-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After searching for the old property, bail out with -ENODEV
if it was not found.

It is unnecessary to check if oldprop is NULL before removing
its binary file; the check was already done before.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/of/base.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index f72d19b..6d4ee22 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1828,17 +1828,13 @@ int of_update_property(struct device_node *np, struct property *newprop)
 		next = &(*next)->next;
 	}
 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
-	if (rc)
-		return rc;
+	if (!found)
+		return -ENODEV;
 
 	/* Update the sysfs attribute */
-	if (oldprop)
-		sysfs_remove_bin_file(&np->kobj, &oldprop->attr);
+	sysfs_remove_bin_file(&np->kobj, &oldprop->attr);
 	__of_add_property_sysfs(np, newprop);
 
-	if (!found)
-		return -ENODEV;
-
 	return 0;
 }
 
-- 
1.7.9.7

