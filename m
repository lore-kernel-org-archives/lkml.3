Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388Ab3H1QUI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 12:20:08 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:34370 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab3H1QUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 12:20:07 -0400
From: Rob Herring <robherring2@gmail.com>
To: xen-devel@lists.xensource.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH] ARM: xen: only set pm function ptrs for Xen guests
Date: Wed, 28 Aug 2013 11:19:54 -0500
Message-Id: <1377706794-8481-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

xen_pm_init was unconditionally setting pm_power_off and arm_pm_restart
function pointers. This breaks multi-platform kernels. Move this
initialization into xen_guest_init, so it is conditional on running as a
Xen guest.

Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
This breaks reset and poweroff for Midway when Xen is enabled. This 
should go into 3.11 or stable.

Rob

 arch/arm/xen/enlighten.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 8a6295c..fa86452 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -263,6 +263,9 @@ static int __init xen_guest_init(void)
 	if (xen_vcpu_info == NULL)
 		return -ENOMEM;
 
+	pm_power_off = xen_power_off;
+	arm_pm_restart = xen_restart;
+
 	gnttab_init();
 	if (!xen_initial_domain())
 		xenbus_probe(NULL);
@@ -271,15 +274,6 @@ static int __init xen_guest_init(void)
 }
 core_initcall(xen_guest_init);
 
-static int __init xen_pm_init(void)
-{
-	pm_power_off = xen_power_off;
-	arm_pm_restart = xen_restart;
-
-	return 0;
-}
-subsys_initcall(xen_pm_init);
-
 static irqreturn_t xen_arm_callback(int irq, void *arg)
 {
 	xen_hvm_evtchn_do_upcall();
-- 
1.8.1.2

