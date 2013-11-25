Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab3KYNVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:21:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57155 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab3KYNIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:08:04 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 37/78] PCI/PM: Clear state_saved during suspend
Date: Mon, 25 Nov 2013 13:06:24 +0000
Message-Id: <1385384825-21681-38-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 82fee4d67ab86d6fe5eb0f9a9e988ca9d654d765 upstream.

This patch clears pci_dev->state_saved at the beginning of suspending.
PCI config state may be saved long before that.  Some drivers call
pci_save_state() from the ->probe() callback to get snapshot of sane
configuration space to use in the ->slot_reset() callback.

[wangyj: adjust context]
Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org> # add comment
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/pci/pci-driver.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 3389387..920d701 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -686,6 +686,7 @@ static int pci_pm_suspend(struct device *dev)
 		goto Fixup;
 	}
 
+	pci_dev->state_saved = false;
 	if (pm->suspend) {
 		pci_power_t prev = pci_dev->current_state;
 		int error;
@@ -832,6 +833,7 @@ static int pci_pm_freeze(struct device *dev)
 		return 0;
 	}
 
+	pci_dev->state_saved = false;
 	if (pm->freeze) {
 		int error;
 
@@ -920,6 +922,7 @@ static int pci_pm_poweroff(struct device *dev)
 		goto Fixup;
 	}
 
+	pci_dev->state_saved = false;
 	if (pm->poweroff) {
 		int error;
 
@@ -1038,6 +1041,7 @@ static int pci_pm_runtime_suspend(struct device *dev)
 	if (!pm || !pm->runtime_suspend)
 		return -ENOSYS;
 
+	pci_dev->state_saved = false;
 	error = pm->runtime_suspend(dev);
 	suspend_report_result(pm->runtime_suspend, error);
 	if (error)
-- 
1.8.3.2

