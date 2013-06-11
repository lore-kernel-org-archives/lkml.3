Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269Ab3FKUWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:22:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41820 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527Ab3FKUDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@intel.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Seth Forshee <seth.forshee@canonical.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [ 09/79] x86/PCI: Map PCI setup data with ioremap() so it can be in highmem
Date: Tue, 11 Jun 2013 13:02:35 -0700
Message-Id: <20130611195313.629553357@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Fleming <matt.fleming@intel.com>

commit 65694c5aaddfedd9da082e4e150cafc6b3fc8a6a upstream.

f9a37be0f0 ("x86: Use PCI setup data") added support for using PCI ROM
images from setup_data.  This used phys_to_virt(), which is not valid for
highmem addresses, and can cause a crash when booting a 32-bit kernel via
the EFI boot stub.

pcibios_add_device() assumes that the physical addresses stored in
setup_data are accessible via the direct kernel mapping, and that calling
phys_to_virt() is valid.  This isn't guaranteed to be true on x86 where the
direct mapping range is much smaller than on x86-64.

Calling phys_to_virt() on a highmem address results in the following:

 BUG: unable to handle kernel paging request at 39a3c198
 IP: [<c262be0f>] pcibios_add_device+0x2f/0x90
 ...
 Call Trace:
  [<c2370c73>] pci_device_add+0xe3/0x130
  [<c274640b>] pci_scan_single_device+0x8b/0xb0
  [<c2370d08>] pci_scan_slot+0x48/0x100
  [<c2371904>] pci_scan_child_bus+0x24/0xc0
  [<c262a7b0>] pci_acpi_scan_root+0x2c0/0x490
  [<c23b7203>] acpi_pci_root_add+0x312/0x42f
  ...

The solution is to use ioremap() instead of phys_to_virt() to map the
setup data into the kernel address space.

[bhelgaas: changelog]
Tested-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Seth Forshee <seth.forshee@canonical.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/pci/common.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -617,7 +617,9 @@ int pcibios_add_device(struct pci_dev *d
 
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
-		data = phys_to_virt(pa_data);
+		data = ioremap(pa_data, sizeof(*rom));
+		if (!data)
+			return -ENOMEM;
 
 		if (data->type == SETUP_PCI) {
 			rom = (struct pci_setup_rom *)data;
@@ -634,6 +636,7 @@ int pcibios_add_device(struct pci_dev *d
 			}
 		}
 		pa_data = data->next;
+		iounmap(data);
 	}
 	return 0;
 }


