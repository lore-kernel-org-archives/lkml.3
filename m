Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086AbaICWPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:15:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45638 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933637AbaICWIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:08:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tyrel Datwyler <tyreld@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.14 52/88] powerpc/pci: Reorder pci bus/bridge unregistration during PHB removal
Date: Wed,  3 Sep 2014 15:05:26 -0700
Message-Id: <20140903220517.522038717@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220515.958924632@linuxfoundation.org>
References: <20140903220515.958924632@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/platforms/pseries/pci_dlpar.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/platforms/pseries/pci_dlpar.c
+++ b/arch/powerpc/platforms/pseries/pci_dlpar.c
@@ -118,10 +118,10 @@ int remove_phb_dynamic(struct pci_contro
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


