Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbaAQJY0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 04:24:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbaAQJYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 04:24:19 -0500
Date: Fri, 17 Jan 2014 10:26:20 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pci@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/9] PCI/MSI: Undeprecate pci_enable_msi()
Message-ID: <20140117092620.GA29340@dhcp-26-207.brq.redhat.com>
References: <cover.1389904166.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1389904166.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 Documentation/PCI/MSI-HOWTO.txt |   23 ++++++++++++++++++++---
 1 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/Documentation/PCI/MSI-HOWTO.txt b/Documentation/PCI/MSI-HOWTO.txt
index a8d0100..3c3080e 100644
--- a/Documentation/PCI/MSI-HOWTO.txt
+++ b/Documentation/PCI/MSI-HOWTO.txt
@@ -82,7 +82,19 @@ Most of the hard work is done for the driver in the PCI layer.  It simply
 has to request that the PCI layer set up the MSI capability for this
 device.
 
-4.2.1 pci_enable_msi_range
+4.2.1 pci_enable_msi
+
+int pci_enable_msi(struct pci_dev *dev)
+
+A successful call allocates ONE interrupt to the device, regardless
+of how many MSIs the device supports.  The device is switched from
+pin-based interrupt mode to MSI mode.  The dev->irq number is changed
+to a new number which represents the message signaled interrupt;
+consequently, this function should be called before the driver calls
+request_irq(), because an MSI is delivered via a vector that is
+different from the vector of a pin-based interrupt.
+
+4.2.2 pci_enable_msi_range
 
 int pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec)
 
@@ -158,7 +170,12 @@ static int foo_driver_enable_single_msi(struct pci_dev *pdev)
 	return pci_enable_msi_range(pdev, 1, 1);
 }
 
-4.2.2 pci_disable_msi
+Note, unlike pci_enable_msi() function, which could be also used to
+enable the single MSI mode, pci_enable_msi_range() returns either a
+negative errno or 1 (not negative errno or 0 - as pci_enable_msi()
+does).
+
+4.2.3 pci_disable_msi
 
 void pci_disable_msi(struct pci_dev *dev)
 
@@ -172,7 +189,7 @@ on any interrupt for which it previously called request_irq().
 Failure to do so results in a BUG_ON(), leaving the device with
 MSI enabled and thus leaking its vector.
 
-4.2.3 pci_msi_vec_count
+4.2.4 pci_msi_vec_count
 
 int pci_msi_vec_count(struct pci_dev *dev)
 
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
