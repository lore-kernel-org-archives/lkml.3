Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab3H2MoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 08:44:08 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:60206 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755081Ab3H2MoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 08:44:06 -0400
From: Rob Herring <robherring2@gmail.com>
To: xen-devel@lists.xensource.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: julien.grall@linaro.org, Rob Herring <rob.herring@calxeda.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v3] ARM: xen: only set pm function ptrs for Xen guests
Date: Thu, 29 Aug 2013 07:43:52 -0500
Message-Id: <1377780232-13545-1-git-send-email-robherring2@gmail.com>
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
index 8a6295c..7071fca 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -273,12 +273,15 @@ core_initcall(xen_guest_init);
 
 static int __init xen_pm_init(void)
 {
+	if (!xen_domain())
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

