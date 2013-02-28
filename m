Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453Ab3B1Oz6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:55:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42526 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933064Ab3B1OvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:51:01 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Beulich <jbeulich@suse.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 125/139] xen-pciback: rate limit error messages from xen_pcibk_enable_msi{,x}()
Date: Thu, 28 Feb 2013 14:44:35 +0000
Message-Id: <1362062689-2567-126-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Beulich <jbeulich@suse.com>

commit 51ac8893a7a51b196501164e645583bf78138699 upstream.

... as being guest triggerable (e.g. by invoking
XEN_PCI_OP_enable_msi{,x} on a device not being MSI/MSI-X capable).

This is CVE-2013-0231 / XSA-43.

Also make the two messages uniform in both their wording and severity.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/xen/xen-pciback/pciback_ops.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/xen/xen-pciback/pciback_ops.c b/drivers/xen/xen-pciback/pciback_ops.c
index 97f5d26..37c1f82 100644
--- a/drivers/xen/xen-pciback/pciback_ops.c
+++ b/drivers/xen/xen-pciback/pciback_ops.c
@@ -135,7 +135,6 @@ int xen_pcibk_enable_msi(struct xen_pcibk_device *pdev,
 			 struct pci_dev *dev, struct xen_pci_op *op)
 {
 	struct xen_pcibk_dev_data *dev_data;
-	int otherend = pdev->xdev->otherend_id;
 	int status;
 
 	if (unlikely(verbose_request))
@@ -144,8 +143,9 @@ int xen_pcibk_enable_msi(struct xen_pcibk_device *pdev,
 	status = pci_enable_msi(dev);
 
 	if (status) {
-		printk(KERN_ERR "error enable msi for guest %x status %x\n",
-			otherend, status);
+		pr_warn_ratelimited(DRV_NAME ": %s: error enabling MSI for guest %u: err %d\n",
+				    pci_name(dev), pdev->xdev->otherend_id,
+				    status);
 		op->value = 0;
 		return XEN_PCI_ERR_op_failed;
 	}
@@ -223,10 +223,10 @@ int xen_pcibk_enable_msix(struct xen_pcibk_device *pdev,
 						pci_name(dev), i,
 						op->msix_entries[i].vector);
 		}
-	} else {
-		printk(KERN_WARNING DRV_NAME ": %s: failed to enable MSI-X: err %d!\n",
-			pci_name(dev), result);
-	}
+	} else
+		pr_warn_ratelimited(DRV_NAME ": %s: error enabling MSI-X for guest %u: err %d!\n",
+				    pci_name(dev), pdev->xdev->otherend_id,
+				    result);
 	kfree(entries);
 
 	op->value = result;
-- 
1.8.1.2

