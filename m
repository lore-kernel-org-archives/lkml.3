Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbaGKTHY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 15:07:24 -0400
Received: from mail.kernel.org ([198.145.19.201]:46745 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195AbaGKTHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 15:07:22 -0400
From: konrad@kernel.org
To: xen-devel@lists.xenproject.org, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v4 2/5] xen/pciback: Don't deadlock when unbinding.
Date: Fri, 11 Jul 2014 16:08:49 -0400
Message-Id: <1405109332-31659-3-git-send-email-konrad@kernel.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1405109332-31659-1-git-send-email-konrad@kernel.org>
References: <1405109332-31659-1-git-send-email-konrad@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

As commit 0a9fd0152929db372ff61b0d6c280fdd34ae8bdb
'xen/pciback: Document the entry points for 'pcistub_put_pci_dev''
explained there are four entry points in this function.
Two of them are when the user fiddles in the SysFS to
unbind a device which might be in use by a guest or not.

Both 'unbind' states will cause a deadlock as the the PCI lock has
already been taken, which then pci_device_reset tries to take.

We can simplify this by requiring that all callers of
pcistub_put_pci_dev MUST hold the device lock. And then
we can just call the lockless version of pci_device_reset.

To make it even simpler we will modify xen_pcibk_release_pci_dev
to quality whether it should take a lock or not - as it ends
up calling xen_pcibk_release_pci_dev and needs to hold the lock.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
[v2: Per David Vrabel's suggestion - use lockless version of reset]
---
 drivers/xen/xen-pciback/passthrough.c |    9 +++++++--
 drivers/xen/xen-pciback/pci_stub.c    |   11 +++++------
 drivers/xen/xen-pciback/pciback.h     |    7 ++++---
 drivers/xen/xen-pciback/vpci.c        |    9 +++++++--
 drivers/xen/xen-pciback/xenbus.c      |    2 +-
 5 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/xen/xen-pciback/passthrough.c b/drivers/xen/xen-pciback/passthrough.c
index 828dddc..d0c3fb4 100644
--- a/drivers/xen/xen-pciback/passthrough.c
+++ b/drivers/xen/xen-pciback/passthrough.c
@@ -69,7 +69,7 @@ static int __xen_pcibk_add_pci_dev(struct xen_pcibk_device *pdev,
 }
 
 static void __xen_pcibk_release_pci_dev(struct xen_pcibk_device *pdev,
-					struct pci_dev *dev)
+					struct pci_dev *dev, bool lock)
 {
 	struct passthrough_dev_data *dev_data = pdev->pci_dev_data;
 	struct pci_dev_entry *dev_entry, *t;
@@ -87,8 +87,13 @@ static void __xen_pcibk_release_pci_dev(struct xen_pcibk_device *pdev,
 
 	mutex_unlock(&dev_data->lock);
 
-	if (found_dev)
+	if (found_dev) {
+		if (lock)
+			device_lock(&found_dev->dev);
 		pcistub_put_pci_dev(found_dev);
+		if (lock)
+			device_unlock(&found_dev->dev);
+	}
 }
 
 static int __xen_pcibk_init_devices(struct xen_pcibk_device *pdev)
diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index d57a173..eebbb41 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -250,6 +250,8 @@ struct pci_dev *pcistub_get_pci_dev(struct xen_pcibk_device *pdev,
  *  - 'echo BDF > unbind' with a guest still using it. See pcistub_remove
  *
  *  As such we have to be careful.
+ *
+ *  To make this easier, the caller has to hold the device lock.
  */
 void pcistub_put_pci_dev(struct pci_dev *dev)
 {
@@ -276,11 +278,7 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
 	/* Cleanup our device
 	 * (so it's ready for the next domain)
 	 */
-
-	/* This is OK - we are running from workqueue context
-	 * and want to inhibit the user from fiddling with 'reset'
-	 */
-	pci_reset_function(dev);
+	__pci_reset_function_locked(dev);
 	pci_restore_state(dev);
 
 	/* This disables the device. */
@@ -567,7 +565,8 @@ static void pcistub_remove(struct pci_dev *dev)
 			/* N.B. This ends up calling pcistub_put_pci_dev which ends up
 			 * doing the FLR. */
 			xen_pcibk_release_pci_dev(found_psdev->pdev,
-						found_psdev->dev);
+						found_psdev->dev,
+						false /* caller holds the lock. */);
 		}
 
 		spin_lock_irqsave(&pcistub_devices_lock, flags);
diff --git a/drivers/xen/xen-pciback/pciback.h b/drivers/xen/xen-pciback/pciback.h
index f72af87..58e38d5 100644
--- a/drivers/xen/xen-pciback/pciback.h
+++ b/drivers/xen/xen-pciback/pciback.h
@@ -99,7 +99,8 @@ struct xen_pcibk_backend {
 		    unsigned int *domain, unsigned int *bus,
 		    unsigned int *devfn);
 	int (*publish)(struct xen_pcibk_device *pdev, publish_pci_root_cb cb);
-	void (*release)(struct xen_pcibk_device *pdev, struct pci_dev *dev);
+	void (*release)(struct xen_pcibk_device *pdev, struct pci_dev *dev,
+                        bool lock);
 	int (*add)(struct xen_pcibk_device *pdev, struct pci_dev *dev,
 		   int devid, publish_pci_dev_cb publish_cb);
 	struct pci_dev *(*get)(struct xen_pcibk_device *pdev,
@@ -122,10 +123,10 @@ static inline int xen_pcibk_add_pci_dev(struct xen_pcibk_device *pdev,
 }
 
 static inline void xen_pcibk_release_pci_dev(struct xen_pcibk_device *pdev,
-					     struct pci_dev *dev)
+					     struct pci_dev *dev, bool lock)
 {
 	if (xen_pcibk_backend && xen_pcibk_backend->release)
-		return xen_pcibk_backend->release(pdev, dev);
+		return xen_pcibk_backend->release(pdev, dev, lock);
 }
 
 static inline struct pci_dev *
diff --git a/drivers/xen/xen-pciback/vpci.c b/drivers/xen/xen-pciback/vpci.c
index 51afff9..2fdfcb9 100644
--- a/drivers/xen/xen-pciback/vpci.c
+++ b/drivers/xen/xen-pciback/vpci.c
@@ -145,7 +145,7 @@ out:
 }
 
 static void __xen_pcibk_release_pci_dev(struct xen_pcibk_device *pdev,
-					struct pci_dev *dev)
+					struct pci_dev *dev, bool lock)
 {
 	int slot;
 	struct vpci_dev_data *vpci_dev = pdev->pci_dev_data;
@@ -169,8 +169,13 @@ static void __xen_pcibk_release_pci_dev(struct xen_pcibk_device *pdev,
 out:
 	mutex_unlock(&vpci_dev->lock);
 
-	if (found_dev)
+	if (found_dev) {
+		if (lock)
+			device_lock(&found_dev->dev);
 		pcistub_put_pci_dev(found_dev);
+		if (lock)
+			device_unlock(&found_dev->dev);
+	}
 }
 
 static int __xen_pcibk_init_devices(struct xen_pcibk_device *pdev)
diff --git a/drivers/xen/xen-pciback/xenbus.c b/drivers/xen/xen-pciback/xenbus.c
index 4a7e6e0..065aae8 100644
--- a/drivers/xen/xen-pciback/xenbus.c
+++ b/drivers/xen/xen-pciback/xenbus.c
@@ -290,7 +290,7 @@ static int xen_pcibk_remove_device(struct xen_pcibk_device *pdev,
 
 	/* N.B. This ends up calling pcistub_put_pci_dev which ends up
 	 * doing the FLR. */
-	xen_pcibk_release_pci_dev(pdev, dev);
+	xen_pcibk_release_pci_dev(pdev, dev, true /* use the lock */);
 
 out:
 	return err;
-- 
1.7.7.6

