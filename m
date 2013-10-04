Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab3JDBHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 21:07:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:3963 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab3JDBHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 21:07:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1029,1371106800"; 
   d="scan'208";a="411276468"
From: Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: [PATCH char-misc-next] misc: mic: Enable OSPM suspend and resume support.
Date: Thu,  3 Oct 2013 18:06:23 -0700
Message-Id: <7f7ca30f308753310b6ed87e75232bd66ce40f23.1380847709.git.dasaratharaman.chandramouli@intel.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables support for OSPM suspend and resume in the MIC
driver. During a host suspend event, the driver performs an
orderly shutdown of the cards if they are online. Upon resume, any
cards that were previously online before suspend are rebooted.
The driver performs an orderly shutdown of the card primarily to
ensure that applications in the card are terminated and mounted
devices are safely un-mounted before the card is powered down in
the event of an OSPM suspend.

The driver makes use of the MIC daemon to accomplish OSPM suspend
and resume. The driver registers a PM notifier per MIC device.
The devices get notified synchronously during PM_SUSPEND_PREPARE and
PM_POST_SUSPEND phases.

During the PM_SUSPEND_PREPARE phase, the driver performs one of the
following three tasks.
1) If the card is 'offline', the driver sets the card to a
   'suspended' state and returns.
2) If the card is 'online', the driver initiates card shutdown by
   setting the card state to suspending. This notifies the MIC
   daemon which invokes shutdown and sets card state to 'suspended'.
   The driver returns after the shutdown is complete.
3) If the card is already being shutdown, possibly by a host user
   space application, the driver sets the card state to 'suspended'
   and returns after the shutdown is complete.

During the PM_POST_SUSPEND phase, the driver simply notifies the
daemon and returns. The daemon boots those cards that were previously
online during the suspend phase.

Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Nikhil Rao <nikhil.rao@intel.com>
Signed-off-by: Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>
---
 Documentation/ABI/testing/sysfs-class-mic.txt |  60 +++++++------
 Documentation/mic/mic_overview.txt            |   4 +-
 Documentation/mic/mpssd/mpssd.c               |  27 +++++-
 Documentation/mic/mpssd/mpssd.h               |   1 +
 drivers/misc/mic/host/mic_boot.c              | 120 +++++++++++++++++++++++++-
 drivers/misc/mic/host/mic_device.h            |   8 ++
 drivers/misc/mic/host/mic_main.c              |  63 +++++++++++++-
 drivers/misc/mic/host/mic_sysfs.c             |   7 ++
 include/uapi/linux/mic_common.h               |   2 +
 9 files changed, 257 insertions(+), 35 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-mic.txt b/Documentation/ABI/testing/sysfs-class-mic.txt
index 82cdad3..13f48af 100644
--- a/Documentation/ABI/testing/sysfs-class-mic.txt
+++ b/Documentation/ABI/testing/sysfs-class-mic.txt
@@ -1,6 +1,6 @@
 What:		/sys/class/mic/
-Date:		August 2013
-KernelVersion:	3.11
+Date:		October 2013
+KernelVersion:	3.13
 Contact:	Sudeep Dutt <sudeep.dutt@intel.com>
 Description:
 		The mic class directory belongs to Intel MIC devices and
@@ -9,8 +9,8 @@ Description:
 		Integrated Core (MIC) architecture that runs a Linux OS.
 
 What:		/sys/class/mic/mic(x)
-Date:		August 2013
-KernelVersion:	3.11
+Date:		October 2013
+KernelVersion:	3.13
 Contact:	Sudeep Dutt <sudeep.dutt@intel.com>
 Description:
 		The directories /sys/class/mic/mic0, /sys/class/mic/mic1 etc.,
@@ -18,33 +18,41 @@ Description:
 		information specific to that MIC device.
 
 What:		/sys/class/mic/mic(x)/family
-Date:		August 2013
-KernelVersion:	3.11
+Date:		October 2013
+KernelVersion:	3.13
 Contact:	Sudeep Dutt <sudeep.dutt@intel.com>
 Description:
 		Provides information about the Coprocessor family for an Intel
 		MIC device. For example - "x100"
 
 What:		/sys/class/mic/mic(x)/stepping
-Date:		August 2013
-KernelVersion:	3.11
+Date:		October 2013
+KernelVersion:	3.13
 Contact:	Sudeep Dutt <sudeep.dutt@intel.com>
 Description:
 		Provides information about the silicon stepping for an Intel
 		MIC device. For example - "A0" or "B0"
 
 What:		/sys/class/mic/mic(x)/state
-Date:		August 2013
-KernelVersion:	3.11
+Date:		October 2013
+KernelVersion:	3.13
 Contact:	Sudeep Dutt <sudeep.dutt@intel.com>
 Description:
 		When read, this entry provides the current state of an Intel
 		MIC device in the context of the card OS. Possible values that
 		will be read are:
-		"offline" - The MIC device is ready to boot the card OS.
+		"offline" - The MIC device is ready to boot the card OS. On
+		reading this entry after an OSPM resume, a "boot" has to be
+		written to this entry if the card was previously shutdown
+		during OSPM suspend.
 		"online" - The MIC device has initiated booting a card OS.
 		"shutting_down" - The card OS is shutting down.
 		"reset_failed" - The MIC device has failed to reset.
+		"suspending" - The MIC device is currently being prepared for
+		suspend. On reading this entry, a "suspend" has to be written
+		to the state sysfs entry to ensure the card is shutdown during
+		OSPM suspend.
+		"suspended" - The MIC device has been suspended.
 
 		When written, this sysfs entry triggers different state change
 		operations depending upon the current state of the card OS.
@@ -54,10 +62,12 @@ Description:
 			sysfs entries.
 		"reset" - Initiates device reset.
 		"shutdown" - Initiates card OS shutdown.
+		"suspend" - Initiates card OS shutdown and also marks the card
+		as suspended.
 
 What:		/sys/class/mic/mic(x)/shutdown_status
-Date:		August 2013
-KernelVersion:	3.11
+Date:		October 2013
+KernelVersion:	3.13
 Contact:	Sudeep Dutt <sudeep.dutt@intel.com>
 Description:
 		An Intel MIC device runs a Linux OS during its operation. This
@@ -72,8 +82,8 @@ Description:
 		"restart" - Shutdown because of a restart command.
 
 What:		/sys/class/mic/mic(x)/cmdline
-Date:		August 2013
-KernelVersion:	3.11
+Date:		October 2013
+KernelVersion:	3.13
 Contact:	Sudeep Dutt <sudeep.dutt@intel.com>
 Description:
 		An Intel MIC device runs a Linux OS during its operation. Before
@@ -88,8 +98,8 @@ Description:
 		line back to this entry.
 
 What:		/sys/class/mic/mic(x)/firmware
-Date:		August 2013
-KernelVersion:	3.11
+Date:		October 2013
+KernelVersion:	3.13
 Contact:	Sudeep Dutt <sudeep.dutt@intel.com>
 Description:
 		When read, this sysfs entry provides the path name under
@@ -98,8 +108,8 @@ Description:
 		firmware image location under /lib/firmware/.
 
 What:		/sys/class/mic/mic(x)/ramdisk
-Date:		August 2013
-KernelVersion:	3.11
+Date:		October 2013
+KernelVersion:	3.13
 Contact:	Sudeep Dutt <sudeep.dutt@intel.com>
 Description:
 		When read, this sysfs entry provides the path name under
@@ -108,8 +118,8 @@ Description:
 		the ramdisk image location under /lib/firmware/.
 
 What:		/sys/class/mic/mic(x)/bootmode
-Date:		August 2013
-KernelVersion:	3.11
+Date:		October 2013
+KernelVersion:	3.13
 Contact:	Sudeep Dutt <sudeep.dutt@intel.com>
 Description:
 		When read, this sysfs entry provides the current bootmode for
@@ -119,8 +129,8 @@ Description:
 		b) elf - Boot an elf image for flash updates.
 
 What:		/sys/class/mic/mic(x)/log_buf_addr
-Date:		August 2013
-KernelVersion:	3.11
+Date:		October 2013
+KernelVersion:	3.13
 Contact:	Sudeep Dutt <sudeep.dutt@intel.com>
 Description:
 		An Intel MIC device runs a Linux OS during its operation. For
@@ -133,8 +143,8 @@ Description:
 		file of the card OS.
 
 What:		/sys/class/mic/mic(x)/log_buf_len
-Date:		August 2013
-KernelVersion:	3.11
+Date:		October 2013
+KernelVersion:	3.13
 Contact:	Sudeep Dutt <sudeep.dutt@intel.com>
 Description:
 		An Intel MIC device runs a Linux OS during its operation. For
diff --git a/Documentation/mic/mic_overview.txt b/Documentation/mic/mic_overview.txt
index c4424ed..b419292 100644
--- a/Documentation/mic/mic_overview.txt
+++ b/Documentation/mic/mic_overview.txt
@@ -4,7 +4,9 @@ that runs a Linux OS. It is a PCIe endpoint in a platform and therefore
 implements the three required standard address spaces i.e. configuration,
 memory and I/O. The host OS loads a device driver as is typical for
 PCIe devices. The card itself runs a bootstrap after reset that
-transfers control to the card OS downloaded from the host driver.
+transfers control to the card OS downloaded from the host driver. The
+host driver supports OSPM suspend and resume operations. It shuts down
+the card during suspend and reboots the card OS during resume.
 The card OS as shipped by Intel is a Linux kernel with modifications
 for the X100 devices.
 
diff --git a/Documentation/mic/mpssd/mpssd.c b/Documentation/mic/mpssd/mpssd.c
index 82c6bc2..0c980ad 100644
--- a/Documentation/mic/mpssd/mpssd.c
+++ b/Documentation/mic/mpssd/mpssd.c
@@ -1295,7 +1295,13 @@ reset(struct mic_info *mic)
 			goto retry;
 		mpsslog("%s: %s %d state %s\n",
 			mic->name, __func__, __LINE__, state);
-		if ((!strcmp(state, "offline"))) {
+
+		/*
+		 * If the shutdown was initiated by OSPM, the state stays
+		 * in "suspended" which is also a valid condition for reset.
+		 */
+		if ((!strcmp(state, "offline")) ||
+		    (!strcmp(state, "suspended"))) {
 			free(state);
 			break;
 		}
@@ -1334,6 +1340,10 @@ static int get_mic_state(struct mic_info *mic, char *state)
 		return MIC_SHUTTING_DOWN;
 	if (!strcmp(state, "reset_failed"))
 		return MIC_RESET_FAILED;
+	if (!strcmp(state, "suspending"))
+		return MIC_SUSPENDING;
+	if (!strcmp(state, "suspended"))
+		return MIC_SUSPENDED;
 	mpsslog("%s: BUG invalid state %s\n", mic->name, state);
 	/* Invalid state */
 	assert(0);
@@ -1418,6 +1428,17 @@ retry:
 		case MIC_SHUTTING_DOWN:
 			mic_handle_shutdown(mic);
 			goto close_error;
+		case MIC_SUSPENDING:
+			mic->boot_on_resume = 1;
+			setsysfs(mic->name, "state", "suspend");
+			mic_handle_shutdown(mic);
+			goto close_error;
+		case MIC_OFFLINE:
+			if (mic->boot_on_resume) {
+				setsysfs(mic->name, "state", "boot");
+				mic->boot_on_resume = 0;
+			}
+			break;
 		default:
 			break;
 		}
@@ -1621,11 +1642,9 @@ init_mic_list(void)
 
 	while ((file = readdir(dp)) != NULL) {
 		if (!strncmp(file->d_name, "mic", 3)) {
-			mic->next = malloc(sizeof(struct mic_info));
+			mic->next = calloc(1, sizeof(struct mic_info));
 			if (mic->next) {
 				mic = mic->next;
-				mic->next = NULL;
-				memset(mic, 0, sizeof(struct mic_info));
 				mic->id = atoi(&file->d_name[3]);
 				mic->name = malloc(strlen(file->d_name) + 16);
 				if (mic->name)
diff --git a/Documentation/mic/mpssd/mpssd.h b/Documentation/mic/mpssd/mpssd.h
index ccd589f..f5f18b1 100644
--- a/Documentation/mic/mpssd/mpssd.h
+++ b/Documentation/mic/mpssd/mpssd.h
@@ -91,6 +91,7 @@ struct mic_info {
 	struct mic_net_info	mic_net;
 	struct mic_virtblk_info	mic_virtblk;
 	int		restart;
+	int		boot_on_resume;
 	struct mic_info *next;
 };
 
diff --git a/drivers/misc/mic/host/mic_boot.c b/drivers/misc/mic/host/mic_boot.c
index 60c54d5..d56b8bf 100644
--- a/drivers/misc/mic/host/mic_boot.c
+++ b/drivers/misc/mic/host/mic_boot.c
@@ -37,12 +37,13 @@ static void mic_reset(struct mic_device *mdev)
 
 #define MIC_RESET_TO (45)
 
+	INIT_COMPLETION(mdev->reset_wait);
 	mdev->ops->reset_fw_ready(mdev);
 	mdev->ops->reset(mdev);
 
 	for (i = 0; i < MIC_RESET_TO; i++) {
 		if (mdev->ops->is_fw_ready(mdev))
-			return;
+			goto done;
 		/*
 		 * Resets typically take 10s of seconds to complete.
 		 * Since an MMIO read is required to check if the
@@ -51,6 +52,8 @@ static void mic_reset(struct mic_device *mdev)
 		msleep(1000);
 	}
 	mic_set_state(mdev, MIC_RESET_FAILED);
+done:
+	complete_all(&mdev->reset_wait);
 }
 
 /* Initialize the MIC bootparams */
@@ -123,7 +126,8 @@ void mic_stop(struct mic_device *mdev, bool force)
 		if (MIC_RESET_FAILED == mdev->state)
 			goto unlock;
 		mic_set_shutdown_status(mdev, MIC_NOP);
-		mic_set_state(mdev, MIC_OFFLINE);
+		if (MIC_SUSPENDED != mdev->state)
+			mic_set_state(mdev, MIC_OFFLINE);
 	}
 unlock:
 	mutex_unlock(&mdev->mic_mutex);
@@ -165,7 +169,14 @@ void mic_shutdown_work(struct work_struct *work)
 	mutex_lock(&mdev->mic_mutex);
 	mic_set_shutdown_status(mdev, bootparam->shutdown_status);
 	bootparam->shutdown_status = 0;
-	if (MIC_SHUTTING_DOWN != mdev->state)
+
+	/*
+	 * if state is MIC_SUSPENDED, OSPM suspend is in progress. We do not
+	 * change the state here so as to prevent users from booting the card
+	 * during and after the suspend operation.
+	 */
+	if (MIC_SHUTTING_DOWN != mdev->state &&
+	    MIC_SUSPENDED != mdev->state)
 		mic_set_state(mdev, MIC_SHUTTING_DOWN);
 	mutex_unlock(&mdev->mic_mutex);
 }
@@ -183,3 +194,106 @@ void mic_reset_trigger_work(struct work_struct *work)
 
 	mic_stop(mdev, false);
 }
+
+/**
+ * mic_complete_resume - Complete MIC Resume after an OSPM suspend/hibernate
+ * event.
+ * @mdev: pointer to mic_device instance
+ *
+ * RETURNS: None.
+ */
+void mic_complete_resume(struct mic_device *mdev)
+{
+	if (mdev->state != MIC_SUSPENDED) {
+		dev_warn(mdev->sdev->parent, "state %d should be %d\n",
+			 mdev->state, MIC_SUSPENDED);
+		return;
+	}
+
+	/* Make sure firmware is ready */
+	if (!mdev->ops->is_fw_ready(mdev))
+		mic_stop(mdev, true);
+
+	mutex_lock(&mdev->mic_mutex);
+	mic_set_state(mdev, MIC_OFFLINE);
+	mutex_unlock(&mdev->mic_mutex);
+}
+
+/**
+ * mic_prepare_suspend - Handle suspend notification for the MIC device.
+ * @mdev: pointer to mic_device instance
+ *
+ * RETURNS: None.
+ */
+void mic_prepare_suspend(struct mic_device *mdev)
+{
+	int rc;
+
+#define MIC_SUSPEND_TIMEOUT (60 * HZ)
+
+	mutex_lock(&mdev->mic_mutex);
+	switch (mdev->state) {
+	case MIC_OFFLINE:
+		/*
+		 * Card is already offline. Set state to MIC_SUSPENDED
+		 * to prevent users from booting the card.
+		 */
+		mic_set_state(mdev, MIC_SUSPENDED);
+		mutex_unlock(&mdev->mic_mutex);
+		break;
+	case MIC_ONLINE:
+		/*
+		 * Card is online. Set state to MIC_SUSPENDING and notify
+		 * MIC user space daemon which will issue card
+		 * shutdown and reset.
+		 */
+		mic_set_state(mdev, MIC_SUSPENDING);
+		mutex_unlock(&mdev->mic_mutex);
+		rc = wait_for_completion_timeout(&mdev->reset_wait,
+						MIC_SUSPEND_TIMEOUT);
+		/* Force reset the card if the shutdown completion timed out */
+		if (!rc) {
+			mutex_lock(&mdev->mic_mutex);
+			mic_set_state(mdev, MIC_SUSPENDED);
+			mutex_unlock(&mdev->mic_mutex);
+			mic_stop(mdev, true);
+		}
+		break;
+	case MIC_SHUTTING_DOWN:
+		/*
+		 * Card is shutting down. Set state to MIC_SUSPENDED
+		 * to prevent further boot of the card.
+		 */
+		mic_set_state(mdev, MIC_SUSPENDED);
+		mutex_unlock(&mdev->mic_mutex);
+		rc = wait_for_completion_timeout(&mdev->reset_wait,
+						MIC_SUSPEND_TIMEOUT);
+		/* Force reset the card if the shutdown completion timed out */
+		if (!rc)
+			mic_stop(mdev, true);
+		break;
+	default:
+		mutex_unlock(&mdev->mic_mutex);
+		break;
+	}
+}
+
+/**
+ * mic_suspend - Initiate MIC suspend. Suspend merely issues card shutdown.
+ * @mdev: pointer to mic_device instance
+ *
+ * RETURNS: None.
+ */
+void mic_suspend(struct mic_device *mdev)
+{
+	struct mic_bootparam *bootparam = mdev->dp;
+	s8 db = bootparam->h2c_shutdown_db;
+
+	mutex_lock(&mdev->mic_mutex);
+	if (MIC_SUSPENDING == mdev->state && db != -1) {
+		bootparam->shutdown_card = 1;
+		mdev->ops->send_intr(mdev, db);
+		mic_set_state(mdev, MIC_SUSPENDED);
+	}
+	mutex_unlock(&mdev->mic_mutex);
+}
diff --git a/drivers/misc/mic/host/mic_device.h b/drivers/misc/mic/host/mic_device.h
index dcba2a5..3574cc3 100644
--- a/drivers/misc/mic/host/mic_device.h
+++ b/drivers/misc/mic/host/mic_device.h
@@ -23,6 +23,7 @@
 
 #include <linux/cdev.h>
 #include <linux/idr.h>
+#include <linux/notifier.h>
 
 #include "mic_intr.h"
 
@@ -75,6 +76,7 @@ enum mic_stepping {
  * @state: MIC state.
  * @shutdown_status: MIC status reported by card for shutdown/crashes.
  * @state_sysfs: Sysfs dirent for notifying ring 3 about MIC state changes.
+ * @reset_wait: Waitqueue for sleeping while reset completes.
  * @log_buf_addr: Log buffer address for MIC.
  * @log_buf_len: Log buffer length address for MIC.
  * @dp: virtio device page
@@ -83,6 +85,7 @@ enum mic_stepping {
  * @shutdown_cookie: shutdown cookie.
  * @cdev: Character device for MIC.
  * @vdev_list: list of virtio devices.
+ * @pm_notifier: Handles PM notifications from the OS.
  */
 struct mic_device {
 	struct mic_mw mmio;
@@ -110,6 +113,7 @@ struct mic_device {
 	u8 state;
 	u8 shutdown_status;
 	struct sysfs_dirent *state_sysfs;
+	struct completion reset_wait;
 	void *log_buf_addr;
 	int *log_buf_len;
 	void *dp;
@@ -118,6 +122,7 @@ struct mic_device {
 	struct mic_irq *shutdown_cookie;
 	struct cdev cdev;
 	struct list_head vdev_list;
+	struct notifier_block pm_notifier;
 };
 
 /**
@@ -192,4 +197,7 @@ void mic_create_debug_dir(struct mic_device *dev);
 void mic_delete_debug_dir(struct mic_device *dev);
 void __init mic_init_debugfs(void);
 void mic_exit_debugfs(void);
+void mic_prepare_suspend(struct mic_device *mdev);
+void mic_complete_resume(struct mic_device *mdev);
+void mic_suspend(struct mic_device *mdev);
 #endif
diff --git a/drivers/misc/mic/host/mic_main.c b/drivers/misc/mic/host/mic_main.c
index ca06aa9..b352085 100644
--- a/drivers/misc/mic/host/mic_main.c
+++ b/drivers/misc/mic/host/mic_main.c
@@ -26,6 +26,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/poll.h>
+#include <linux/suspend.h>
 
 #include <linux/mic_common.h>
 #include "../common/mic_dev.h"
@@ -187,6 +188,43 @@ static enum mic_hw_family mic_get_family(struct pci_dev *pdev)
 }
 
 /**
+* mic_pm_notifier: Notifier callback function that handles
+* PM notifications.
+*
+* @notifier_block: The notifier structure.
+* @pm_event: The event for which the driver was notified.
+* @unused: Meaningless. Always NULL.
+*
+* returns NOTIFY_DONE
+*/
+static int mic_pm_notifier(struct notifier_block *notifier,
+		unsigned long pm_event, void *unused)
+{
+	struct mic_device *mdev = container_of(notifier,
+		struct mic_device, pm_notifier);
+
+	switch (pm_event) {
+	case PM_HIBERNATION_PREPARE:
+		/* Fall through */
+	case PM_SUSPEND_PREPARE:
+		mic_prepare_suspend(mdev);
+		break;
+	case PM_POST_HIBERNATION:
+		/* Fall through */
+	case PM_POST_SUSPEND:
+		/* Fall through */
+	case PM_POST_RESTORE:
+		mic_complete_resume(mdev);
+		break;
+	case PM_RESTORE_PREPARE:
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_DONE;
+}
+
+/**
  * mic_device_init - Allocates and initializes the MIC device structure
  *
  * @mdev: pointer to mic_device instance
@@ -194,9 +232,11 @@ static enum mic_hw_family mic_get_family(struct pci_dev *pdev)
  *
  * returns none.
  */
-static void
+static int
 mic_device_init(struct mic_device *mdev, struct pci_dev *pdev)
 {
+	int rc;
+
 	mdev->family = mic_get_family(pdev);
 	mdev->stepping = pdev->revision;
 	mic_ops_init(mdev);
@@ -205,7 +245,20 @@ mic_device_init(struct mic_device *mdev, struct pci_dev *pdev)
 	mdev->irq_info.next_avail_src = 0;
 	INIT_WORK(&mdev->reset_trigger_work, mic_reset_trigger_work);
 	INIT_WORK(&mdev->shutdown_work, mic_shutdown_work);
+	init_completion(&mdev->reset_wait);
 	INIT_LIST_HEAD(&mdev->vdev_list);
+	mdev->pm_notifier.notifier_call = mic_pm_notifier;
+	rc = register_pm_notifier(&mdev->pm_notifier);
+	if (rc) {
+		dev_err(&pdev->dev, "register_pm_notifier failed rc %d\n",
+			rc);
+		goto register_pm_notifier_fail;
+	}
+	return 0;
+register_pm_notifier_fail:
+	flush_work(&mdev->shutdown_work);
+	flush_work(&mdev->reset_trigger_work);
+	return rc;
 }
 
 /**
@@ -224,6 +277,7 @@ static void mic_device_uninit(struct mic_device *mdev)
 	kfree(mdev->bootmode);
 	flush_work(&mdev->reset_trigger_work);
 	flush_work(&mdev->shutdown_work);
+	unregister_pm_notifier(&mdev->pm_notifier);
 }
 
 /**
@@ -253,7 +307,11 @@ static int mic_probe(struct pci_dev *pdev,
 		goto ida_fail;
 	}
 
-	mic_device_init(mdev, pdev);
+	rc = mic_device_init(mdev, pdev);
+	if (rc) {
+		dev_err(&pdev->dev, "mic_device_init failed rc %d\n", rc);
+		goto device_init_fail;
+	}
 
 	rc = pci_enable_device(pdev);
 	if (rc) {
@@ -376,6 +434,7 @@ disable_device:
 	pci_disable_device(pdev);
 uninit_device:
 	mic_device_uninit(mdev);
+device_init_fail:
 	ida_simple_remove(&g_mic_ida, mdev->id);
 ida_fail:
 	kfree(mdev);
diff --git a/drivers/misc/mic/host/mic_sysfs.c b/drivers/misc/mic/host/mic_sysfs.c
index 75746ad..6dd864e 100644
--- a/drivers/misc/mic/host/mic_sysfs.c
+++ b/drivers/misc/mic/host/mic_sysfs.c
@@ -33,6 +33,8 @@ static const char * const mic_state_string[] = {
 	[MIC_ONLINE] = "online",
 	[MIC_SHUTTING_DOWN] = "shutting_down",
 	[MIC_RESET_FAILED] = "reset_failed",
+	[MIC_SUSPENDING] = "suspending",
+	[MIC_SUSPENDED] = "suspended",
 };
 
 /*
@@ -156,6 +158,11 @@ state_store(struct device *dev, struct device_attribute *attr,
 		goto done;
 	}
 
+	if (sysfs_streq(buf, "suspend")) {
+		mic_suspend(mdev);
+		goto done;
+	}
+
 	count = -EINVAL;
 done:
 	return count;
diff --git a/include/uapi/linux/mic_common.h b/include/uapi/linux/mic_common.h
index 364ac75..17e7d95 100644
--- a/include/uapi/linux/mic_common.h
+++ b/include/uapi/linux/mic_common.h
@@ -219,6 +219,8 @@ enum mic_states {
 	MIC_ONLINE,
 	MIC_SHUTTING_DOWN,
 	MIC_RESET_FAILED,
+	MIC_SUSPENDING,
+	MIC_SUSPENDED,
 	MIC_LAST
 };
 
-- 
1.8.1.5

