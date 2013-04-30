Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933822Ab3D3V23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 17:28:29 -0400
Received: from mxout1.idt.com ([157.165.5.25]:60679 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933058Ab3D3V2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 17:28:20 -0400
From: Alexandre Bounine <alexandre.bounine@idt.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Alexandre Bounine <alexandre.bounine@idt.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Li Yang <leoli@freescale.com>, Kumar Gala <galak@kernel.crashing.org>,
        Andre van Herk <andre.van.herk@Prodrive.nl>,
        Micha Nelissen <micha.nelissen@Prodrive.nl>
Subject: [PATCH v2 2/3] rapidio: add enumeration/discovery start from user space
Date: Tue, 30 Apr 2013 17:25:54 -0400
Message-Id: <1367357155-11586-3-git-send-email-alexandre.bounine@idt.com>
X-Mailer: git-send-email 1.7.8.4
In-Reply-To: <1367357155-11586-1-git-send-email-alexandre.bounine@idt.com>
References: <1367357155-11586-1-git-send-email-alexandre.bounine@idt.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add RapidIO enumeration/discovery start from user space.
User space start allows to defer RapidIO fabric scan until the moment when all
participating endpoints are initialized avoiding mandatory synchronized start
of all endpoints (which may be challenging in systems with large number of
RapidIO endpoints).

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@Prodrive.nl>
Cc: Micha Nelissen <micha.nelissen@Prodrive.nl>
---
 drivers/rapidio/rio-driver.c |    1 +
 drivers/rapidio/rio-scan.c   |   24 +++++++++++++++++++--
 drivers/rapidio/rio-sysfs.c  |   45 ++++++++++++++++++++++++++++++++++++++++++
 drivers/rapidio/rio.c        |   28 ++++++++++++++++++++++++-
 drivers/rapidio/rio.h        |    2 +
 include/linux/rio.h          |    9 ++++++-
 6 files changed, 102 insertions(+), 7 deletions(-)

diff --git a/drivers/rapidio/rio-driver.c b/drivers/rapidio/rio-driver.c
index 55850bb..a0c8755 100644
--- a/drivers/rapidio/rio-driver.c
+++ b/drivers/rapidio/rio-driver.c
@@ -207,6 +207,7 @@ struct bus_type rio_bus_type = {
 	.name = "rapidio",
 	.match = rio_match_bus,
 	.dev_attrs = rio_dev_attrs,
+	.bus_attrs = rio_bus_attrs,
 	.probe = rio_device_probe,
 	.remove = rio_device_remove,
 };
diff --git a/drivers/rapidio/rio-scan.c b/drivers/rapidio/rio-scan.c
index 7bdc674..4c15dbf 100644
--- a/drivers/rapidio/rio-scan.c
+++ b/drivers/rapidio/rio-scan.c
@@ -1134,19 +1134,30 @@ static void rio_pw_enable(struct rio_mport *port, int enable)
 /**
  * rio_enum_mport- Start enumeration through a master port
  * @mport: Master port to send transactions
+ * @flags: Enumeration control flags
  *
  * Starts the enumeration process. If somebody has enumerated our
  * master port device, then give up. If not and we have an active
  * link, then start recursive peer enumeration. Returns %0 if
  * enumeration succeeds or %-EBUSY if enumeration fails.
  */
-int rio_enum_mport(struct rio_mport *mport)
+int rio_enum_mport(struct rio_mport *mport, u32 flags)
 {
 	struct rio_net *net = NULL;
 	int rc = 0;
 
 	printk(KERN_INFO "RIO: enumerate master port %d, %s\n", mport->id,
 	       mport->name);
+
+	/*
+	 * To avoid multiple start requests (repeat enumeration is not supported
+	 * by this method) check if enumeration/discovery was performed for this
+	 * mport: if mport was added into the list of mports for a net exit
+	 * with error.
+	 */
+	if (mport->nnode.next || mport->nnode.prev)
+		return -EBUSY;
+
 	/* If somebody else enumerated our master port device, bail. */
 	if (rio_enum_host(mport) < 0) {
 		printk(KERN_INFO
@@ -1236,14 +1247,16 @@ static void rio_build_route_tables(struct rio_net *net)
 /**
  * rio_disc_mport- Start discovery through a master port
  * @mport: Master port to send transactions
+ * @flags: discovery control flags
  *
  * Starts the discovery process. If we have an active link,
- * then wait for the signal that enumeration is complete.
+ * then wait for the signal that enumeration is complete (if wait
+ * is allowed).
  * When enumeration completion is signaled, start recursive
  * peer discovery. Returns %0 if discovery succeeds or %-EBUSY
  * on failure.
  */
-int rio_disc_mport(struct rio_mport *mport)
+int rio_disc_mport(struct rio_mport *mport, u32 flags)
 {
 	struct rio_net *net = NULL;
 	unsigned long to_end;
@@ -1253,6 +1266,11 @@ int rio_disc_mport(struct rio_mport *mport)
 
 	/* If master port has an active link, allocate net and discover peers */
 	if (rio_mport_is_active(mport)) {
+		if (rio_enum_complete(mport))
+			goto enum_done;
+		else if (flags & RIO_SCAN_ENUM_NO_WAIT)
+			return -EAGAIN;
+
 		pr_debug("RIO: wait for enumeration to complete...\n");
 
 		to_end = jiffies + CONFIG_RAPIDIO_DISC_TIMEOUT * HZ;
diff --git a/drivers/rapidio/rio-sysfs.c b/drivers/rapidio/rio-sysfs.c
index 4dbe360..66d4acd 100644
--- a/drivers/rapidio/rio-sysfs.c
+++ b/drivers/rapidio/rio-sysfs.c
@@ -285,3 +285,48 @@ void rio_remove_sysfs_dev_files(struct rio_dev *rdev)
 			rdev->rswitch->sw_sysfs(rdev, RIO_SW_SYSFS_REMOVE);
 	}
 }
+
+static ssize_t bus_scan_store(struct bus_type *bus, const char *buf,
+				size_t count)
+{
+	long val;
+	struct rio_mport *port = NULL;
+	int rc;
+
+	if (kstrtol(buf, 0, &val) < 0)
+		return -EINVAL;
+
+	if (val == RIO_MPORT_ANY) {
+		rc = rio_init_mports();
+		goto exit;
+	}
+
+	if (val < 0 || val >= RIO_MAX_MPORTS)
+		return -EINVAL;
+
+	port = rio_find_mport((int)val);
+
+	if (!port) {
+		pr_debug("RIO: %s: mport_%d not available\n",
+			 __func__, (int)val);
+		return -EINVAL;
+	}
+
+	if (!port->nscan)
+		return -EINVAL;
+
+	if (port->host_deviceid >= 0)
+		rc = port->nscan->enumerate(port, 0);
+	else
+		rc = port->nscan->discover(port, RIO_SCAN_ENUM_NO_WAIT);
+exit:
+	if (!rc)
+		rc = count;
+
+	return rc;
+}
+
+struct bus_attribute rio_bus_attrs[] = {
+	__ATTR(scan, (S_IWUSR|S_IWGRP), NULL, bus_scan_store),
+	__ATTR_NULL
+};
diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
index 6e75dda..cb1c089 100644
--- a/drivers/rapidio/rio.c
+++ b/drivers/rapidio/rio.c
@@ -1383,6 +1383,30 @@ EXPORT_SYMBOL_GPL(rio_dma_prep_slave_sg);
 #endif /* CONFIG_RAPIDIO_DMA_ENGINE */
 
 /**
+ * rio_find_mport - find RIO mport by its ID
+ * @mport_id: number (ID) of mport device
+ *
+ * Given a RIO mport number, the desired mport is located
+ * in the global list of mports. If the mport is found, a pointer to its
+ * data structure is returned.  If no mport is found, %NULL is returned.
+ */
+struct rio_mport *rio_find_mport(int mport_id)
+{
+	struct rio_mport *port;
+
+	mutex_lock(&rio_mport_list_lock);
+	list_for_each_entry(port, &rio_mports, node) {
+		if (port->id == mport_id)
+			goto found;
+	}
+	port = NULL;
+found:
+	mutex_unlock(&rio_mport_list_lock);
+
+	return port;
+}
+
+/**
  * rio_register_scan - enumeration/discovery method registration interface
  * @mport_id: mport device ID for which fabric scan routine has to be set
  *            (RIO_MPORT_ANY = set for all available mports)
@@ -1475,7 +1499,7 @@ static void disc_work_handler(struct work_struct *_work)
 	work = container_of(_work, struct rio_disc_work, work);
 	pr_debug("RIO: discovery work for mport %d %s\n",
 		 work->mport->id, work->mport->name);
-	work->mport->nscan->discover(work->mport);
+	work->mport->nscan->discover(work->mport, 0);
 }
 
 int rio_init_mports(void)
@@ -1495,7 +1519,7 @@ int rio_init_mports(void)
 	list_for_each_entry(port, &rio_mports, node) {
 		if (port->host_deviceid >= 0) {
 			if (port->nscan)
-				port->nscan->enumerate(port);
+				port->nscan->enumerate(port, 0);
 		} else
 			n++;
 	}
diff --git a/drivers/rapidio/rio.h b/drivers/rapidio/rio.h
index 0afdf48..c14f864 100644
--- a/drivers/rapidio/rio.h
+++ b/drivers/rapidio/rio.h
@@ -45,9 +45,11 @@ extern int rio_enable_rx_tx_port(struct rio_mport *port, int local, u16 destid,
 extern int rio_register_scan(int mport_id, struct rio_scan *scan_ops);
 extern int rio_unregister_scan(int mport_id);
 extern void rio_attach_device(struct rio_dev *rdev);
+extern struct rio_mport *rio_find_mport(int mport_id);
 
 /* Structures internal to the RIO core code */
 extern struct device_attribute rio_dev_attrs[];
+extern struct bus_attribute rio_bus_attrs[];
 
 extern struct rio_switch_ops __start_rio_switch_ops[];
 extern struct rio_switch_ops __end_rio_switch_ops[];
diff --git a/include/linux/rio.h b/include/linux/rio.h
index cd3796e..18e0993 100644
--- a/include/linux/rio.h
+++ b/include/linux/rio.h
@@ -265,6 +265,11 @@ struct rio_mport {
 	struct rio_scan *nscan;
 };
 
+/*
+ * Enumeration/discovery control flags
+ */
+#define RIO_SCAN_ENUM_NO_WAIT	0x00000001 /* Do not wait for enum completed */
+
 struct rio_id_table {
 	u16 start;	/* logical minimal id */
 	u32 max;	/* max number of IDs in table */
@@ -467,8 +472,8 @@ static inline struct rio_mport *dma_to_mport(struct dma_device *ddev)
  * @discover: Callback to perform RapidIO fabric discovery.
  */
 struct rio_scan {
-	int (*enumerate)(struct rio_mport *mport);
-	int (*discover)(struct rio_mport *mport);
+	int (*enumerate)(struct rio_mport *mport, u32 flags);
+	int (*discover)(struct rio_mport *mport, u32 flags);
 };
 
 /* Architecture and hardware-specific functions */
-- 
1.7.8.4

