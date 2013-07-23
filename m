Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979Ab3GWR1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 13:27:53 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:26966 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071Ab3GWR1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 13:27:52 -0400
X-IronPort-AV: E=Sophos;i="4.89,729,1367971200"; 
   d="scan'208";a="36903615"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <konrad.wilk@oracle.com>, <stefano.stabellini@eu.citrix.com>,
        <alex@alex.org.uk>, <dcrisan@flexiant.com>, <ian.campbell@citrix.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 1/2] xen/balloon: set a mapping for ballooned out pages
Date: Tue, 23 Jul 2013 18:27:45 +0100
Message-ID: <1374600466-3229-1-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1307231820570.4893@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1307231820570.4893@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently ballooned out pages are mapped to 0 and have INVALID_P2M_ENTRY
in the p2m. These ballooned out pages are used to map foreign grants
by gntdev and blkback (see alloc_xenballooned_pages).

Allocate a page per cpu and map all the ballooned out pages to the
corresponding mfn. Set the p2m accordingly. This way reading from a
ballooned out page won't cause a kernel crash (see
http://lists.xen.org/archives/html/xen-devel/2012-12/msg01154.html).

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: alex@alex.org.uk
CC: dcrisan@flexiant.com
---
 drivers/xen/balloon.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++--
 include/xen/balloon.h |    3 ++
 2 files changed, 58 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 930fb68..b9260dd 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -36,6 +36,7 @@
  * IN THE SOFTWARE.
  */
 
+#include <linux/cpu.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/errno.h>
@@ -50,6 +51,7 @@
 #include <linux/notifier.h>
 #include <linux/memory.h>
 #include <linux/memory_hotplug.h>
+#include <linux/percpu-defs.h>
 
 #include <asm/page.h>
 #include <asm/pgalloc.h>
@@ -88,6 +90,8 @@ EXPORT_SYMBOL_GPL(balloon_stats);
 
 /* We increase/decrease in batches which fit in a page */
 static xen_pfn_t frame_list[PAGE_SIZE / sizeof(unsigned long)];
+static DEFINE_PER_CPU(struct page *, balloon_scratch_page);
+
 
 #ifdef CONFIG_HIGHMEM
 #define inc_totalhigh_pages() (totalhigh_pages++)
@@ -423,7 +427,8 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
 		if (xen_pv_domain() && !PageHighMem(page)) {
 			ret = HYPERVISOR_update_va_mapping(
 				(unsigned long)__va(pfn << PAGE_SHIFT),
-				__pte_ma(0), 0);
+				pfn_pte(page_to_pfn(__get_cpu_var(balloon_scratch_page)),
+					PAGE_KERNEL_RO), 0);
 			BUG_ON(ret);
 		}
 #endif
@@ -436,7 +441,8 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
 	/* No more mappings: invalidate P2M and add to balloon. */
 	for (i = 0; i < nr_pages; i++) {
 		pfn = mfn_to_pfn(frame_list[i]);
-		__set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
+		__set_phys_to_machine(pfn,
+				pfn_to_mfn(page_to_pfn(__get_cpu_var(balloon_scratch_page))));
 		balloon_append(pfn_to_page(pfn));
 	}
 
@@ -491,6 +497,18 @@ static void balloon_process(struct work_struct *work)
 	mutex_unlock(&balloon_mutex);
 }
 
+struct page* get_balloon_scratch_page(void)
+{
+	struct page *ret = get_cpu_var(balloon_scratch_page);
+	BUG_ON(ret == NULL);
+	return ret;
+}
+
+void put_balloon_scratch_page(void)
+{
+	put_cpu_var(balloon_scratch_page);
+}
+
 /* Resets the Xen limit, sets new target, and kicks off processing. */
 void balloon_set_new_target(unsigned long target)
 {
@@ -584,13 +602,47 @@ static void __init balloon_add_region(unsigned long start_pfn,
 	}
 }
 
+static int __cpuinit balloon_cpu_notify(struct notifier_block *self,
+				    unsigned long action, void *hcpu)
+{
+	int cpu = (long)hcpu;
+	switch (action) {
+	case CPU_UP_PREPARE:
+		if (per_cpu(balloon_scratch_page, cpu) != NULL)
+			break;
+		per_cpu(balloon_scratch_page, cpu) = alloc_page(GFP_KERNEL);
+		if (per_cpu(balloon_scratch_page, cpu) == NULL) {
+			pr_warn("Failed to allocate balloon_scratch_page for cpu %d\n", cpu);
+			return NOTIFY_BAD;
+		}
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block balloon_cpu_notifier __cpuinitdata = {
+	.notifier_call	= balloon_cpu_notify,
+};
+
 static int __init balloon_init(void)
 {
-	int i;
+	int i, cpu;
 
 	if (!xen_domain())
 		return -ENODEV;
 
+	for_each_online_cpu(cpu)
+	{
+		per_cpu(balloon_scratch_page, cpu) = alloc_page(GFP_KERNEL);
+		if (per_cpu(balloon_scratch_page, cpu) == NULL) {
+			pr_warn("Failed to allocate balloon_scratch_page for cpu %d\n", cpu);
+			return -ENOMEM;
+		}
+	}
+	register_cpu_notifier(&balloon_cpu_notifier);
+	
 	pr_info("xen/balloon: Initialising balloon driver.\n");
 
 	balloon_stats.current_pages = xen_pv_domain()
diff --git a/include/xen/balloon.h b/include/xen/balloon.h
index cc2e1a7..7a819b7 100644
--- a/include/xen/balloon.h
+++ b/include/xen/balloon.h
@@ -29,6 +29,9 @@ int alloc_xenballooned_pages(int nr_pages, struct page **pages,
 		bool highmem);
 void free_xenballooned_pages(int nr_pages, struct page **pages);
 
+struct page* get_balloon_scratch_page(void);
+void put_balloon_scratch_page(void);
+
 struct device;
 #ifdef CONFIG_XEN_SELFBALLOONING
 extern int register_xen_selfballooning(struct device *dev);
-- 
1.7.2.5

