Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaKUWSk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 17:18:40 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:34050 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbaKUWSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 17:18:03 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, bhelgaas@google.com, linux@eikelenboom.it
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v4 2/7] driver core: Provide an wrapper around the mutex to do lockdep warnings
Date: Fri, 21 Nov 2014 17:17:46 -0500
Message-Id: <1416608271-18931-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416608271-18931-1-git-send-email-konrad.wilk@oracle.com>
References: <1416608271-18931-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of open-coding it in drivers that want to double check
that their functions are indeed holding the device lock.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Suggested-by: David Vrabel <david.vrabel@citrix.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/xen-pciback/pci_stub.c | 2 +-
 include/linux/device.h             | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index 9cbe1a3..8b77089 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -278,7 +278,7 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
 	/* Cleanup our device
 	 * (so it's ready for the next domain)
 	 */
-	lockdep_assert_held(&dev->dev.mutex);
+	device_lock_assert(&dev->dev);
 	__pci_reset_function_locked(dev);
 	pci_restore_state(dev);
 
diff --git a/include/linux/device.h b/include/linux/device.h
index ce1f2160..41d6a75 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -911,6 +911,11 @@ static inline void device_unlock(struct device *dev)
 	mutex_unlock(&dev->mutex);
 }
 
+static inline void device_lock_assert(struct device *dev)
+{
+	lockdep_assert_held(&dev->mutex);
+}
+
 void driver_init(void);
 
 /*
-- 
1.9.3

