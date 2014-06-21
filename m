Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbaFUPF7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 11:05:59 -0400
Received: from ns.gsystem.sk ([62.176.172.50]:54731 "EHLO ns.gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946AbaFUPF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 11:05:57 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Samuel Chessman <chessman@tux.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/11] tlan: Enable device at resume
Date: Sat, 21 Jun 2014 16:47:55 +0200
Message-Id: <1403362076-7777-11-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403362076-7777-1-git-send-email-linux@rainbow-software.org>
References: <1403362076-7777-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pci_disable_device() is called in _suspend but there's no corresponding
pci_enable_device() in _resume.
This causes "disabling already-disabled device" warning on 2nd suspend.

Add pci_enable_device() call to _resume to fix this problem.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/net/ethernet/ti/tlan.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/tlan.c b/drivers/net/ethernet/ti/tlan.c
index ef32e5f..3c88ac2 100644
--- a/drivers/net/ethernet/ti/tlan.c
+++ b/drivers/net/ethernet/ti/tlan.c
@@ -366,8 +366,10 @@ static int tlan_suspend(struct pci_dev *pdev, pm_message_t state)
 static int tlan_resume(struct pci_dev *pdev)
 {
 	struct net_device *dev = pci_get_drvdata(pdev);
+	int rc = pci_enable_device(pdev);
 
-	pci_set_power_state(pdev, PCI_D0);
+	if (rc)
+		return rc;
 	pci_restore_state(pdev);
 	pci_enable_wake(pdev, PCI_D0, 0);
 	netif_device_attach(dev);
-- 
Ondrej Zary

