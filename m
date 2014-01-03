Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbaACVpH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 16:45:07 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:37028 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752756AbaACVpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 16:45:05 -0500
Date: Fri, 3 Jan 2014 16:45:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] x86: Do not force removal of __user when calling
 copy_to/from_user_nocheck()
Message-ID: <20140103164500.5f6478f5@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit ff47ab4ff3cdd "x86: Add 1/2/4/8 byte optimization to 64bit
__copy_{from,to}_user_inatomic" added a "_nocheck" call in between
the copy_to/from_user() and copy_user_generic(). As both the
normal and nocheck versions of theses calls use the proper __user
annotation, a typecast to remove it should not be added.
This causes sparse to spin out the following warnings:

arch/x86/include/asm/uaccess_64.h:207:47: warning: incorrect type in argument 2 (different address spaces)
arch/x86/include/asm/uaccess_64.h:207:47:    expected void const [noderef] <asn:1>*src
arch/x86/include/asm/uaccess_64.h:207:47:    got void const *<noident>
arch/x86/include/asm/uaccess_64.h:207:47: warning: incorrect type in argument 2 (different address spaces)
arch/x86/include/asm/uaccess_64.h:207:47:    expected void const [noderef] <asn:1>*src
arch/x86/include/asm/uaccess_64.h:207:47:    got void const *<noident>
arch/x86/include/asm/uaccess_64.h:207:47: warning: incorrect type in argument 2 (different address spaces)
arch/x86/include/asm/uaccess_64.h:207:47:    expected void const [noderef] <asn:1>*src
arch/x86/include/asm/uaccess_64.h:207:47:    got void const *<noident>
arch/x86/include/asm/uaccess_64.h:207:47: warning: incorrect type in argument 2 (different address spaces)
arch/x86/include/asm/uaccess_64.h:207:47:    expected void const [noderef] <asn:1>*src
arch/x86/include/asm/uaccess_64.h:207:47:    got void const *<noident>

Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/include/asm/uaccess_64.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 190413d..12a26b9 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -204,13 +204,13 @@ int __copy_in_user(void __user *dst, const void __user *src, unsigned size)
 static __must_check __always_inline int
 __copy_from_user_inatomic(void *dst, const void __user *src, unsigned size)
 {
-	return __copy_from_user_nocheck(dst, (__force const void *)src, size);
+	return __copy_from_user_nocheck(dst, src, size);
 }
 
 static __must_check __always_inline int
 __copy_to_user_inatomic(void __user *dst, const void *src, unsigned size)
 {
-	return __copy_to_user_nocheck((__force void *)dst, src, size);
+	return __copy_to_user_nocheck(dst, src, size);
 }
 
 extern long __copy_user_nocache(void *dst, const void __user *src,
-- 
1.8.1.4

