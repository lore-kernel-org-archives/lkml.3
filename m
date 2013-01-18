Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab3ARLmf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 06:42:35 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:34347 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab3ARLma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 06:42:30 -0500
Subject: [PATCH 4/5] PCI: don't touch enable_cnt in pci_device_shutdown()
To: linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: e1000-devel@lists.sourceforge.net, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Khalid Aziz <khalid.aziz@hp.com>
Date: Fri, 18 Jan 2013 15:42:26 +0400
Message-ID: <20130118114225.6698.42016.stgit@zurg>
In-Reply-To: <20130118113019.6698.25941.stgit@zurg>
References: <20130118113019.6698.25941.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

comment in commit b566a22c23327f18ce941ffad0ca907e50a53d41
("PCI: disable Bus Master on PCI device shutdown") says:

| Disable Bus Master bit on the device in pci_device_shutdown() to ensure PCI
| devices do not continue to DMA data after shutdown.  This can cause memory
| corruption in case of a kexec where the current kernel shuts down and
| transfers control to a new kernel while a PCI device continues to DMA to
| memory that does not belong to it any more in the new kernel.

Seems like pci_clear_master() must be used here instead of pci_disable_device(),
because it disables Bus Muster unconditionally and doesn't changes enable_cnt.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-pci@vger.kernel.org
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Khalid Aziz <khalid.aziz@hp.com>
---
 drivers/pci/pci-driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 030dbf0..853d605 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -392,7 +392,7 @@ static void pci_device_shutdown(struct device *dev)
 	 * Turn off Bus Master bit on the device to tell it to not
 	 * continue to do DMA
 	 */
-	pci_disable_device(pci_dev);
+	pci_clear_master(pci_dev);
 }
 
 #ifdef CONFIG_PM

