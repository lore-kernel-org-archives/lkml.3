Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486AbaGHTo0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:44:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54065 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755662AbaGHTIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:39 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "James Bottomley" <JBottomley@Parallels.com>,
        "Sarah Sharp" <sarah.a.sharp@linux.intel.com>,
        "Alan Stern" <stern@rowland.harvard.edu>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.675411122@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 105/125] [SCSI] fix our current target reap infrastructure
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: James Bottomley <JBottomley@Parallels.com>

commit e63ed0d7a98014fdfc2cfeb3f6dada313dcabb59 upstream.

This patch eliminates the reap_ref and replaces it with a proper kref.
On last put of this kref, the target is removed from visibility in
sysfs.  The final call to scsi_target_reap() for the device is done from
__scsi_remove_device() and only if the device was made visible.  This
ensures that the target disappears as soon as the last device is gone
rather than waiting until final release of the device (which is often
too long).

Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/scsi_scan.c   | 99 ++++++++++++++++++++++++++++------------------
 drivers/scsi/scsi_sysfs.c  | 20 +++++++---
 include/scsi/scsi_device.h |  3 +-
 3 files changed, 75 insertions(+), 47 deletions(-)

--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -383,6 +383,31 @@ static struct scsi_target *__scsi_find_t
 }
 
 /**
+ * scsi_target_reap_ref_release - remove target from visibility
+ * @kref: the reap_ref in the target being released
+ *
+ * Called on last put of reap_ref, which is the indication that no device
+ * under this target is visible anymore, so render the target invisible in
+ * sysfs.  Note: we have to be in user context here because the target reaps
+ * should be done in places where the scsi device visibility is being removed.
+ */
+static void scsi_target_reap_ref_release(struct kref *kref)
+{
+	struct scsi_target *starget
+		= container_of(kref, struct scsi_target, reap_ref);
+
+	transport_remove_device(&starget->dev);
+	device_del(&starget->dev);
+	starget->state = STARGET_DEL;
+	scsi_target_destroy(starget);
+}
+
+static void scsi_target_reap_ref_put(struct scsi_target *starget)
+{
+	kref_put(&starget->reap_ref, scsi_target_reap_ref_release);
+}
+
+/**
  * scsi_alloc_target - allocate a new or find an existing target
  * @parent:	parent of the target (need not be a scsi host)
  * @channel:	target channel number (zero if no channels)
@@ -404,7 +429,7 @@ static struct scsi_target *scsi_alloc_ta
 		+ shost->transportt->target_size;
 	struct scsi_target *starget;
 	struct scsi_target *found_target;
-	int error;
+	int error, ref_got;
 
 	starget = kzalloc(size, GFP_KERNEL);
 	if (!starget) {
@@ -413,7 +438,7 @@ static struct scsi_target *scsi_alloc_ta
 	}
 	dev = &starget->dev;
 	device_initialize(dev);
-	starget->reap_ref = 1;
+	kref_init(&starget->reap_ref);
 	dev->parent = get_device(parent);
 	dev_set_name(dev, "target%d:%d:%d", shost->host_no, channel, id);
 	dev->bus = &scsi_bus_type;
@@ -453,29 +478,36 @@ static struct scsi_target *scsi_alloc_ta
 	return starget;
 
  found:
-	found_target->reap_ref++;
+	/*
+	 * release routine already fired if kref is zero, so if we can still
+	 * take the reference, the target must be alive.  If we can't, it must
+	 * be dying and we need to wait for a new target
+	 */
+	ref_got = kref_get_unless_zero(&found_target->reap_ref);
+
 	spin_unlock_irqrestore(shost->host_lock, flags);
-	if (found_target->state != STARGET_DEL) {
+	if (ref_got) {
 		put_device(dev);
 		return found_target;
 	}
-	/* Unfortunately, we found a dying target; need to
-	 * wait until it's dead before we can get a new one */
+	/*
+	 * Unfortunately, we found a dying target; need to wait until it's
+	 * dead before we can get a new one.  There is an anomaly here.  We
+	 * *should* call scsi_target_reap() to balance the kref_get() of the
+	 * reap_ref above.  However, since the target being released, it's
+	 * already invisible and the reap_ref is irrelevant.  If we call
+	 * scsi_target_reap() we might spuriously do another device_del() on
+	 * an already invisible target.
+	 */
 	put_device(&found_target->dev);
-	flush_scheduled_work();
+	/*
+	 * length of time is irrelevant here, we just want to yield the CPU
+	 * for a tick to avoid busy waiting for the target to die.
+	 */
+	msleep(1);
 	goto retry;
 }
 
-static void scsi_target_reap_usercontext(struct work_struct *work)
-{
-	struct scsi_target *starget =
-		container_of(work, struct scsi_target, ew.work);
-
-	transport_remove_device(&starget->dev);
-	device_del(&starget->dev);
-	scsi_target_destroy(starget);
-}
-
 /**
  * scsi_target_reap - check to see if target is in use and destroy if not
  * @starget: target to be checked
@@ -486,28 +518,11 @@ static void scsi_target_reap_usercontext
  */
 void scsi_target_reap(struct scsi_target *starget)
 {
-	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
-	unsigned long flags;
-	enum scsi_target_state state;
-	int empty = 0;
-
-	spin_lock_irqsave(shost->host_lock, flags);
-	state = starget->state;
-	if (--starget->reap_ref == 0 && list_empty(&starget->devices)) {
-		empty = 1;
-		starget->state = STARGET_DEL;
-	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
-
-	if (!empty)
-		return;
-
-	BUG_ON(state == STARGET_DEL);
-	if (state == STARGET_CREATED)
+	BUG_ON(starget->state == STARGET_DEL);
+	if (starget->state == STARGET_CREATED)
 		scsi_target_destroy(starget);
 	else
-		execute_in_process_context(scsi_target_reap_usercontext,
-					   &starget->ew);
+		scsi_target_reap_ref_put(starget);
 }
 
 /**
@@ -1532,6 +1547,10 @@ struct scsi_device *__scsi_add_device(st
 	}
 	mutex_unlock(&shost->scan_mutex);
 	scsi_autopm_put_target(starget);
+	/*
+	 * paired with scsi_alloc_target().  Target will be destroyed unless
+	 * scsi_probe_and_add_lun made an underlying device visible
+	 */
 	scsi_target_reap(starget);
 	put_device(&starget->dev);
 
@@ -1612,8 +1631,10 @@ static void __scsi_scan_target(struct de
 
  out_reap:
 	scsi_autopm_put_target(starget);
-	/* now determine if the target has any children at all
-	 * and if not, nuke it */
+	/*
+	 * paired with scsi_alloc_target(): determine if the target has
+	 * any children at all and if not, nuke it
+	 */
 	scsi_target_reap(starget);
 
 	put_device(&starget->dev);
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -331,17 +331,14 @@ static void scsi_device_dev_release_user
 {
 	struct scsi_device *sdev;
 	struct device *parent;
-	struct scsi_target *starget;
 	struct list_head *this, *tmp;
 	unsigned long flags;
 
 	sdev = container_of(work, struct scsi_device, ew.work);
 
 	parent = sdev->sdev_gendev.parent;
-	starget = to_scsi_target(parent);
 
 	spin_lock_irqsave(sdev->host->host_lock, flags);
-	starget->reap_ref++;
 	list_del(&sdev->siblings);
 	list_del(&sdev->same_target_siblings);
 	list_del(&sdev->starved_entry);
@@ -361,8 +358,6 @@ static void scsi_device_dev_release_user
 	/* NULL queue means the device can't be used */
 	sdev->request_queue = NULL;
 
-	scsi_target_reap(scsi_target(sdev));
-
 	kfree(sdev->inquiry);
 	kfree(sdev);
 
@@ -977,6 +972,13 @@ void __scsi_remove_device(struct scsi_de
 		sdev->host->hostt->slave_destroy(sdev);
 	transport_destroy_device(dev);
 
+	/*
+	 * Paired with the kref_get() in scsi_sysfs_initialize().  We have
+	 * remoed sysfs visibility from the device, so make the target
+	 * invisible if this was the last device underneath it.
+	 */
+	scsi_target_reap(scsi_target(sdev));
+
 	put_device(dev);
 }
 
@@ -1039,7 +1041,7 @@ void scsi_remove_target(struct device *d
 			continue;
 		if (starget->dev.parent == dev || &starget->dev == dev) {
 			/* assuming new targets arrive at the end */
-			starget->reap_ref++;
+			kref_get(&starget->reap_ref);
 			spin_unlock_irqrestore(shost->host_lock, flags);
 			if (last)
 				scsi_target_reap(last);
@@ -1123,6 +1125,12 @@ void scsi_sysfs_device_initialize(struct
 	list_add_tail(&sdev->same_target_siblings, &starget->devices);
 	list_add_tail(&sdev->siblings, &shost->__devices);
 	spin_unlock_irqrestore(shost->host_lock, flags);
+	/*
+	 * device can now only be removed via __scsi_remove_device() so hold
+	 * the target.  Target will be held in CREATED state until something
+	 * beneath it becomes visible (in which case it moves to RUNNING)
+	 */
+	kref_get(&starget->reap_ref);
 }
 
 int scsi_is_sdev_device(const struct device *dev)
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -239,7 +239,7 @@ struct scsi_target {
 	struct list_head	siblings;
 	struct list_head	devices;
 	struct device		dev;
-	unsigned int		reap_ref; /* protected by the host lock */
+	struct kref		reap_ref; /* last put renders target invisible */
 	unsigned int		channel;
 	unsigned int		id; /* target id ... replace
 				     * scsi_device.id eventually */
@@ -261,7 +261,6 @@ struct scsi_target {
 #define SCSI_DEFAULT_TARGET_BLOCKED	3
 
 	char			scsi_level;
-	struct execute_work	ew;
 	enum scsi_target_state	state;
 	void 			*hostdata; /* available to low-level driver */
 	unsigned long		starget_data[0]; /* for the transport */

