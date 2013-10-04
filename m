Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab3JGMDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 08:03:11 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:60619 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab3JGMCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 08:02:50 -0400
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH] of: fix iteration bug over CPU reg properties
Date: Fri,  4 Oct 2013 17:40:02 +0100
Message-Id: <1380904802-10432-1-git-send-email-grant.likely@linaro.org>
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

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

I discovered this during code inspection. I don't think it is an actual
bug seen in the wild, but the code does look wrong. I'd appreciate
someone take a look and confirm that I've read the code right.

 drivers/of/base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index e4c9945..470b871 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -263,11 +263,11 @@ static bool __of_find_n_match_cpu_property(struct device_node *cpun,
 	int ac, prop_len, tid;
 	u64 hwid;
 
-	ac = of_n_addr_cells(cpun);
+	ac = of_n_addr_cells(cpun) ? : OF_ROOT_NODE_ADDR_CELLS_DEFAULT;
 	cell = of_get_property(cpun, prop_name, &prop_len);
 	if (!cell)
 		return false;
-	prop_len /= sizeof(*cell);
+	prop_len /= sizeof(*cell) * ac;
 	for (tid = 0; tid < prop_len; tid++) {
 		hwid = of_read_number(cell, ac);
 		if (arch_match_cpu_phys_id(cpu, hwid)) {
-- 
1.8.1.2

