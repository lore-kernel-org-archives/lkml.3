Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302Ab3EZP5o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 11:57:44 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:40078 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab3EZP5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 11:57:41 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH v3, part2 06/20] PCI, FRV: use hotplug-safe iterators to walk PCI buses
Date: Sun, 26 May 2013 23:53:03 +0800
Message-Id: <1369583597-3801-7-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369583597-3801-1-git-send-email-jiang.liu@huawei.com>
References: <1369583597-3801-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhance FRV architecture specific code to use hotplug-safe iterators
to walk PCI buses.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org
---
 arch/frv/mb93090-mb00/pci-frv.c | 5 ++++-
 arch/frv/mb93090-mb00/pci-vdk.c | 2 +-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/frv/mb93090-mb00/pci-frv.c b/arch/frv/mb93090-mb00/pci-frv.c
index c281217..48ee89a 100644
--- a/arch/frv/mb93090-mb00/pci-frv.c
+++ b/arch/frv/mb93090-mb00/pci-frv.c
@@ -188,8 +188,11 @@ static void __init pcibios_assign_resources(void)
 
 void __init pcibios_resource_survey(void)
 {
+	struct pci_bus *bus;
+
 	DBG("PCI: Allocating resources\n");
-	pcibios_allocate_bus_resources(&pci_root_buses);
+	for_each_pci_root_bus(bus)
+		pcibios_allocate_bus_resources(&bus->children);
 	pcibios_allocate_resources(0);
 	pcibios_allocate_resources(1);
 	pcibios_assign_resources();
diff --git a/arch/frv/mb93090-mb00/pci-vdk.c b/arch/frv/mb93090-mb00/pci-vdk.c
index 0aa35f0..f1d6c16 100644
--- a/arch/frv/mb93090-mb00/pci-vdk.c
+++ b/arch/frv/mb93090-mb00/pci-vdk.c
@@ -234,7 +234,7 @@ static void __init pcibios_fixup_peer_bridges(void)
 		return;
 	printk("PCI: Peer bridge fixup\n");
 	for (n=0; n <= pcibios_last_bus; n++) {
-		if (pci_find_bus(0, n))
+		if (pci_bus_exists(0, n))
 			continue;
 		bus.number = n;
 		bus.ops = pci_root_ops;
-- 
1.8.1.2

