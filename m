Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab3EIWcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:32:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757538Ab3EIWct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:32:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?T=F3th=20Attila?= <atoth@atoth.sote.hu>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: [ 13/73] PCI/PM: Clear state_saved during suspend
Date: Thu,  9 May 2013 15:31:36 -0700
Message-Id: <20130509222759.392140885@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222757.917088509@linuxfoundation.org>
References: <20130509222757.917088509@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 82fee4d67ab86d6fe5eb0f9a9e988ca9d654d765 upstream.

This patch clears pci_dev->state_saved at the beginning of suspending.
PCI config state may be saved long before that.  Some drivers call
pci_save_state() from the ->probe() callback to get snapshot of sane
configuration space to use in the ->slot_reset() callback.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org> # add comment
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Tóth Attila <atoth@atoth.sote.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/pci-driver.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -628,6 +628,7 @@ static int pci_pm_suspend(struct device
 		goto Fixup;
 	}
 
+	pci_dev->state_saved = false;
 	if (pm->suspend) {
 		pci_power_t prev = pci_dev->current_state;
 		int error;
@@ -774,6 +775,7 @@ static int pci_pm_freeze(struct device *
 		return 0;
 	}
 
+	pci_dev->state_saved = false;
 	if (pm->freeze) {
 		int error;
 
@@ -862,6 +864,7 @@ static int pci_pm_poweroff(struct device
 		goto Fixup;
 	}
 
+	pci_dev->state_saved = false;
 	if (pm->poweroff) {
 		int error;
 
@@ -987,6 +990,7 @@ static int pci_pm_runtime_suspend(struct
 	if (!pm || !pm->runtime_suspend)
 		return -ENOSYS;
 
+	pci_dev->state_saved = false;
 	pci_dev->no_d3cold = false;
 	error = pm->runtime_suspend(dev);
 	suspend_report_result(pm->runtime_suspend, error);


