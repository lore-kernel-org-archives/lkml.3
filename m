Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbaESTAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:00:10 -0400
Received: from mail.skyhub.de ([78.46.96.112]:38917 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbaESS7k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 14:59:40 -0400
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH 1/2] x86: Carve out cmdline parsing function
Date: Mon, 19 May 2014 20:59:16 +0200
Message-Id: <1400525957-11525-2-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1400525957-11525-1-git-send-email-bp@alien8.de>
References: <1400525957-11525-1-git-send-email-bp@alien8.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

into .../lib/cmdline.c to use by kernel proper too.

Adapted from arch/x86/boot/cmdline.c.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/cmdline.h |  6 +++
 arch/x86/lib/Makefile          |  2 +-
 arch/x86/lib/cmdline.c         | 84 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 91 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/include/asm/cmdline.h
 create mode 100644 arch/x86/lib/cmdline.c

diff --git a/arch/x86/include/asm/cmdline.h b/arch/x86/include/asm/cmdline.h
new file mode 100644
index 000000000000..e01f7f7ccb0c
--- /dev/null
+++ b/arch/x86/include/asm/cmdline.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_X86_CMDLINE_H
+#define _ASM_X86_CMDLINE_H
+
+int cmdline_find_option_bool(const char *cmdline_ptr, const char *option);
+
+#endif /* _ASM_X86_CMDLINE_H */
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index eabcb6e6a900..4d4f96a27638 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -16,7 +16,7 @@ clean-files := inat-tables.c
 
 obj-$(CONFIG_SMP) += msr-smp.o cache-smp.o
 
-lib-y := delay.o misc.o
+lib-y := delay.o misc.o cmdline.o
 lib-y += thunk_$(BITS).o
 lib-y += usercopy_$(BITS).o usercopy.o getuser.o putuser.o
 lib-y += memcpy_$(BITS).o
diff --git a/arch/x86/lib/cmdline.c b/arch/x86/lib/cmdline.c
new file mode 100644
index 000000000000..422db000d727
--- /dev/null
+++ b/arch/x86/lib/cmdline.c
@@ -0,0 +1,84 @@
+/*
+ * This file is part of the Linux kernel, and is made available under
+ * the terms of the GNU General Public License version 2.
+ *
+ * Misc librarized functions for cmdline poking.
+ */
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/ctype.h>
+#include <asm/setup.h>
+
+static inline int myisspace(u8 c)
+{
+	return c <= ' ';	/* Close enough approximation */
+}
+
+/**
+ * Find a boolean option (like quiet,noapic,nosmp....)
+ *
+ * @cmdline: the cmdline string
+ * @option: option string to look for
+ *
+ * Returns the position of that @option (starts counting with 1)
+ * or 0 on not found.
+ */
+int cmdline_find_option_bool(const char *cmdline, const char *option)
+{
+	char c;
+	int len, pos = 0, wstart = 0;
+	const char *opptr = NULL;
+	enum {
+		st_wordstart = 0,	/* Start of word/after whitespace */
+		st_wordcmp,	/* Comparing this word */
+		st_wordskip,	/* Miscompare, skip */
+	} state = st_wordstart;
+
+	if (!cmdline)
+		return -1;      /* No command line */
+
+	len = min_t(int, strlen(cmdline), COMMAND_LINE_SIZE);
+	if (!len)
+		return 0;
+
+	while (len--) {
+		c = *(char *)cmdline++;
+		pos++;
+
+		switch (state) {
+		case st_wordstart:
+			if (!c)
+				return 0;
+			else if (myisspace(c))
+				break;
+
+			state = st_wordcmp;
+			opptr = option;
+			wstart = pos;
+			/* fall through */
+
+		case st_wordcmp:
+			if (!*opptr)
+				if (!c || myisspace(c))
+					return wstart;
+				else
+					state = st_wordskip;
+			else if (!c)
+				return 0;
+			else if (c != *opptr++)
+				state = st_wordskip;
+			else if (!len)		/* last word and is matching */
+				return wstart;
+			break;
+
+		case st_wordskip:
+			if (!c)
+				return 0;
+			else if (myisspace(c))
+				state = st_wordstart;
+			break;
+		}
+	}
+
+	return 0;	/* Buffer overrun */
+}
-- 
1.9.0

