Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbaDZPau (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 11:30:50 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:47283 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbaDZPas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 11:30:48 -0400
Date: Sat, 26 Apr 2014 18:30:33 +0300
From: Sami Laine <laine.j.sami@gmail.com>
To: daeseok.youn@gmail.com
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH next-20140424] staging/cxt1e1: hwprobe.c sparse warning
 corrections
Message-ID: <20140426153033.GA4088@acer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sami Laine <laine.j.sami@gmail.com>

Sparse warning corrections:
 - declarations made static where they should be such
 - changed NULL-pointers as NULL instead of static 0's
 - added __force to a few casts seemingly safe enough

Signed-off-by: Sami Laine <laine.j.sami@gmail.com>
---
diff --git a/drivers/staging/cxt1e1/hwprobe.c b/drivers/staging/cxt1e1/hwprobe.c
index cc2151e..d1c0493 100644
--- a/drivers/staging/cxt1e1/hwprobe.c
+++ b/drivers/staging/cxt1e1/hwprobe.c
@@ -40,10 +40,10 @@ struct net_device * __init c4_add_dev(hdw_info_t *, int, unsigned long,
 				      unsigned long, int, int);
 
 
-struct s_hdw_info hdw_info[MAX_BOARDS];
+static struct s_hdw_info hdw_info[MAX_BOARDS];
 
 
-void __init
+static void __init
 show_two(hdw_info_t *hi, int brdno)
 {
 	ci_t       *ci;
@@ -88,13 +88,13 @@ show_two(hdw_info_t *hi, int brdno)
 }
 
 
-void __init
+static void __init
 hdw_sn_get(hdw_info_t *hi, int brdno)
 {
 	/* obtain hardware EEPROM information */
-	long        addr;
+	long addr;
 
-	addr = (long) hi->addr_mapped[1] + EEPROM_OFFSET;
+	addr = (long __force)hi->addr_mapped[1] + EEPROM_OFFSET;
 
 	/* read EEPROM with largest known format size... */
 	pmc_eeprom_read_buffer(addr, 0, (char *)hi->mfg_info.data,
@@ -145,7 +145,7 @@ hdw_sn_get(hdw_info_t *hi, int brdno)
 }
 
 
-	void __init
+static void __init
 prep_hdw_info(void)
 {
 	hdw_info_t *hi;
@@ -159,12 +159,12 @@ prep_hdw_info(void)
 		hi->ndev = NULL;
 		hi->addr[0] = 0L;
 		hi->addr[1] = 0L;
-		hi->addr_mapped[0] = 0L;
-		hi->addr_mapped[1] = 0L;
+		hi->addr_mapped[0] = NULL;
+		hi->addr_mapped[1] = NULL;
 	}
 }
 
-void
+static void
 cleanup_ioremap(void)
 {
 	hdw_info_t *hi;
@@ -176,18 +176,18 @@ cleanup_ioremap(void)
 		if (hi->addr_mapped[0]) {
 			iounmap(hi->addr_mapped[0]);
 			release_mem_region((long) hi->addr[0], hi->len[0]);
-			hi->addr_mapped[0] = 0;
+			hi->addr_mapped[0] = NULL;
 		}
 		if (hi->addr_mapped[1]) {
 			iounmap(hi->addr_mapped[1]);
 			release_mem_region((long) hi->addr[1], hi->len[1]);
-			hi->addr_mapped[1] = 0;
+			hi->addr_mapped[1] = NULL;
 		}
 	}
 }
 
 
-void
+static void
 cleanup_devs(void)
 {
 	hdw_info_t *hi;
@@ -287,7 +287,7 @@ c4_hdw_init(struct pci_dev *pdev, int found)
 	return 1;
 }
 
-status_t __init
+static status_t __init
 c4hw_attach_all(void)
 {
 	hdw_info_t *hi;
@@ -361,10 +361,11 @@ c4hw_attach_all(void)
 		}
 		pci_set_master(hi->pdev[0]);
 		pci_set_master(hi->pdev[1]);
-		hi->ndev = c4_add_dev(hi, i, (long) hi->addr_mapped[0],
-				      (long) hi->addr_mapped[1],
-				      hi->pdev[0]->irq,
-				      hi->pdev[1]->irq);
+		hi->ndev = c4_add_dev(hi, i,
+				(unsigned long __force) hi->addr_mapped[0],
+				(unsigned long __force) hi->addr_mapped[1],
+				hi->pdev[0]->irq,
+				hi->pdev[1]->irq);
 		if (!hi->ndev) {
 			drvr_state = SBE_DRVR_DOWN;
 			cleanup_ioremap();
