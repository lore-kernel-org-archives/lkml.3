Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab3F1S4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:56:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41780 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab3F1S4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:56:04 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Aaron Lu <aaron.lu@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 097/105] libata-acpi: add back ACPI based hotplug functionality
Date: Fri, 28 Jun 2013 11:51:59 -0700
Message-Id: <1372445527-24414-98-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Lu <aaron.lu@intel.com>

commit 44521527be36172864e6e7a6fba4b66e9aa48e40 upstream.

Commit 30dcf76acc69 "libata: migrate ACPI code over to new bindings"
mistakenly dropped the code to register hotplug notificaion handler
for ATA port/devices, causing regression for people using ATA bay,
as kernel bug #59871 shows.

Fix this by adding back the hotplug notification handler registration
code.  Since this code has to be run once and notification needs to
be installed on every ATA port/devices handle no matter if there is
actual device attached, we can't do this in binding time for ATA
device ACPI handle, as the binding only occurs when a SCSI device is
created, i.e. there is device attached.  So introduce the
ata_acpi_hotplug_init() function to loop scan all ATA ACPI handles
and if it is available, install the notificaion handler for it during
ATA init time.

With the ATA ACPI handle binding to SCSI device tree, it is possible
now that when the SCSI hotplug work removes the SCSI device, the ACPI
unbind function will find that the corresponding ACPI device has
already been deleted by dock driver, causing a scaring message like:
[  128.263966] scsi 4:0:0:0: Oops, 'acpi_handle' corrupt
Fix this by waiting for SCSI hotplug task finish in our notificaion
handler, so that the removal of ACPI device done in ACPI unbind
function triggered by the removal of SCSI device is run earlier when
ACPI device is still available.

[rjw: Rebased]
References: https://bugzilla.kernel.org/show_bug.cgi?id=59871
Reported-bisected-and-tested-by: Dirk Griesbach <spamthis@freenet.de>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ kamal: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/ata/libata-acpi.c | 36 +++++++++++++++++++++++++++++++++++-
 drivers/ata/libata-core.c |  2 ++
 drivers/ata/libata.h      |  2 ++
 3 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index cc8aa9e..4cdeee4 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -156,8 +156,10 @@ static void ata_acpi_handle_hotplug(struct ata_port *ap, struct ata_device *dev,
 
 	spin_unlock_irqrestore(ap->lock, flags);
 
-	if (wait)
+	if (wait) {
 		ata_port_wait_eh(ap);
+		flush_work(&ap->hotplug_task.work);
+	}
 }
 
 static void ata_acpi_dev_notify_dock(acpi_handle handle, u32 event, void *data)
@@ -214,6 +216,38 @@ static const struct acpi_dock_ops ata_acpi_ap_dock_ops = {
 	.uevent = ata_acpi_ap_uevent,
 };
 
+void ata_acpi_hotplug_init(struct ata_host *host)
+{
+	int i;
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+		acpi_handle handle;
+		struct ata_device *dev;
+
+		if (!ap)
+			continue;
+
+		handle = ata_ap_acpi_handle(ap);
+		if (handle) {
+			/* we might be on a docking station */
+			register_hotplug_dock_device(handle,
+						     &ata_acpi_ap_dock_ops, ap);
+		}
+
+		ata_for_each_dev(dev, &ap->link, ALL) {
+			handle = ata_dev_acpi_handle(dev);
+			if (!handle)
+				continue;
+
+			/* we might be on a docking station */
+			register_hotplug_dock_device(handle,
+						     &ata_acpi_dev_dock_ops,
+						     dev);
+		}
+	}
+}
+
 /**
  * ata_acpi_dissociate - dissociate ATA host from ACPI objects
  * @host: target ATA host
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 3b3afa8..5866bf5 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6124,6 +6124,8 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 	if (rc)
 		goto err_tadd;
 
+	ata_acpi_hotplug_init(host);
+
 	/* set cable, sata_spd_limit and report */
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 7148a58..15ac13f 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -122,6 +122,7 @@ extern int ata_acpi_register(void);
 extern void ata_acpi_unregister(void);
 extern void ata_acpi_bind(struct ata_device *dev);
 extern void ata_acpi_unbind(struct ata_device *dev);
+extern void ata_acpi_hotplug_init(struct ata_host *host);
 #else
 static inline void ata_acpi_dissociate(struct ata_host *host) { }
 static inline int ata_acpi_on_suspend(struct ata_port *ap) { return 0; }
@@ -134,6 +135,7 @@ static inline int ata_acpi_register(void) { return 0; }
 static inline void ata_acpi_unregister(void) { }
 static inline void ata_acpi_bind(struct ata_device *dev) { }
 static inline void ata_acpi_unbind(struct ata_device *dev) { }
+static inline void ata_acpi_hotplug_init(struct ata_host *host) {}
 #endif
 
 /* libata-scsi.c */
-- 
1.8.1.2

