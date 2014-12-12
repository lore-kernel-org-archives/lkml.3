Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966522AbaLLGzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:55:42 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51752 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758673AbaLLGQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:54 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Tomas Winkler" <tomas.winkler@intel.com>,
        "Alexander Usyskin" <alexander.usyskin@intel.com>
Date: Fri, 12 Dec 2014 06:14:26 +0000
Message-ID: <lsq.1418364866.800329869@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 159/164] mei: limit the number of consecutive resets
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Winkler <tomas.winkler@intel.com>

commit 6adb8efb024a7e413b93b22848fc13395b1a438a upstream.

give up reseting after 3 unsuccessful tries

[Backported to 3.2: files were moved]
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/mei/init.c      |  9 +++++++++
 drivers/staging/mei/interrupt.c |  4 +++-
 drivers/staging/mei/mei_dev.h   | 12 +++++++++++-
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/mei/init.c b/drivers/staging/mei/init.c
index 8bf34794489c..a78e63bc6dbe 100644
--- a/drivers/staging/mei/init.c
+++ b/drivers/staging/mei/init.c
@@ -132,6 +132,7 @@ struct mei_device *mei_device_init(struct pci_dev *pdev)
 	init_waitqueue_head(&dev->wait_recvd_msg);
 	init_waitqueue_head(&dev->wait_stop_wd);
 	dev->mei_state = MEI_INITIALIZING;
+	dev->reset_count = 0;
 	dev->iamthif_state = MEI_IAMTHIF_IDLE;
 	dev->wd_interface_reg = false;
 
@@ -290,6 +291,14 @@ void mei_reset(struct mei_device *dev, int interrupts_enabled)
 
 	dev->need_reset = false;
 
+	dev->reset_count++;
+	if (dev->reset_count > MEI_MAX_CONSEC_RESET) {
+		dev_err(&dev->pdev->dev, "reset: reached maximal consecutive resets: disabling the device\n");
+		dev->mei_state = MEI_DISABLED;
+		return;
+	}
+
+
 	if (dev->mei_state != MEI_INITIALIZING) {
 		if (dev->mei_state != MEI_DISABLED &&
 		    dev->mei_state != MEI_POWER_DOWN)
diff --git a/drivers/staging/mei/interrupt.c b/drivers/staging/mei/interrupt.c
index 882d106d54e5..42b7c9a4a3c4 100644
--- a/drivers/staging/mei/interrupt.c
+++ b/drivers/staging/mei/interrupt.c
@@ -770,6 +770,7 @@ static void mei_irq_thread_read_bus_message(struct mei_device *dev,
 					 */
 					bitmap_set(dev->host_clients_map, 0, 3);
 					dev->mei_state = MEI_ENABLED;
+					dev->reset_count = 0;
 
 					/* if wd initialization fails, initialization the AMTHI client,
 					 * otherwise the AMTHI client will be initialized after the WD client connect response
@@ -1527,7 +1528,8 @@ void mei_timer(struct work_struct *work)
 		}
 	}
 out:
-	 schedule_delayed_work(&dev->timer_work, 2 * HZ);
+	 if (dev->mei_state != MEI_DISABLED)
+		schedule_delayed_work(&dev->timer_work, 2 * HZ);
 	 mutex_unlock(&dev->device_lock);
 }
 
diff --git a/drivers/staging/mei/mei_dev.h b/drivers/staging/mei/mei_dev.h
index af4b1af9eeac..264bf2366276 100644
--- a/drivers/staging/mei/mei_dev.h
+++ b/drivers/staging/mei/mei_dev.h
@@ -64,6 +64,11 @@ extern const uuid_le mei_wd_guid;
 extern const u8 mei_wd_state_independence_msg[3][4];
 
 /*
+ * maximum number of consecutive resets
+ */
+#define MEI_MAX_CONSEC_RESET  3
+
+/*
  * Number of File descriptors/handles
  * that can be opened to the driver.
  *
@@ -178,7 +183,11 @@ struct mei_io_list {
 	int status;
 };
 
-/* MEI private device struct */
+/**
+ * mei_device - MEI private device struct
+ *
+ * @reset_count - limits the number of consecutive resets
+ */
 struct mei_device {
 	struct pci_dev *pdev;	/* pointer to pci device struct */
 	/*
@@ -225,6 +234,7 @@ struct mei_device {
 	/*
 	 * mei device  states
 	 */
+	unsigned long reset_count;
 	enum mei_states mei_state;
 	enum mei_init_clients_states init_clients_state;
 	u16 init_clients_timer;

