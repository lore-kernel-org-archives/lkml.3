Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab3EVJnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 05:43:14 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:42070 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752445Ab3EVJnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 05:43:12 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, <stable@vger.kernel.org>
Subject: [PATCH] x86/PCI: setup data may be in highmem
Date: Wed, 22 May 2013 10:43:02 +0100
Message-Id: <1369215782-32697-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

pcibios_add_device() assumes that the physical addresses stored in
setup_data are accessible via the direct kernel mapping, and that
calling phys_to_virt() is valid. This isn't guaranteed to be true on x86
where the direct mapping range is much smaller than on x86-64.

Calling phys_to_virt() on a highmem address results in the following,

 BUG: unable to handle kernel paging request at 39a3c198
 IP: [<c262be0f>] pcibios_add_device+0x2f/0x90
 *pde = 00000000
 Oops: 0000 [#1] SMP
 Modules linked in:
 Pid: 1, comm: swapper/0 Tainted: G        W I  3.9.0-rc2+ #280
 EIP: 0060:[<c262be0f>] EFLAGS: 00010206 CPU: 1
 EIP is at pcibios_add_device+0x2f/0x90
 EAX: f6258800 EBX: f6258800 ECX: 79a3c190 EDX: 39a3c190
 ESI: f62d9814 EDI: f6258864 EBP: f60add38 ESP: f60add2c
  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
 CR0: 8005003b CR2: 39a3c198 CR3: 02b91000 CR4: 001007d0
 DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
 DR6: ffff0ff0 DR7: 00000400
 Process swapper/0 (pid: 1, ti=f60ac000 task=f60b0000 task.ti=f60ac000)
 Stack:
  f6258800 f62d9814 f6258864 f60add4c c2370c73 00000000 f62d9800 00000000
  f60add6c c274640b 0000ea60 f6258800 0f008086 f62d9800 f62d9800 00000000
  f60add84 c2370d08 00000000 00000008 f62d9800 00000000 f60adda4 c2371904
 Call Trace:
  [<c2370c73>] pci_device_add+0xe3/0x130
  [<c274640b>] pci_scan_single_device+0x8b/0xb0
  [<c2370d08>] pci_scan_slot+0x48/0x100
  [<c2371904>] pci_scan_child_bus+0x24/0xc0
  [<c262a7b0>] pci_acpi_scan_root+0x2c0/0x490
  [<c23b7203>] acpi_pci_root_add+0x312/0x42f
  [<c23b29d7>] ? acpi_device_notify_fixed+0x1d/0x1d
  [<c23b36a8>] acpi_bus_device_attach+0x77/0xdd
  [<c23cb6be>] acpi_ns_walk_namespace+0xb1/0x163
  [<c23b3631>] ? acpi_bus_type_and_status+0x82/0x82
  [<c23cbd4e>] acpi_walk_namespace+0x7e/0xa8
  [<c23b3631>] ? acpi_bus_type_and_status+0x82/0x82
  [<c23b46e0>] acpi_bus_scan+0x9a/0xa6
  [<c23b3631>] ? acpi_bus_type_and_status+0x82/0x82
  [<c2b17ec9>] acpi_scan_init+0x51/0x144
  [<c2b252a2>] ? pci_mmcfg_late_init+0x49/0x4b
  [<c2b17cdc>] acpi_init+0x224/0x28c
  [<c2001144>] do_one_initcall+0x34/0x170
  [<c2b17ab8>] ? acpi_sleep_proc_init+0x2e/0x2e
  [<c2aeeb83>] kernel_init_freeable+0x119/0x1b6
  [<c2aee4da>] ? do_early_param+0x74/0x74
  [<c2743f10>] kernel_init+0x10/0xd0
  [<c2765697>] ret_from_kernel_thread+0x1b/0x28
  [<c2743f00>] ? rest_init+0x60/0x60

The most reliable way to trigger this crash seems to be booting a 32-bit
kernel via the EFI boot stub.

The solution is to use early_ioremap() instead of phys_to_virt() to map
the setup data into the kernel address space.

Tested-by: Jani Nikula <jani.nikula@intel.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Seth Forshee <seth.forshee@canonical.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/pci/common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 305c68b..7ae6671 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -628,7 +628,7 @@ int pcibios_add_device(struct pci_dev *dev)
 
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
-		data = phys_to_virt(pa_data);
+		data = early_ioremap(pa_data, sizeof(*rom));
 
 		if (data->type == SETUP_PCI) {
 			rom = (struct pci_setup_rom *)data;
@@ -645,6 +645,7 @@ int pcibios_add_device(struct pci_dev *dev)
 			}
 		}
 		pa_data = data->next;
+		early_iounmap(data, sizeof(*rom));
 	}
 	return 0;
 }
-- 
1.8.1.4

