Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135Ab3LFX1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:27:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48998 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162437Ab3LFXUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:20:44 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Xiangliang Yu <yuxiangl@marvell.com>, Tejun Heo <tj@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 026/152] ahci: disabled FBS prior to issuing software reset
Date: Fri,  6 Dec 2013 15:09:10 -0800
Message-Id: <1386371476-2477-27-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: xiangliang yu <yxlraid@gmail.com>

commit 89dafa20f3daab5b3e0c13d0068a28e8e64e2102 upstream.

Tested with Marvell 88se9125, attached with one port mulitplier(5 ports)
and one disk, we will get following boot log messages if using current
code:

  ata8: SATA link up 6.0 Gbps (SStatus 133 SControl 330)
  ata8.15: Port Multiplier 1.2, 0x1b4b:0x9715 r160, 5 ports, feat 0x1/0x1f
  ahci 0000:03:00.0: FBS is enabled
  ata8.00: hard resetting link
  ata8.00: SATA link down (SStatus 0 SControl 330)
  ata8.01: hard resetting link
  ata8.01: SATA link down (SStatus 0 SControl 330)
  ata8.02: hard resetting link
  ata8.02: SATA link down (SStatus 0 SControl 330)
  ata8.03: hard resetting link
  ata8.03: SATA link up 6.0 Gbps (SStatus 133 SControl 133)
  ata8.04: hard resetting link
  ata8.04: failed to resume link (SControl 133)
  ata8.04: failed to read SCR 0 (Emask=0x40)
  ata8.04: failed to read SCR 0 (Emask=0x40)
  ata8.04: failed to read SCR 1 (Emask=0x40)
  ata8.04: failed to read SCR 0 (Emask=0x40)
  ata8.03: native sectors (2) is smaller than sectors (976773168)
  ata8.03: ATA-8: ST3500413AS, JC4B, max UDMA/133
  ata8.03: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
  ata8.03: configured for UDMA/133
  ata8.04: failed to IDENTIFY (I/O error, err_mask=0x100)
  ata8.15: hard resetting link
  ata8.15: SATA link up 6.0 Gbps (SStatus 133 SControl 330)
  ata8.15: Port Multiplier vendor mismatch '0x1b4b' != '0x133'
  ata8.15: PMP revalidation failed (errno=-19)
  ata8.15: hard resetting link
  ata8.15: SATA link up 6.0 Gbps (SStatus 133 SControl 330)
  ata8.15: Port Multiplier vendor mismatch '0x1b4b' != '0x133'
  ata8.15: PMP revalidation failed (errno=-19)
  ata8.15: limiting SATA link speed to 3.0 Gbps
  ata8.15: hard resetting link
  ata8.15: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
  ata8.15: Port Multiplier vendor mismatch '0x1b4b' != '0x133'
  ata8.15: PMP revalidation failed (errno=-19)
  ata8.15: failed to recover PMP after 5 tries, giving up
  ata8.15: Port Multiplier detaching
  ata8.03: disabled
  ata8.00: disabled
  ata8: EH complete

The reason is that current detection code doesn't follow AHCI spec:

First,the port multiplier detection process look like this:

	ahci_hardreset(link, class, deadline)
	if (class == ATA_DEV_PMP) {
		sata_pmp_attach(dev)	/* will enable FBS */
		sata_pmp_init_links(ap, nr_ports);
		ata_for_each_link(link, ap, EDGE) {
			sata_std_hardreset(link, class, deadline);
			if (link_is_online)	/* do soft reset */
				ahci_softreset(link, class, deadline);
		}
	}
But, according to chapter 9.3.9 in AHCI spec: Prior to issuing software
reset, software shall clear PxCMD.ST to '0' and then clear PxFBS.EN to
'0'.

The patch test ok with kernel 3.11.1.

tj: Patch white space contaminated, applied manually with trivial
    updates.

Signed-off-by: Xiangliang Yu <yuxiangl@marvell.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/ata/libahci.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index c86d560..a2fe286 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1266,9 +1266,11 @@ int ahci_do_softreset(struct ata_link *link, unsigned int *class,
 {
 	struct ata_port *ap = link->ap;
 	struct ahci_host_priv *hpriv = ap->host->private_data;
+	struct ahci_port_priv *pp = ap->private_data;
 	const char *reason = NULL;
 	unsigned long now, msecs;
 	struct ata_taskfile tf;
+	bool fbs_disabled = false;
 	int rc;
 
 	DPRINTK("ENTER\n");
@@ -1278,6 +1280,16 @@ int ahci_do_softreset(struct ata_link *link, unsigned int *class,
 	if (rc && rc != -EOPNOTSUPP)
 		ata_link_warn(link, "failed to reset engine (errno=%d)\n", rc);
 
+	/*
+	 * According to AHCI-1.2 9.3.9: if FBS is enable, software shall
+	 * clear PxFBS.EN to '0' prior to issuing software reset to devices
+	 * that is attached to port multiplier.
+	 */
+	if (!ata_is_host_link(link) && pp->fbs_enabled) {
+		ahci_disable_fbs(ap);
+		fbs_disabled = true;
+	}
+
 	ata_tf_init(link->device, &tf);
 
 	/* issue the first D2H Register FIS */
@@ -1318,6 +1330,10 @@ int ahci_do_softreset(struct ata_link *link, unsigned int *class,
 	} else
 		*class = ahci_dev_classify(ap);
 
+	/* re-enable FBS if disabled before */
+	if (fbs_disabled)
+		ahci_enable_fbs(ap);
+
 	DPRINTK("EXIT, class=%u\n", *class);
 	return 0;
 
-- 
1.8.3.2

