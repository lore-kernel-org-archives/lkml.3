Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbaJUXfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 19:35:22 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:50508 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaJUXfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 19:35:21 -0400
Date: Tue, 21 Oct 2014 16:35:18 -0700
From: josh@joshtriplett.org
To: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: .exit.text section in vmlinux ?
Message-ID: <20141021233518.GA15840@cloud>
References: <201410212319.20340.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201410212319.20340.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 11:19:01PM +0200, Peter Hüwe wrote:
> as far as I remember everything marked with __exit or __exit_data will only be 
> used/called when unloading a module, and gets moved to the .exit.text or 
> .exit.data sections.
> 
> Why are these sections present in the vmlinux/vmlinux.bin/bzImage and not 
> dropped by the linker or at least objdump? 
> This code will never be called for everything compiled in - in an allyesconfig 
> build these sections account for ~80kb of code.
> 
> Is there something I'm missing here, or can we add "--remove-section 
> .exit.data --remove-section .exit.text" to the OBJCOPYFLAGS for vmlinux?

Good catch!  I didn't realize that section even appeared in vmlinux; it
should be entirely omitted.

Removing it via objcopy would work, but seems suboptimal, since that
won't let the compiler know the functions are unused (and thus that it
can throw away code and data only referenced from __exit, or inline
functions into their now-only caller, etc).  So, ideally, when compiling
code in the kernel rather than in modules, we should tell the compiler
enough to omit functions tagged as __exit.

(Also, in the course of working on this, I discovered that several
files declare functions as "static inline ... __exit", which makes no
sense, and which actually forces an out-of-line version to exist even if
the function has no body.  For instance, exit_amd_microcode and
bcma_host_soc_unregister_driver.)

The following patch seems to mostly do the right thing, though for some
reason some __exit functions remain in the final binary (such as
md_exit and mon_exit):

--->8---
>From 1646d051a4a4c18b9a6163fceabcafa20628c728 Mon Sep 17 00:00:00 2001
From: Josh Triplett <josh@joshtriplett.org>
Date: Tue, 21 Oct 2014 16:14:19 -0700
Subject: [PATCH] linux/init.h: Always omit __exit code and data for in-kernel
 compilation

__exit code and data only exists for module removal; when compiling such
code in the kernel, omit the __exit functions to save space.  For x86
defconfig this saves about 9k, and significantly more in the compiled
binary size.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/init.h | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/linux/init.h b/include/linux/init.h
index 2df8e8d..daa329d 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -42,8 +42,14 @@
 #define __init		__section(.init.text) __cold notrace
 #define __initdata	__section(.init.data)
 #define __initconst	__constsection(.init.rodata)
+
+#ifdef MODULE
 #define __exitdata	__section(.exit.data)
 #define __exit_call	__used __section(.exitcall.exit)
+#else
+#define __exitdata	__always_unused
+#define __exit_call	__always_unused
+#endif
 
 /*
  * Some architecture have tool chains which do not handle rodata attributes
@@ -89,7 +95,11 @@
 #define __exitused  __used
 #endif
 
-#define __exit          __section(.exit.text) __exitused __cold notrace
+#ifdef MODULE
+#define __exit          __section(.exit.text) __cold notrace
+#else
+#define __exit          __always_unused
+#endif
 
 /* temporary, until all users are removed */
 #define __cpuinit
-- 
2.1.1

