Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934269AbaKSW1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:27:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55908 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893AbaKSUyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:54:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 3.17 050/141] ahci: fix AHCI parameters not taken into account
Date: Wed, 19 Nov 2014 12:51:13 -0800
Message-Id: <20141119205152.318670779@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoine Tenart <antoine.tenart@free-electrons.com>

commit 9a23c1d6f0f5dbac4c9b73fa6cea7c9ee3d29074 upstream.

Changes into the AHCI subsystem have introduced a bug by not taking into
account the force_port_map and mask_port_map parameters when using the
ahci_pci_save_initial_config function. This commit fixes it by setting
the internal parameters of the ahci_port_priv structure.

Fixes: 725c7b570fda

Reported-and-tested-by: Zlatko Calusic <zcalusic@bitsync.net>
Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ahci.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -519,12 +519,9 @@ MODULE_PARM_DESC(marvell_enable, "Marvel
 static void ahci_pci_save_initial_config(struct pci_dev *pdev,
 					 struct ahci_host_priv *hpriv)
 {
-	unsigned int force_port_map = 0;
-	unsigned int mask_port_map = 0;
-
 	if (pdev->vendor == PCI_VENDOR_ID_JMICRON && pdev->device == 0x2361) {
 		dev_info(&pdev->dev, "JMB361 has only one port\n");
-		force_port_map = 1;
+		hpriv->force_port_map = 1;
 	}
 
 	/*
@@ -534,9 +531,9 @@ static void ahci_pci_save_initial_config
 	 */
 	if (hpriv->flags & AHCI_HFLAG_MV_PATA) {
 		if (pdev->device == 0x6121)
-			mask_port_map = 0x3;
+			hpriv->mask_port_map = 0x3;
 		else
-			mask_port_map = 0xf;
+			hpriv->mask_port_map = 0xf;
 		dev_info(&pdev->dev,
 			  "Disabling your PATA port. Use the boot option 'ahci.marvell_enable=0' to avoid this.\n");
 	}


