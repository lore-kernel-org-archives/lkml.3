Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552Ab3LKQti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 11:49:38 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:37935 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab3LKQte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 11:49:34 -0500
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        haver@linux.vnet.ibm.com
Subject: [RFC 2/2] GenWQE: Make use of the generic CRC kernel infrastructure
Date: Wed, 11 Dec 2013 17:49:23 +0100
Message-Id: <1386780563-1722-2-git-send-email-haver@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1386592244-2521-7-git-send-email-haver@linux.vnet.ibm.com>
References: <1386592244-2521-7-git-send-email-haver@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121116-8372-0000-0000-0000080E4781
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of reimplementing the CRC, make use of the generic CRC kernel
infrastructure. Note that GenWQE seems currently the only one using
this particular polynomial.

This change requires a previous patch which adds the GenWQE crc32 to
the generic kernel crc32 support.

Signed-off-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
---
 drivers/misc/genwqe/card_base.c  |    2 	0 +	2 -	0 !
 drivers/misc/genwqe/card_base.h  |    1 	0 +	1 -	0 !
 drivers/misc/genwqe/card_utils.c |   39 	2 +	37 -	0 !
 3 files changed, 2 insertions(+), 40 deletions(-)

--- a/drivers/misc/genwqe/card_base.c
+++ b/drivers/misc/genwqe/card_base.c
@@ -1016,8 +1016,6 @@ static int genwqe_probe(struct pci_dev *
 	int err;
 	struct genwqe_dev *cd;
 
-	genwqe_init_crc32();
-
 	cd = genwqe_dev_alloc();
 	if (IS_ERR(cd)) {
 		dev_err(&pci_dev->dev, "err: could not alloc mem (err=%d)!\n",
--- a/drivers/misc/genwqe/card_base.h
+++ b/drivers/misc/genwqe/card_base.h
@@ -441,7 +441,6 @@ int  genwqe_ffdc_dump_dma(struct genwqe_
 int  genwqe_init_debug_data(struct genwqe_dev *cd,
 			    struct genwqe_debug_data *d);
 
-void genwqe_init_crc32(void);
 int  genwqe_read_app_id(struct genwqe_dev *cd, char *app_name, int len);
 
 /* Memory allocation/deallocation; dma address handling */
--- a/drivers/misc/genwqe/card_utils.c
+++ b/drivers/misc/genwqe/card_utils.c
@@ -37,6 +37,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/delay.h>
+#include <linux/crc32.h>
 #include <asm/pgtable.h>
 
 #include "genwqe_driver.h"
@@ -151,34 +152,6 @@ int genwqe_read_app_id(struct genwqe_dev
 }
 
 /**
- * genwqe_init_crc32() - Prepare a lookup table for fast crc32 calculations
- *
- * Existing kernel functions seem to use a different polynom,
- * therefore we could not use them here.
- *
- * Genwqe's Polynomial = 0x20044009
- */
-#define CRC32_POLYNOMIAL	0x20044009
-static u32 crc32_tab[256];	/* crc32 lookup table */
-
-void genwqe_init_crc32(void)
-{
-	int i, j;
-	u32 crc;
-
-	for (i = 0;  i < 256;  i++) {
-		crc = i << 24;
-		for (j = 0;  j < 8;  j++) {
-			if (crc & 0x80000000)
-				crc = (crc << 1) ^ CRC32_POLYNOMIAL;
-			else
-				crc = (crc << 1);
-		}
-		crc32_tab[i] = crc;
-	}
-}
-
-/**
  * genwqe_crc32() - Generate 32-bit crc as required for DDCBs
  * @buff:       pointer to data buffer
  * @len:        length of data for calculation
@@ -195,15 +168,7 @@ void genwqe_init_crc32(void)
  */
 u32 genwqe_crc32(u8 *buff, size_t len, u32 init)
 {
-	int i;
-	u32 crc;
-
-	crc = init;
-	while (len--) {
-		i = ((crc >> 24) ^ *buff++) & 0xFF;
-		crc = (crc << 8) ^ crc32_tab[i];
-	}
-	return crc;
+	return __crc32g_be(init, buff, len);
 }
 
 void *__genwqe_alloc_consistent(struct genwqe_dev *cd, size_t size,

