Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab3EUXz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 19:55:28 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:51213 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab3EUXzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 19:55:24 -0400
Date: Wed, 22 May 2013 08:55:19 +0900
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>, Jan Beulich <JBeulich@suse.com>
Subject: [PATCH] AHCI: Make distinct names for ports in /proc/interrupts
 /proc/interrupts
Message-ID: <20130521235519.GF6985@mtj.dyndns.org>
References: <cover.1369161950.git.agordeev@redhat.com>
 <fcdc76842896b5884b480b5778339e1e6a19f181.1369161950.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fcdc76842896b5884b480b5778339e1e6a19f181.1369161950.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've refreshed on top of libata/for-3.11 and applied it.  If I broke
something, please let me know.

Thanks a lot!

>From b29900e62598cecd519c9ab2b8e4d03f8ebf702d Mon Sep 17 00:00:00 2001
From: Alexander Gordeev <agordeev@redhat.com>
Date: Wed, 22 May 2013 08:53:48 +0900

Currently all interrupts assigned to AHCI ports show up in
'/proc/interrupts' as 'ahci'. This fix adds port numbers as
suffixes and hence makes the descriptions distinct.

Reported-by: Jan Beulich <JBeulich@suse.com>
Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/ata/ahci.c    |  4 +++-
 drivers/ata/ahci.h    |  1 +
 drivers/ata/libahci.c | 10 ++++++++++
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 251e57d..4d1c672 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1142,9 +1142,11 @@ int ahci_host_activate(struct ata_host *host, int irq, unsigned int n_msis)
 		return rc;
 
 	for (i = 0; i < host->n_ports; i++) {
+		struct ahci_port_priv *pp = host->ports[i]->private_data;
+
 		rc = devm_request_threaded_irq(host->dev,
 			irq + i, ahci_hw_interrupt, ahci_thread_fn, IRQF_SHARED,
-			dev_driver_string(host->dev), host->ports[i]);
+			pp->irq_desc, host->ports[i]);
 		if (rc)
 			goto out_free_irqs;
 	}
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index b830e6c..05adf29 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -306,6 +306,7 @@ struct ahci_port_priv {
 	int			fbs_last_dev;	/* save FBS.DEV of last FIS */
 	/* enclosure management info per PM slot */
 	struct ahci_em_priv	em_priv[EM_MAX_SLOTS];
+	char			*irq_desc;	/* desc in /proc/interrupts */
 };
 
 struct ahci_host_priv {
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 34c8216..3797a7b 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -2234,6 +2234,16 @@ static int ahci_port_start(struct ata_port *ap)
 	if (!pp)
 		return -ENOMEM;
 
+	if (ap->host->n_ports > 1) {
+		pp->irq_desc = devm_kzalloc(dev, 8, GFP_KERNEL);
+		if (!pp->irq_desc) {
+			devm_kfree(dev, pp);
+			return -ENOMEM;
+		}
+		snprintf(pp->irq_desc, 8,
+			 "%s%d", dev_driver_string(dev), ap->port_no);
+	}
+
 	/* check FBS capability */
 	if ((hpriv->cap & HOST_CAP_FBS) && sata_pmp_supported(ap)) {
 		void __iomem *port_mmio = ahci_port_base(ap);
-- 
1.8.1.4

