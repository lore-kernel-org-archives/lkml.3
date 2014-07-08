Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136AbaGHR6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 13:58:32 -0400
Received: from mail.kernel.org ([198.145.19.201]:54856 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755311AbaGHR5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 13:57:04 -0400
From: konrad@kernel.org
To: xen-devel@lists.xenproject.org, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v3 3/7] xen/pciback: Move the FLR code to a function.
Date: Tue,  8 Jul 2014 14:58:25 -0400
Message-Id: <1404845909-13563-4-git-send-email-konrad@kernel.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1404845909-13563-1-git-send-email-konrad@kernel.org>
References: <1404845909-13563-1-git-send-email-konrad@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Moving the bulk of the code its own function to aid
in making the 'xen/pciback: implement PCI reset slot
or bus with 'do_flr' SysFS attribute' easier.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-pciback/pci_stub.c |   42 ++++++++++++++++++++++-------------
 1 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index b1fb099..03badac 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -242,6 +242,31 @@ struct pci_dev *pcistub_get_pci_dev(struct xen_pcibk_device *pdev,
 	return found_dev;
 }
 
+static void pcistub_reset_pci_dev(struct pci_dev *dev)
+{
+	/* This is OK - we are running from workqueue context
+	 * and want to inhibit the user from fiddling with 'reset'
+	 */
+
+	dev_dbg(&dev->dev, "resetting (FLR, D3, etc) the device\n");
+	/* We might be holding the PCI lock (see comment at the top of the
+	 * function) - as such try lock and if we can't then don't worry -
+	 * as either:
+	 *  - we are 'unbind' in which case 'pcistub_device_release' gets
+	 *    called which does the locked version of this.
+	 *  - the toolstack has the smarts to do it and has done the
+	 *    reset on SysFS before assigning this device to another guest.
+	 */
+	pci_try_reset_function(dev);
+	pci_restore_state(dev);
+
+	/* This disables the device. */
+	xen_pcibk_reset_device(dev);
+
+	/* And cleanup up our emulated fields. */
+	xen_pcibk_config_reset_dev(dev);
+}
+
 /*
  * Called when:
  *  - XenBus state has been reconfigure (pci unplug). See xen_pcibk_remove_device
@@ -276,23 +301,8 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
 	/* Cleanup our device
 	 * (so it's ready for the next domain)
 	 */
+	pcistub_reset_pci_dev(dev);
 
-	/* We might be holding the PCI lock (see comment at the top of the
-	 * function) - as such try lock and if we can't then don't worry -
-	 * as either:
-	 *  - we are 'unbind' in which case 'pcistub_device_release' gets
-	 *    called which does the locked version of this.
-	 *  - the toolstack has the smarts to do it and has done the
-	 *    reset on SysFS before assigning this device to another guest.
-	 */
-	pci_try_reset_function(dev);
-	pci_restore_state(dev);
-
-	/* This disables the device. */
-	xen_pcibk_reset_device(dev);
-
-	/* And cleanup up our emulated fields. */
-	xen_pcibk_config_reset_dev(dev);
 	xen_pcibk_config_free_dyn_fields(dev);
 
 	xen_unregister_device_domain_owner(dev);
-- 
1.7.7.6

