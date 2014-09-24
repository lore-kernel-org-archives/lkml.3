Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbaIXLmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:42:42 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:52237 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaIXLmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:42:40 -0400
Date: Wed, 24 Sep 2014 12:42:36 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Roy Franz <roy.franz@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Boyer <jwboyer@redhat.com>
Subject: Re: [GIT PULL] x86 fixes
Message-ID: <20140924114236.GM18635@console-pimps.org>
References: <CA+55aFxW9PmtjOf9nUQwpU8swsFqJOz8whZXcONo+XFmkSwezg@mail.gmail.com>
 <20140923053510.GB27825@gmail.com>
 <20140923053711.GA28704@gmail.com>
 <20140923055802.GA29052@gmail.com>
 <1411456851.21380.355.camel@mfleming-mobl1.ger.corp.intel.com>
 <CAKv+Gu_xqnkVKuoWY=PRoAVYE_qOH8dwM+ZxG+ysC7Xvs82ZNw@mail.gmail.com>
 <20140923131805.GH18635@console-pimps.org>
 <542182E0.6090101@canonical.com>
 <20140923143712.GI18635@console-pimps.org>
 <20140924072633.GA1768@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140924072633.GA1768@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep, at 09:26:33AM, Ingo Molnar wrote:
> 
> So 'status' is unused - either use it for a less threatening 
> message, or remove the return code from the function and document 
> that failure is an option?

I think removing the return code is the way to go (I have a patch queued
for v3.18 that adds call-site error messages).

Something like this?

---

>From 737ed0ea66f79fe1e5343f9f4cbdf7c0f57e1a0f Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt.fleming@intel.com>
Date: Thu, 11 Sep 2014 09:04:25 +0100
Subject: [PATCH] x86/efi: Delete misleading efi_printk() error message
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A number of people are reporting seeing the "setup_efi_pci() failed!"
error message in what used to be a quiet boot,

  https://bugzilla.kernel.org/show_bug.cgi?id=81891

The message isn't all that helpful because setup_efi_pci() can return a
non-success error code for a variety of reasons, not all of them fatal.

Let's drop the return code from setup_efi_pci*() altogether, since
there's no way to process it in any meaningful way outside of the inner
__setup_efi_pci*() functions.

Reported-by: Darren Hart <dvhart@linux.intel.com>
Reported-by: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Ulf Winkelvos <ulf@winkelvos.de>
Cc: Andre Müller <andre.muller@web.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/compressed/eboot.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 8c311ab1b8c8..41ded80b3424 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -365,7 +365,7 @@ free_struct:
 	return status;
 }
 
-static efi_status_t
+static void
 setup_efi_pci32(struct boot_params *params, void **pci_handle,
 		unsigned long size)
 {
@@ -408,8 +408,6 @@ setup_efi_pci32(struct boot_params *params, void **pci_handle,
 		data = (struct setup_data *)rom;
 
 	}
-
-	return status;
 }
 
 static efi_status_t
@@ -468,7 +466,7 @@ free_struct:
 
 }
 
-static efi_status_t
+static void
 setup_efi_pci64(struct boot_params *params, void **pci_handle,
 		unsigned long size)
 {
@@ -511,11 +509,18 @@ setup_efi_pci64(struct boot_params *params, void **pci_handle,
 		data = (struct setup_data *)rom;
 
 	}
-
-	return status;
 }
 
-static efi_status_t setup_efi_pci(struct boot_params *params)
+/*
+ * There's no way to return an informative status from this function,
+ * because any analysis (and printing of error messages) needs to be
+ * done directly at the EFI function call-site.
+ *
+ * For example, EFI_INVALID_PARAMETER could indicate a bug or maybe we
+ * just didn't find any PCI devices, but there's no way to tell outside
+ * the context of the call.
+ */
+static void setup_efi_pci(struct boot_params *params)
 {
 	efi_status_t status;
 	void **pci_handle = NULL;
@@ -532,7 +537,7 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 					size, (void **)&pci_handle);
 
 		if (status != EFI_SUCCESS)
-			return status;
+			return;
 
 		status = efi_call_early(locate_handle,
 					EFI_LOCATE_BY_PROTOCOL, &pci_proto,
@@ -543,13 +548,12 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 		goto free_handle;
 
 	if (efi_early->is64)
-		status = setup_efi_pci64(params, pci_handle, size);
+		setup_efi_pci64(params, pci_handle, size);
 	else
-		status = setup_efi_pci32(params, pci_handle, size);
+		setup_efi_pci32(params, pci_handle, size);
 
 free_handle:
 	efi_call_early(free_pool, pci_handle);
-	return status;
 }
 
 static void
@@ -1385,10 +1389,7 @@ struct boot_params *efi_main(struct efi_config *c,
 
 	setup_graphics(boot_params);
 
-	status = setup_efi_pci(boot_params);
-	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table, "setup_efi_pci() failed!\n");
-	}
+	setup_efi_pci(boot_params);
 
 	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
 				sizeof(*gdt), (void **)&gdt);
-- 
1.9.3

-- 
Matt Fleming, Intel Open Source Technology Center
