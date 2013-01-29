Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab3A2TB3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 14:01:29 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:56796 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab3A2TB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 14:01:26 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc: Axel Lin <axel.lin@ingics.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        AnilKumar Ch <anilkumar@ti.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: clear state each invocation of of_regulator_match
Date: Tue, 29 Jan 2013 12:01:13 -0700
Message-Id: <1359486073-26504-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

of_regulator_match() saves some dynamcially allocated state into the
match table that's passed to it. By implementation and not contract, for
each match table entry, if non-NULL state is already present,
of_regulator_match() will not overwrite it. of_regulator_match() is
typically called each time a regulator is probe()d. This means it is
called with the same match table over and over again if a regulator
triggers deferred probe. This results in stale, kfree()d data being left
in the match table from probe to probe, which causes a variety of crashes
or use of invalid data.

Explicitly free all output state from of_regulator_match() before
generating new results in order to avoid this.

Cc: stable@vger.kernel.org
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/regulator/of_regulator.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/regulator/of_regulator.c b/drivers/regulator/of_regulator.c
index 6f68491..66ca769 100644
--- a/drivers/regulator/of_regulator.c
+++ b/drivers/regulator/of_regulator.c
@@ -120,6 +120,12 @@ int of_regulator_match(struct device *dev, struct device_node *node,
 	if (!dev || !node)
 		return -EINVAL;
 
+	for (i = 0; i < num_matches; i++) {
+		struct of_regulator_match *match = &matches[i];
+		match->init_data = NULL;
+		match->of_node = NULL;
+	}
+
 	for_each_child_of_node(node, child) {
 		name = of_get_property(child,
 					"regulator-compatible", NULL);
-- 
1.7.10.4

