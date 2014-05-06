Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467AbaEFN6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:58:00 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:59157 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbaEFN56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:57:58 -0400
From: Levente Kurusa <levex@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux ATA/IDE <linux-ide@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Joe Thomas <Joe.Thomas@dothill.com>, Levente Kurusa <levex@linux.com>
Subject: [PATCH] libata: clean up ZPODD when a port is detached
Date: Tue,  6 May 2014 15:57:48 +0200
Message-Id: <1399384668-20394-1-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a ZPODD device is unbound via sysfs, the ACPI notify handler
is not removed. This causes panics as observed in Bug #74601. The
panic only happens when the wake happens from outside the kernel
(i.e. inserting a media or pressing a button). Add a loop to
ata_port_detach which loops through the port's devices and checks
if zpodd is enabled, if so call zpodd_exit.

Cc: stable@vger.kernel.org
Reviewed-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Levente Kurusa <levex@linux.com>
---
 drivers/ata/libata-core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 943cc8b..ea83828 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6314,6 +6314,8 @@ int ata_host_activate(struct ata_host *host, int irq,
 static void ata_port_detach(struct ata_port *ap)
 {
 	unsigned long flags;
+	struct ata_link *link;
+	struct ata_device *dev;
 
 	if (!ap->ops->error_handler)
 		goto skip_eh;
@@ -6333,6 +6335,13 @@ static void ata_port_detach(struct ata_port *ap)
 	cancel_delayed_work_sync(&ap->hotplug_task);
 
  skip_eh:
+	/* clean up zpodd on port removal */
+	ata_for_each_link(link, ap, HOST_FIRST) {
+		ata_for_each_dev(dev, link, ALL) {
+			if (zpodd_dev_enabled(dev))
+				zpodd_exit(dev);
+		}
+	}
 	if (ap->pmp_link) {
 		int i;
 		for (i = 0; i < SATA_PMP_MAX_PORTS; i++)
-- 
1.8.3.1

