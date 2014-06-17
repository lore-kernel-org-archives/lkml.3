Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966118AbaFQVsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:48:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53949 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966078AbaFQVsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:48:08 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Levente Kurusa <levex@linux.com>, Tejun Heo <tj@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 095/212] libata: clean up ZPODD when a port is detached
Date: Tue, 17 Jun 2014 14:43:09 -0700
Message-Id: <1403041506-13646-96-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Levente Kurusa <levex@linux.com>

commit a6f9bf4d2f965b862b95213303d154e02957eed8 upstream.

When a ZPODD device is unbound via sysfs, the ACPI notify handler
is not removed. This causes panics as observed in Bug #74601. The
panic only happens when the wake happens from outside the kernel
(i.e. inserting a media or pressing a button). Add a loop to
ata_port_detach which loops through the port's devices and checks
if zpodd is enabled, if so call zpodd_exit.

Reviewed-by: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Levente Kurusa <levex@linux.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/ata/libata-core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 5ab4e3d..62fda16 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6329,6 +6329,8 @@ int ata_host_activate(struct ata_host *host, int irq,
 static void ata_port_detach(struct ata_port *ap)
 {
 	unsigned long flags;
+	struct ata_link *link;
+	struct ata_device *dev;
 
 	if (!ap->ops->error_handler)
 		goto skip_eh;
@@ -6348,6 +6350,13 @@ static void ata_port_detach(struct ata_port *ap)
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
1.9.1

