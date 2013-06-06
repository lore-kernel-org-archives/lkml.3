Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab3FFFGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 01:06:36 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:34640 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab3FFFGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 01:06:34 -0400
Subject: Re: [PATCH] Modify UEFI anti-bricking code
From: joeyli <jlee@suse.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
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
In-Reply-To: <20130605155904.GC30420@console-pimps.org>
References: <1370117180-1712-1-git-send-email-matthew.garrett@nebula.com>
	 <1370276021.30695.4.camel@linux-s257.site>
	 <1370277079.6315.14.camel@x230.lan>
	 <1370316933.30695.7.camel@linux-s257.site>
	 <CAL01qptzxe5L6Vq+nBZLq+bQNxbe_i_2OdKMNJGZQDfMihaHOw@mail.gmail.com>
	 <1370444007.6315.32.camel@x230.lan>
	 <20130605155904.GC30420@console-pimps.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Jun 2013 13:05:10 +0800
Message-ID: <1370495110.6523.35.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 三，2013-06-05 於 16:59 +0100，Matt Fleming 提到：
> On Wed, 05 Jun, at 02:53:27PM, Matthew Garrett wrote:
> > On Wed, 2013-06-05 at 15:49 +0100, Fleming, Matt wrote:
> > 
> > > Folks, what do you want me to do with this? Merge it with Matthew's patch?
> > 
> > Do that and add Joey's signed-off-by?
> 
> Right, this is what I've got queued up.
> 
> ---
> 
> >From 380dcc12ba82f4e10feb6a72207b2e4771d16d8d Mon Sep 17 00:00:00 2001
> From: Matthew Garrett <matthew.garrett@nebula.com>
> Date: Sat, 1 Jun 2013 16:06:20 -0400
> Subject: [PATCH] Modify UEFI anti-bricking code
> 
> This patch reworks the UEFI anti-bricking code, including an effective
> reversion of cc5a080c and 31ff2f20. It turns out that calling
> QueryVariableInfo() from boot services results in some firmware
> implementations jumping to physical addresses even after entering virtual
> mode, so until we have 1:1 mappings for UEFI runtime space this isn't
> going to work so well.
[...]

The follow diff change is base on 380dcc12 patch queued in efi git tree,
it included Matthew and hpa's suggestions. I fix the attributes of DUMMY
object to NV/BS/RT and introduced a #define of the minimum reserve flash
space.

This change works to me on OVMF.



Thanks a lot!
Joey Lee

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index cc3cfe8..2617675 100644
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
@@ -1051,7 +1057,12 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 	 * write if permitting it would reduce the available space to under
 	 * 5KB. This figure was provided by Samsung, so should be safe.
 	 */
-	if ((remaining_size - size < 5120) && !efi_no_storage_paranoia) {
+	if ((remaining_size - size < EFI_MIN_RESERVE) &&
+		!efi_no_storage_paranoia) {
+
+		if (!(attributes & EFI_VARIABLE_NON_VOLATILE))
+			return EFI_OUT_OF_RESOURCES;
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
@@ -1085,7 +1099,7 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 		/*
 		 * There still isn't enough room, so return an error
 		 */
-		if (remaining_size - size < 5120)
+		if (remaining_size - size < EFI_MIN_RESERVE)
 			return EFI_OUT_OF_RESOURCES;
 	}
 







