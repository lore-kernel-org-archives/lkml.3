Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301AbaLBV1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 16:27:11 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:37153
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267AbaLBV1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 16:27:08 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 2/3] Drivers: hv: hv_balloon: Fix a locking bug in the balloon driver
Date: Tue,  2 Dec 2014 14:29:14 -0800
Message-Id: <1417559355-13730-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1417559355-13730-1-git-send-email-kys@microsoft.com>
References: <1417559331-13691-1-git-send-email-kys@microsoft.com>
 <1417559355-13730-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We support memory hot-add in the Hyper-V balloon driver by hot adding an appropriately
sized and aligned region and controlling the on-lining of pages within that region
based on the pages that the host wants us to online. We do this because the
granularity and alignment requirements in Linux are different from what Windows
expects. The state to manage the onlining of pages needs to be correctly
protected. Fix this bug.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/hv_balloon.c |   69 +++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 64 insertions(+), 5 deletions(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 9cbbb83..2c610ec 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -533,6 +533,9 @@ struct hv_dynmem_device {
 	 */
 	struct task_struct *thread;
 
+	struct mutex ha_region_mutex;
+	struct completion waiter_event;
+
 	/*
 	 * A list of hot-add regions.
 	 */
@@ -549,7 +552,60 @@ struct hv_dynmem_device {
 static struct hv_dynmem_device dm_device;
 
 static void post_status(struct hv_dynmem_device *dm);
+
+static void acquire_region_mutex(bool trylock)
+{
+	if (trylock) {
+		reinit_completion(&dm_device.waiter_event);
+		while (!mutex_trylock(&dm_device.ha_region_mutex))
+			wait_for_completion(&dm_device.waiter_event);
+	} else {
+		mutex_lock(&dm_device.ha_region_mutex);
+	}
+}
+
+static void release_region_mutex(bool trylock)
+{
+	if (trylock) {
+		mutex_unlock(&dm_device.ha_region_mutex);
+	} else {
+		mutex_unlock(&dm_device.ha_region_mutex);
+		complete(&dm_device.waiter_event);
+	}
+}
+
+
 #ifdef CONFIG_MEMORY_HOTPLUG
+static int hv_memory_notifier(struct notifier_block *nb, unsigned long val,
+			      void *v)
+{
+	switch (val) {
+	case MEM_GOING_ONLINE:
+		acquire_region_mutex(true);
+		break;
+
+	case MEM_ONLINE:
+	case MEM_CANCEL_ONLINE:
+		release_region_mutex(true);
+		if (dm_device.ha_waiting) {
+			dm_device.ha_waiting = false;
+			complete(&dm_device.ol_waitevent);
+		}
+		break;
+
+	case MEM_GOING_OFFLINE:
+	case MEM_OFFLINE:
+	case MEM_CANCEL_OFFLINE:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block hv_memory_nb = {
+	.notifier_call = hv_memory_notifier,
+	.priority = 0
+};
+
 
 static void hv_bring_pgs_online(unsigned long start_pfn, unsigned long size)
 {
@@ -591,6 +647,7 @@ static void hv_mem_hot_add(unsigned long start, unsigned long size,
 		init_completion(&dm_device.ol_waitevent);
 		dm_device.ha_waiting = true;
 
+		release_region_mutex(false);
 		nid = memory_add_physaddr_to_nid(PFN_PHYS(start_pfn));
 		ret = add_memory(nid, PFN_PHYS((start_pfn)),
 				(HA_CHUNK << PAGE_SHIFT));
@@ -619,6 +676,7 @@ static void hv_mem_hot_add(unsigned long start, unsigned long size,
 		 * have not been "onlined" within the allowed time.
 		 */
 		wait_for_completion_timeout(&dm_device.ol_waitevent, 5*HZ);
+		acquire_region_mutex(false);
 		post_status(&dm_device);
 	}
 
@@ -632,11 +690,6 @@ static void hv_online_page(struct page *pg)
 	unsigned long cur_start_pgp;
 	unsigned long cur_end_pgp;
 
-	if (dm_device.ha_waiting) {
-		dm_device.ha_waiting = false;
-		complete(&dm_device.ol_waitevent);
-	}
-
 	list_for_each(cur, &dm_device.ha_region_list) {
 		has = list_entry(cur, struct hv_hotadd_state, list);
 		cur_start_pgp = (unsigned long)
@@ -834,6 +887,7 @@ static void hot_add_req(struct work_struct *dummy)
 	resp.hdr.size = sizeof(struct dm_hot_add_response);
 
 #ifdef CONFIG_MEMORY_HOTPLUG
+	acquire_region_mutex(false);
 	pg_start = dm->ha_wrk.ha_page_range.finfo.start_page;
 	pfn_cnt = dm->ha_wrk.ha_page_range.finfo.page_cnt;
 
@@ -865,6 +919,7 @@ static void hot_add_req(struct work_struct *dummy)
 	if (do_hot_add)
 		resp.page_count = process_hot_add(pg_start, pfn_cnt,
 						rg_start, rg_sz);
+	release_region_mutex(false);
 #endif
 	/*
 	 * The result field of the response structure has the
@@ -1388,7 +1443,9 @@ static int balloon_probe(struct hv_device *dev,
 	dm_device.next_version = DYNMEM_PROTOCOL_VERSION_WIN7;
 	init_completion(&dm_device.host_event);
 	init_completion(&dm_device.config_event);
+	init_completion(&dm_device.waiter_event);
 	INIT_LIST_HEAD(&dm_device.ha_region_list);
+	mutex_init(&dm_device.ha_region_mutex);
 	INIT_WORK(&dm_device.balloon_wrk.wrk, balloon_up);
 	INIT_WORK(&dm_device.ha_wrk.wrk, hot_add_req);
 	dm_device.host_specified_ha_region = false;
@@ -1402,6 +1459,7 @@ static int balloon_probe(struct hv_device *dev,
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 	set_online_page_callback(&hv_online_page);
+	register_memory_notifier(&hv_memory_nb);
 #endif
 
 	hv_set_drvdata(dev, &dm_device);
@@ -1520,6 +1578,7 @@ static int balloon_remove(struct hv_device *dev)
 	kfree(send_buffer);
 #ifdef CONFIG_MEMORY_HOTPLUG
 	restore_online_page_callback(&hv_online_page);
+	unregister_memory_notifier(&hv_memory_nb);
 #endif
 	list_for_each_safe(cur, tmp, &dm->ha_region_list) {
 		has = list_entry(cur, struct hv_hotadd_state, list);
-- 
1.7.4.1

