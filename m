Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab3FQSAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 14:00:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50418 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab3FQRbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:31:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Chen <peter.chen@freescale.com>, Felipe Balbi <balbi@ti.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 12/84] usb: dwc3: pci: PHY should be deleted later than dwc3 core
Date: Mon, 17 Jun 2013 10:30:16 -0700
Message-Id: <1371490288-23167-13-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chen <peter.chen@freescale.com>

commit f28c42c576b293b3a1daaed8ca2775ebc2fe5398 upstream.

If the glue layer is removed first (core layer later),
it deletes the phy device first, then the core device.
But at core's removal, it still uses PHY's resources, it may
cause kernel's oops. It is much like the problem
Paul Zimmerman reported at:
http://marc.info/?l=linux-usb&m=136547502011472&w=2.

Besides, it is reasonable the PHY is deleted at last as
the controller is the PHY's user.

Signed-off-by: Peter Chen <peter.chen@freescale.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/dwc3/dwc3-pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 7d70f44..9c0306b 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -198,9 +198,9 @@ static void dwc3_pci_remove(struct pci_dev *pci)
 {
 	struct dwc3_pci	*glue = pci_get_drvdata(pci);
 
+	platform_device_unregister(glue->dwc3);
 	platform_device_unregister(glue->usb2_phy);
 	platform_device_unregister(glue->usb3_phy);
-	platform_device_unregister(glue->dwc3);
 	pci_set_drvdata(pci, NULL);
 	pci_disable_device(pci);
 }
-- 
1.8.1.2

