Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab3KRSuH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:50:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57586 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab3KRSlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:41:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: [PATCH 3.4 11/12] PCI/PM: Clear state_saved during suspend
Date: Mon, 18 Nov 2013 10:41:44 -0800
Message-Id: <20131118184133.451435120@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131118184130.257996039@linuxfoundation.org>
References: <20131118184130.257996039@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci-driver.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -680,6 +680,7 @@ static int pci_pm_suspend(struct device
 		goto Fixup;
 	}
 
+	pci_dev->state_saved = false;
 	if (pm->suspend) {
 		pci_power_t prev = pci_dev->current_state;
 		int error;
@@ -826,6 +827,7 @@ static int pci_pm_freeze(struct device *
 		return 0;
 	}
 
+	pci_dev->state_saved = false;
 	if (pm->freeze) {
 		int error;
 
@@ -914,6 +916,7 @@ static int pci_pm_poweroff(struct device
 		goto Fixup;
 	}
 
+	pci_dev->state_saved = false;
 	if (pm->poweroff) {
 		int error;
 
@@ -1032,6 +1035,7 @@ static int pci_pm_runtime_suspend(struct
 	if (!pm || !pm->runtime_suspend)
 		return -ENOSYS;
 
+	pci_dev->state_saved = false;
 	error = pm->runtime_suspend(dev);
 	suspend_report_result(pm->runtime_suspend, error);
 	if (error)


