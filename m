Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab3LYSPK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 13:15:10 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:58016 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab3LYSPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 13:15:09 -0500
Date: Wed, 25 Dec 2013 10:15:03 -0800
From: "H.J. Lu" <hjl.tools@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, alan.cox@intel.com,
        Thomas Gleixner <tglx@linutronix.de>, tiwai@suse.de, perex@perex.cz,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/2] Add __compat_aligned_s64 and __compat_aligned_u64
Message-ID: <20131225181502.GA25627@gmail.com>
References: <20131225171551.GA1798@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <20131225171551.GA1798@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 25, 2013 at 09:15:51AM -0800, H.J. Lu wrote:
> X32 uses the 32-bit compat layer for 32-bit kernel interface, which is
> also used by ia32.  But long long is 4-byte aligned for ia32 and 8-byte
> aligned for x32.  When the long long field in a system call struct has
> different offsets between ia32 and x32 due to alignment padding, like
> struct snd_ctl_elem_value in include/uapi/sound/asound.h, we need to
> either add a special case for x32 or we can use 4-byte aligned long
> long in the system call struct so that x32 can share the same compat
> system cal with ia32.  This patch adds __compat_aligned_s64 and
> __compat_aligned_u64 to include/uapi/asm-generic/int-ll64.h.  By
> default, they are the same as __s64/__u64.  It does the following
> things:
> 
> 1. Add default __compat_aligned_s64/__compat_aligned_u64 to
> include/uapi/asm-generic/int-ll64.h.
> 2. Add arch/x86/include/asm/types.h for kernel internal use, which is the
> same as before, i.e., <asm-generic/types.h>.
> 3. Change arch/x86/include/uapi/asm/types.h not to use the default
> include/uapi/asm-generic/int-ll64.h.  Instead, it has a modified copy
> of include/uapi/asm-generic/int-ll64.h with 4-byte aligned
> __compat_aligned_s64 and __compat_aligned_u64 for x32 and ia32.
> 
> When building x86 kernel, nothing is changed.  The difference is
> x32 can use 4-byte aligned long long for system calls so that it
> can share the same 32-bit compat system call with ia32.
> 
> Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
> ---
>  arch/x86/include/asm/types.h        |  6 ++++++
>  arch/x86/include/uapi/asm/types.h   | 35 ++++++++++++++++++++++++++++++++++-
>  include/uapi/asm-generic/int-ll64.h |  3 +++
>  3 files changed, 43 insertions(+), 1 deletion(-)
>  create mode 100644 arch/x86/include/asm/types.h
...
> diff --git a/arch/x86/include/uapi/asm/types.h b/arch/x86/include/uapi/asm/types.h
> index 8e8c23f..7dac28b 100644
> --- a/arch/x86/include/uapi/asm/types.h
> +++ b/arch/x86/include/uapi/asm/types.h
...
> +#if defined(__i386__) || defined(__ILP32__)
> +typedef s64 __attribute__((aligned(4))) __compat_aligned_s64;
> +typedef u64 __attribute__((aligned(4))) __compat_aligned_u64;

Here are 2 typos. They should be __s64 and __u64.

> +#else
> +typedef __s64 __compat_aligned_s64;
> +typedef __u64 __compat_aligned_u64;
> +#endif

Here is the updated patch.

H.J.

--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-Add-__compat_aligned_s64-and-__compat_aligned_u64.patch"

>From 42181ac3158ae8d0303ded5614ccb04105fe9251 Mon Sep 17 00:00:00 2001
From: "H.J. Lu" <hjl.tools@gmail.com>
Date: Wed, 21 Aug 2013 12:35:56 -0700
Subject: [PATCH 1/2] Add __compat_aligned_s64 and __compat_aligned_u64

X32 uses the 32-bit compat layer for 32-bit kernel interface, which is
also used by ia32.  But long long is 4-byte aligned for ia32 and 8-byte
aligned for x32.  When the long long field in a system call struct has
different offsets between ia32 and x32 due to alignment padding, like
struct snd_ctl_elem_value in include/uapi/sound/asound.h, we need to
either add a special case for x32 or we can use 4-byte aligned long
long in the system call struct so that x32 can share the same compat
system cal with ia32.  This patch adds __compat_aligned_s64 and
__compat_aligned_u64 to include/uapi/asm-generic/int-ll64.h.  By
default, they are the same as __s64/__u64.  It does the following
things:

1. Add default __compat_aligned_s64/__compat_aligned_u64 to
include/uapi/asm-generic/int-ll64.h.
2. Add arch/x86/include/asm/types.h for kernel internal use, which is the
same as before, i.e., <asm-generic/types.h>.
3. Change arch/x86/include/uapi/asm/types.h not to use the default
include/uapi/asm-generic/int-ll64.h.  Instead, it has a modified copy
of include/uapi/asm-generic/int-ll64.h with 4-byte aligned
__compat_aligned_s64 and __compat_aligned_u64 for x32 and ia32.

When building x86 kernel, nothing is changed.  The difference is
x32 can use 4-byte aligned long long for system calls so that it
can share the same 32-bit compat system call with ia32.

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
---
 arch/x86/include/asm/types.h        |  6 ++++++
 arch/x86/include/uapi/asm/types.h   | 35 ++++++++++++++++++++++++++++++++++-
 include/uapi/asm-generic/int-ll64.h |  3 +++
 3 files changed, 43 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/include/asm/types.h

diff --git a/arch/x86/include/asm/types.h b/arch/x86/include/asm/types.h
new file mode 100644
index 0000000..8e8c23f
--- /dev/null
+++ b/arch/x86/include/asm/types.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_X86_TYPES_H
+#define _ASM_X86_TYPES_H
+
+#include <asm-generic/types.h>
+
+#endif /* _ASM_X86_TYPES_H */
diff --git a/arch/x86/include/uapi/asm/types.h b/arch/x86/include/uapi/asm/types.h
index 8e8c23f..7d9c75a 100644
--- a/arch/x86/include/uapi/asm/types.h
+++ b/arch/x86/include/uapi/asm/types.h
@@ -1,6 +1,39 @@
 #ifndef _ASM_X86_TYPES_H
 #define _ASM_X86_TYPES_H
 
-#include <asm-generic/types.h>
+#include <asm/bitsperlong.h>
+
+#ifndef __ASSEMBLY__
+/*
+ * __xx is ok: it doesn't pollute the POSIX namespace. Use these in the
+ * header files exported to user space
+ */
+
+typedef __signed__ char __s8;
+typedef unsigned char __u8;
+
+typedef __signed__ short __s16;
+typedef unsigned short __u16;
+
+typedef __signed__ int __s32;
+typedef unsigned int __u32;
+
+#ifdef __GNUC__
+__extension__ typedef __signed__ long long __s64;
+__extension__ typedef unsigned long long __u64;
+#else
+typedef __signed__ long long __s64;
+typedef unsigned long long __u64;
+#endif
+
+#if defined(__i386__) || defined(__ILP32__)
+typedef __s64 __attribute__((aligned(4))) __compat_aligned_s64;
+typedef __u64 __attribute__((aligned(4))) __compat_aligned_u64;
+#else
+typedef __s64 __compat_aligned_s64;
+typedef __u64 __compat_aligned_u64;
+#endif
+
+#endif /* __ASSEMBLY__ */
 
 #endif /* _ASM_X86_TYPES_H */
diff --git a/include/uapi/asm-generic/int-ll64.h b/include/uapi/asm-generic/int-ll64.h
index a8658b2..3306917 100644
--- a/include/uapi/asm-generic/int-ll64.h
+++ b/include/uapi/asm-generic/int-ll64.h
@@ -33,6 +33,9 @@ typedef __signed__ long long __s64;
 typedef unsigned long long __u64;
 #endif
 
+typedef __s64 __compat_aligned_s64;
+typedef __u64 __compat_aligned_u64;
+
 #endif /* __ASSEMBLY__ */
 
 
-- 
1.8.4.2


--3V7upXqbjpZ4EhLz--
