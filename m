Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab3ARLnR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 06:43:17 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:64515 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab3ARLmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 06:42:22 -0500
Subject: [PATCH 2/5] e1000e: fix pci device enable counter balance
To: linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: e1000-devel@lists.sourceforge.net, linux-pci@vger.kernel.org,
        Bruce Allan <bruce.w.allan@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Fri, 18 Jan 2013 15:42:18 +0400
Message-ID: <20130118114218.6698.42484.stgit@zurg>
In-Reply-To: <20130118113019.6698.25941.stgit@zurg>
References: <20130118113019.6698.25941.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__e1000_shutdown() calls pci_disable_device() at the end, thus __e1000_resume()
should call pci_enable_device_mem() to keep enable counter in balance.

Bug was introduced in commit 23606cf5d1192c2b17912cb2ef6e62f9b11de133
("e1000e / PCI / PM: Add basic runtime PM support (rev. 4)") in v2.6.35

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: e1000-devel@lists.sourceforge.net
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Bruce Allan <bruce.w.allan@intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 2853c11..6bce796 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5598,6 +5598,13 @@ static int __e1000_resume(struct pci_dev *pdev)
 	pci_restore_state(pdev);
 	pci_save_state(pdev);
 
+	err = pci_enable_device_mem(pdev);
+	if (err) {
+		dev_err(&pdev->dev,
+			"Cannot re-enable PCI device after suspend.\n");
+		return err;
+	}
+
 	e1000e_set_interrupt_capability(adapter);
 	if (netif_running(netdev)) {
 		err = e1000_request_irq(adapter);

