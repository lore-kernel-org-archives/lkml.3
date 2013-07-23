Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab3GWDyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 23:54:23 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:42438 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab3GWDyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 23:54:20 -0400
From: Xiaotian Feng <xtfeng@gmail.com>
Cc: Xiaotian Feng <xtfeng@gmail.com>, Alexander Gordeev <agordeev@redhat.com>,
        Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] AHCI: fix Null pointer dereference in achi_host_active()
Date: Tue, 23 Jul 2013 11:54:10 +0800
Message-Id: <1374551650-56759-1-git-send-email-xtfeng@gmail.com>
X-Mailer: git-send-email 1.7.9.6 (Apple Git-31.1)
In-Reply-To: <20130722212822.GB16776@mtj.dyndns.org>
References: <20130722212822.GB16776@mtj.dyndns.org>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit b29900e6 (AHCI: Make distinct names for ports in /proc/interrupts)
introuded a regression, which resulted Null pointer dereference for achi
host with dummy ports. For ahci ports, when the port is dummy port, its
private_data will be NULL, as ata_dummy_port_ops doesn't support ->port_start.

changes in v2: use pp to check dummy ports, update comments

Reported-and-tested-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Xiaotian Feng <xtfeng@gmail.com>
Cc: Alexander Gordeev <agordeev@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/ata/ahci.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 5064f3e..db4380d 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1146,11 +1146,18 @@ int ahci_host_activate(struct ata_host *host, int irq, unsigned int n_msis)
 		return rc;
 
 	for (i = 0; i < host->n_ports; i++) {
+		const char* desc;
 		struct ahci_port_priv *pp = host->ports[i]->private_data;
 
+		/* pp is NULL for dummy ports */
+		if (pp)
+			desc = pp->irq_desc;
+		else
+			desc = dev_driver_string(host->dev);
+
 		rc = devm_request_threaded_irq(host->dev,
 			irq + i, ahci_hw_interrupt, ahci_thread_fn, IRQF_SHARED,
-			pp->irq_desc, host->ports[i]);
+			desc, host->ports[i]);
 		if (rc)
 			goto out_free_irqs;
 	}
-- 
1.7.9.6 (Apple Git-31.1)

