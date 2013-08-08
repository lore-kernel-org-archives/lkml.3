Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966409Ab3HHUKZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 16:10:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966282Ab3HHUKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 16:10:23 -0400
Subject: [PATCH v5 8/9] pci: Tune secondary bus reset timing
To: bhelgaas@google.com, linux-pci@vger.kernel.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: alexander.h.duyck@intel.com, ddutile@redhat.com,
        indou.takao@jp.fujitsu.com, linux-kernel@vger.kernel.org
Date: Thu, 08 Aug 2013 14:10:13 -0600
Message-ID: <20130808201012.2932.39882.stgit@bling.home>
In-Reply-To: <20130808200444.2932.17381.stgit@bling.home>
References: <20130808200444.2932.17381.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI spec indicates that with stable power, reset needs to be
asserted for a minimum of 1ms (Trst).  We should be able to assume
stable power for a Hot Reset, but we add another millisecond as
a fudge factor to make sure the reset is seen on the bus for at least
a full 1ms.

After reset is de-asserted we must wait for devices to complete
initialization.  The specs refer to this as "recovery time" (Trhfa).
For PCI this is 2^25 clock cycles or 2^26 for PCI-X.  For minimum
bus speeds, both of those come to 1s.  PCIe "softens" this
requirement with the Configuration Request Retry Status (CRS)
completion status.  Theoretically we could use CRS to shorten the
wait time.  We don't make use of that here, using a fixed 1s delay
to allow devices to re-initialize.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/pci.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b204206..ba68451 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3230,11 +3230,23 @@ void pci_reset_bridge_secondary_bus(struct pci_dev *dev)
 	pci_read_config_word(dev, PCI_BRIDGE_CONTROL, &ctrl);
 	ctrl |= PCI_BRIDGE_CTL_BUS_RESET;
 	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, ctrl);
-	msleep(100);
+	/*
+	 * PCI spec v3.0 7.6.4.2 requires minimum Trst of 1ms.  Double
+	 * this to 2ms to ensure that we meet the minium requirement.
+	 */
+	msleep(2);
 
 	ctrl &= ~PCI_BRIDGE_CTL_BUS_RESET;
 	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, ctrl);
-	msleep(100);
+
+	/*
+	 * Trhfa for conventional PCI is 2^25 clock cycles.
+	 * Assuming a minimum 33MHz clock this results in a 1s
+	 * delay before we can consider subordinate devices to
+	 * be re-initialized.  PCIe has some ways to shorten this,
+	 * but we don't make use of them yet.
+	 */
+	ssleep(1);
 }
 EXPORT_SYMBOL_GPL(pci_reset_bridge_secondary_bus);
 

