Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab3KCMRF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 07:17:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384Ab3KCMRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 07:17:03 -0500
Date: Sun, 3 Nov 2013 20:16:47 +0800
From: Dave Young <dyoung@redhat.com>
To: matt.fleming@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] efi earlyprintk fix
Message-ID: <20131103121647.GA4770@dhcp-16-126.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


there's below one line shift problem:

                     ACPI=0xdabfe000  ACPI 2.0=0xdabfe014  SMBIOS=0xdaa9e000
[    0.000000] efi:  

In fact check efi_y and the lfb_height should be compared at the begin of the
loop of early_efi_write

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 arch/x86/platform/efi/early_printk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/arch/x86/platform/efi/early_printk.c
+++ linux-2.6/arch/x86/platform/efi/early_printk.c
@@ -106,6 +106,15 @@ early_efi_write(struct console *con, con
 		if (count > linemax)
 			count = linemax;
 
+		if (efi_y + font->height >= si->lfb_height) {
+			u32 i;
+
+			efi_y -= font->height;
+			early_efi_scroll_up();
+
+			for (i = 0; i < font->height; i++)
+				early_efi_clear_scanline(efi_y + i);
+		}
 		for (h = 0; h < font->height; h++) {
 			unsigned int n, x;
 
@@ -142,15 +151,6 @@ early_efi_write(struct console *con, con
 			efi_y += font->height;
 		}
 
-		if (efi_y + font->height >= si->lfb_height) {
-			u32 i;
-
-			efi_y -= font->height;
-			early_efi_scroll_up();
-
-			for (i = 0; i < font->height; i++)
-				early_efi_clear_scanline(efi_y + i);
-		}
 	}
 }
 
