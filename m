Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab3KYQPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 11:15:36 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:33815 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757127Ab3KYQPc convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Mon, 25 Nov 2013 11:15:32 -0500
Message-Id: <529385AF0200007800106C84@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Mon, 25 Nov 2013 16:15:27 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <arjan@linux.intel.com>, <linux@roeck-us.net>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: override __compiletime_object_size()
References: <5265056D02000078000FC4F3@nat28.tlf.novell.com>
 <20131026103109.GC14949@gmail.com>
 <526F914A02000078000FD806@nat28.tlf.novell.com>
 <20131029095408.GB25306@gmail.com>
 <526F971F02000078000FD841@nat28.tlf.novell.com>
 <20131029101257.GA25953@gmail.com>
In-Reply-To: <20131029101257.GA25953@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed in the context of commits 3df7b41a ("x86: Unify
copy_from_user() size checking") and 7a3d9b0f ("x86: Unify
copy_to_user() and add size checking to it"), we want to leverage
__builtin_object_size() also on newer gcc versions, but with other
architectures still using another model of copy_*_user() verification
we can't replace the global definition. Do it in the (only) header
needing the construct for now.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Guenter Roeck <linux@roeck-us.net>
---
 arch/x86/include/asm/uaccess.h |    6 ++++++
 1 file changed, 6 insertions(+)

--- 3.13-rc1/arch/x86/include/asm/uaccess.h
+++ 3.13-rc1-x86-compiletime-object-size/arch/x86/include/asm/uaccess.h
@@ -584,6 +584,12 @@ __copy_from_user_overflow(int size, unsi
 
 #endif
 
+/* linux/compiler-gcc4.h restricts this to gcc < 4.6, which doesn't suit us. */
+#if defined(__GNUC__) && GCC_VERSION >= 40100
+# undef __compiletime_object_size
+# define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
+#endif
+
 static inline unsigned long __must_check
 copy_from_user(void *to, const void __user *from, unsigned long n)
 {



