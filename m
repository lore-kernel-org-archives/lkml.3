Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbaEWQsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 12:48:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47378 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbaEWQsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 12:48:30 -0400
Date: Fri, 23 May 2014 18:48:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@suse.de,
        m.chehab@samsung.com, linux-edac@vger.kernel.org, x86@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org
Subject: Re: [PATCH 4/7] acpi, apei, ghes: Factor out NMI error notification
 context.
Message-ID: <20140523164824.GG21332@pd.tnic>
References: <1397056476-9183-1-git-send-email-tomasz.nowicki@linaro.org>
 <1397056476-9183-5-git-send-email-tomasz.nowicki@linaro.org>
 <20140513194125.GD8760@pd.tnic>
 <537F39D7.6090309@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <537F39D7.6090309@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 02:06:47PM +0200, Tomasz Nowicki wrote:
> I had that thoughts too. Looking at simple MCE calls, yes, it does
> make sense to create corresponding arch-specific version and provide
> logic as needed. I think that NMI is much more complicated....

How about this ontop of your patches. It builds here but it is not
trivial for me to try it on !X86. Maybe you can test it quicker than me
finding some other arch box first... :)

Thanks.

---
Index: b/arch/x86/include/asm/nmi.h
===================================================================
--- a/arch/x86/include/asm/nmi.h	2014-05-23 17:17:08.192266007 +0200
+++ b/arch/x86/include/asm/nmi.h	2014-05-23 18:45:06.636178772 +0200
@@ -57,7 +57,7 @@ struct nmiaction {
 
 int __register_nmi_handler(unsigned int, struct nmiaction *);
 
-void unregister_nmi_handler(unsigned int, const char *);
+void unregister_nmi_handler(unsigned int type, const char *name);
 
 void stop_nmi(void);
 void restart_nmi(void);
Index: b/drivers/acpi/apei/ghes.c
===================================================================
--- a/drivers/acpi/apei/ghes.c	2014-05-23 17:17:27.680265685 +0200
+++ b/drivers/acpi/apei/ghes.c	2014-05-23 17:46:32.968236841 +0200
@@ -47,15 +47,13 @@
 #include <linux/genalloc.h>
 #include <linux/pci.h>
 #include <linux/aer.h>
+#include <linux/nmi.h>
 
 #include <acpi/ghes.h>
 #ifdef CONFIG_X86_MCE
 #include <asm/mce.h>
 #endif
 #include <asm/tlbflush.h>
-#ifdef CONFIG_ACPI_APEI_NMI
-#include <asm/nmi.h>
-#endif
 
 #include "apei-internal.h"
 
Index: b/include/linux/nmi.h
===================================================================
--- a/include/linux/nmi.h	2014-05-23 17:42:55.928240428 +0200
+++ b/include/linux/nmi.h	2014-05-23 18:44:41.244179192 +0200
@@ -53,4 +53,11 @@ extern int proc_dowatchdog(struct ctl_ta
 			   void __user *, size_t *, loff_t *);
 #endif
 
+#ifdef CONFIG_ACPI_APEI_NMI
+#include <asm/nmi.h>
+#else
+#define register_nmi_handler(t, fn, fg, n, init...) do { } while(0)
+void unregister_nmi_handler(unsigned int type, const char *name) {}
+#endif /* CONFIG_ACPI_APEI_NMI */
+
 #endif

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
