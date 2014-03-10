Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbaCJUc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:32:28 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:44597 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbaCJUcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:32:25 -0400
X-Originating-IP: 98.158.13.34
Date: Mon, 10 Mar 2014 13:32:13 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jan Beulich <JBeulich@suse.com>, Josh Triplett <josh@joshtriplett.org>,
        Kees Cook <keescook@chromium.org>, Kyungsik Lee <kyungsik.lee@lge.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [PATCH 2/3] x86, boot: Don't compile aslr.c when
 !CONFIG_RANDOMIZE_BASE
Message-ID: <d117bf82ca277e0f6bd0b2a4f663d6c0dd7f11bb.1394483342.git.josh@joshtriplett.org>
References: <5675f041c50dca1c214a4b315ccd18805ab121a8.1394483342.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5675f041c50dca1c214a4b315ccd18805ab121a8.1394483342.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the code in aslr.c gets compiled out if !CONFIG_RANDOMIZE_BASE, but
aslr.o itself still gets compiled in.  Eliminate it from the compile
entirely in that case.

This does not change the generated code at all, in either case.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/boot/compressed/Makefile | 4 +++-
 arch/x86/boot/compressed/aslr.c   | 3 ---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 7c50279..42e738d 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -28,7 +28,9 @@ HOST_EXTRACFLAGS += -I$(srctree)/tools/include
 
 vmlinux-objs-y := $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
 	$(obj)/string.o $(obj)/cmdline.o $(obj)/early_serial_console.o \
-	$(obj)/piggy.o $(obj)/cpuflags.o $(obj)/aslr.o
+	$(obj)/piggy.o $(obj)/cpuflags.o
+
+vmlinux-objs-$(CONFIG_RANDOMIZE_BASE) += $(obj)/aslr.o
 
 $(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
 
diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index 4dbf967..d0f8923 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -1,6 +1,5 @@
 #include "misc.h"
 
-#ifdef CONFIG_RANDOMIZE_BASE
 #include <asm/msr.h>
 #include <asm/archrandom.h>
 #include <asm/e820.h>
@@ -313,5 +312,3 @@ unsigned char *choose_kernel_location(unsigned char *input,
 out:
 	return (unsigned char *)choice;
 }
-
-#endif /* CONFIG_RANDOMIZE_BASE */
-- 
1.9.0

