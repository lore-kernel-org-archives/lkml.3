Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbaCJUd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 16:33:57 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:37533 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbaCJUd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 16:33:56 -0400
X-Originating-IP: 98.158.13.34
Date: Mon, 10 Mar 2014 13:33:44 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jan Beulich <JBeulich@suse.com>, Josh Triplett <josh@joshtriplett.org>,
        Kees Cook <keescook@chromium.org>, Kyungsik Lee <kyungsik.lee@lge.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [PATCH 3/3] x86, boot: Don't compile early_serial_console.c when
 !CONFIG_EARLY_PRINTK
Message-ID: <69ac941fe6c54922e391b566b1e8c383959825cd.1394483342.git.josh@joshtriplett.org>
References: <5675f041c50dca1c214a4b315ccd18805ab121a8.1394483342.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5675f041c50dca1c214a4b315ccd18805ab121a8.1394483342.git.josh@joshtriplett.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the code in early_serial_console.c gets compiled out if
!CONFIG_EARLY_PRINTK, but early_serial_console.o itself still gets
compiled in.  Eliminate it from the compile entirely in that case.

This does not change the generated code at all, in either case.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/boot/compressed/Makefile               | 3 ++-
 arch/x86/boot/compressed/early_serial_console.c | 4 ----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 42e738d..704f58a 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -27,9 +27,10 @@ hostprogs-y	:= mkpiggy
 HOST_EXTRACFLAGS += -I$(srctree)/tools/include
 
 vmlinux-objs-y := $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
-	$(obj)/string.o $(obj)/cmdline.o $(obj)/early_serial_console.o \
+	$(obj)/string.o $(obj)/cmdline.o \
 	$(obj)/piggy.o $(obj)/cpuflags.o
 
+vmlinux-objs-$(CONFIG_EARLY_PRINTK) += $(obj)/early_serial_console.o
 vmlinux-objs-$(CONFIG_RANDOMIZE_BASE) += $(obj)/aslr.o
 
 $(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
diff --git a/arch/x86/boot/compressed/early_serial_console.c b/arch/x86/boot/compressed/early_serial_console.c
index d3d003c..261e81f 100644
--- a/arch/x86/boot/compressed/early_serial_console.c
+++ b/arch/x86/boot/compressed/early_serial_console.c
@@ -1,9 +1,5 @@
 #include "misc.h"
 
-#ifdef CONFIG_EARLY_PRINTK
-
 int early_serial_base;
 
 #include "../early_serial_console.c"
-
-#endif
-- 
1.9.0

