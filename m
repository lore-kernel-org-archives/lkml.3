Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaACWrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 17:47:06 -0500
Received: from [198.137.202.10] ([198.137.202.10]:33754 "EHLO
	terminus.zytor.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbaACWrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 17:47:04 -0500
Date: Fri, 3 Jan 2014 14:46:19 -0800
From: tip-bot for Steven Rostedt <tipbot@zytor.com>
Message-ID: <tip-c7c4c8f1b828b550295f1d937578e3090f3b5d66@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, ak@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, ak@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <20140103164500.5f6478f5@gandalf.local.home>
References: <20140103164500.5f6478f5@gandalf.local.home>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/build] x86, sparse:
  Do not force removal of __user when calling copy_to/from_user_nocheck()
Git-Commit-ID: c7c4c8f1b828b550295f1d937578e3090f3b5d66
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 03 Jan 2014 14:46:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c7c4c8f1b828b550295f1d937578e3090f3b5d66
Gitweb:     http://git.kernel.org/tip/c7c4c8f1b828b550295f1d937578e3090f3b5d66
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Fri, 3 Jan 2014 16:45:00 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 3 Jan 2014 14:43:44 -0800

x86, sparse: Do not force removal of __user when calling copy_to/from_user_nocheck()

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
Link: http://lkml.kernel.org/r/20140103164500.5f6478f5@gandalf.local.home
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
