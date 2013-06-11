Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab3FKU1C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:27:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41744 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441Ab3FKUDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Beulich <jbeulich@suse.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 28/32] xen-pciback: rate limit error messages from xen_pcibk_enable_msi{,x}()
Date: Tue, 11 Jun 2013 13:03:27 -0700
Message-Id: <20130611200129.359917239@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611200126.214442788@linuxfoundation.org>
References: <20130611200126.214442788@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
[stable tree: Added two extra #include files]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/xen-pciback/pciback_ops.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/xen/xen-pciback/pciback_ops.c
+++ b/drivers/xen/xen-pciback/pciback_ops.c
@@ -9,6 +9,8 @@
 #include <xen/events.h>
 #include <linux/sched.h>
 #include "pciback.h"
+#include <linux/ratelimit.h>
+#include <linux/printk.h>
 
 int verbose_request;
 module_param(verbose_request, int, 0644);
@@ -136,7 +138,6 @@ int xen_pcibk_enable_msi(struct xen_pcib
 			 struct pci_dev *dev, struct xen_pci_op *op)
 {
 	struct xen_pcibk_dev_data *dev_data;
-	int otherend = pdev->xdev->otherend_id;
 	int status;
 
 	if (unlikely(verbose_request))
@@ -145,8 +146,9 @@ int xen_pcibk_enable_msi(struct xen_pcib
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
@@ -224,10 +226,10 @@ int xen_pcibk_enable_msix(struct xen_pci
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


