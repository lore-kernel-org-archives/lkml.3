Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab3JCUMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 16:12:53 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:61704 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748Ab3JCUMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 16:12:51 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, David Miller <davem@davemloft.net>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH] of: fix unnecessary warning on missing /cpus node
Date: Thu,  3 Oct 2013 21:12:29 +0100
Message-Id: <1380831149-15764-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all DT platforms have all the cpus collected under a /cpus node.
That just happens to be a details of FDT, ePAPR and PowerPC platforms.
Sparc does something different, but unfortunately the current code
complains with a warning if /cpus isn't there. This became a problem
with commit f86e4718, "driver/core cpu: initialize of_node in cpu's
device structure", which caused the function to get called for all
architectures.

This commit is a temporary fix to fail silently if the cpus node isn't
present. A proper fix will come later to allow arch code to provide a
custom mechanism for decoding the CPU hwid if the 'reg' property isn't
appropriate.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: David Miller <davem@davemloft.net>
Cc: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Cc: Rob Herring <rob.herring@calxeda.com>
---
 drivers/of/base.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 865d3f6..7d4c70f 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -303,10 +303,8 @@ struct device_node *of_get_cpu_node(int cpu, unsigned int *thread)
 	struct device_node *cpun, *cpus;
 
 	cpus = of_find_node_by_path("/cpus");
-	if (!cpus) {
-		pr_warn("Missing cpus node, bailing out\n");
+	if (!cpus)
 		return NULL;
-	}
 
 	for_each_child_of_node(cpus, cpun) {
 		if (of_node_cmp(cpun->type, "cpu"))
-- 
1.8.1.2

