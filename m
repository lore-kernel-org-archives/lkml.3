Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbaBRCJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 21:09:59 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:43390 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbaBRCJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 21:09:57 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-pci@vger.kernel.org
Cc: horms@verge.net.au, linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        valentine.barshak@cogentembedded.com, ben.dooks@codethink.co.uk,
        geert@linux-m68k.org, bhelgaas@google.com,
        Magnus Damm <magnus.damm@gmail.com>
Date: Tue, 18 Feb 2014 11:11:11 +0900
Message-Id: <20140218021111.14164.93740.sendpatchset@w520>
In-Reply-To: <20140218021041.14164.56411.sendpatchset@w520>
References: <20140218021041.14164.56411.sendpatchset@w520>
Subject: [PATCH 03/08] PCI: rcar: fix bridge logic configuration accesses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Dooks <ben.dooks@codethink.co.uk>

The bridge logic at slot 0 only supports reads up to 0x40 and the
rest of the PCI configuration space for this slot is marked as
reserved in the manual.

Trying a read from offset 0x100 is producing an error from the
bridge. With error interrupts enabled, the following is printed:

pci-rcar-gen2 ee0d0000.pci: error irq: status 00000014

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Signed-off-by: Magnus Damm <damm@opensource.se>
---

 drivers/pci/host/pci-rcar-gen2.c |    4 ++++
 1 file changed, 4 insertions(+)

--- 0005/drivers/pci/host/pci-rcar-gen2.c
+++ work/drivers/pci/host/pci-rcar-gen2.c	2014-02-13 09:45:45.000000000 +0900
@@ -119,6 +119,10 @@ static void __iomem *rcar_pci_cfg_base(s
 	if (slot > 2)
 		return NULL;
 
+	/* bridge logic only has registers to 0x40 */
+	if (slot == 0x0 && where >= 0x40)
+		return NULL;
+
 	val = slot ? RCAR_AHBPCI_WIN1_DEVICE | RCAR_AHBPCI_WIN_CTR_CFG :
 		     RCAR_AHBPCI_WIN1_HOST | RCAR_AHBPCI_WIN_CTR_CFG;
 
