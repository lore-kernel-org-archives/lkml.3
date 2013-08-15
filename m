Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755643Ab3HOK6O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 06:58:14 -0400
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:15641
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755378Ab3HOK6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 06:58:11 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: Dong Aisheng <b29396@freescale.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 1/3] of: add device node status update APIs
Date: Thu, 15 Aug 2013 18:55:31 +0800
Message-ID: <1376564133-11286-2-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1376564133-11286-1-git-send-email-b29396@freescale.com>
References: <1376564133-11286-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used for convineniently update the device node status.

Signed-off-by: Dong Aisheng <b29396@freescale.com>
---
 drivers/of/base.c  |   74 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/of.h |    5 +++
 2 files changed, 79 insertions(+), 0 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 5c54279..f944a54 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1424,6 +1424,80 @@ int of_update_property(struct device_node *np, struct property *newprop)
 	return 0;
 }
 
+/* update the node status property to be "enabled" or "disabled" */
+static int of_node_status_update(struct device_node *np, bool enable)
+{
+	struct property *oldprop;
+	struct property *newprop;
+	int ret;
+
+	if (of_device_is_available(np) == enable)
+		return 0;
+
+	oldprop = of_find_property(np, "status", NULL);
+
+	if (enable) {
+		/* for disabled node, there must be a status property with "disabled" state */
+		ret = of_remove_property(np, oldprop);
+	} else {
+		newprop = kzalloc(sizeof(*newprop), GFP_KERNEL);
+		if (!newprop)
+			return -ENOMEM;
+
+		newprop->name = kstrdup("status", GFP_KERNEL);
+		newprop->value = kstrdup("disabled", GFP_KERNEL);
+		newprop->length = 9;
+		if (!newprop->name || !newprop->value) {
+			kfree(newprop->name);
+			kfree(newprop->value);
+			kfree(newprop);
+			return -ENOMEM;
+		}
+
+		ret = of_update_property(np, newprop);
+	}
+
+	pr_debug("%s:  %s --> %s %s\n", np->full_name, enable ?
+		"disabled" : "enabled", enable ? "enabled" : "disabled",
+		ret ? "failed" : "okay");
+
+	return ret;
+}
+
+int of_node_status_disable(struct device_node *np)
+{
+	return of_node_status_update(np, 0);
+}
+
+int of_node_status_enable(struct device_node *np)
+{
+	return of_node_status_update(np, 1);
+}
+
+int of_node_status_disable_by_path(const char *path)
+{
+	struct device_node *np;
+
+	pr_debug("disable node: %s\n", path);
+	np = of_find_node_by_path(path);
+	if (!np)
+		return -ENODEV;
+
+	return of_node_status_update(np, 0);
+}
+
+int of_node_status_enable_by_path(const char *path)
+{
+	struct device_node *np;
+
+	pr_debug("enable node: %s\n", path);
+	np = of_find_node_by_path(path);
+	if (!np)
+		return -ENODEV;
+
+	return of_node_status_update(np, 1);
+}
+
 #if defined(CONFIG_OF_DYNAMIC)
 /*
  * Support for dynamic device trees.
diff --git a/include/linux/of.h b/include/linux/of.h
index 1fd08ca..61b35fe 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -292,6 +292,11 @@ extern int of_add_property(struct device_node *np, struct property *prop);
 extern int of_remove_property(struct device_node *np, struct property *prop);
 extern int of_update_property(struct device_node *np, struct property *newprop);
 
+extern int of_node_status_disable(struct device_node *np);
+extern int of_node_status_enable(struct device_node *np);
+extern int of_node_status_disable_by_path(const char *path);
+extern int of_node_status_enable_by_path(const char *path);
+
 /* For updating the device tree at runtime */
 #define OF_RECONFIG_ATTACH_NODE		0x0001
 #define OF_RECONFIG_DETACH_NODE		0x0002
-- 
1.7.1


