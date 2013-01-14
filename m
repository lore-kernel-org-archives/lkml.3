Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab3ANI7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 03:59:37 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:43461 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756525Ab3ANI7g convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Mon, 14 Jan 2013 03:59:36 -0500
Message-Id: <50F3D70402000078000B530E@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Mon, 14 Jan 2013 08:59:32 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mjg@redhat.com>
Cc: "Bjorn Helgaas" <bjorn.helgaas@google.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix setup_efi_pci()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes three issues:
- missing parentheses around a flag test
- wrong memory type used for allocation intended to persist post-boot
- four similar build warnings on 32-bit (casts between different size
  pointers and integers)

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/boot/compressed/eboot.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- 3.8-rc3/arch/x86/boot/compressed/eboot.c
+++ 3.8-rc3-x86-EFI-PCI-ROMs/arch/x86/boot/compressed/eboot.c
@@ -256,10 +256,10 @@ static efi_status_t setup_efi_pci(struct
 	int i;
 	struct setup_data *data;
 
-	data = (struct setup_data *)params->hdr.setup_data;
+	data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
 
 	while (data && data->next)
-		data = (struct setup_data *)data->next;
+		data = (struct setup_data *)(unsigned long)data->next;
 
 	status = efi_call_phys5(sys_table->boottime->locate_handle,
 				EFI_LOCATE_BY_PROTOCOL, &pci_proto,
@@ -302,7 +302,7 @@ static efi_status_t setup_efi_pci(struct
 		if (status != EFI_SUCCESS)
 			continue;
 
-		if (!attributes & EFI_PCI_IO_ATTRIBUTE_EMBEDDED_ROM)
+		if (!(attributes & EFI_PCI_IO_ATTRIBUTE_EMBEDDED_ROM))
 			continue;
 
 		if (!pci->romimage || !pci->romsize)
@@ -311,7 +311,7 @@ static efi_status_t setup_efi_pci(struct
 		size = pci->romsize + sizeof(*rom);
 
 		status = efi_call_phys3(sys_table->boottime->allocate_pool,
-				EFI_LOADER_DATA, size, &rom);
+					EFI_RUNTIME_SERVICES_DATA, size, &rom);
 
 		if (status != EFI_SUCCESS)
 			continue;
@@ -345,9 +345,9 @@ static efi_status_t setup_efi_pci(struct
 		memcpy(rom->romdata, pci->romimage, pci->romsize);
 
 		if (data)
-			data->next = (uint64_t)rom;
+			data->next = (unsigned long)rom;
 		else
-			params->hdr.setup_data = (uint64_t)rom;
+			params->hdr.setup_data = (unsigned long)rom;
 
 		data = (struct setup_data *)rom;
 



