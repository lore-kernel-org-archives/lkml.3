Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205Ab3JONbV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 09:31:21 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:44991 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758853Ab3JONbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 09:31:20 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH v2] of: fix iteration bug over CPU reg properties
Date: Tue, 15 Oct 2013 14:30:53 +0100
Message-Id: <1381843853-13871-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The size of each hwid in a cpu nodes 'reg' property is defined by the
parents #address-cells property in the normal way. The cpu parsing code
has a bug where it will overrun the end of the property if
address-cells is greater than one. This commit fixes the problem by
adjusting the array size by the number of address cells. It also makes
sure address-cells isn't zero for that would cause an infinite loop.

v2: bail if #address-cells is zero instead of forcing to
    OF_ROOT_NODE_ADDR_CELLS_DEFAULT. Forcing it will cause the reg
    property to be parsed incorrectly.
Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 drivers/of/base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 15c4b59..a96f850 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -272,9 +272,9 @@ static bool __of_find_n_match_cpu_property(struct device_node *cpun,
 
 	ac = of_n_addr_cells(cpun);
 	cell = of_get_property(cpun, prop_name, &prop_len);
-	if (!cell)
+	if (!cell || !ac)
 		return false;
-	prop_len /= sizeof(*cell);
+	prop_len /= sizeof(*cell) * ac;
 	for (tid = 0; tid < prop_len; tid++) {
 		hwid = of_read_number(cell, ac);
 		if (arch_match_cpu_phys_id(cpu, hwid)) {
-- 
1.8.1.2

