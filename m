Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373AbaGNQUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:20:24 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43131 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175AbaGNQTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:19:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: gregkh@linuxfoundation.org, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v5 3/6] driver core: Provide an wrapper around the mutex to do lockdep warnings
Date: Mon, 14 Jul 2014 12:18:53 -0400
Message-Id: <1405354736-7358-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405354736-7358-1-git-send-email-konrad.wilk@oracle.com>
References: <1405354736-7358-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of open-coding it in drivers that want to double check
that their functions are indeed holding the device lock.

CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-pciback/pci_stub.c | 2 +-
 include/linux/device.h             | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index d4cae5b..f9bf793 100644
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
index af424ac..1d29fb2 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -908,6 +908,11 @@ static inline void device_unlock(struct device *dev)
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

