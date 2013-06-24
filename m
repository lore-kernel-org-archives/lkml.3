Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956Ab3FXMeE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 08:34:04 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:49033 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954Ab3FXMeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 08:34:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Cc: Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Jiang Liu <jiang.liu@huawei.com>, Dirk Griesbach <spamthis@freenet.de>
Subject: [PATCH] libata-acpi: add back ACPI based hotplug functionality
Date: Mon, 24 Jun 2013 14:43:27 +0200
Message-ID: <1715067.uK3nZ8ehWr@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaron Lu <aaron.lu@intel.com>

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
---

Hi Tejun,

If I'm not overlooking any hidden twists, it should be safe to add this
patch on top of the following three that I'm going to push for 3.10
in a couple of days (unless 3.10 is released first):

https://patchwork.kernel.org/patch/2766491/
https://patchwork.kernel.org/patch/2766501/
https://patchwork.kernel.org/patch/2768521/

May I add the $subject patch to that series and push along with it?

Rafael

---
 drivers/ata/libata-acpi.c |   37 ++++++++++++++++++++++++++++++++++++-
 drivers/ata/libata-core.c |    2 ++
 drivers/ata/libata.h      |    2 ++
 3 files changed, 40 insertions(+), 1 deletion(-)

Index: linux-pm/drivers/ata/libata-acpi.c
===================================================================
--- linux-pm.orig/drivers/ata/libata-acpi.c
+++ linux-pm/drivers/ata/libata-acpi.c
@@ -156,8 +156,10 @@ static void ata_acpi_handle_hotplug(stru
 
 	spin_unlock_irqrestore(ap->lock, flags);
 
-	if (wait)
+	if (wait) {
 		ata_port_wait_eh(ap);
+		flush_work(&ap->hotplug_task.work);
+	}
 }
 
 static void ata_acpi_dev_notify_dock(acpi_handle handle, u32 event, void *data)
@@ -214,6 +216,39 @@ static const struct acpi_dock_ops ata_ac
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
+						     &ata_acpi_ap_dock_ops, ap,
+						     NULL, NULL);
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
+						     dev, NULL, NULL);
+		}
+	}
+}
+
 /**
  * ata_acpi_dissociate - dissociate ATA host from ACPI objects
  * @host: target ATA host
Index: linux-pm/drivers/ata/libata-core.c
===================================================================
--- linux-pm.orig/drivers/ata/libata-core.c
+++ linux-pm/drivers/ata/libata-core.c
@@ -6148,6 +6148,8 @@ int ata_host_register(struct ata_host *h
 	if (rc)
 		goto err_tadd;
 
+	ata_acpi_hotplug_init(host);
+
 	/* set cable, sata_spd_limit and report */
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
Index: linux-pm/drivers/ata/libata.h
===================================================================
--- linux-pm.orig/drivers/ata/libata.h
+++ linux-pm/drivers/ata/libata.h
@@ -122,6 +122,7 @@ extern int ata_acpi_register(void);
 extern void ata_acpi_unregister(void);
 extern void ata_acpi_bind(struct ata_device *dev);
 extern void ata_acpi_unbind(struct ata_device *dev);
+extern void ata_acpi_hotplug_init(struct ata_host *host);
 #else
 static inline void ata_acpi_dissociate(struct ata_host *host) { }
 static inline int ata_acpi_on_suspend(struct ata_port *ap) { return 0; }
@@ -134,6 +135,7 @@ static inline int ata_acpi_register(void
 static inline void ata_acpi_unregister(void) { }
 static inline void ata_acpi_bind(struct ata_device *dev) { }
 static inline void ata_acpi_unbind(struct ata_device *dev) { }
+static inline void ata_acpi_hotplug_init(struct ata_host *host) {}
 #endif
 
 /* libata-scsi.c */

