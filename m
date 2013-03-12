Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513Ab3CLWc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:32:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60073 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726Ab3CLWch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:32:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takahisa Tanaka <mc74hc00@gmail.com>,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        Wim Van Sebroeck <wim@iguana.be>
Subject: [ 011/100] watchdog: sp5100_tco: Write back the original value to reserved bits, instead of zero
Date: Tue, 12 Mar 2013 15:30:56 -0700
Message-Id: <20130312223124.163480310@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takahisa Tanaka <mc74hc00@gmail.com>

commit 41adafbd7b84c66c2cdad857b75d5d45032310a6 upstream.

In case of SP5100 or SB7x0 chipsets, the sp5100_tco module writes zero to
reserved bits. The module, however, shouldn't depend on specific default
value, and should perform a read-merge-write operation for the reserved
bits.

This patch makes the sp5100_tco module perform a read-merge-write operation
on all the chipset (sp5100, sb7x0, sb8x0 or later).

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=43176
Signed-off-by: Takahisa Tanaka <mc74hc00@gmail.com>
Tested-by: Paul Menzel <paulepanter@users.sourceforge.net>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/watchdog/sp5100_tco.c |   28 ++++++++--------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

--- a/drivers/watchdog/sp5100_tco.c
+++ b/drivers/watchdog/sp5100_tco.c
@@ -361,7 +361,7 @@ static unsigned char sp5100_tco_setupdev
 {
 	struct pci_dev *dev = NULL;
 	const char *dev_name = NULL;
-	u32 val;
+	u32 val, tmp_val;
 	u32 index_reg, data_reg, base_addr;
 
 	/* Match the PCI device */
@@ -497,31 +497,19 @@ static unsigned char sp5100_tco_setupdev
 		pr_debug("Got 0x%04x from resource tree\n", val);
 	}
 
-	/* Restore to the low three bits, if chipset is SB8x0(or later) */
-	if (sp5100_tco_pci->revision >= 0x40) {
-		u8 reserved_bit;
-		outb(base_addr+0, index_reg);
-		reserved_bit = inb(data_reg) & 0x7;
-		val |= (u32)reserved_bit;
-	}
+	/* Restore to the low three bits */
+	outb(base_addr+0, index_reg);
+	tmp_val = val | (inb(data_reg) & 0x7);
 
 	/* Re-programming the watchdog timer base address */
 	outb(base_addr+0, index_reg);
-	/* Low three bits of BASE are reserved */
-	outb((val >>  0) & 0xff, data_reg);
+	outb((tmp_val >>  0) & 0xff, data_reg);
 	outb(base_addr+1, index_reg);
-	outb((val >>  8) & 0xff, data_reg);
+	outb((tmp_val >>  8) & 0xff, data_reg);
 	outb(base_addr+2, index_reg);
-	outb((val >> 16) & 0xff, data_reg);
+	outb((tmp_val >> 16) & 0xff, data_reg);
 	outb(base_addr+3, index_reg);
-	outb((val >> 24) & 0xff, data_reg);
-
-	/*
-	 * Clear unnecessary the low three bits,
-	 * if chipset is SB8x0(or later)
-	 */
-	if (sp5100_tco_pci->revision >= 0x40)
-		val &= ~0x7;
+	outb((tmp_val >> 24) & 0xff, data_reg);
 
 	if (!request_mem_region_exclusive(val, SP5100_WDT_MEM_MAP_SIZE,
 								   dev_name)) {


