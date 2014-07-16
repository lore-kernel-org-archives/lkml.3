Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760767AbaGPIhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:37:19 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35106 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760709AbaGPIhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:37:01 -0400
From: Lokesh Vutla <lokeshvutla@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <tony@atomide.com>, <paul@pwsan.com>, <linux@arm.linux.org.uk>,
        <nsekhar@ti.com>, <j-keerthy@ti.com>, <nm@ti.com>, <rogerq@ti.com>,
        <lokeshvutla@ti.com>
Subject: [PATCH 2/2] ARM: DRA7: hwmod: Add dra74x and dra72x specific ocp interface lists
Date: Wed, 16 Jul 2014 14:06:14 +0530
Message-ID: <1405499774-19770-3-git-send-email-lokeshvutla@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405499774-19770-1-git-send-email-lokeshvutla@ti.com>
References: <1405499774-19770-1-git-send-email-lokeshvutla@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rajendra Nayak <rnayak@ti.com>

To deal with IPs which are specific to dra74x and dra72x, maintain seperate
ocp interface lists, while keeping the common list for all common IPs.

Move USB OTG SS4 to dra74x only list since its unavailable in
dra72x and is giving an abort during boot. The dra72x only list
is empty for now and a placeholder for future hwmod additions which
are specific to dra72x.

Fixes: d904b38 ARM: DRA7: hwmod: Add SYSCONFIG for usb_otg_ss
Reported-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Rajendra Nayak <rnayak@ti.com>
Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
 arch/arm/mach-omap2/omap_hwmod.c          |    3 +++
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c |   22 ++++++++++++++++++++--
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index 6c074f3..14f8370 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -3345,6 +3345,9 @@ int __init omap_hwmod_register_links(struct omap_hwmod_ocp_if **ois)
 	if (!ois)
 		return 0;
 
+	if (ois[0] == NULL) /*empty list*/
+		return 0;
+
 	if (!linkspace) {
 		if (_alloc_linkspace(ois)) {
 			pr_err("omap_hwmod: could not allocate link space\n");
diff --git a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
index 284324f..c95033c 100644
--- a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
@@ -35,6 +35,7 @@
 #include "i2c.h"
 #include "mmc.h"
 #include "wd_timer.h"
+#include "soc.h"
 
 /* Base offset for all DRA7XX interrupts external to MPUSS */
 #define DRA7XX_IRQ_GIC_START	32
@@ -2705,7 +2706,6 @@ static struct omap_hwmod_ocp_if *dra7xx_hwmod_ocp_ifs[] __initdata = {
 	&dra7xx_l4_per3__usb_otg_ss1,
 	&dra7xx_l4_per3__usb_otg_ss2,
 	&dra7xx_l4_per3__usb_otg_ss3,
-	&dra7xx_l4_per3__usb_otg_ss4,
 	&dra7xx_l3_main_1__vcp1,
 	&dra7xx_l4_per2__vcp1,
 	&dra7xx_l3_main_1__vcp2,
@@ -2714,8 +2714,26 @@ static struct omap_hwmod_ocp_if *dra7xx_hwmod_ocp_ifs[] __initdata = {
 	NULL,
 };
 
+static struct omap_hwmod_ocp_if *dra74x_hwmod_ocp_ifs[] __initdata = {
+	&dra7xx_l4_per3__usb_otg_ss4,
+	NULL,
+};
+
+static struct omap_hwmod_ocp_if *dra72x_hwmod_ocp_ifs[] __initdata = {
+	NULL,
+};
+
 int __init dra7xx_hwmod_init(void)
 {
+	int ret;
+
 	omap_hwmod_init();
-	return omap_hwmod_register_links(dra7xx_hwmod_ocp_ifs);
+	ret = omap_hwmod_register_links(dra7xx_hwmod_ocp_ifs);
+
+	if (!ret && soc_is_dra74x())
+		return omap_hwmod_register_links(dra74x_hwmod_ocp_ifs);
+	else if (!ret && soc_is_dra72x())
+		return omap_hwmod_register_links(dra72x_hwmod_ocp_ifs);
+
+	return ret;
 }
-- 
1.7.9.5

