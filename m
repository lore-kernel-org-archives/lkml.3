Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098AbaCQNFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:05:43 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:22718 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756378AbaCQNFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:05:40 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-da-5326f322e21c
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Oliver Schinagl <oliver@schinagl.nl>, linux-ide@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ata: ahci_sunxi: disable resources on driver removal
Date: Mon, 17 Mar 2014 14:05:15 +0100
Message-id: <4639408.hubNkUp5Oa@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t9jQV2lz2rBBjMnGFm8OT6dyWLT42us
	Fsd2PGKyuLxrDpvF1k17mS1eTnrIavFr+VFGB3aPJ5suMnpsWtXJ5rF5Sb3H+31X2TxaW5az
	enzeJBfAFsVlk5Kak1mWWqRvl8CVsfLRZcaCs1wVZ74+Ym1gbOXsYuTkkBAwkdjz9g4LhC0m
	ceHeerYuRi4OIYHpjBLr9rcxQzgtTBKXfp1nBaliE7CSmNi+ihHEFhGQlbgy7SEjSBGzwBNG
	iQUnt7KBJIQFXCVu7VkAZrMIqEq8ObIbrIFXQFNi5q2DYOtEBTwldmxfyQYRF5T4MfkeWJxZ
	QF5i3/6prBC2lsT6nceZJjDyzUJSNgtJ2SwkZQsYmVcxiqYWJBcUJ6XnGukVJ+YWl+al6yXn
	525iBAfwM+kdjKsaLA4xCnAwKvHwTlBWCxZiTSwrrsw9xCjBwawkwuv0DijEm5JYWZValB9f
	VJqTWnyIUZqDRUmc92CrdaCQQHpiSWp2ampBahFMlomDU6qBUb6zePHq2Wv983Sc23epeLTH
	NldpTRJsDFkpphB+LuqyXl/c/17+8u1rzKdrmW/5pPZl3uRQphWrJs11fWKVaaJzXWqh4CPj
	1TFe25feLnrbZPh+X+Gb+xo1kyvUojlP772S+U6pIPFz6MmfhwNtLFc+eOD/tMMqdxbbxzvL
	d+x/y8a2rG6qlBJLcUaioRZzUXEiAHi7eqFcAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add custom ->host_stop method to disable resources on driver removal.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
Compile tested only.

 drivers/ata/ahci_sunxi.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

Index: b/drivers/ata/ahci_sunxi.c
===================================================================
--- a/drivers/ata/ahci_sunxi.c	2014-03-17 13:48:26.292485389 +0100
+++ b/drivers/ata/ahci_sunxi.c	2014-03-17 13:55:48.912477842 +0100
@@ -156,13 +156,25 @@ static void ahci_sunxi_start_engine(stru
 	sunxi_setbits(port_mmio + PORT_CMD, PORT_CMD_START);
 }
 
+static void ahci_sunxi_host_stop(struct ata_host *host)
+{
+	struct ahci_host_priv *hpriv = host->private_data;
+
+	ahci_platform_disable_resources(hpriv);
+}
+
+static struct ata_port_operations ahci_sunxi_port_ops = {
+	.inherits	= &ahci_platform_ops,
+	.host_stop	= ahci_sunxi_host_stop,
+};
+
 static const struct ata_port_info ahci_sunxi_port_info = {
 	AHCI_HFLAGS(AHCI_HFLAG_32BIT_ONLY | AHCI_HFLAG_NO_MSI |
 			  AHCI_HFLAG_NO_PMP | AHCI_HFLAG_YES_NCQ),
 	.flags		= AHCI_FLAG_COMMON | ATA_FLAG_NCQ,
 	.pio_mask	= ATA_PIO4,
 	.udma_mask	= ATA_UDMA6,
-	.port_ops	= &ahci_platform_ops,
+	.port_ops	= &ahci_sunxi_port_ops,
 };
 
 static int ahci_sunxi_probe(struct platform_device *pdev)

