Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494Ab3HAQ4G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 12:56:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757303Ab3HAQ4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 12:56:01 -0400
Subject: [PATCH v3 8/9] pci: Tune secondary bus reset timing
To: bhelgaas@google.com, linux-pci@vger.kernel.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: indou.takao@jp.fujitsu.com, linux-kernel@vger.kernel.org
Date: Thu, 01 Aug 2013 10:55:58 -0600
Message-ID: <20130801165557.16145.57324.stgit@bling.home>
In-Reply-To: <20130801164652.16145.79918.stgit@bling.home>
References: <20130801164652.16145.79918.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI spec indicates that with stable power, reset needs to be
asserted for a minimum of 1ms (Trst).  Seems like we should be able
to assume power is stable for a runtime secondary bus reset.  The
current code has always used 100ms with no explanation where that
came from.  The aer_do_secondary_bus_reset() function uses 2ms, but
that seems to be a misinterpretation of the PCIe spec, where hot
reset is implemented by TS1 ordered sets containing the hot reset
command.  After a 2ms delay the state machine enters the detect state,
but to generate a link down, only two consecutive TS1 hot reset
ordered sets are requred.  1ms should be plenty for that.

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
 drivers/pci/pci.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 3e71887..a5c6a9b 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3291,11 +3291,22 @@ void pci_reset_bridge_secondary_bus(struct pci_dev *dev)
 	pci_read_config_word(dev, PCI_BRIDGE_CONTROL, &ctrl);
 	ctrl |= PCI_BRIDGE_CTL_BUS_RESET;
 	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, ctrl);
-	msleep(100);
+	/*
+	 * PCI spec v3.0 7.6.4.2 requires minimum Trst of 1ms.
+	 */
+	msleep(1);
 
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
 

