Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab3KTMNB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 07:13:01 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49890 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab3KTMM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 07:12:57 -0500
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Mike Turquette <mturquette@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: Grygorii Strashko <grygorii.strashko@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] clk: keystone: gate: fix error handling on init
Date: Wed, 20 Nov 2013 14:09:01 +0200
Message-ID: <1384949341-26486-1-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes Keystone gate control clock driver initialization path:
1) clk_register_psc() returns error code and not a pure pointer, hence
its return value need to be checked using IS_ERR(clk) macro.

2) Mapped IO memory isn't unmapped in case of errors, hence fix it.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/clk/keystone/gate.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/keystone/gate.c b/drivers/clk/keystone/gate.c
index 1f333bc..17a5983 100644
--- a/drivers/clk/keystone/gate.c
+++ b/drivers/clk/keystone/gate.c
@@ -223,8 +223,7 @@ static void __init of_psc_clk_init(struct device_node *node, spinlock_t *lock)
 	data->domain_base = of_iomap(node, i);
 	if (!data->domain_base) {
 		pr_err("%s: domain ioremap failed\n", __func__);
-		iounmap(data->control_base);
-		goto out;
+		goto unmap_ctrl;
 	}
 
 	of_property_read_u32(node, "domain-id", &data->domain_id);
@@ -237,16 +236,21 @@ static void __init of_psc_clk_init(struct device_node *node, spinlock_t *lock)
 	parent_name = of_clk_get_parent_name(node, 0);
 	if (!parent_name) {
 		pr_err("%s: Parent clock not found\n", __func__);
-		goto out;
+		goto unmap_domain;
 	}
 
 	clk = clk_register_psc(NULL, clk_name, parent_name, data, lock);
-	if (clk) {
+	if (!IS_ERR(clk)) {
 		of_clk_add_provider(node, of_clk_src_simple_get, clk);
 		return;
 	}
 
 	pr_err("%s: error registering clk %s\n", __func__, node->name);
+
+unmap_domain:
+	iounmap(data->domain_base);
+unmap_ctrl:
+	iounmap(data->control_base);
 out:
 	kfree(data);
 	return;
-- 
1.7.9.5

