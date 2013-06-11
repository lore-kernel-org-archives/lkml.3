Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab3FKQB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 12:01:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751808Ab3FKQBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 12:01:55 -0400
Subject: [PATCH 3/3] vfio-pci: Avoid deadlock on remove
To: alex.williamson@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Date: Tue, 11 Jun 2013 10:01:54 -0600
Message-ID: <20130611160154.9995.5152.stgit@bling.home>
In-Reply-To: <20130611155848.9995.41709.stgit@bling.home>
References: <20130611155848.9995.41709.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an attempt is made to unbind a device from vfio-pci while that
device is in use, the request is blocked until the device becomes
unused.  Unfortunately, that unbind path still grabs the device_lock,
which certain things like __pci_reset_function() also want to take.
This means we need to try to acquire the locks ourselves and use the
pre-locked version, __pci_reset_function_locked().

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index ac37254..41023e4 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -137,8 +137,27 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
 	 */
 	pci_write_config_word(pdev, PCI_COMMAND, PCI_COMMAND_INTX_DISABLE);
 
-	if (vdev->reset_works)
-		__pci_reset_function(pdev);
+	/*
+	 * Careful, device_lock may already be held.  This is the case if
+	 * a driver unbind is blocked.  Try to get the locks ourselves to
+	 * prevent a deadlock.
+	 */
+	if (vdev->reset_works) {
+		bool reset_done = false;
+
+		if (pci_cfg_access_trylock(pdev)) {
+			if (device_trylock(&pdev->dev)) {
+				__pci_reset_function_locked(pdev);
+				reset_done = true;
+				device_unlock(&pdev->dev);
+			}
+			pci_cfg_access_unlock(pdev);
+		}
+
+		if (!reset_done)
+			pr_warn("%s: Unable to acquire locks for reset of %s\n",
+				__func__, dev_name(&pdev->dev));
+	}
 
 	pci_restore_state(pdev);
 }

