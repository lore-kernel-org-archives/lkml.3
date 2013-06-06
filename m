Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab3FFHlw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 03:41:52 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:39115 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab3FFHlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 03:41:50 -0400
Subject: Re: [PATCH] Modify UEFI anti-bricking code
From: joeyli <jlee@suse.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Matt Fleming <matt@console-pimps.org>,
        "Fleming, Matt" <matt.fleming@intel.com>, "rja@sgi.com" <rja@sgi.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "bp@alien8.de" <bp@alien8.de>, "jkosina@suse.cz" <jkosina@suse.cz>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "oneukum@suse.de" <oneukum@suse.de>
In-Reply-To: <1370497321.6315.44.camel@x230.lan>
References: <1370117180-1712-1-git-send-email-matthew.garrett@nebula.com>
	 <1370276021.30695.4.camel@linux-s257.site>
	 <1370277079.6315.14.camel@x230.lan>
	 <1370316933.30695.7.camel@linux-s257.site>
	 <CAL01qptzxe5L6Vq+nBZLq+bQNxbe_i_2OdKMNJGZQDfMihaHOw@mail.gmail.com>
	 <1370444007.6315.32.camel@x230.lan>
	 <20130605155904.GC30420@console-pimps.org>
	 <1370495110.6523.35.camel@linux-s257.site>
	 <1370497321.6315.44.camel@x230.lan>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Jun 2013 15:40:26 +0800
Message-ID: <1370504426.6523.49.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 四，2013-06-06 於 05:42 +0000，Matthew Garrett 提到：
> On Thu, 2013-06-06 at 13:05 +0800, joeyli wrote:
> 
> > +		if (!(attributes & EFI_VARIABLE_NON_VOLATILE))
> > +			return EFI_OUT_OF_RESOURCES;
> 
> I'd move this up to the top of the function, and just return 0 - there's
> no risk of the firmware causing problems if it's a volatile variable, so
> we should probably just pass it down to the firmware and return an error
> from there.
> 

OK, I moved volatile checking to the top of the function.
New version, version 3 diff result like the following.


Thanks a lot for reviewing
Joey Lee

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index cc3cfe8..5ae2eb0 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -53,6 +53,8 @@
 
 #define EFI_DEBUG	1
 
+#define EFI_MIN_RESERVE 5120
+
 #define EFI_DUMMY_GUID \
 	EFI_GUID(0x4424ac57, 0xbe4b, 0x47dd, 0x9e, 0x97, 0xed, 0x50, 0xf0, 0x9f, 0x92, 0xa9)
 
@@ -988,7 +990,11 @@ void __init efi_enter_virtual_mode(void)
 	kfree(new_memmap);
 
 	/* clean DUMMY object */
-	efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID, 0, 0, NULL);
+	efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
+			 EFI_VARIABLE_NON_VOLATILE |
+			 EFI_VARIABLE_BOOTSERVICE_ACCESS |
+			 EFI_VARIABLE_RUNTIME_ACCESS,
+			 0, NULL);
 }
 
 /*
@@ -1040,6 +1046,9 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 	efi_status_t status;
 	u64 storage_size, remaining_size, max_size;
 
+	if (!(attributes & EFI_VARIABLE_NON_VOLATILE))
+		return 0;
+
 	status = efi.query_variable_info(attributes, &storage_size,
 					 &remaining_size, &max_size);
 	if (status != EFI_SUCCESS)
@@ -1051,7 +1060,9 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 	 * write if permitting it would reduce the available space to under
 	 * 5KB. This figure was provided by Samsung, so should be safe.
 	 */
-	if ((remaining_size - size < 5120) && !efi_no_storage_paranoia) {
+	if ((remaining_size - size < EFI_MIN_RESERVE) &&
+		!efi_no_storage_paranoia) {
+
 		/*
 		 * Triggering garbage collection may require that the firmware
 		 * generate a real EFI_OUT_OF_RESOURCES error. We can force
@@ -1061,7 +1072,10 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 		void *dummy = kmalloc(dummy_size, GFP_ATOMIC);
 
 		status = efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
-					  attributes, dummy_size, dummy);
+					  EFI_VARIABLE_NON_VOLATILE |
+					  EFI_VARIABLE_BOOTSERVICE_ACCESS |
+					  EFI_VARIABLE_RUNTIME_ACCESS,
+					  dummy_size, dummy);
 
 		if (status == EFI_SUCCESS) {
 			/*
@@ -1069,7 +1083,10 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 			 * that we delete it...
 			 */
 			efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
-					 attributes, 0, dummy);
+					 EFI_VARIABLE_NON_VOLATILE |
+					 EFI_VARIABLE_BOOTSERVICE_ACCESS |
+					 EFI_VARIABLE_RUNTIME_ACCESS,
+					 0, dummy);
 		}
 
 		/*
@@ -1085,7 +1102,7 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 		/*
 		 * There still isn't enough room, so return an error
 		 */
-		if (remaining_size - size < 5120)
+		if (remaining_size - size < EFI_MIN_RESERVE)
 			return EFI_OUT_OF_RESOURCES;
 	}
 


