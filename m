Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371AbaHNVqG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 17:46:06 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:54989 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036AbaHNVp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 17:45:56 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Doug Thompson <dougthompson@xmission.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Borislav Petkov <bp@alien8.de>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Rui Wang <ruiv.wang@gmail.com>
Subject: [PATCH 2/2] sb_edac: Claim a different PCI device
Date: Thu, 14 Aug 2014 14:45:41 -0700
Message-Id: <59f55d679cc596731589516a71075b6059fcaaa5.1408051536.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1408051536.git.luto@amacapital.net>
References: <cover.1408051536.git.luto@amacapital.net>
In-Reply-To: <cover.1408051536.git.luto@amacapital.net>
References: <cover.1408051536.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sb_edac controls a large number of different PCI functions.  Rather
than registering as a normal PCI driver for all of them, it
registers for just one so that it gets probed and, at probe time, it
looks for all the others.

Coincidentally, the device it registers for also contains the SMBUS
registers, so the PCI core will refuse to probe both sb_edac and a
future iMC SMBUS driver.  The drivers don't actually conflict, so
just change sb_edac's device table to probe a different device.

An alternative fix would be to merge the two drivers, but sb_edac
will also refuse to load on non-ECC systems, whereas i2c_imc would
still be useful without ECC.

The only user-visible change should be that sb_edac appears to bind
a different device.

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Rui Wang <ruiv.wang@gmail.com>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 drivers/edac/sb_edac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index a2597e9313c6..e3bc2cced580 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -432,7 +432,7 @@ static const struct pci_id_table pci_dev_descr_ibridge_table[] = {
  *	pci_device_id	table for which devices we are looking for
  */
 static const struct pci_device_id sbridge_pci_tbl[] = {
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_TA)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_HA0)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IBRIDGE_IMC_HA0_TA)},
 	{0,}			/* 0 terminated list. */
 };
-- 
1.9.3

