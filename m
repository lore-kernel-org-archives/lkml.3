Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbaDXJhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:37:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300AbaDXJhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 05:37:10 -0400
Date: Thu, 24 Apr 2014 17:36:58 +0800
From: Dave Young <dyoung@redhat.com>
To: matt.fleming@intel.com, hpa@zytor.com, akpm@linux-foundation.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ignore ,keep for efi earlyprintk
Message-ID: <20140424093658.GA7158@dhcp-16-198.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

earlyprint=efi,keep results a kernel hang after "Freeing unused kernel memory"

Actually efi earlyprintk is using __init functions such as early_ioremap etc.
Thus efi earlyconsole can not be kept.

So just ignore it and give out a warning to user.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 arch/x86/kernel/early_printk.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/early_printk.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/early_printk.c
+++ linux-2.6/arch/x86/kernel/early_printk.c
@@ -237,8 +237,11 @@ static int __init setup_early_printk(cha
 		}
 #endif
 #ifdef CONFIG_EARLY_PRINTK_EFI
-		if (!strncmp(buf, "efi", 3))
-			early_console_register(&early_efi_console, keep);
+		if (!strncmp(buf, "efi", 3)) {
+			if (keep)
+				pr_warn("Ignoring ,keep for earlyprintk=efi\n");
+			early_console_register(&early_efi_console, 0);
+		}
 #endif
 
 		buf++;
