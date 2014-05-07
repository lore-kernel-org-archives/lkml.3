Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaEGVsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 17:48:36 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:44934 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaEGVsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 17:48:30 -0400
From: Rob Herring <robherring2@gmail.com>
To: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Josh Cartwright <joshc@codeaurora.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn@kryo.se>, Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH 3/4] of/platform: fix device naming for non-translatable addresses
Date: Wed,  7 May 2014 16:48:17 -0500
Message-Id: <1399499298-8830-4-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399499298-8830-1-git-send-email-robherring2@gmail.com>
References: <1399499298-8830-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

Using non-translatable addresses in platform device names is wrong
because they may not be globally unique. Just use the default naming with
a global index if the address cannot be translated instead.

of_can_translate_address has the same checks as of_translate_address, so
we can remove it here as well.

Reported-by: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Josh Cartwright <joshc@codeaurora.org>
Cc: Courtney Cavin <courtney.cavin@sonymobile.com>
Cc: Bjorn Andersson <bjorn@kryo.se>
Cc: Frank Rowand <frowand.list@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Rob Herring <robh@kernel.org>
---
 drivers/of/platform.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 622aeb3..d827ceb 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -78,7 +78,6 @@ void of_device_make_bus_id(struct device *dev)
 	struct device_node *node = dev->of_node;
 	const __be32 *reg;
 	u64 addr;
-	const __be32 *addrp;
 	int magic;
 
 #ifdef CONFIG_PPC_DCR
@@ -106,15 +105,7 @@ void of_device_make_bus_id(struct device *dev)
 	 */
 	reg = of_get_property(node, "reg", NULL);
 	if (reg) {
-		if (of_can_translate_address(node)) {
-			addr = of_translate_address(node, reg);
-		} else {
-			addrp = of_get_address(node, 0, NULL, NULL);
-			if (addrp)
-				addr = of_read_number(addrp, 1);
-			else
-				addr = OF_BAD_ADDR;
-		}
+		addr = of_translate_address(node, reg);
 		if (addr != OF_BAD_ADDR) {
 			dev_set_name(dev, "%llx.%s",
 				     (unsigned long long)addr, node->name);
-- 
1.9.1

