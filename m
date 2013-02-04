Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab3BDMNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:13:48 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:47454 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab3BDL4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:56:16 -0500
Subject: [PATCH v2 6/7] PCI/PM: warn about incomplete actions in
 ->runtime_suspend() callback
To: e1000-devel@lists.sourceforge.net, linux-pci@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 04 Feb 2013 15:56:12 +0400
Message-ID: <20130204115612.5569.49895.stgit@zurg>
In-Reply-To: <20130204115246.5569.85829.stgit@zurg>
References: <20130204115246.5569.85829.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation/power/pci.txt says:
| It is expected that the device driver's pm->runtime_suspend() callback will
| not attempt to prepare the device for signaling wakeup or to put it into a
| low-power state.  The driver ought to leave these tasks to the PCI subsystem
| that has all of the information necessary to perform them.

After commit 42eca2302146fed51335b95128e949ee6f54478f
("PCI: Don't touch card regs after runtime suspend D3")
| If the driver takes care of state saving, don't touch any registers on it.
pci_pm_runtime_suspend() thinks if state has been saved by ->runtime_suspend()
that means device alredy prepared for wakeup and probably no longer accessible.

Thus driver must either do all actions or leave all these tasks to PCI subsystem.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
---
 drivers/pci/pci-driver.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index f9aa311..2b0ff9a 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -1009,12 +1009,19 @@ static int pci_pm_runtime_suspend(struct device *dev)
 		return 0;
 	}
 
-	if (!pci_dev->state_saved) {
-		pci_save_state(pci_dev);
-		pci_finish_runtime_suspend(pci_dev);
+	if (pci_dev->state_saved) {
+		WARN_ONCE(pci_dev->current_state == prev,
+			"PCI PM: Power state of device not changed by %pF\n",
+			pm->runtime_suspend);
+		WARN_ONCE(pci_dev_run_wake(pci_dev) &&
+				!pci_dev->wakeup_prepared,
+			"PCI PM: Waking of device not configured by %pF\n",
+			pm->runtime_suspend);
+		return 0;
 	}
 
-	return 0;
+	pci_save_state(pci_dev);
+	return pci_finish_runtime_suspend(pci_dev);
 }
 
 static int pci_pm_runtime_resume(struct device *dev)

