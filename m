Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab3I1BDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 21:03:17 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:53672 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab3I1BCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 21:02:52 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rui Wang <ruiv.wang@gmail.com>, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v5 2/4] sb_edac: Claim a different PCI device
Date: Fri, 27 Sep 2013 18:02:41 -0700
Message-Id: <5af4ca11ba50a042003de09576cfed9c2ffb105c.1380315959.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1380315959.git.luto@amacapital.net>
References: <cover.1380315959.git.luto@amacapital.net>
In-Reply-To: <cover.1380315959.git.luto@amacapital.net>
References: <cover.1380315959.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sb_edac controls a large number of different PCI functions.  Rather
than registering as a normal PCI driver for all of them, it
registers for just one so that it gets probed and, at probe time, it
looks for all the others.

Coincidentally, the device it registers for also contains the SMBUS
registers, so the PCI core will refuse to probe both sb_edac and an
iMC SMBUS driver.  The drivers don't actually conflict, so just
change sb_edac's device table to probe a different device.

An alternative fix would be to merge the two drivers, but sb_edac
will also refuse to load on non-ECC systems, whereas the i2c_imc
is still useful without ECC.

The only user-visible change should be that sb_edac appears to bind
a different device.

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Rui Wang <ruiv.wang@gmail.com>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 drivers/edac/sb_edac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 4fac6f5..4f30aa7 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -338,7 +338,7 @@ static const struct pci_id_table pci_dev_descr_sbridge_table[] = {
  *	pci_device_id	table for which devices we are looking for
  */
 static DEFINE_PCI_DEVICE_TABLE(sbridge_pci_tbl) = {
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_TA)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_SBRIDGE_IMC_HA0)},
 	{0,}			/* 0 terminated list. */
 };
 
-- 
1.8.3.1

