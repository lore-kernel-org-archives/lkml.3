Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246Ab3ERDJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:09:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758753Ab3ERDAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:22 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=7Ga_VcgPoMoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=OBazriehf1sA:10 a=QyXUC8HyAAAA:8 a=6rqHouBjAAAA:8 a=1XWaLZrsAAAA:8 a=aCPqOQJ_S1qBLZ7JjQ4A:9 a=dGJ0OcVc7YAA:10 a=TAmEwCHjoHMA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021656.674764124@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Bjorn Helgaas <bhelgaas@google.com>
Subject: [ 093/136 ] PCI/PM: Clear state_saved during suspend
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0093-PCI-PM-Clear-state_saved-during-suspend.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 82fee4d67ab86d6fe5eb0f9a9e988ca9d654d765 ]

This patch clears pci_dev->state_saved at the beginning of suspending.
PCI config state may be saved long before that.  Some drivers call
pci_save_state() from the ->probe() callback to get snapshot of sane
configuration space to use in the ->slot_reset() callback.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org> # add comment
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/pci/pci-driver.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 729e038..97d0f03d 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -685,6 +685,7 @@ static int pci_pm_suspend(struct device *dev)
 		goto Fixup;
 	}
 
+	pci_dev->state_saved = false;
 	if (pm->suspend) {
 		pci_power_t prev = pci_dev->current_state;
 		int error;
@@ -831,6 +832,7 @@ static int pci_pm_freeze(struct device *dev)
 		return 0;
 	}
 
+	pci_dev->state_saved = false;
 	if (pm->freeze) {
 		int error;
 
@@ -919,6 +921,7 @@ static int pci_pm_poweroff(struct device *dev)
 		goto Fixup;
 	}
 
+	pci_dev->state_saved = false;
 	if (pm->poweroff) {
 		int error;
 
@@ -1037,6 +1040,7 @@ static int pci_pm_runtime_suspend(struct device *dev)
 	if (!pm || !pm->runtime_suspend)
 		return -ENOSYS;
 
+	pci_dev->state_saved = false;
 	pci_dev->no_d3cold = false;
 	error = pm->runtime_suspend(dev);
 	suspend_report_result(pm->runtime_suspend, error);
-- 
1.7.10.4


