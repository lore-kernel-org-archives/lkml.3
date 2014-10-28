Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbaJ1Ue4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 16:34:56 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:41019 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbaJ1UeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:34:15 -0400
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH 3/5] of: Only call notifiers when node is attached
Date: Tue, 28 Oct 2014 22:33:51 +0200
Message-Id: <1414528433-9650-4-git-send-email-pantelis.antoniou@konsulko.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1414528433-9650-1-git-send-email-pantelis.antoniou@konsulko.com>
References: <1414528433-9650-1-git-send-email-pantelis.antoniou@konsulko.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure we call notifier only when the node is attached.
When a detatched tree is being constructed we do not want the
notifiers to fire at all.

Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
---
 drivers/of/base.c    | 9 ++++++---
 drivers/of/dynamic.c | 5 +----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 2305dc0..a79d4ee 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1695,7 +1695,8 @@ int of_add_property(struct device_node *np, struct property *prop)
 
 	mutex_unlock(&of_mutex);
 
-	if (!rc)
+	/* only call notifiers if the node is attached and no error occurred */
+	if (of_node_is_attached(np) && !rc)
 		of_property_notify(OF_RECONFIG_ADD_PROPERTY, np, prop, NULL);
 
 	return rc;
@@ -1754,7 +1755,8 @@ int of_remove_property(struct device_node *np, struct property *prop)
 
 	mutex_unlock(&of_mutex);
 
-	if (!rc)
+	/* only call notifiers if the node is attached and no error occurred */
+	if (of_node_is_attached(np) && !rc)
 		of_property_notify(OF_RECONFIG_REMOVE_PROPERTY, np, prop, NULL);
 
 	return rc;
@@ -1830,7 +1832,8 @@ int of_update_property(struct device_node *np, struct property *newprop)
 
 	mutex_unlock(&of_mutex);
 
-	if (!rc)
+	/* only call notifiers if the node is attached and no error occurred */
+	if (of_node_is_attached(np) && !rc)
 		of_property_notify(OF_RECONFIG_UPDATE_PROPERTY, np, newprop, oldprop);
 
 	return rc;
diff --git a/drivers/of/dynamic.c b/drivers/of/dynamic.c
index f297891..8e8b614 100644
--- a/drivers/of/dynamic.c
+++ b/drivers/of/dynamic.c
@@ -90,10 +90,6 @@ int of_property_notify(int action, struct device_node *np,
 {
 	struct of_prop_reconfig pr;
 
-	/* only call notifiers if the node is attached */
-	if (!of_node_is_attached(np))
-		return 0;
-
 	pr.dn = np;
 	pr.prop = prop;
 	pr.old_prop = oldprop;
@@ -138,6 +134,7 @@ int of_attach_node(struct device_node *np)
 	__of_attach_node_sysfs(np);
 	mutex_unlock(&of_mutex);
 
+	/* node is guaranteed to be attached at this point */
 	of_reconfig_notify(OF_RECONFIG_ATTACH_NODE, np);
 
 	return 0;
-- 
1.7.12

