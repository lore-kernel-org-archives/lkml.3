Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205AbaJCXeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:34:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46443 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588AbaJCWDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:03:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Keerthy <j-keerthy@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Nishanth Menon <nm@ti.com>,
        Paul Walmsley <paul@pwsan.com>
Subject: [PATCH 3.14 111/238] ARM: DRA7: hwmod: Add dra74x and dra72x specific ocp interface lists
Date: Fri,  3 Oct 2014 14:30:26 -0700
Message-Id: <20141003212917.228415848@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rajendra Nayak <rnayak@ti.com>

commit f7f7a29bf0cf25af23f37e5b5bf1368b85705286 upstream.

To deal with IPs which are specific to dra74x and dra72x, maintain seperate
ocp interface lists, while keeping the common list for all common IPs.

Move USB OTG SS4 to dra74x only list since its unavailable in
dra72x and is giving an abort during boot. The dra72x only list
is empty for now and a placeholder for future hwmod additions which
are specific to dra72x.

Fixes: d904b38df0db13 ("ARM: DRA7: hwmod: Add SYSCONFIG for usb_otg_ss")
Reported-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Rajendra Nayak <rnayak@ti.com>
Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
Tested-by: Nishanth Menon <nm@ti.com>
[paul@pwsan.com: fixed comment style to conform with CodingStyle]
Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/omap_hwmod.c          |    3 +++
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c |   22 ++++++++++++++++++++--
 2 files changed, 23 insertions(+), 2 deletions(-)

--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -3349,6 +3349,9 @@ int __init omap_hwmod_register_links(str
 	if (!ois)
 		return 0;
 
+	if (ois[0] == NULL) /* Empty list */
+		return 0;
+
 	if (!linkspace) {
 		if (_alloc_linkspace(ois)) {
 			pr_err("omap_hwmod: could not allocate link space\n");
--- a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
@@ -35,6 +35,7 @@
 #include "i2c.h"
 #include "mmc.h"
 #include "wd_timer.h"
+#include "soc.h"
 
 /* Base offset for all DRA7XX interrupts external to MPUSS */
 #define DRA7XX_IRQ_GIC_START	32
@@ -2707,7 +2708,6 @@ static struct omap_hwmod_ocp_if *dra7xx_
 	&dra7xx_l4_per3__usb_otg_ss1,
 	&dra7xx_l4_per3__usb_otg_ss2,
 	&dra7xx_l4_per3__usb_otg_ss3,
-	&dra7xx_l4_per3__usb_otg_ss4,
 	&dra7xx_l3_main_1__vcp1,
 	&dra7xx_l4_per2__vcp1,
 	&dra7xx_l3_main_1__vcp2,
@@ -2716,8 +2716,26 @@ static struct omap_hwmod_ocp_if *dra7xx_
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


