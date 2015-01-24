Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbbAXOG5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:06:57 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:35776 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbbAXOE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:04:26 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH 24/32] usb: use %*pb[l] to print bitmaps including cpumasks and nodemasks
Date: Sat, 24 Jan 2015 09:03:30 -0500
Message-Id: <1422108218-25398-25-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422108218-25398-1-git-send-email-tj@kernel.org>
References: <1422108218-25398-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

* drivers/uwb/drp.c::uwb_drp_handle_alien_drp() was formatting mas.bm
  into a buffer but never used it.  Removed.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Please wait till the forementioned patches are merged to mainline
before applying to subsystem trees.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/host/whci/debug.c      |  7 ++-----
 drivers/usb/wusbcore/reservation.c |  5 ++---
 drivers/usb/wusbcore/wa-rpipe.c    |  5 ++---
 drivers/usb/wusbcore/wusbhc.c      |  7 ++-----
 drivers/uwb/drp.c                  |  2 --
 drivers/uwb/uwb-debug.c            | 16 +++++-----------
 6 files changed, 13 insertions(+), 29 deletions(-)

diff --git a/drivers/usb/host/whci/debug.c b/drivers/usb/host/whci/debug.c
index ba61dae..774b89d 100644
--- a/drivers/usb/host/whci/debug.c
+++ b/drivers/usb/host/whci/debug.c
@@ -86,17 +86,14 @@ static void qset_print(struct seq_file *s, struct whc_qset *qset)
 static int di_print(struct seq_file *s, void *p)
 {
 	struct whc *whc = s->private;
-	char buf[72];
 	int d;
 
 	for (d = 0; d < whc->n_devices; d++) {
 		struct di_buf_entry *di = &whc->di_buf[d];
 
-		bitmap_scnprintf(buf, sizeof(buf),
-				 (unsigned long *)di->availability_info, UWB_NUM_MAS);
-
 		seq_printf(s, "DI[%d]\n", d);
-		seq_printf(s, "  availability: %s\n", buf);
+		seq_printf(s, "  availability: %*pb\n",
+			   UWB_NUM_MAS, (unsigned long *)di->availability_info);
 		seq_printf(s, "  %c%c key idx: %d dev addr: %d\n",
 			   (di->addr_sec_info & WHC_DI_SECURE) ? 'S' : ' ',
 			   (di->addr_sec_info & WHC_DI_DISABLE) ? 'D' : ' ',
diff --git a/drivers/usb/wusbcore/reservation.c b/drivers/usb/wusbcore/reservation.c
index d5efd0f..7b1b2e2 100644
--- a/drivers/usb/wusbcore/reservation.c
+++ b/drivers/usb/wusbcore/reservation.c
@@ -49,14 +49,13 @@ static void wusbhc_rsv_complete_cb(struct uwb_rsv *rsv)
 	struct wusbhc *wusbhc = rsv->pal_priv;
 	struct device *dev = wusbhc->dev;
 	struct uwb_mas_bm mas;
-	char buf[72];
 
 	dev_dbg(dev, "%s: state = %d\n", __func__, rsv->state);
 	switch (rsv->state) {
 	case UWB_RSV_STATE_O_ESTABLISHED:
 		uwb_rsv_get_usable_mas(rsv, &mas);
-		bitmap_scnprintf(buf, sizeof(buf), mas.bm, UWB_NUM_MAS);
-		dev_dbg(dev, "established reservation: %s\n", buf);
+		dev_dbg(dev, "established reservation: %*pb\n",
+			UWB_NUM_MAS, mas.bm);
 		wusbhc_bwa_set(wusbhc, rsv->stream, &mas);
 		break;
 	case UWB_RSV_STATE_NONE:
diff --git a/drivers/usb/wusbcore/wa-rpipe.c b/drivers/usb/wusbcore/wa-rpipe.c
index a80c5d2..c7ecdbe 100644
--- a/drivers/usb/wusbcore/wa-rpipe.c
+++ b/drivers/usb/wusbcore/wa-rpipe.c
@@ -496,10 +496,9 @@ void wa_rpipes_destroy(struct wahc *wa)
 	struct device *dev = &wa->usb_iface->dev;
 
 	if (!bitmap_empty(wa->rpipe_bm, wa->rpipes)) {
-		char buf[256];
 		WARN_ON(1);
-		bitmap_scnprintf(buf, sizeof(buf), wa->rpipe_bm, wa->rpipes);
-		dev_err(dev, "BUG: pipes not released on exit: %s\n", buf);
+		dev_err(dev, "BUG: pipes not released on exit: %*pb\n",
+			wa->rpipes, wa->rpipe_bm);
 	}
 	kfree(wa->rpipe_bm);
 }
diff --git a/drivers/usb/wusbcore/wusbhc.c b/drivers/usb/wusbcore/wusbhc.c
index 3e1ba51..94f401a 100644
--- a/drivers/usb/wusbcore/wusbhc.c
+++ b/drivers/usb/wusbcore/wusbhc.c
@@ -496,11 +496,8 @@ static void __exit wusbcore_exit(void)
 {
 	clear_bit(0, wusb_cluster_id_table);
 	if (!bitmap_empty(wusb_cluster_id_table, CLUSTER_IDS)) {
-		char buf[256];
-		bitmap_scnprintf(buf, sizeof(buf), wusb_cluster_id_table,
-				 CLUSTER_IDS);
-		printk(KERN_ERR "BUG: WUSB Cluster IDs not released "
-		       "on exit: %s\n", buf);
+		printk(KERN_ERR "BUG: WUSB Cluster IDs not released on exit: %*pb\n",
+		       CLUSTER_IDS, wusb_cluster_id_table);
 		WARN_ON(1);
 	}
 	usb_unregister_notify(&wusb_usb_notifier);
diff --git a/drivers/uwb/drp.c b/drivers/uwb/drp.c
index 05b7bd7..8fc1b78 100644
--- a/drivers/uwb/drp.c
+++ b/drivers/uwb/drp.c
@@ -619,11 +619,9 @@ static void uwb_drp_handle_alien_drp(struct uwb_rc *rc, struct uwb_ie_drp *drp_i
 	struct device *dev = &rc->uwb_dev.dev;
 	struct uwb_mas_bm mas;
 	struct uwb_cnflt_alien *cnflt;
-	char buf[72];
 	unsigned long delay_us = UWB_MAS_LENGTH_US * UWB_MAS_PER_ZONE;
 
 	uwb_drp_ie_to_bm(&mas, drp_ie);
-	bitmap_scnprintf(buf, sizeof(buf), mas.bm, UWB_NUM_MAS);
 
 	list_for_each_entry(cnflt, &rc->cnflt_alien_list, rc_node) {
 		if (bitmap_equal(cnflt->mas.bm, mas.bm, UWB_NUM_MAS)) {
diff --git a/drivers/uwb/uwb-debug.c b/drivers/uwb/uwb-debug.c
index 6ec45be..0b1e5a9 100644
--- a/drivers/uwb/uwb-debug.c
+++ b/drivers/uwb/uwb-debug.c
@@ -217,7 +217,6 @@ static int reservations_print(struct seq_file *s, void *p)
 		struct uwb_dev_addr devaddr;
 		char owner[UWB_ADDR_STRSIZE], target[UWB_ADDR_STRSIZE];
 		bool is_owner;
-		char buf[72];
 
 		uwb_dev_addr_print(owner, sizeof(owner), &rsv->owner->dev_addr);
 		if (rsv->target.type == UWB_RSV_TARGET_DEV) {
@@ -234,8 +233,7 @@ static int reservations_print(struct seq_file *s, void *p)
 			   owner, target, uwb_rsv_state_str(rsv->state));
 		seq_printf(s, "  stream: %d  type: %s\n",
 			   rsv->stream, uwb_rsv_type_str(rsv->type));
-		bitmap_scnprintf(buf, sizeof(buf), rsv->mas.bm, UWB_NUM_MAS);
-		seq_printf(s, "  %s\n", buf);
+		seq_printf(s, "  %*pb\n", UWB_NUM_MAS, rsv->mas.bm);
 	}
 
 	mutex_unlock(&rc->rsvs_mutex);
@@ -259,14 +257,10 @@ static const struct file_operations reservations_fops = {
 static int drp_avail_print(struct seq_file *s, void *p)
 {
 	struct uwb_rc *rc = s->private;
-	char buf[72];
-
-	bitmap_scnprintf(buf, sizeof(buf), rc->drp_avail.global, UWB_NUM_MAS);
-	seq_printf(s, "global:  %s\n", buf);
-	bitmap_scnprintf(buf, sizeof(buf), rc->drp_avail.local, UWB_NUM_MAS);
-	seq_printf(s, "local:   %s\n", buf);
-	bitmap_scnprintf(buf, sizeof(buf), rc->drp_avail.pending, UWB_NUM_MAS);
-	seq_printf(s, "pending: %s\n", buf);
+
+	seq_printf(s, "global:  %*pb\n", UWB_NUM_MAS, rc->drp_avail.global);
+	seq_printf(s, "local:   %*pb\n", UWB_NUM_MAS, rc->drp_avail.local);
+	seq_printf(s, "pending: %*pb\n", UWB_NUM_MAS, rc->drp_avail.pending);
 
 	return 0;
 }
-- 
2.1.0

