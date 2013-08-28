Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab3H1SUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:20:19 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:62351 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab3H1SUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:20:14 -0400
From: Rob Herring <robherring2@gmail.com>
To: xen-devel@lists.xensource.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: julien.grall@linaro.org, Rob Herring <rob.herring@calxeda.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v2] ARM: xen: only set pm function ptrs for Xen guests
Date: Wed, 28 Aug 2013 13:20:03 -0500
Message-Id: <1377714003-22096-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

xen_pm_init was unconditionally setting pm_power_off and arm_pm_restart
function pointers. This breaks multi-platform kernels. Make this
conditional on running as a Xen guest and make it a late_initcall to
ensure it is setup after platform code for Dom0.

Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 arch/arm/xen/enlighten.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 8a6295c..13a7d1f 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -273,12 +273,15 @@ core_initcall(xen_guest_init);
 
 static int __init xen_pm_init(void)
 {
+	if (!of_find_compatible_node(NULL, NULL, "xen,xen"))
+		return -ENODEV;
+
 	pm_power_off = xen_power_off;
 	arm_pm_restart = xen_restart;
 
 	return 0;
 }
-subsys_initcall(xen_pm_init);
+late_initcall(xen_pm_init);
 
 static irqreturn_t xen_arm_callback(int irq, void *arg)
 {
-- 
1.8.1.2

