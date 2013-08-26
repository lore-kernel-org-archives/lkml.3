Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab3HZEEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 00:04:09 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:32888 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab3HZEEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 00:04:07 -0400
MIME-Version: 1.0
Date: Mon, 26 Aug 2013 12:04:05 +0800
Message-ID: <CAPgLHd-Lj7MjTYGA6TNK2JtScORtd5NvAo3WZuM425sRJj8=tw@mail.gmail.com>
Subject: [PATCH] vme: vme_ca91cx42.c: fix to pass correct device identity to free_irq()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: martyn.welch@ge.com, manohar.vanga@gmail.com, gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

free_irq() expects the same device identity that was passed to
corresponding request_irq(), otherwise the IRQ is not freed.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/vme/bridges/vme_ca91cx42.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/vme/bridges/vme_ca91cx42.c b/drivers/vme/bridges/vme_ca91cx42.c
index 64bfea3..f24e234 100644
--- a/drivers/vme/bridges/vme_ca91cx42.c
+++ b/drivers/vme/bridges/vme_ca91cx42.c
@@ -243,6 +243,8 @@ static int ca91cx42_irq_init(struct vme_bridge *ca91cx42_bridge)
 static void ca91cx42_irq_exit(struct ca91cx42_driver *bridge,
 	struct pci_dev *pdev)
 {
+	struct vme_bridge *ca91cx42_bridge;
+
 	/* Disable interrupts from PCI to VME */
 	iowrite32(0, bridge->base + VINT_EN);
 
@@ -251,7 +253,9 @@ static void ca91cx42_irq_exit(struct ca91cx42_driver *bridge,
 	/* Clear Any Pending PCI Interrupts */
 	iowrite32(0x00FFFFFF, bridge->base + LINT_STAT);
 
-	free_irq(pdev->irq, pdev);
+	ca91cx42_bridge = container_of((void *)bridge, struct vme_bridge,
+				       driver_priv);
+	free_irq(pdev->irq, ca91cx42_bridge);
 }
 
 static int ca91cx42_iack_received(struct ca91cx42_driver *bridge, int level)

