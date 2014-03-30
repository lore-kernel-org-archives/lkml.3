Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbaCaAFv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:05:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754398AbaC3Xmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:42:50 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Shane Huang" <shane.huang@amd.com>,
        "Jean Delvare" <khali@linux-fr.org>,
        "Wolfram Sang" <wsa@the-dreams.de>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.666053498@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 054/200] i2c: piix4: Add support for AMD ML and CZ
 SMBus changes
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Shane Huang <shane.huang@amd.com>

commit 032f708bc4f6da868ec49dac48ddf3670d8035d3 upstream.

The locations of SMBus register base address and enablement bit are changed
from AMD ML, which need this patch to be supported.

Signed-off-by: Shane Huang <shane.huang@amd.com>
Reviewed-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
[bwh: Backported to 3.2:
 - Adjust context
 - Aux bus support is not included]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/Documentation/i2c/busses/i2c-piix4
+++ b/Documentation/i2c/busses/i2c-piix4
@@ -8,7 +8,7 @@ Supported adapters:
     Datasheet: Only available via NDA from ServerWorks
   * ATI IXP200, IXP300, IXP400, SB600, SB700 and SB800 southbridges
     Datasheet: Not publicly available
-  * AMD Hudson-2, CZ
+  * AMD Hudson-2, ML, CZ
     Datasheet: Not publicly available
   * Standard Microsystems (SMSC) SLC90E66 (Victory66) southbridge
     Datasheet: Publicly available at the SMSC website http://www.smsc.com
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -137,6 +137,7 @@ config I2C_PIIX4
 	    ATI SB700
 	    ATI SB800
 	    AMD Hudson-2
+	    AMD ML
 	    AMD CZ
 	    Serverworks OSB4
 	    Serverworks CSB5
--- a/drivers/i2c/busses/i2c-piix4.c
+++ b/drivers/i2c/busses/i2c-piix4.c
@@ -22,7 +22,7 @@
 	Intel PIIX4, 440MX
 	Serverworks OSB4, CSB5, CSB6, HT-1000, HT-1100
 	ATI IXP200, IXP300, IXP400, SB600, SB700, SB800
-	AMD Hudson-2, CZ
+	AMD Hudson-2, ML, CZ
 	SMSC Victory66
 
    Note: we assume there can only be one device, with one SMBus interface.
@@ -231,7 +231,8 @@ static int __devinit piix4_setup_sb800(s
 				const struct pci_device_id *id)
 {
 	unsigned short smba_idx = 0xcd6;
-	u8 smba_en_lo, smba_en_hi, i2ccfg, i2ccfg_offset = 0x10, smb_en = 0x2c;
+	u8 smba_en_lo, smba_en_hi, smb_en, smb_en_status;
+	u8 i2ccfg, i2ccfg_offset = 0x10;
 
 	/* SB800 and later SMBus does not support forcing address */
 	if (force || force_addr) {
@@ -241,6 +242,16 @@ static int __devinit piix4_setup_sb800(s
 	}
 
 	/* Determine the address of the SMBus areas */
+	if ((PIIX4_dev->vendor == PCI_VENDOR_ID_AMD &&
+	     PIIX4_dev->device == PCI_DEVICE_ID_AMD_HUDSON2_SMBUS &&
+	     PIIX4_dev->revision >= 0x41) ||
+	    (PIIX4_dev->vendor == PCI_VENDOR_ID_AMD &&
+	     PIIX4_dev->device == 0x790b &&
+	     PIIX4_dev->revision >= 0x49))
+		smb_en = 0x00;
+	else
+		smb_en = 0x2c;
+
 	if (!request_region(smba_idx, 2, "smba_idx")) {
 		dev_err(&PIIX4_dev->dev, "SMBus base address index region "
 			"0x%x already in use!\n", smba_idx);
@@ -252,13 +263,20 @@ static int __devinit piix4_setup_sb800(s
 	smba_en_hi = inb_p(smba_idx + 1);
 	release_region(smba_idx, 2);
 
-	if ((smba_en_lo & 1) == 0) {
+	if (!smb_en) {
+		smb_en_status = smba_en_lo & 0x10;
+		piix4_smba = smba_en_hi << 8;
+	} else {
+		smb_en_status = smba_en_lo & 0x01;
+		piix4_smba = ((smba_en_hi << 8) | smba_en_lo) & 0xffe0;
+	}
+
+	if (!smb_en_status) {
 		dev_err(&PIIX4_dev->dev,
 			"Host SMBus controller not enabled!\n");
 		return -ENODEV;
 	}
 
-	piix4_smba = ((smba_en_hi << 8) | smba_en_lo) & 0xffe0;
 	if (acpi_check_region(piix4_smba, SMBIOSIZE, piix4_driver.name))
 		return -ENODEV;
 

