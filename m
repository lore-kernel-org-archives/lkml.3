Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965986Ab3DQLPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 07:15:13 -0400
Received: from trac3r.net ([69.55.60.109]:59867 "EHLO trac3r.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965117Ab3DQLPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 07:15:11 -0400
X-Greylist: delayed 508 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Apr 2013 07:15:11 EDT
From: Artem Savkov <artem.savkov@gmail.com>
To: linux-pci@vger.kernel.org
Cc: bhelgaas@google.com, linux-kernel@vger.kernel.org,
        Artem Savkov <artem.savkov@gmail.com>
Subject: [PATCH] PCI: pci_bus_add_device() should succeed even if creating sysfs files fails
Date: Wed, 17 Apr 2013 11:06:38 +0000
Message-Id: <1366196798-15929-1-git-send-email-artem.savkov@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduced in cc8f7f9e4e79a0940af6b4b6fdfbcf18a03aa9f4
("PCI: Fix __must_check annotation on pci_create_sysfs_dev_files()")

pci_bus_add_device() should not fail to add device if
pci_create_sysfs_dev_files() call fails, as sysfs files are not critical.

pci_sysfs_init() is a "late_initcall" and is called after acpi_init, so
pci_bus_add_device() fails to create devices during boot resulting in a
bug during acpi_init. It is safe not to create sysfs_dev_files in
pci_bus_add_device() as they are later created in pci_sysfs_ini().

[    0.316603] ------------[ cut here ]------------
[    0.317000] kernel BUG at drivers/pci/bus.c:210!
[    0.317000] invalid opcode: 0000 [#1] SMP
[    0.317000] Modules linked in:
[    0.317000] Pid: 1, comm: swapper/0 Not tainted 3.9.0-rc2+ #357 Bochs Bochs
[    0.317000] EIP: 0060:[<c12d2d7e>] EFLAGS: 00010246 CPU: 0
[    0.317000] EIP is at pci_bus_add_devices+0x7e/0x80
[    0.317000] EAX: fffffff3 EBX: df207000 ECX: 00000000 EDX: 00000001
[    0.317000] ESI: df228000 EDI: df228014 EBP: df0a1dec ESP: df0a1de0
[    0.317000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.317000] CR0: 8005003b CR2: ffe16000 CR3: 01c32000 CR4: 00000690
[    0.317000] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    0.317000] DR6: ffff0ff0 DR7: 00000400
[    0.317000] Process swapper/0 (pid: 1, ti=df0a0000 task=df098000 task.ti=df0a0000)
[    0.317000] Stack:
[    0.317000]  df1702c0 c19f2294 00000000 df0a1e2c c13102d9 c18fec3e c18febce 00000008
[    0.317000]  00000000 df1702d4 df056044 00000008 00000000 00000000 c130d023 00000006
[    0.317000]  c19f22fc c173ec9c df17c590 df0a1e5c c130d0f4 df056000 df05603c df02f9c0
[    0.317000] Call Trace:
[    0.317000]  [<c13102d9>] acpi_pci_root_add+0x3af/0x3ea
[    0.317000]  [<c130d023>] ? acpi_bus_type_and_status+0x3d/0x88
[    0.317000]  [<c130d0f4>] acpi_bus_device_attach+0x86/0xe4
[    0.317000]  [<c1334d05>] acpi_ns_walk_namespace+0xf5/0x240
[    0.317000]  [<c1335567>] acpi_walk_namespace+0xdd/0x11c
[    0.317000]  [<c130d06e>] ? acpi_bus_type_and_status+0x88/0x88
[    0.317000]  [<c130e021>] acpi_bus_scan+0x95/0xa8
[    0.317000]  [<c130d06e>] ? acpi_bus_type_and_status+0x88/0x88
[    0.317000]  [<c1a5dae6>] acpi_scan_init+0x59/0x152
[    0.317000]  [<c1a5d90d>] acpi_init+0x243/0x28b
[    0.317000]  [<c1a5d6ca>] ? acpi_sleep_proc_init+0x2e/0x2e
[    0.317000]  [<c10011f2>] do_one_initcall+0x102/0x150
[    0.317000]  [<c1a36b40>] kernel_init_freeable+0x135/0x1c7
[    0.317000]  [<c1a364c8>] ? do_early_param+0x78/0x78
[    0.317000]  [<c16daae0>] kernel_init+0x10/0x140
[    0.317000]  [<c16fa4b7>] ret_from_kernel_thread+0x1b/0x28
[    0.317000]  [<c16daad0>] ? rest_init+0xd0/0xd0
[    0.317000] Code: 0c 85 f6 74 1b 89 f0 e8 a1 ff ff ff 0f b6 86 18 03 00 00 a8 01 75 09 83 c8 01 88 86 18 03 00 00 8b 1b 39 fb 75 cf 5b 5e 5f 5d c3 <0f> 0b 55 89 e5 53 3e 8d 74 26 00 83 fa 03 7e 32 8b 48 38 8d 58
[    0.317000] EIP: [<c12d2d7e>] pci_bus_add_devices+0x7e/0x80 SS:ESP 0068:df0a1de0
[    0.318013] ---[ end trace 9e4164edb7144ba6 ]---
[    0.319015] swapper/0 (1) used greatest stack depth: 5720 bytes left
[    0.320011] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
[    0.320011]

Signed-off-by: Artem Savkov <artem.savkov@gmail.com>
---
 drivers/pci/bus.c |    4 +---
 drivers/pci/pci.h |    2 +-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 445a99d..748f8f3 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -174,9 +174,7 @@ int pci_bus_add_device(struct pci_dev *dev)
 	 * Can not put in pci_device_add yet because resources
 	 * are not assigned yet for some devices.
 	 */
-	retval = pci_create_sysfs_dev_files(dev);
-	if (retval)
-		return retval;
+	pci_create_sysfs_dev_files(dev);
 
 	dev->match_driver = true;
 	retval = device_attach(&dev->dev);
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 0f1b306..68678ed 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -8,7 +8,7 @@
 
 /* Functions internal to the PCI core code */
 
-int __must_check pci_create_sysfs_dev_files(struct pci_dev *pdev);
+int pci_create_sysfs_dev_files(struct pci_dev *pdev);
 void pci_remove_sysfs_dev_files(struct pci_dev *pdev);
 #if !defined(CONFIG_DMI) && !defined(CONFIG_ACPI)
 static inline void pci_create_firmware_label_files(struct pci_dev *pdev)
-- 
1.7.0.4

