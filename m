Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934161Ab3GQWwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:52:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56314 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757813Ab3GQWu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:50:57 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Slaby <jslaby@suse.cz>, Samuel Ortiz <sameo@linux.intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 136/145] MFD: rtsx_pcr: Fix probe fail path
Date: Wed, 17 Jul 2013 15:47:48 -0700
Message-Id: <1374101277-7915-137-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit 9d66b568a215fe2da2a9db736ebf9b8d66082d88 upstream.

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
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/mfd/rtsx_pcr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index 1e2d120..148aa18 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -1136,7 +1136,7 @@ static int rtsx_pci_probe(struct pci_dev *pcidev,
 
 	ret = rtsx_pci_acquire_irq(pcr);
 	if (ret < 0)
-		goto free_dma;
+		goto disable_msi;
 
 	pci_set_master(pcidev);
 	synchronize_irq(pcr->irq);
@@ -1160,7 +1160,9 @@ static int rtsx_pci_probe(struct pci_dev *pcidev,
 
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
1.8.1.2

