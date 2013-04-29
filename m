Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab3D2LiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 07:38:20 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32616 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab3D2LiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 07:38:19 -0400
From: Daniel Kiper <daniel.kiper@oracle.com>
To: carsten@schiers.de, darren.s.shepherd@gmail.com, david.vrabel@citrix.com,
        ian.campbell@citrix.com, ian.jackson@eu.citrix.com,
        james-xen@dingwall.me.uk, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH v2 1/2] xen/balloon: Notify a host about a guest memory size limit
Date: Mon, 29 Apr 2013 13:37:47 +0200
Message-Id: <1367235468-8360-2-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367235468-8360-1-git-send-email-daniel.kiper@oracle.com>
References: <1367235468-8360-1-git-send-email-daniel.kiper@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Notify a host about a guest memory size limit.

Idea of this patch was discussed with Ian Campbell and Ian Jackson.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 drivers/xen/balloon.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index a56776d..856661f 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -65,6 +65,7 @@
 #include <xen/balloon.h>
 #include <xen/features.h>
 #include <xen/page.h>
+#include <xen/xenbus.h>
 
 /*
  * balloon_process() state:
@@ -586,6 +587,9 @@ static void __init balloon_add_region(unsigned long start_pfn,
 static int __init balloon_init(void)
 {
 	int i;
+#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
+	int rc;
+#endif
 
 	if (!xen_domain())
 		return -ENODEV;
@@ -621,6 +625,27 @@ static int __init balloon_init(void)
 			balloon_add_region(PFN_UP(xen_extra_mem[i].start),
 					   PFN_DOWN(xen_extra_mem[i].size));
 
+#ifdef CONFIG_XEN_BALLOON_MEMORY_HOTPLUG
+	/*
+	 * Notify a host about our memory size limit.
+	 *
+	 * The guest-max value is in KiB, so MAX_DOMAIN_PAGES should
+	 * be converted respectively. PAGE_SHIFT converts pages to bytes,
+	 * hence PAGE_SHIFT - 10.
+	 */
+	rc = xenbus_printf(XBT_NIL, "memory", "guest-max", "%lu",
+				MAX_DOMAIN_PAGES << (PAGE_SHIFT - 10));
+
+	if (rc < 0)
+		pr_info("xen/balloon: Memory hotplug may not be supported "
+			"in some environments: %i\n", rc);
+#else
+	xenbus_printf(XBT_NIL, "memory", "guest-max", "%lu",
+			(balloon_stats.current_pages +
+			 balloon_stats.balloon_low +
+			 balloon_stats.balloon_high) << (PAGE_SHIFT - 10));
+#endif
+
 	return 0;
 }
 
-- 
1.7.10.4

