Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab3EUTEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 15:04:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764Ab3EUTEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 15:04:35 -0400
Date: Tue, 21 May 2013 21:03:40 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>, Jan Beulich <JBeulich@suse.com>
Subject: [PATCH RESEND 1/1] AHCI: Make distinct names for ports in
 /proc/interrupts
Message-ID: <fcdc76842896b5884b480b5778339e1e6a19f181.1369161950.git.agordeev@redhat.com>
References: <cover.1369161950.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1369161950.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently all interrupts assigned to AHCI ports show up in
'/proc/interrupts' as 'ahci'. This fix adds port numbers as
suffixes and hence makes the descriptions distinct.

Reported-by: Jan Beulich <JBeulich@suse.com>
Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/ata/ahci.c    |    5 +++--
 drivers/ata/ahci.h    |    1 +
 drivers/ata/libahci.c |   10 ++++++++++
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index e4d915f..32dd3e2 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1148,10 +1148,11 @@ int ahci_host_activate(struct ata_host *host, int irq, unsigned int n_msis,
 			return -EINVAL;
 
 		for (i = 0; i < n_irqs; i++) {
+			struct ahci_port_priv *pp = host->ports[i]->private_data;
+
 			rc = devm_request_threaded_irq(host->dev, irq + i,
 				ahci_multi_irqs_intr, ahci_port_thread_fn,
-				IRQF_SHARED, dev_driver_string(host->dev),
-				host->ports[i]);
+				IRQF_SHARED, pp->irq_desc, host->ports[i]);
 			if (rc)
 				goto out_free_irqs;
 		}
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index ed1fbc8..7386dfd 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -305,6 +305,7 @@ struct ahci_port_priv {
 	int			fbs_last_dev;	/* save FBS.DEV of last FIS */
 	/* enclosure management info per PM slot */
 	struct ahci_em_priv	em_priv[EM_MAX_SLOTS];
+	char			*irq_desc;	/* desc in /proc/interrupts */
 };
 
 struct ahci_host_priv {
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 68b3bdd..2b56769 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -2251,6 +2251,16 @@ static int ahci_port_start(struct ata_port *ap)
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
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
