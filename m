Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab3ARQIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 11:08:40 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33924 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598Ab3ARQIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 11:08:35 -0500
From: Jiang Liu <liuj97@gmail.com>
To: "Rafael J . Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: [RFC PATCH v5 8/8] PCI/PCIe: only claim PME from firmware when CONFIG_PCIE_PME is enabled
Date: Sat, 19 Jan 2013 00:07:46 +0800
Message-Id: <1358525267-14268-9-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358525267-14268-1-git-send-email-jiang.liu@huawei.com>
References: <1358525267-14268-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_PCIE_PME is not defined, system should avoid claiming PME from
firmware so firmware could still manage PME events for those devices.
Also don't create PCIe port device for PME service if CONFIG_PCIE_PME
is not defined.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/acpi/pci_root.c         |    5 +++--
 drivers/pci/pcie/portdrv_core.c |    4 +++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index c37eedb..7f7e464 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -550,8 +550,9 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 
 	if (!pcie_ports_disabled
 	    && (flags & ACPI_PCIE_REQ_SUPPORT) == ACPI_PCIE_REQ_SUPPORT) {
-		flags = OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL
-			| OSC_PCI_EXPRESS_PME_CONTROL;
+		flags = OSC_PCI_EXPRESS_CAP_STRUCTURE_CONTROL;
+		if (IS_ENABLED(CONFIG_PCIE_PME))
+			flags |= OSC_PCI_EXPRESS_PME_CONTROL;
 		if (!pcie_native_hotplug_disabled)
 			flags |= OSC_PCI_EXPRESS_NATIVE_HP_CONTROL;
 
diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index e7e1679..7e6546f 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -263,7 +263,9 @@ static int get_port_device_capability(struct pci_dev *dev)
 
 	err = pcie_port_platform_notify(dev, &cap_mask);
 	if (!pcie_ports_auto) {
-		cap_mask = PCIE_PORT_SERVICE_PME | PCIE_PORT_SERVICE_VC;
+		cap_mask = PCIE_PORT_SERVICE_VC;
+		if (IS_ENABLED(CONFIG_PCIE_PME))
+			cap_mask |= PCIE_PORT_SERVICE_PME;
 		if (!pcie_native_hotplug_disabled)
 			cap_mask |= PCIE_PORT_SERVICE_HP;
 		if (pci_aer_available())
-- 
1.7.9.5

