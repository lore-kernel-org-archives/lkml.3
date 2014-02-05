Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbaBEC3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 21:29:30 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57277 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbaBEC32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 21:29:28 -0500
Message-ID: <52F1A203.7060802@gmail.com>
Date: Tue, 04 Feb 2014 18:29:23 -0800
From: Rajat Jain <rajatxjain@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
CC: Guenter Roeck <groeck@juniper.net>, Rajat Jain <rajatjain@juniper.net>,
        Rajat Jain <rajatxjain@gmail.com>
Subject: [PATCH v4 3/8] pciehp: Enable link state change notifications
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabled the Link state notifications unconditionaly. Enable the
presence detection notification only if attention button is absent.
This was discussed at this thread:
http://marc.info/?t=138611014300001&r=1&w=2

Signed-off-by: Rajat Jain <rajatxjain@gmail.com>
Signed-off-by: Rajat Jain <rajatjain@juniper.net>
Signed-off-by: Guenter Roeck <groeck@juniper.net>
---
 drivers/pci/hotplug/pciehp_hpc.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index b413dce..245a3cb 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -600,9 +600,17 @@ void pcie_enable_notification(struct controller *ctrl)
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
@@ -610,7 +618,8 @@ void pcie_enable_notification(struct controller *ctrl)
 
 	mask = (PCI_EXP_SLTCTL_PDCE | PCI_EXP_SLTCTL_ABPE |
 		PCI_EXP_SLTCTL_MRLSCE | PCI_EXP_SLTCTL_PFDE |
-		PCI_EXP_SLTCTL_HPIE | PCI_EXP_SLTCTL_CCIE);
+		PCI_EXP_SLTCTL_HPIE | PCI_EXP_SLTCTL_CCIE |
+		PCI_EXP_SLTCTL_DLLSCE);
 
 	pcie_write_cmd(ctrl, cmd, mask);
 }
-- 
1.7.9.5

