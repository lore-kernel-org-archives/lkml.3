Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab3HAQ4B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 12:56:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756814Ab3HAQzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 12:55:55 -0400
Subject: [PATCH v3 7/9] pci: Wake-up devices before save for reset
To: bhelgaas@google.com, linux-pci@vger.kernel.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: indou.takao@jp.fujitsu.com, linux-kernel@vger.kernel.org
Date: Thu, 01 Aug 2013 10:55:51 -0600
Message-ID: <20130801165551.16145.34134.stgit@bling.home>
In-Reply-To: <20130801164652.16145.79918.stgit@bling.home>
References: <20130801164652.16145.79918.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Devices come out of reset in D0.  Restoring a device to a different
post-reset state takes more smarts than our simple config space
restore, which can leave devices in an inconsistent state.  For
example, if a device is reset in D3, but the restore doesn't
successfully return the device to D3, then the actual state of the
device and dev->current_state are contradictory.  Put everything
in D0 going into the reset, then we don't need to do anything
special on the way out.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/pci.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 91f7bc4..3e71887 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3393,6 +3393,13 @@ static void pci_dev_unlock(struct pci_dev *dev)
 
 static void pci_dev_save_and_disable(struct pci_dev *dev)
 {
+	/*
+	 * Wake-up device prior to save.  PM registers default to D0 after
+	 * reset and a simple register restore doesn't reliably return
+	 * to a non-D0 state anyway.
+	 */
+	pci_set_power_state(dev, PCI_D0);
+
 	pci_save_state(dev);
 	/*
 	 * both INTx and MSI are disabled after the Interrupt Disable bit

