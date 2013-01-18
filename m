Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab3ARLm3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 06:42:29 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:44001 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab3ARLm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 06:42:26 -0500
Subject: [PATCH 3/5] PCI: revert preparing for wakeup in runtime-suspend
 finalization
To: linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: e1000-devel@lists.sourceforge.net, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, Dave Airlie <airlied@redhat.com>
Date: Fri, 18 Jan 2013 15:42:22 +0400
Message-ID: <20130118114222.6698.7103.stgit@zurg>
In-Reply-To: <20130118113019.6698.25941.stgit@zurg>
References: <20130118113019.6698.25941.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch effectively reverts commit 42eca2302146fed51335b95128e949ee6f54478f
("PCI: Don't touch card regs after runtime suspend D3")

| This patch checks whether the pci state is saved and doesn't attempt to hit
| any registers after that point if it is.

This seems completely wrong. Yes, PCI configuration space has been saved by
driver, but this doesn't means that all job is done and device has been
suspended and ready for waking up in the future.

For example driver e1000e for ethernet in my thinkpad x220 saves pci-state
but device cannot wakeup after that, because it needs some ACPI callbacks
which usually called from pci_finish_runtime_suspend().

| Optimus (dual-gpu) laptops seem to have their own form of D3cold, but
| unfortunately enter it on normal D3 transitions via the ACPI callback.

Hardware which disappears from the bus unexpectedly is exception, so let's
handle it as an exception. Its driver should set device state to D3cold and
the rest code will handle it properly.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-pci@vger.kernel.org
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Dave Airlie <airlied@redhat.com>
---
 drivers/pci/pci-driver.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index f79cbcd..030dbf0 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -1005,10 +1005,11 @@ static int pci_pm_runtime_suspend(struct device *dev)
 		return 0;
 	}
 
-	if (!pci_dev->state_saved) {
+	if (!pci_dev->state_saved)
 		pci_save_state(pci_dev);
+
+	if (pci_dev->current_state != PCI_D3cold)
 		pci_finish_runtime_suspend(pci_dev);
-	}
 
 	return 0;
 }

