Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab3LQUGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 15:06:01 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:51846 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab3LQUF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 15:05:58 -0500
Message-ID: <52B0AEA3.6000608@gmail.com>
Date: Tue, 17 Dec 2013 12:05:55 -0800
From: Rajat Jain <rajatjain.linux@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
CC: Guenter Roeck <groeck@juniper.net>, Rajat Jain <rajatjain@juniper.net>,
        Rajat Jain <rajatxjain@gmail.com>
Subject: [PATCH v3 3/8] pciehp: Enable link state change notifications
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabled the Link state notifications unconditionaly. Enable the
presence detection notification only if attention button is absent.
This was discussed at this thread:
http://marc.info/?t=138611014300001&r=1&w=2

Signed-off-by: Rajat Jain <rajatjain@juniper.net>
Signed-off-by: Guenter Roeck <groeck@juniper.net>
---
v3: * created by splitting the patch v2 [2/4]
    * Disable presence detect notification, when ATTN BTN is present
v2: (non existent)
v1: (non existent)

 drivers/pci/hotplug/pciehp_hpc.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index 1e9f814..b45b568 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -723,9 +723,17 @@ int pcie_enable_notification(struct controller *ctrl)
 	 * when it is cleared in the interrupt service routine, and
 	 * next power fault detected interrupt was notified again.
 	 */
-	cmd = PCI_EXP_SLTCTL_PDCE;
+
+	/*
+	 * Always enable link events: thus link-up and link-down shall
+	 * always be treated as hotplug and unplug respectively. Enable
+	 * presence detect only if Attention Button is not present.
+	 */
+	cmd = PCI_EXP_SLTCTL_DLLSCE;
 	if (ATTN_BUTTN(ctrl))
 		cmd |= PCI_EXP_SLTCTL_ABPE;
+	else
+		cmd |= PCI_EXP_SLTCTL_PDCE;
 	if (MRL_SENS(ctrl))
 		cmd |= PCI_EXP_SLTCTL_MRLSCE;
 	if (!pciehp_poll_mode)
@@ -733,7 +741,8 @@ int pcie_enable_notification(struct controller *ctrl)
 
 	mask = (PCI_EXP_SLTCTL_PDCE | PCI_EXP_SLTCTL_ABPE |
 		PCI_EXP_SLTCTL_MRLSCE | PCI_EXP_SLTCTL_PFDE |
-		PCI_EXP_SLTCTL_HPIE | PCI_EXP_SLTCTL_CCIE);
+		PCI_EXP_SLTCTL_HPIE | PCI_EXP_SLTCTL_CCIE |
+		PCI_EXP_SLTCTL_DLLSCE);
 
 	if (pcie_write_cmd(ctrl, cmd, mask)) {
 		ctrl_err(ctrl, "Cannot enable software notification\n");
-- 
1.7.9.5

