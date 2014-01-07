Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbaAGOmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:42:08 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:44683 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbaAGOlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:41:39 -0500
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        dan.carpenter@oracle.com, fengguang.wu@intel.com, weiyj.lk@gmail.com,
        jim.epost@gmail.com, sfr@canb.auug.org.au, jsvogt@de.ibm.com,
        MIJUNG@de.ibm.com, michael@ibmra.de, schwidefsky@de.ibm.com,
        cody@linux.vnet.ibm.com, cascardo@linux.vnet.ibm.com,
        kernel-janitors@vger.kernel.org, haver@linux.vnet.ibm.com
Subject: [PATCH 3/3] GenWQE: Fix warnings for sparc
Date: Tue,  7 Jan 2014 15:41:25 +0100
Message-Id: <1389105685-25245-3-git-send-email-haver@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1389105556.15325.22.camel@oc7383187364.ibm.com>
References: <1389105556.15325.22.camel@oc7383187364.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010714-0542-0000-0000-00000795DA2E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_addr_t was not used, where it should have been used.
Some format strings were not optimal.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
---
 drivers/misc/genwqe/card_dev.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/drivers/misc/genwqe/card_dev.c
+++ b/drivers/misc/genwqe/card_dev.c
@@ -214,9 +214,9 @@ static void genwqe_remove_mappings(struc
 		 */
 		dev_err(&pci_dev->dev,
 			"[%s] %d. cleanup mapping: u_vaddr=%p "
-			"u_kaddr=%016lx dma_addr=%llx\n", __func__, i++,
+			"u_kaddr=%016lx dma_addr=%lx\n", __func__, i++,
 			dma_map->u_vaddr, (unsigned long)dma_map->k_vaddr,
-			dma_map->dma_addr);
+			(unsigned long)dma_map->dma_addr);
 
 		if (dma_map->type == GENWQE_MAPPING_RAW) {
 			/* we allocated this dynamically */
@@ -507,7 +507,8 @@ static int do_flash_update(struct genwqe
 {
 	int rc = 0;
 	int blocks_to_flash;
-	u64 dma_addr, flash = 0;
+	dma_addr_t dma_addr;
+	u64 flash = 0;
 	size_t tocopy = 0;
 	u8 __user *buf;
 	u8 *xbuf;
@@ -558,8 +559,9 @@ static int do_flash_update(struct genwqe
 		crc = genwqe_crc32(xbuf, tocopy, 0xffffffff);
 
 		dev_dbg(&pci_dev->dev,
-			"[%s] DMA: 0x%llx CRC: %08x SZ: %ld %d\n",
-			__func__, dma_addr, crc, tocopy, blocks_to_flash);
+			"[%s] DMA: %lx CRC: %08x SZ: %ld %d\n",
+			__func__, (unsigned long)dma_addr, crc, tocopy,
+			blocks_to_flash);
 
 		/* prepare DDCB for SLU process */
 		req = ddcb_requ_alloc();
@@ -638,7 +640,8 @@ static int do_flash_read(struct genwqe_f
 			 struct genwqe_bitstream *load)
 {
 	int rc, blocks_to_flash;
-	u64 dma_addr, flash = 0;
+	dma_addr_t dma_addr;
+	u64 flash = 0;
 	size_t tocopy = 0;
 	u8 __user *buf;
 	u8 *xbuf;
@@ -680,8 +683,9 @@ static int do_flash_read(struct genwqe_f
 		tocopy = min_t(size_t, load->size, FLASH_BLOCK);
 
 		dev_dbg(&pci_dev->dev,
-			"[%s] DMA: 0x%llx SZ: %ld %d\n",
-			__func__, dma_addr, tocopy, blocks_to_flash);
+			"[%s] DMA: %lx SZ: %ld %d\n",
+			__func__, (unsigned long)dma_addr, tocopy,
+			blocks_to_flash);
 
 		/* prepare DDCB for SLU process */
 		cmd = ddcb_requ_alloc();
@@ -864,7 +868,8 @@ static int ddcb_cmd_fixups(struct genwqe
 	for (i = 0, asiv_offs = 0x00; asiv_offs <= 0x58;
 	     i++, asiv_offs += 0x08) {
 
-		u64 u_addr, d_addr;
+		u64 u_addr;
+		dma_addr_t d_addr;
 		u32 u_size = 0;
 		u64 ats_flags;
 

