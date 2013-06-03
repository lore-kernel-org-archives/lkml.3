Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411Ab3FCQPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 12:15:16 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:52250 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759038Ab3FCQO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 12:14:27 -0400
Subject: Re: [PATCH] Modify UEFI anti-bricking code
From: joeyli <jlee@suse.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: rja@sgi.com, mingo@kernel.org, torvalds@linux-foundation.org, bp@alien8.de,
        jkosina@suse.cz, matt.fleming@intel.com, linux-efi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        hpa@linux.intel.com, akpm@linux-foundation.org, oneukum@suse.de
In-Reply-To: <1370117180-1712-1-git-send-email-matthew.garrett@nebula.com>
References: <1370117180-1712-1-git-send-email-matthew.garrett@nebula.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Jun 2013 00:13:40 +0800
Message-ID: <1370276021.30695.4.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 六，2013-06-01 於 16:06 -0400，Matthew Garrett 提到：
> +               unsigned long dummy_size = remaining_size + 1024;
> +               void *dummy = kmalloc(dummy_size, GFP_ATOMIC);
> +               efi_char16_t efi_name[6] = { 'D', 'U', 'M', 'M', 'Y', 0 };
> +               efi_guid_t guid = EFI_GUID(0x4424ac57, 0xbe4b, 0x47dd, 0x9e,
> +                                          0x97, 0xed, 0x50, 0xf0, 0x9f, 0x92,
> +                                          0xa9);
> +
> +               status = efi.set_variable(efi_name, &guid, attributes,
> +                                         dummy_size, dummy);
> +
> +               if (status == EFI_SUCCESS) {
> +                       /*
> +                        * This should have failed, so if it didn't make sure
> +                        * that we delete it...
> +                        */
> +                       efi.set_variable(efi_name, &guid, attributes, 0,
> +                                        dummy);
> +               } 

Oliver raised a question for if power fails between that succesful
attempt and the deletion?

Due to the create/delete operating are not atomic, I think that will be
better we try to delete DUMMY object in efi_enter_virtual_mode() or when
efivars initial.

The following diff tested on OVMF for delete DUMMY object when system
boot, for reference.


Thanks a lot!
Joey Lee


diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 63e167a..72770b0 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -861,6 +861,10 @@ void __init efi_enter_virtual_mode(void)
 	u64 end, systab, start_pfn, end_pfn;
 	void *p, *va, *new_memmap = NULL;
 	int count = 0;
+	efi_char16_t efi_name[6] = { 'D', 'U', 'M', 'M', 'Y', 0 };
+	efi_guid_t guid = EFI_GUID(0x4424ac57, 0xbe4b, 0x47dd, 0x9e,
+				   0x97, 0xed, 0x50, 0xf0, 0x9f, 0x92,
+				   0xa9);
 
 	efi.systab = NULL;
 
@@ -981,6 +985,9 @@ void __init efi_enter_virtual_mode(void)
 		runtime_code_page_mkexec();
 
 	kfree(new_memmap);
+
+	/* clean DUMMY object */
+	efi.set_variable(efi_name, &guid, 0, 0, NULL);
 }
 
 /*


