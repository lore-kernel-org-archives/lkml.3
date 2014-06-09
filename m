Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936497AbaFIJ3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:29:17 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59137 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936406AbaFIJ1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:27:33 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 139/146] iommu/amd: Fix interrupt remapping for aliased devices
Date: Mon,  9 Jun 2014 10:51:14 +0200
Message-Id: <5e028169bf6bcfd63afdc9ec4682e2c24e0053a3.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Williamson <alex.williamson@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e028a9e6b8a637af09ac4114083280df4a7045f1 upstream.

An apparent cut and paste error prevents the correct flags from being
set on the alias device resulting in MSI on conventional PCI devices
failing to work.  This also produces error events from the IOMMU like:

AMD-Vi: Event logged [INVALID_DEVICE_REQUEST device=00:14.4 address=0x000000fdf8000000 flags=0x0a00]

Where 14.4 is a PCIe-to-PCI bridge with a device behind it trying to
use MSI interrupts.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/iommu/amd_iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 5d2edb4b60aa..22f656e125dd 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3999,7 +3999,7 @@ static struct irq_remap_table *get_irq_table(u16 devid, bool ioapic)
 	iommu_flush_dte(iommu, devid);
 	if (devid != alias) {
 		irq_lookup_table[alias] = table;
-		set_dte_irq_entry(devid, table);
+		set_dte_irq_entry(alias, table);
 		iommu_flush_dte(iommu, alias);
 	}
 
-- 
1.9.3

