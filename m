Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936625AbaFIJfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:35:48 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59137 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933477AbaFIJ0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:26:49 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Levente Kurusa <levex@linux.com>,
        Tejun Heo <tj@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 126/146] libata: clean up ZPODD when a port is detached
Date: Mon,  9 Jun 2014 10:51:01 +0200
Message-Id: <12099bea51969a7ae1561118127960470613398e.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Levente Kurusa <levex@linux.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/ata/libata-core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 97ae08de4b52..d7f00adbc374 100644
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
1.9.3

