Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804Ab3BKWTW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 17:19:22 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37223 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932711Ab3BKWTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 17:19:21 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Rob Herring <robherring2@gmail.com>
Subject: [PATCH] of: Fix locking when calling of_get_next_available_child()
Date: Mon, 11 Feb 2013 22:19:17 +0000
Message-Id: <1360621157-23570-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_get_next_available_child() obtains the devtree_lock and then calls
of_device_is_available() which also attempts to claim the lock. This is
obviously incorrect and causes a deadlock on boot. Fix issue by adding
an variant of of_device_is_available() which doesn't obtain the lock.

Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: Rob Herring <robherring2@gmail.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/of/base.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index e8d65af..4af74b7 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -297,7 +297,7 @@ EXPORT_SYMBOL(of_machine_is_compatible);
  *  Returns 1 if the status property is absent or set to "okay" or "ok",
  *  0 otherwise
  */
-int of_device_is_available(const struct device_node *device)
+int __of_device_is_available(const struct device_node *device)
 {
 	const char *status;
 	int statlen;
@@ -313,6 +313,17 @@ int of_device_is_available(const struct device_node *device)
 
 	return 0;
 }
+
+int of_device_is_available(const struct device_node *device)
+{
+	unsigned long flags;
+	int rc;
+
+	raw_spin_lock_irqsave(&devtree_lock, flags);
+	rc = __of_device_is_available(device);
+	raw_spin_unlock_irqrestore(&devtree_lock, flags);
+	return rc;
+}
 EXPORT_SYMBOL(of_device_is_available);
 
 /**
@@ -404,7 +415,7 @@ struct device_node *of_get_next_available_child(const struct device_node *node,
 	raw_spin_lock(&devtree_lock);
 	next = prev ? prev->sibling : node->child;
 	for (; next; next = next->sibling) {
-		if (!of_device_is_available(next))
+		if (!__of_device_is_available(next))
 			continue;
 		if (of_node_get(next))
 			break;
-- 
1.7.10.4

