Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab3FDDg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 23:36:26 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:46575 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab3FDDgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 23:36:25 -0400
Subject: Re: [PATCH] Modify UEFI anti-bricking code
From: joeyli <jlee@suse.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "rja@sgi.com" <rja@sgi.com>, "mingo@kernel.org" <mingo@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "bp@alien8.de" <bp@alien8.de>, "jkosina@suse.cz" <jkosina@suse.cz>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "oneukum@suse.de" <oneukum@suse.de>
In-Reply-To: <1370277079.6315.14.camel@x230.lan>
References: <1370117180-1712-1-git-send-email-matthew.garrett@nebula.com>
	 <1370276021.30695.4.camel@linux-s257.site>
	 <1370277079.6315.14.camel@x230.lan>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Jun 2013 11:35:33 +0800
Message-ID: <1370316933.30695.7.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 一，2013-06-03 於 16:31 +0000，Matthew Garrett 提到：
> On Tue, 2013-06-04 at 00:13 +0800, joeyli wrote:
> 
> > Oliver raised a question for if power fails between that succesful
> > attempt and the deletion?
> 
> It's a pretty tiny window, but sure. Making sure we delete it seems
> sensible. In that case we should make the GUID a #define rather than
> write it out twice.
> 

Base on your patch, the following diff moved DUMMY GUID to #define, and
add a static efi name string:


Thanks a lot!
Joey Lee


diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 63e167a..cc3cfe8 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -53,6 +53,11 @@
 
 #define EFI_DEBUG	1
 
+#define EFI_DUMMY_GUID \
+	EFI_GUID(0x4424ac57, 0xbe4b, 0x47dd, 0x9e, 0x97, 0xed, 0x50, 0xf0, 0x9f, 0x92, 0xa9)
+
+static efi_char16_t efi_dummy_name[6] = { 'D', 'U', 'M', 'M', 'Y', 0 };
+
 struct efi __read_mostly efi = {
 	.mps        = EFI_INVALID_TABLE_ADDR,
 	.acpi       = EFI_INVALID_TABLE_ADDR,
@@ -981,6 +986,9 @@ void __init efi_enter_virtual_mode(void)
 		runtime_code_page_mkexec();
 
 	kfree(new_memmap);
+
+	/* clean DUMMY object */
+	efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID, 0, 0, NULL);
 }
 
 /*
@@ -1051,21 +1059,17 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 		 */
 		unsigned long dummy_size = remaining_size + 1024;
 		void *dummy = kmalloc(dummy_size, GFP_ATOMIC);
-		efi_char16_t efi_name[6] = { 'D', 'U', 'M', 'M', 'Y', 0 };
-		efi_guid_t guid = EFI_GUID(0x4424ac57, 0xbe4b, 0x47dd, 0x9e,
-					   0x97, 0xed, 0x50, 0xf0, 0x9f, 0x92,
-					   0xa9);
 
-		status = efi.set_variable(efi_name, &guid, attributes,
-					  dummy_size, dummy);
+		status = efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
+					  attributes, dummy_size, dummy);
 
 		if (status == EFI_SUCCESS) {
 			/*
 			 * This should have failed, so if it didn't make sure
 			 * that we delete it...
 			 */
-			efi.set_variable(efi_name, &guid, attributes, 0,
-					 dummy);
+			efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
+					 attributes, 0, dummy);
 		}
 
 		/*

