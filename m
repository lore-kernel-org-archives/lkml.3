Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab3JCL0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 07:26:17 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:33832 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab3JCL0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 07:26:14 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        matt.fleming@intel.com, grant.likely@secretlab.ca,
        roy.franz@linaro.org, msalter@redhat.com,
        Leif Lindholm <leif.lindholm@linaro.org>, linux-doc@vger.kernel.org
Subject: [PATCH v2 1/3] Documentation: arm: add UEFI support documentation
Date: Thu,  3 Oct 2013 12:24:39 +0100
Message-Id: <1380799481-5470-2-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1380799481-5470-1-git-send-email-leif.lindholm@linaro.org>
References: <1380799481-5470-1-git-send-email-leif.lindholm@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides documentation of the [U]EFI runtime services and
configuration features.

Cc: linux-doc@vger.kernel.org
Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
Acked-by: Rob Landley <rob@landley.net>
---
 Documentation/arm/00-INDEX |    3 +++
 Documentation/arm/uefi.txt |   47 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)
 create mode 100644 Documentation/arm/uefi.txt

diff --git a/Documentation/arm/00-INDEX b/Documentation/arm/00-INDEX
index 4978456..87e01d1 100644
--- a/Documentation/arm/00-INDEX
+++ b/Documentation/arm/00-INDEX
@@ -36,3 +36,6 @@ nwfpe/
 	- NWFPE floating point emulator documentation
 swp_emulation
 	- SWP/SWPB emulation handler/logging description
+
+uefi.txt
+	- [U]EFI configuration and runtime services documentation
diff --git a/Documentation/arm/uefi.txt b/Documentation/arm/uefi.txt
new file mode 100644
index 0000000..e6e4d41
--- /dev/null
+++ b/Documentation/arm/uefi.txt
@@ -0,0 +1,47 @@
+UEFI, the Unified Extensible Firmware Interface is a speifcication
+governing the behaviours of compatible firmware interfaces. It is
+maintained by the UEFI Forum - http://www.uefi.org/.
+
+Since UEFI is an evolution of its predecessor 'EFI', the terms EFI and
+UEFI are used somewhat interchangeably in this document and associated
+source code.
+
+The implementation depends on receiving the UEFI runtime memory map and a
+pointer to the System Table in a Flattened Device Tree - so is only available
+with CONFIG_OF.
+
+It parses the FDT /chosen node for the following parameters:
+- 'linux,efi-system-table':
+  Physical address of the system table. (required)
+  64-bit value since an ARMv7 plattform may support LPAE, and to facilitate
+  code sharing with arm64. Top 32 bits will be ignored, since UEFI specification
+  mandates a 1:1 mapping of all RAM.
+- 'linux,efi-mmap':
+  The EFI memory map as an embedded property. (required)
+  An array of type EFI_MEMORY_DESCRIPTOR as described by the UEFI
+  specification, current version described in Linux by efi_memory_desc_t.
+  The memory map is represented in little-endian, not DT, byte order.
+  This map needs to contain at least the regions to be preserved for runtime
+  services, but would normally just be the map retreieved by calling UEFI
+  GetMemoryMap() immediately before ExitBootServices().
+- 'linux,efi-mmap-desc-size':
+  Size of each descriptor in the memory map. (override default)
+- 'linux,efi-mmap-desc-ver':
+  Memory descriptor format version. (override default)
+
+It also depends on early_memremap() to parse the UEFI configuration tables.
+
+For actually enabling [U]EFI support, enable:
+- CONFIG_EFI=y
+- CONFIG_EFI_VARS=y or m
+
+After the kernel has mapped the required regions into its address space,
+a SetVirtualAddressMap() call is made into UEFI in order to update
+relocations. This call must be performed with all the code in a 1:1
+mapping. This implementation achieves this by temporarily disabling the
+MMU for the duration of this call. This can only be done safely:
+- before secondary CPUs are brought online.
+- after early_initcalls have completed, since it uses setup_mm_for_reboot().
+
+For verbose debug messages, specify 'uefi_debug' on the kernel command
+line.
-- 
1.7.10.4

