Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbaDWM7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:59:55 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:40743 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbaDWM7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:59:54 -0400
From: Anders Darander <anders.darander@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, Anders Darander <anders.darander@gmail.com>
Subject: [PATCH linux-next v2]  staging/rtl8821ae: fix sparse address space warning
Date: Wed, 23 Apr 2014 14:59:46 +0200
Message-Id: <1398257986-21395-1-git-send-email-anders.darander@gmail.com>
X-Mailer: git-send-email 2.0.0.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the definition of pci_mem_start|end from correct from pci_io(un)map's
point of view.

Signed-off-by: Anders Darander <anders.darander@gmail.com>
---

Changes v1 -> v2:
	* Change the struct definition instead of casting all
	  pci_iomap and pci_iounmap calls.

 drivers/staging/rtl8821ae/pci.c  | 14 +++++++-------
 drivers/staging/rtl8821ae/wifi.h |  4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/rtl8821ae/pci.c b/drivers/staging/rtl8821ae/pci.c
index a562aa6..5306e66 100644
--- a/drivers/staging/rtl8821ae/pci.c
+++ b/drivers/staging/rtl8821ae/pci.c
@@ -2313,16 +2313,16 @@ int __devinit rtl_pci_probe(struct pci_dev *pdev,
 
 	/*shared mem start */
 	rtlpriv->io.pci_mem_start =
-			(unsigned long)pci_iomap(pdev,
+			pci_iomap(pdev,
 			rtlpriv->cfg->bar_id, pmem_len);
-	if (rtlpriv->io.pci_mem_start == 0) {
+	if (rtlpriv->io.pci_mem_start == NULL) {
 		RT_ASSERT(false, ("Can't map PCI mem\n"));
 		goto fail2;
 	}
 
 	RT_TRACE(COMP_INIT, DBG_DMESG,
 		 ("mem mapped space: start: 0x%08lx len:%08lx "
-		  "flags:%08lx, after map:0x%08lx\n",
+		  "flags:%08lx, after map:0x%p\n",
 		  pmem_start, pmem_len, pmem_flags,
 		  rtlpriv->io.pci_mem_start));
 
@@ -2415,8 +2415,8 @@ fail3:
 	rtl_deinit_core(hw);
 	ieee80211_free_hw(hw);
 
-	if (rtlpriv->io.pci_mem_start != 0)
-		pci_iounmap(pdev, (void *)rtlpriv->io.pci_mem_start);
+	if (rtlpriv->io.pci_mem_start != NULL )
+		pci_iounmap(pdev, rtlpriv->io.pci_mem_start);
 
 fail2:
 	pci_release_regions(pdev);
@@ -2478,8 +2478,8 @@ void rtl_pci_disconnect(struct pci_dev *pdev)
 		pci_disable_msi(rtlpci->pdev);
 
 	list_del(&rtlpriv->list);
-	if (rtlpriv->io.pci_mem_start != 0) {
-		pci_iounmap(pdev, (void *)rtlpriv->io.pci_mem_start);
+	if (rtlpriv->io.pci_mem_start != NULL) {
+		pci_iounmap(pdev, rtlpriv->io.pci_mem_start);
 		pci_release_regions(pdev);
 	}
 
diff --git a/drivers/staging/rtl8821ae/wifi.h b/drivers/staging/rtl8821ae/wifi.h
index 17a9d9f..e8250da 100644
--- a/drivers/staging/rtl8821ae/wifi.h
+++ b/drivers/staging/rtl8821ae/wifi.h
@@ -1086,8 +1086,8 @@ struct rtl_io {
 	struct device *dev;
 
 	/*PCI MEM map */
-	unsigned long pci_mem_end;	/*shared mem end        */
-	unsigned long pci_mem_start;	/*shared mem start */
+	void __iomem *pci_mem_end;	/*shared mem end        */
+	void __iomem *pci_mem_start;	/*shared mem start */
 
 	/*PCI IO map */
 	unsigned long pci_base_addr;	/*device I/O address */
-- 
2.0.0.rc0

