Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538Ab3CDVPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 16:15:54 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:16510 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758173Ab3CDVPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 16:15:52 -0500
From: Daniel Kiper <daniel.kiper@oracle.com>
To: carsten@schiers.de, darren.s.shepherd@gmail.com, david.vrabel@citrix.com,
        james-xen@dingwall.me.uk, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH 1/1] xen/balloon: Enforce various limits on target
Date: Mon,  4 Mar 2013 22:14:51 +0100
Message-Id: <1362431691-5167-1-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.7.10.4
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enforces on target limit statically defined in Linux Kernel
source and limit defined by hypervisor or host.

Particularly this patch fixes bug which led to flood
of dom0 kernel log with messages similar to:

System RAM resource [mem 0x1b8000000-0x1bfffffff] cannot be added
xen_balloon: reserve_additional_memory: add_memory() failed: -17

It does not allow balloon driver to execute infinite
loops when target exceeds limits in other cases too.

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 drivers/xen/balloon.c |   47 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index a56776d..07da753 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -65,6 +65,7 @@
 #include <xen/balloon.h>
 #include <xen/features.h>
 #include <xen/page.h>
+#include <xen/xenbus.h>
 
 /*
  * balloon_process() state:
@@ -490,11 +491,55 @@ static void balloon_process(struct work_struct *work)
 	mutex_unlock(&balloon_mutex);
 }
 
-/* Resets the Xen limit, sets new target, and kicks off processing. */
+/* Enforce limits, set new target and kick off processing. */
 void balloon_set_new_target(unsigned long target)
 {
+	domid_t domid = DOMID_SELF;
+	int rc;
+	unsigned long long host_limit;
+
+	/* Enforce statically defined limit. */
+	target = min(target, MAX_DOMAIN_PAGES);
+
+	if (xen_initial_domain()) {
+		rc = HYPERVISOR_memory_op(XENMEM_maximum_reservation, &domid);
+
+		/* Limit is not enforced by hypervisor. */
+		if (rc == -EPERM)
+			goto no_host_limit;
+
+		if (rc <= 0) {
+			pr_info("xen_balloon: %s: Initial domain target limit "
+				"could not be established: %i\n", __func__, rc);
+			goto no_host_limit;
+		}
+
+		host_limit = rc;
+	} else {
+		rc = xenbus_scanf(XBT_NIL, "memory", "static-max",
+							"%llu", &host_limit);
+
+		if (rc != 1) {
+			pr_info("xen_balloon: %s: Guest domain target limit "
+				"could not be established: %i\n", __func__, rc);
+			goto no_host_limit;
+		}
+
+		/*
+		 * The given memory target limit value is in KiB, so it needs
+		 * converting to pages. PAGE_SHIFT converts bytes to pages,
+		 * hence PAGE_SHIFT - 10.
+		 */
+		host_limit >>= (PAGE_SHIFT - 10);
+	}
+
+	/* Enforce hypervisor/host defined limit. */
+	target = min(target, (unsigned long)host_limit);
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

