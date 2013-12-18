Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab3LRVMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:12:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab3LRVL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:11:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chang Liu <cl91tp@gmail.com>, Khalid Aziz <khalid.aziz@oracle.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: [PATCH 3.10 23/78] PCI: Disable Bus Master only on kexec reboot
Date: Wed, 18 Dec 2013 13:10:51 -0800
Message-Id: <20131218211112.556556545@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211111.903835960@linuxfoundation.org>
References: <20131218211111.903835960@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/pci-driver.c |   12 +++++++++---
 include/linux/kexec.h    |    3 +++
 kernel/kexec.c           |    4 ++++
 3 files changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -19,6 +19,7 @@
 #include <linux/cpu.h>
 #include <linux/pm_runtime.h>
 #include <linux/suspend.h>
+#include <linux/kexec.h>
 #include "pci.h"
 
 struct pci_dynid {
@@ -388,12 +389,17 @@ static void pci_device_shutdown(struct d
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
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -198,6 +198,9 @@ extern u32 vmcoreinfo_note[VMCOREINFO_NO
 extern size_t vmcoreinfo_size;
 extern size_t vmcoreinfo_max_size;
 
+/* flag to track if kexec reboot is in progress */
+extern bool kexec_in_progress;
+
 int __init parse_crashkernel(char *cmdline, unsigned long long system_ram,
 		unsigned long long *crash_size, unsigned long long *crash_base);
 int parse_crashkernel_high(char *cmdline, unsigned long long system_ram,
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -47,6 +47,9 @@ u32 vmcoreinfo_note[VMCOREINFO_NOTE_SIZE
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


