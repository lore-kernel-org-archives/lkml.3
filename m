Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab3HTKBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 06:01:00 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:41209 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab3HTKA7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 06:00:59 -0400
Date: Tue, 20 Aug 2013 12:01:05 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] of: reduce the number of PROBE_DEFERs
Message-ID: <20130820120105.55a4c0ce@armhf>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch populates the platform from the device tree into two steps:
the first step creates the nodes that are referenced by a phandle,
the second step creates the other nodes.

This permits to reduce the number of PROBE_DEFERs.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
A better way to reduce probe deferral could be sorting the nodes
according to their phandle level in the DT blob at compilation time ...
---
 drivers/of/platform.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index e0a6514..a2ea858 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -382,8 +382,23 @@ static int of_platform_bus_create(struct device_node *bus,
 	if (!dev || !of_match_node(matches, bus))
 		return 0;
 
+	/* first step: create the nodes that are referenced by phandle */
 	for_each_child_of_node(bus, child) {
-		pr_debug("   create child: %s\n", child->full_name);
+		if (child->phandle == 0)
+			continue;
+		pr_debug("   create child 1: %s\n", child->full_name);
+		rc = of_platform_bus_create(child, matches, lookup, &dev->dev, strict);
+		if (rc) {
+			of_node_put(child);
+			return rc;
+		}
+	}
+
+	/* second step: create the other nodes */
+	for_each_child_of_node(bus, child) {
+		if (child->phandle != 0)
+			continue;
+		pr_debug("   create child 2: %s\n", child->full_name);
 		rc = of_platform_bus_create(child, matches, lookup, &dev->dev, strict);
 		if (rc) {
 			of_node_put(child);


-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
