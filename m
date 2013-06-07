Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684Ab3FGXws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:52:48 -0400
Received: from smtp.outflux.net ([198.145.64.163]:58180 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757494Ab3FGXwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:52:46 -0400
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        David Woodhouse <dwmw2@infradead.org>,
        Karsten Keil <isdn@linux-pingi.de>, Kees Cook <keescook@chromium.org>
Subject: [PATCH 4/6] workqueue: avoid format strings in names
Date: Fri,  7 Jun 2013 16:50:53 -0700
Message-Id: <1370649055-12830-5-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370649055-12830-1-git-send-email-keescook@chromium.org>
References: <1370649055-12830-1-git-send-email-keescook@chromium.org>
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the workqueue creation interfaces that do not expect format strings,
make sure they cannot accidently be parsed that way. Additionally, clean
up calls made with a single parameter that would be handled as a format
string. Many callers are passing potentially dynamic string content,
so use "%s" in those cases to avoid any potential accidents.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 crypto/pcrypt.c                         |    4 ++--
 drivers/media/pci/cx18/cx18-driver.c    |    2 +-
 drivers/message/i2o/driver.c            |    4 ++--
 drivers/net/wireless/rt2x00/rt2x00dev.c |    2 +-
 drivers/net/wireless/rtlwifi/base.c     |    2 +-
 drivers/pci/hotplug/pciehp_hpc.c        |    4 +---
 drivers/pci/hotplug/shpchp_core.c       |    3 +--
 drivers/scsi/be2iscsi/be_main.c         |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c           |    4 ++--
 drivers/scsi/scsi_transport_fc.c        |    6 +++---
 include/linux/workqueue.h               |    7 ++++---
 net/bluetooth/hci_core.c                |    9 ++++-----
 net/mac80211/main.c                     |    2 +-
 13 files changed, 24 insertions(+), 27 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index b2c99dc..f8c920c 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -455,8 +455,8 @@ static int pcrypt_init_padata(struct padata_pcrypt *pcrypt,
 
 	get_online_cpus();
 
-	pcrypt->wq = alloc_workqueue(name,
-				     WQ_MEM_RECLAIM | WQ_CPU_INTENSIVE, 1);
+	pcrypt->wq = alloc_workqueue("%s", WQ_MEM_RECLAIM | WQ_CPU_INTENSIVE,
+				     1, name);
 	if (!pcrypt->wq)
 		goto err;
 
diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
index 67b61cf..004d8ac 100644
--- a/drivers/media/pci/cx18/cx18-driver.c
+++ b/drivers/media/pci/cx18/cx18-driver.c
@@ -695,7 +695,7 @@ static int cx18_create_in_workq(struct cx18 *cx)
 {
 	snprintf(cx->in_workq_name, sizeof(cx->in_workq_name), "%s-in",
 		 cx->v4l2_dev.name);
-	cx->in_work_queue = alloc_ordered_workqueue(cx->in_workq_name, 0);
+	cx->in_work_queue = alloc_ordered_workqueue("%s", 0, cx->in_workq_name);
 	if (cx->in_work_queue == NULL) {
 		CX18_ERR("Unable to create incoming mailbox handler thread\n");
 		return -ENOMEM;
diff --git a/drivers/message/i2o/driver.c b/drivers/message/i2o/driver.c
index 8a5b2d8..813eaa3 100644
--- a/drivers/message/i2o/driver.c
+++ b/drivers/message/i2o/driver.c
@@ -84,8 +84,8 @@ int i2o_driver_register(struct i2o_driver *drv)
 	osm_debug("Register driver %s\n", drv->name);
 
 	if (drv->event) {
-		drv->event_queue = alloc_workqueue(drv->name,
-						   WQ_MEM_RECLAIM, 1);
+		drv->event_queue = alloc_workqueue("%s", WQ_MEM_RECLAIM, 1,
+						   drv->name);
 		if (!drv->event_queue) {
 			osm_err("Could not initialize event queue for driver "
 				"%s\n", drv->name);
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 90dc143..c8b9ef0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1321,7 +1321,7 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	 * Initialize work.
 	 */
 	rt2x00dev->workqueue =
-	    alloc_ordered_workqueue(wiphy_name(rt2x00dev->hw->wiphy), 0);
+	    alloc_ordered_workqueue("%s", 0, wiphy_name(rt2x00dev->hw->wiphy));
 	if (!rt2x00dev->workqueue) {
 		retval = -ENOMEM;
 		goto exit;
diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
index af59dd5..a5f2231 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -380,7 +380,7 @@ static void _rtl_init_deferred_work(struct ieee80211_hw *hw)
 
 	/* <2> work queue */
 	rtlpriv->works.hw = hw;
-	rtlpriv->works.rtl_wq = alloc_workqueue(rtlpriv->cfg->name, 0, 0);
+	rtlpriv->works.rtl_wq = alloc_workqueue("%s", 0, 0, rtlpriv->cfg->name);
 	INIT_DELAYED_WORK(&rtlpriv->works.watchdog_wq,
 			  (void *)rtl_watchdog_wq_callback);
 	INIT_DELAYED_WORK(&rtlpriv->works.ips_nic_off_wq,
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 5127f3f..b225573 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -773,14 +773,12 @@ static void pcie_shutdown_notification(struct controller *ctrl)
 static int pcie_init_slot(struct controller *ctrl)
 {
 	struct slot *slot;
-	char name[32];
 
 	slot = kzalloc(sizeof(*slot), GFP_KERNEL);
 	if (!slot)
 		return -ENOMEM;
 
-	snprintf(name, sizeof(name), "pciehp-%u", PSN(ctrl));
-	slot->wq = alloc_workqueue(name, 0, 0);
+	slot->wq = alloc_workqueue("pciehp-%u", 0, 0, PSN(ctrl));
 	if (!slot->wq)
 		goto abort;
 
diff --git a/drivers/pci/hotplug/shpchp_core.c b/drivers/pci/hotplug/shpchp_core.c
index 3100c52..d3f757d 100644
--- a/drivers/pci/hotplug/shpchp_core.c
+++ b/drivers/pci/hotplug/shpchp_core.c
@@ -128,8 +128,7 @@ static int init_slots(struct controller *ctrl)
 		slot->hpc_ops = ctrl->hpc_ops;
 		slot->number = ctrl->first_slot + (ctrl->slot_num_inc * i);
 
-		snprintf(name, sizeof(name), "shpchp-%d", slot->number);
-		slot->wq = alloc_workqueue(name, 0, 0);
+		slot->wq = alloc_workqueue("shpchp-%d", 0, 0, slot->number);
 		if (!slot->wq) {
 			retval = -ENOMEM;
 			goto error_info;
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index d24a286..a1f5ac7 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4996,7 +4996,7 @@ static int beiscsi_dev_probe(struct pci_dev *pcidev,
 
 	snprintf(phba->wq_name, sizeof(phba->wq_name), "beiscsi_%02x_wq",
 		 phba->shost->host_no);
-	phba->wq = alloc_workqueue(phba->wq_name, WQ_MEM_RECLAIM, 1);
+	phba->wq = alloc_workqueue("%s", WQ_MEM_RECLAIM, 1, phba->wq_name);
 	if (!phba->wq) {
 		beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
 			    "BM_%d : beiscsi_dev_probe-"
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 4d231c1..b246b3c 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -7060,8 +7060,8 @@ skip_retry_init:
 	}
 	INIT_WORK(&ha->dpc_work, qla4xxx_do_dpc);
 
-	sprintf(buf, "qla4xxx_%lu_task", ha->host_no);
-	ha->task_wq = alloc_workqueue(buf, WQ_MEM_RECLAIM, 1);
+	ha->task_wq = alloc_workqueue("qla4xxx_%lu_task", WQ_MEM_RECLAIM, 1,
+				      ha->host_no);
 	if (!ha->task_wq) {
 		ql4_printk(KERN_WARNING, ha, "Unable to start task thread!\n");
 		ret = -ENODEV;
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index e106c27..4628fd5 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -435,7 +435,7 @@ static int fc_host_setup(struct transport_container *tc, struct device *dev,
 
 	snprintf(fc_host->work_q_name, sizeof(fc_host->work_q_name),
 		 "fc_wq_%d", shost->host_no);
-	fc_host->work_q = alloc_workqueue(fc_host->work_q_name, 0, 0);
+	fc_host->work_q = alloc_workqueue("%s", 0, 0, fc_host->work_q_name);
 	if (!fc_host->work_q)
 		return -ENOMEM;
 
@@ -443,8 +443,8 @@ static int fc_host_setup(struct transport_container *tc, struct device *dev,
 	snprintf(fc_host->devloss_work_q_name,
 		 sizeof(fc_host->devloss_work_q_name),
 		 "fc_dl_%d", shost->host_no);
-	fc_host->devloss_work_q =
-			alloc_workqueue(fc_host->devloss_work_q_name, 0, 0);
+	fc_host->devloss_work_q = alloc_workqueue("%s", 0, 0,
+					fc_host->devloss_work_q_name);
 	if (!fc_host->devloss_work_q) {
 		destroy_workqueue(fc_host->work_q);
 		fc_host->work_q = NULL;
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 623488f..018c9e7 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -410,11 +410,12 @@ __alloc_workqueue_key(const char *fmt, unsigned int flags, int max_active,
 	alloc_workqueue(fmt, WQ_UNBOUND | __WQ_ORDERED | (flags), 1, ##args)
 
 #define create_workqueue(name)						\
-	alloc_workqueue((name), WQ_MEM_RECLAIM, 1)
+	alloc_workqueue("%s", WQ_MEM_RECLAIM, 1, (name))
 #define create_freezable_workqueue(name)				\
-	alloc_workqueue((name), WQ_FREEZABLE | WQ_UNBOUND | WQ_MEM_RECLAIM, 1)
+	alloc_workqueue("%s", WQ_FREEZABLE | WQ_UNBOUND | WQ_MEM_RECLAIM, \
+			1, (name))
 #define create_singlethread_workqueue(name)				\
-	alloc_workqueue((name), WQ_UNBOUND | WQ_MEM_RECLAIM, 1)
+	alloc_workqueue("%s", WQ_UNBOUND | WQ_MEM_RECLAIM, 1, (name))
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 33843c5..1bd6844 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2202,16 +2202,15 @@ int hci_register_dev(struct hci_dev *hdev)
 	list_add(&hdev->list, &hci_dev_list);
 	write_unlock(&hci_dev_list_lock);
 
-	hdev->workqueue = alloc_workqueue(hdev->name, WQ_HIGHPRI | WQ_UNBOUND |
-					  WQ_MEM_RECLAIM, 1);
+	hdev->workqueue = alloc_workqueue("%s", WQ_HIGHPRI | WQ_UNBOUND |
+					  WQ_MEM_RECLAIM, 1, hdev->name);
 	if (!hdev->workqueue) {
 		error = -ENOMEM;
 		goto err;
 	}
 
-	hdev->req_workqueue = alloc_workqueue(hdev->name,
-					      WQ_HIGHPRI | WQ_UNBOUND |
-					      WQ_MEM_RECLAIM, 1);
+	hdev->req_workqueue = alloc_workqueue("%s", WQ_HIGHPRI | WQ_UNBOUND |
+					      WQ_MEM_RECLAIM, 1, hdev->name);
 	if (!hdev->req_workqueue) {
 		destroy_workqueue(hdev->workqueue);
 		error = -ENOMEM;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 8a7bfc4..8eae74a 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -921,7 +921,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		hw->queues = IEEE80211_MAX_QUEUES;
 
 	local->workqueue =
-		alloc_ordered_workqueue(wiphy_name(local->hw.wiphy), 0);
+		alloc_ordered_workqueue("%s", 0, wiphy_name(local->hw.wiphy));
 	if (!local->workqueue) {
 		result = -ENOMEM;
 		goto fail_workqueue;
-- 
1.7.9.5

