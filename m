Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab3BYWUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:20:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55261 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421Ab3BYWUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:20:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Beulich <jbeulich@suse.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 39/58] xen-pciback: rate limit error messages from xen_pcibk_enable_msi{,x}()
Date: Mon, 25 Feb 2013 14:19:35 -0800
Message-Id: <20130225221644.699348668@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130225221636.018756060@linuxfoundation.org>
References: <20130225221636.018756060@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/xen-pciback/pciback_ops.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/xen/xen-pciback/pciback_ops.c
+++ b/drivers/xen/xen-pciback/pciback_ops.c
@@ -135,7 +135,6 @@ int xen_pcibk_enable_msi(struct xen_pcib
 			 struct pci_dev *dev, struct xen_pci_op *op)
 {
 	struct xen_pcibk_dev_data *dev_data;
-	int otherend = pdev->xdev->otherend_id;
 	int status;
 
 	if (unlikely(verbose_request))
@@ -144,8 +143,9 @@ int xen_pcibk_enable_msi(struct xen_pcib
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
@@ -223,10 +223,10 @@ int xen_pcibk_enable_msix(struct xen_pci
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


