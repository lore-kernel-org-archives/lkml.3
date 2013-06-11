Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab3FKUXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:23:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756497Ab3FKUDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Chen <peter.chen@freescale.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 04/79] usb: dwc3: pci: PHY should be deleted later than dwc3 core
Date: Tue, 11 Jun 2013 13:02:30 -0700
Message-Id: <20130611195312.966702027@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/dwc3-pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -196,9 +196,9 @@ static void dwc3_pci_remove(struct pci_d
 {
 	struct dwc3_pci	*glue = pci_get_drvdata(pci);
 
+	platform_device_unregister(glue->dwc3);
 	platform_device_unregister(glue->usb2_phy);
 	platform_device_unregister(glue->usb3_phy);
-	platform_device_unregister(glue->dwc3);
 	pci_set_drvdata(pci, NULL);
 	pci_disable_device(pci);
 }


