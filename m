Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbaLEXFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:05:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38460 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbaLEXFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 18:05:33 -0500
From: Chris J Arges <chris.j.arges@canonical.com>
To: linux-pci@vger.kernel.org
Cc: Chris J Arges <chris.j.arges@canonical.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] PCI/ASPM: use standard parsing functions for sysfs setters
Date: Fri,  5 Dec 2014 17:02:42 -0600
Message-Id: <1417820598-8021-1-git-send-email-chris.j.arges@canonical.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions link_state_store, clk_ctl_store had just subtracted ASCII '0' from
input which could lead to undesired results. Instead, use linux string functions
to safely parse input.

Signed-off-by: Chris J Arges <chris.j.arges@canonical.com>
---
 drivers/pci/pcie/aspm.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index e1e7026..48e1714 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -859,7 +859,10 @@ static ssize_t link_state_store(struct device *dev,
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
 	struct pcie_link_state *link, *root = pdev->link_state->root;
-	u32 val = buf[0] - '0', state = 0;
+	u32 state = 0;
+	u32 val;
+
+	kstrtouint(buf, 10, &val);
 
 	if (aspm_disabled)
 		return -EPERM;
@@ -900,15 +903,14 @@ static ssize_t clk_ctl_store(struct device *dev,
 		size_t n)
 {
 	struct pci_dev *pdev = to_pci_dev(dev);
-	int state;
+	bool state;
 
-	if (n < 1)
+	if (strtobool(buf, &state))
 		return -EINVAL;
-	state = buf[0]-'0';
 
 	down_read(&pci_bus_sem);
 	mutex_lock(&aspm_lock);
-	pcie_set_clkpm_nocheck(pdev->link_state, !!state);
+	pcie_set_clkpm_nocheck(pdev->link_state, state);
 	mutex_unlock(&aspm_lock);
 	up_read(&pci_bus_sem);
 
-- 
1.9.1

