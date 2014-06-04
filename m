Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbaFDX0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:26:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41067 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212AbaFDXYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:24:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Aaron Lu <aaron.lu@intel.com>, Levente Kurusa <levex@linux.com>,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.10 091/103] libata: clean up ZPODD when a port is detached
Date: Wed,  4 Jun 2014 16:25:54 -0700
Message-Id: <20140604232549.789437779@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232546.704156131@linuxfoundation.org>
References: <20140604232546.704156131@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/libata-core.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6300,6 +6300,8 @@ int ata_host_activate(struct ata_host *h
 static void ata_port_detach(struct ata_port *ap)
 {
 	unsigned long flags;
+	struct ata_link *link;
+	struct ata_device *dev;
 
 	if (!ap->ops->error_handler)
 		goto skip_eh;
@@ -6319,6 +6321,13 @@ static void ata_port_detach(struct ata_p
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


