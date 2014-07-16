Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759202AbaGPLWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 07:22:07 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:51098 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445AbaGPLWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 07:22:05 -0400
From: Alex Shi <alex.shi@linaro.org>
To: linux@arm.linux.org.uk
Cc: pawel.moll@arm.com, nico@linaro.org, sudeep.karkadanagesha@arm.com,
        viresh.kumar@linaro.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, mark.brown@linaro.org, tixy@linaro.org
Subject: [PATCH] vexpress/spc: fix a build warning on array bounds
Date: Wed, 16 Jul 2014 19:21:56 +0800
Message-Id: <1405509716-19591-1-git-send-email-alex.shi@linaro.org>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With ARCH_VEXPRESS_SPC option, kernel build has the following 
warning:

arch/arm/mach-vexpress/spc.c: In function ‘ve_spc_clk_init’:
arch/arm/mach-vexpress/spc.c:431:38: warning: array subscript is below array bounds [-Warray-bounds]
  struct ve_spc_opp *opps = info->opps[cluster];
                                      ^
since 'cluster' maybe '-1' in UP system. This patch does a active
checking to fix this issue.

Signed-off-by: Alex Shi <alex.shi@linaro.org>
---
 arch/arm/mach-vexpress/spc.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-vexpress/spc.c b/arch/arm/mach-vexpress/spc.c
index c26ef5b..4833544 100644
--- a/arch/arm/mach-vexpress/spc.c
+++ b/arch/arm/mach-vexpress/spc.c
@@ -426,9 +426,15 @@ static int ve_spc_populate_opps(uint32_t cluster)
 
 static int ve_init_opp_table(struct device *cpu_dev)
 {
-	int cluster = topology_physical_package_id(cpu_dev->id);
-	int idx, ret = 0, max_opp = info->num_opps[cluster];
-	struct ve_spc_opp *opps = info->opps[cluster];
+	int cluster;
+	int idx, ret = 0, max_opp;
+	struct ve_spc_opp *opps;
+
+	cluster = topology_physical_package_id(cpu_dev->id);
+	cluster = cluster < 0 ? 0 : cluster;
+
+	max_opp = info->num_opps[cluster];
+	opps = info->opps[cluster];
 
 	for (idx = 0; idx < max_opp; idx++, opps++) {
 		ret = dev_pm_opp_add(cpu_dev, opps->freq * 1000, opps->u_volt);
@@ -537,6 +543,8 @@ static struct clk *ve_spc_clk_register(struct device *cpu_dev)
 	spc->hw.init = &init;
 	spc->cluster = topology_physical_package_id(cpu_dev->id);
 
+	spc->cluster = spc->cluster < 0 ? 0 : spc->cluster;
+
 	init.name = dev_name(cpu_dev);
 	init.ops = &clk_spc_ops;
 	init.flags = CLK_IS_ROOT | CLK_GET_RATE_NOCACHE;
-- 
1.9.1

