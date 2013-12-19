Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab3LSMPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:15:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45207 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab3LSL7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:59:10 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Khalid Aziz <khalid.aziz@oracle.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 161/208] PCI: Disable Bus Master only on kexec reboot
Date: Thu, 19 Dec 2013 11:54:19 +0000
Message-Id: <1387454106-19326-162-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Khalid Aziz <khalid.aziz@oracle.com>

commit 4fc9bbf98fd66f879e628d8537ba7c240be2b58e upstream.

Add a flag to tell the PCI subsystem that kernel is shutting down in
preparation to kexec a kernel.  Add code in PCI subsystem to use this flag
to clear Bus Master bit on PCI devices only in case of kexec reboot.

This fixes a power-off problem on Acer Aspire V5-573G and likely other
machines and avoids any other issues caused by clearing Bus Master bit on
PCI devices in normal shutdown path.  The problem was introduced by
b566a22c2332 ("PCI: disable Bus Master on PCI device shutdown").

This patch is based on discussion at
http://marc.info/?l=linux-pci&m=138425645204355&w=2

Link: https://bugzilla.kernel.org/show_bug.cgi?id=63861
Reported-by: Chang Liu <cl91tp@gmail.com>
Signed-off-by: Khalid Aziz <khalid.aziz@oracle.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/pci/pci-driver.c | 12 +++++++++---
 include/linux/kexec.h    |  3 +++
 kernel/kexec.c           |  4 ++++
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index e6515e2..6f9b44b 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -19,6 +19,7 @@
 #include <linux/cpu.h>
 #include <linux/pm_runtime.h>
 #include <linux/suspend.h>
+#include <linux/kexec.h>
 #include "pci.h"
 
 struct pci_dynid {
@@ -388,12 +389,17 @@ static void pci_device_shutdown(struct device *dev)
 	pci_msi_shutdown(pci_dev);
 	pci_msix_shutdown(pci_dev);
 
+#ifdef CONFIG_KEXEC
 	/*
-	 * Turn off Bus Master bit on the device to tell it to not
-	 * continue to do DMA. Don't touch devices in D3cold or unknown states.
+	 * If this is a kexec reboot, turn off Bus Master bit on the
+	 * device to tell it to not continue to do DMA. Don't touch
+	 * devices in D3cold or unknown states.
+	 * If it is not a kexec reboot, firmware will hit the PCI
+	 * devices with big hammer and stop their DMA any way.
 	 */
-	if (pci_dev->current_state <= PCI_D3hot)
+	if (kexec_in_progress && (pci_dev->current_state <= PCI_D3hot))
 		pci_clear_master(pci_dev);
+#endif
 }
 
 #ifdef CONFIG_PM
diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index d78d28a..5fd33dc 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -198,6 +198,9 @@ extern u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
 extern size_t vmcoreinfo_size;
 extern size_t vmcoreinfo_max_size;
 
+/* flag to track if kexec reboot is in progress */
+extern bool kexec_in_progress;
+
 int __init parse_crashkernel(char *cmdline, unsigned long long system_ram,
 		unsigned long long *crash_size, unsigned long long *crash_base);
 int parse_crashkernel_high(char *cmdline, unsigned long long system_ram,
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 59f7b55..1f8d938 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -47,6 +47,9 @@ u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE/4];
 size_t vmcoreinfo_size;
 size_t vmcoreinfo_max_size = sizeof(vmcoreinfo_data);
 
+/* Flag to indicate we are going to kexec a new kernel */
+bool kexec_in_progress = false;
+
 /* Location of the reserved area for the crash kernel */
 struct resource crashk_res = {
 	.name  = "Crash kernel",
@@ -1678,6 +1681,7 @@ int kernel_kexec(void)
 	} else
 #endif
 	{
+		kexec_in_progress = true;
 		kernel_restart_prepare(NULL);
 		printk(KERN_EMERG "Starting new kernel\n");
 		machine_shutdown();
-- 
1.8.3.2

