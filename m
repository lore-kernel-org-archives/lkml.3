Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764656Ab3DDTeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 15:34:20 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:35472 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1764640Ab3DDTeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 15:34:19 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: sameo@linux.intel.com
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] MFD: rtsx_pcr, fix probe fail path
Date: Thu,  4 Apr 2013 21:34:11 +0200
Message-Id: <1365104051-22872-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When rtsx_pci_acquire_irq fails in rtsx_pci_probe, we forget to
disable an MSI (if we enabled it). This results in this warning on the
next attempt to load the module:
WARNING: at drivers/pci/msi.c:834 pci_enable_msi_block+0x2a4/0x2b0()
Hardware name: HP EliteBook 840 G1
Modules linked in: rtsx_pci(+) ...
Pid: 4056, comm: modprobe Tainted: G          I  3.8.0-9405-gd895cb1-1-vanilla #1
Call Trace:
 [<ffffffff81045c6a>] warn_slowpath_common+0x7a/0xc0
 [<ffffffff81045cc5>] warn_slowpath_null+0x15/0x20
 [<ffffffff81302544>] pci_enable_msi_block+0x2a4/0x2b0
 [<ffffffffa05e335a>] rtsx_pci_probe+0x55a/0x720 [rtsx_pci]
...

So properly disable MSI in that case.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mfd/rtsx_pcr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index 2f12cc1..578a113 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -1138,7 +1138,7 @@ static int rtsx_pci_probe(struct pci_dev *pcidev,
 
 	ret = rtsx_pci_acquire_irq(pcr);
 	if (ret < 0)
-		goto free_dma;
+		goto disable_msi;
 
 	pci_set_master(pcidev);
 	synchronize_irq(pcr->irq);
@@ -1162,7 +1162,9 @@ static int rtsx_pci_probe(struct pci_dev *pcidev,
 
 disable_irq:
 	free_irq(pcr->irq, (void *)pcr);
-free_dma:
+disable_msi:
+	if (pcr->msi_en)
+		pci_disable_msi(pcr->pci);
 	dma_free_coherent(&(pcr->pci->dev), RTSX_RESV_BUF_LEN,
 			pcr->rtsx_resv_buf, pcr->rtsx_resv_buf_addr);
 unmap:
-- 
1.8.2


