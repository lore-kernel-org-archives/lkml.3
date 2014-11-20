Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbaKTPk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:40:59 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:62306 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaKTPk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:40:57 -0500
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Gaurav Minocha <gaurav.minocha.os@gmail.com>, <stable@vger.kernel.org>
Subject: [PATCH] of/selftest: Fix testing when /aliases is missing
Date: Thu, 20 Nov 2014 15:40:30 +0000
Message-Id: <1416498030-5878-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The /aliases node isn't always present in the device tree, but the
unittest code assumes that /aliases is there. Add a check when inserting
the testcase data to see if of_aliases needs to be updated, and undo the
settings when the nodes are removed.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Gaurav Minocha <gaurav.minocha.os@gmail.com>
Cc: <stable@vger.kernel.org>
---
 drivers/of/selftest.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/of/selftest.c b/drivers/of/selftest.c
index e6c14dc400e9..e2d79afa9dc6 100644
--- a/drivers/of/selftest.c
+++ b/drivers/of/selftest.c
@@ -899,7 +899,11 @@ static void selftest_data_remove(void)
 	while (last_node_index-- > 0) {
 		if (nodes[last_node_index]) {
 			np = of_find_node_by_path(nodes[last_node_index]->full_name);
-			if (strcmp(np->full_name, "/aliases") != 0) {
+			if (np == nodes[last_node_index]) {
+				if (of_aliases == np) {
+					of_node_put(of_aliases);
+					of_aliases = NULL;
+				}
 				detach_node_and_children(np);
 			} else {
 				for_each_property_of_node(np, prop) {
@@ -920,6 +924,8 @@ static int __init of_selftest(void)
 	res = selftest_data_add();
 	if (res)
 		return res;
+	if (!of_aliases)
+		of_aliases = of_find_node_by_path("/aliases");
 
 	np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
 	if (!np) {
-- 
1.9.1

