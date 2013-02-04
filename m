Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab3BDMOw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:14:52 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:43452 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab3BDL4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:56:10 -0500
Subject: [PATCH v2 4/7] PCI/PM: clear state_saved during suspend
To: e1000-devel@lists.sourceforge.net, linux-pci@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 04 Feb 2013 15:56:05 +0400
Message-ID: <20130204115605.5569.84605.stgit@zurg>
In-Reply-To: <20130204115246.5569.85829.stgit@zurg>
References: <20130204115246.5569.85829.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

This patch clears pci_dev->state_saved at the beginnig of suspending.
PCI config state may be saved long before that. Some divers calls
pci_save_state() from its ->probe() callback to get snapshot of sane
configuration space to use in the ->slot_reset() callback.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org> # add comment
Cc: linux-pci@vger.kernel.org
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/pci-driver.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index dc5bdce..f9aa311 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -628,6 +628,7 @@ static int pci_pm_suspend(struct device *dev)
 		goto Fixup;
 	}
 
+	pci_dev->state_saved = false;
 	if (pm->suspend) {
 		pci_power_t prev = pci_dev->current_state;
 		int error;
@@ -774,6 +775,7 @@ static int pci_pm_freeze(struct device *dev)
 		return 0;
 	}
 
+	pci_dev->state_saved = false;
 	if (pm->freeze) {
 		int error;
 
@@ -862,6 +864,7 @@ static int pci_pm_poweroff(struct device *dev)
 		goto Fixup;
 	}
 
+	pci_dev->state_saved = false;
 	if (pm->poweroff) {
 		int error;
 
@@ -987,6 +990,7 @@ static int pci_pm_runtime_suspend(struct device *dev)
 	if (!pm || !pm->runtime_suspend)
 		return -ENOSYS;
 
+	pci_dev->state_saved = false;
 	pci_dev->no_d3cold = false;
 	error = pm->runtime_suspend(dev);
 	suspend_report_result(pm->runtime_suspend, error);

