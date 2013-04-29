Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab3D2Li1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 07:38:27 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32658 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab3D2LiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 07:38:25 -0400
From: Daniel Kiper <daniel.kiper@oracle.com>
To: carsten@schiers.de, darren.s.shepherd@gmail.com, david.vrabel@citrix.com,
        ian.campbell@citrix.com, ian.jackson@eu.citrix.com,
        james-xen@dingwall.me.uk, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH v2 2/2] xen/balloon: Enforce various limits on target
Date: Mon, 29 Apr 2013 13:37:48 +0200
Message-Id: <1367235468-8360-3-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367235468-8360-1-git-send-email-daniel.kiper@oracle.com>
References: <1367235468-8360-1-git-send-email-daniel.kiper@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enforces on target limit statically defined in Linux Kernel
source and limit defined by hypervisor or host. This way the balloon
driver should not attempt to populate pages above given limits
because they may fail.

Particularly this patch fixes bug which led to flood
of dom0 kernel log with messages similar to:

System RAM resource [mem 0x1b8000000-0x1bfffffff] cannot be added
xen_balloon: reserve_additional_memory: add_memory() failed: -17

v2 - suggestions/fixes:
   - always use maximum reservation as a refernce
     (suggested by David Vrabel),
   - change logging level for dom0
     (suggested by Konrad Rzeszutek Wilk),
   - improve commit comment
     (suggested by David Vrabel).

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 drivers/xen/balloon.c |   40 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 856661f..a3a8eaa 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -81,7 +81,6 @@ enum bp_state {
 	BP_ECANCELED
 };
 
-
 static DEFINE_MUTEX(balloon_mutex);
 
 struct balloon_stats balloon_stats;
@@ -90,6 +89,12 @@ EXPORT_SYMBOL_GPL(balloon_stats);
 /* We increase/decrease in batches which fit in a page */
 static xen_pfn_t frame_list[PAGE_SIZE / sizeof(unsigned long)];
 
+/*
+ * Extra internal memory reserved by libxl.
+ * Check tools/libxl/libxl_memory.txt file in Xen source for more details.
+ */
+#define LIBXL_MAXMEM_CONSTANT_PAGES	(1024 * 1024 / PAGE_SIZE)
+
 #ifdef CONFIG_HIGHMEM
 #define inc_totalhigh_pages() (totalhigh_pages++)
 #define dec_totalhigh_pages() (totalhigh_pages--)
@@ -491,11 +496,42 @@ static void balloon_process(struct work_struct *work)
 	mutex_unlock(&balloon_mutex);
 }
 
-/* Resets the Xen limit, sets new target, and kicks off processing. */
+/* Enforce limits, set new target and kick off processing. */
 void balloon_set_new_target(unsigned long target)
 {
+	domid_t domid = DOMID_SELF;
+	int rc;
+
+	/* Enforce statically defined limit. */
+	target = min(target, MAX_DOMAIN_PAGES);
+
+	rc = HYPERVISOR_memory_op(XENMEM_maximum_reservation, &domid);
+
+	if (xen_initial_domain()) {
+		if (rc <= 0) {
+			pr_debug("xen_balloon: %s: Initial domain target limit "
+					"could not be established: %i\n",
+					__func__, rc);
+			goto no_host_limit;
+		}
+	} else {
+		if (rc <= 0) {
+			pr_info("xen_balloon: %s: Guest domain target limit "
+				"could not be established: %i\n", __func__, rc);
+			goto no_host_limit;
+		}
+
+		/* Do not take into account memory reserved for internal stuff. */
+		rc -= LIBXL_MAXMEM_CONSTANT_PAGES;
+	}
+
+	/* Enforce hypervisor/host defined limit. */
+	target = min_t(unsigned long, target, rc);
+
+no_host_limit:
 	/* No need for lock. Not read-modify-write updates. */
 	balloon_stats.target_pages = target;
+
 	schedule_delayed_work(&balloon_worker, 0);
 }
 EXPORT_SYMBOL_GPL(balloon_set_new_target);
-- 
1.7.10.4

