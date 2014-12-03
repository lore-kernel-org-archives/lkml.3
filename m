Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaLCVnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 16:43:41 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:33303 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbaLCVlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 16:41:07 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v5 7/9] xen/pciback: Restore configuration space when detaching from a guest.
Date: Wed,  3 Dec 2014 16:40:32 -0500
Message-Id: <1417642834-20350-8-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417642834-20350-1-git-send-email-konrad.wilk@oracle.com>
References: <1417642834-20350-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit "xen/pciback: Don't deadlock when unbinding." was using
the version of pci_reset_function which would lock the device lock.
That is no good as we can dead-lock. As such we swapped to using
the lock-less version and requiring that the callers
of 'pcistub_put_pci_dev' take the device lock. And as such
this bug got exposed.

Using the lock-less version is  OK, except that we tried to
use 'pci_restore_state' after the lock-less version of
__pci_reset_function_locked - which won't work as 'state_saved'
is set to false. Said 'state_saved' is a toggle boolean that
is to be used by the sequence of a) pci_save_state/pci_restore_state
or b) pci_load_and_free_saved_state/pci_restore_state. We don't
want to use a) as the guest might have messed up the PCI
configuration space and we want it to revert to the state
when the PCI device was binded to us. Therefore we pick
b) to restore the configuration space.

We restore from our 'golden' version of PCI configuration space, when an:
 - Device is unbinded from pciback
 - Device is detached from a guest.

Reported-by:  Sander Eikelenboom <linux@eikelenboom.it>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
v2: Always FLR reset
---
 drivers/xen/xen-pciback/pci_stub.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index 843a2ba..8580e53 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -105,7 +105,7 @@ static void pcistub_device_release(struct kref *kref)
 	 */
 	__pci_reset_function_locked(dev);
 	if (pci_load_and_free_saved_state(dev, &dev_data->pci_saved_state))
-		dev_dbg(&dev->dev, "Could not reload PCI state\n");
+		dev_info(&dev->dev, "Could not reload PCI state\n");
 	else
 		pci_restore_state(dev);
 
@@ -257,6 +257,8 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
 {
 	struct pcistub_device *psdev, *found_psdev = NULL;
 	unsigned long flags;
+	struct xen_pcibk_dev_data *dev_data;
+	int ret;
 
 	spin_lock_irqsave(&pcistub_devices_lock, flags);
 
@@ -280,8 +282,18 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
 	 */
 	device_lock_assert(&dev->dev);
 	__pci_reset_function_locked(dev);
-	pci_restore_state(dev);
 
+	dev_data = pci_get_drvdata(dev);
+	ret = pci_load_saved_state(dev, dev_data->pci_saved_state);
+	if (!ret) {
+		/*
+		 * The usual sequence is pci_save_state & pci_restore_state
+		 * but the guest might have messed the configuration space up.
+		 * Use the initial version (when device was bound to us).
+		 */
+		pci_restore_state(dev);
+	} else
+		dev_info(&dev->dev, "Could not reload PCI state\n");
 	/* This disables the device. */
 	xen_pcibk_reset_device(dev);
 
-- 
1.9.3

