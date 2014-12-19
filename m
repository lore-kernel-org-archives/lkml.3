Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbaLSBWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 20:22:23 -0500
Received: from mga03.intel.com ([134.134.136.65]:39999 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649AbaLSBWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 20:22:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,604,1413270000"; 
   d="scan'208";a="626317801"
Subject: [PATCH] genirq: set initial affinity when hinting
To: tglx@linutronix.de
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 18 Dec 2014 17:22:06 -0800
Message-ID: <20141219012206.4220.27491.stgit@jbrandeb-cp2.jf.intel.com>
User-Agent: StGit/0.16-44-gd947d-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Problem:
The default behavior of the kernel is somewhat undesirable as all
requested interrupts end up on CPU0 after registration.  A user can
run irqbalance daemon, or can manually configure smp_affinity via the
proc filesystem, but the default affinity of the interrupts for all
devices is always CPU zero, this can cause performance problems or
very heavy cpu use of only one core if not noticed and fixed by the
user.

Patch:
This patch enables the setting of the initial affinity directly
when the driver sets a hint.

This enabling means that kernel drivers can include an initial
affinity setting for the interrupt, instead of all interrupts starting
out life on CPU0. Of course if irqbalance is still running then the
interrupts will get moved as before.

This function is currently called by drivers in block, crypto,
infiniband, ethernet and scsi trees, but only a handful, so these will
be the devices affected by this change.

Tested on i40e, and default interrupts were spread across the CPUs
according to the hint.

drivers/block/mtip32xx/mtip32xx.c:3
drivers/block/nvme-core.c:2
drivers/crypto/qat/qat_dh895xcc/adf_isr.c:3
drivers/infiniband/hw/qib/qib_iba7322.c:2
drivers/net/ethernet/intel/i40e/i40e_main.c:3
drivers/net/ethernet/intel/i40evf/i40evf_main.c:3
drivers/net/ethernet/intel/ixgbe/ixgbe_main.c:3
drivers/net/ethernet/mellanox/mlx4/en_cq.c:2
drivers/scsi/hpsa.c:3
drivers/scsi/lpfc/lpfc_init.c:3
drivers/scsi/megaraid/megaraid_sas_base.c:8
drivers/soc/ti/knav_qmss_acc.c:1
drivers/soc/ti/knav_qmss_queue.c:2
drivers/virtio/virtio_pci_common.c:2

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/irq/manage.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 8069237..f038e58 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -243,6 +243,8 @@ int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
 		return -EINVAL;
 	desc->affinity_hint = m;
 	irq_put_desc_unlock(desc, flags);
+	/* set the initial affinity to prevent every interrupt being on CPU0 */
+	__irq_set_affinity(irq, m, false);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(irq_set_affinity_hint);

