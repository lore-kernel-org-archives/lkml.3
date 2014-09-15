Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757806AbaIOWQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:16:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50953 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875AbaIOWQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:16:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 151/187] powerpc/pci: Reorder pci bus/bridge unregistration during PHB removal
Date: Mon, 15 Sep 2014 15:09:21 -0700
Message-Id: <1410818997-9432-152-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

commit 7340056567e32b2c9d3554eb146e1977c93da116 upstream.

Commit bcdde7e made __sysfs_remove_dir() recursive and introduced a BUG_ON
during PHB removal while attempting to delete the power managment attribute
group of the bus. This is a result of tearing the bridge and bus devices down
out of order in remove_phb_dynamic. Since, the the bus resides below the bridge
in the sysfs device tree it should be torn down first.

This patch simply moves the device_unregister call for the PHB bridge device
after the device_unregister call for the PHB bus.

Fixes: bcdde7e221a8 ("sysfs: make __sysfs_remove_dir() recursive")
Signed-off-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/platforms/pseries/pci_dlpar.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/pci_dlpar.c b/arch/powerpc/platforms/pseries/pci_dlpar.c
index efe6137..e68922b 100644
--- a/arch/powerpc/platforms/pseries/pci_dlpar.c
+++ b/arch/powerpc/platforms/pseries/pci_dlpar.c
@@ -118,10 +118,10 @@ int remove_phb_dynamic(struct pci_controller *phb)
 		}
 	}
 
-	/* Unregister the bridge device from sysfs and remove the PCI bus */
-	device_unregister(b->bridge);
+	/* Remove the PCI bus and unregister the bridge device from sysfs */
 	phb->bus = NULL;
 	pci_remove_bus(b);
+	device_unregister(b->bridge);
 
 	/* Now release the IO resource */
 	if (res->flags & IORESOURCE_IO)
-- 
1.9.1

