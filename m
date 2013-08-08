Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966432Ab3HHUKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 16:10:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966282Ab3HHUKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 16:10:34 -0400
Subject: [PATCH v5 7/9] pci: Wake-up devices before save for reset
To: bhelgaas@google.com, linux-pci@vger.kernel.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: alexander.h.duyck@intel.com, ddutile@redhat.com,
        indou.takao@jp.fujitsu.com, linux-kernel@vger.kernel.org
Date: Thu, 08 Aug 2013 14:10:02 -0600
Message-ID: <20130808201001.2932.66514.stgit@bling.home>
In-Reply-To: <20130808200444.2932.17381.stgit@bling.home>
References: <20130808200444.2932.17381.stgit@bling.home>
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
index 1dba7dd..b204206 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3332,6 +3332,13 @@ static void pci_dev_unlock(struct pci_dev *dev)
 
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
 	 * Disable the device by clearing the Command register, except for

