Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892Ab3ANRSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 12:18:46 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:60924 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757698Ab3ANRSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 12:18:20 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] clk: mvebu/clk-cpu.c: fix memory leakage
Date: Mon, 14 Jan 2013 17:18:07 +0000
Message-Id: <1358183892-28928-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the variable cpuclk and clk_name should be properly freed.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 drivers/clk/mvebu/clk-cpu.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/mvebu/clk-cpu.c b/drivers/clk/mvebu/clk-cpu.c
index ff004578..1a0d84f 100644
--- a/drivers/clk/mvebu/clk-cpu.c
+++ b/drivers/clk/mvebu/clk-cpu.c
@@ -124,7 +124,7 @@ void __init of_cpu_clk_setup(struct device_node *node)
 
 	clks = kzalloc(ncpus * sizeof(*clks), GFP_KERNEL);
 	if (WARN_ON(!clks))
-		return;
+		goto clks_out;
 
 	for_each_node_by_type(dn, "cpu") {
 		struct clk_init_data init;
@@ -134,11 +134,11 @@ void __init of_cpu_clk_setup(struct device_node *node)
 		int cpu, err;
 
 		if (WARN_ON(!clk_name))
-			return;
+			goto clk_name_out;
 
 		err = of_property_read_u32(dn, "reg", &cpu);
 		if (WARN_ON(err))
-			return;
+			goto bail_out;
 
 		sprintf(clk_name, "cpu%d", cpu);
 		parent_clk = of_clk_get(node, 0);
@@ -166,7 +166,10 @@ void __init of_cpu_clk_setup(struct device_node *node)
 
 	return;
 bail_out:
+	kfree(clk_name);
+clk_name_out:
 	kfree(clks);
+clks_out:
 	kfree(cpuclk);
 }
 
-- 
1.7.9.5

