Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbaEUDqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 23:46:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58929 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbaEUDp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 23:45:58 -0400
Date: Tue, 20 May 2014 20:45:36 -0700
From: tip-bot for Borislav Petkov <tipbot@zytor.com>
Message-ID: <tip-1b1ded57a4f2f4420b4de7c395d1b841d8b3c41a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, bp@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, bp@suse.de
In-Reply-To: <1400525957-11525-2-git-send-email-bp@alien8.de>
References: <1400525957-11525-2-git-send-email-bp@alien8.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/microcode] x86, boot:
  Carve out early cmdline parsing function
Git-Commit-ID: 1b1ded57a4f2f4420b4de7c395d1b841d8b3c41a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1b1ded57a4f2f4420b4de7c395d1b841d8b3c41a
Gitweb:     http://git.kernel.org/tip/1b1ded57a4f2f4420b4de7c395d1b841d8b3c41a
Author:     Borislav Petkov <bp@suse.de>
AuthorDate: Mon, 19 May 2014 20:59:16 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 20 May 2014 20:21:24 -0700

x86, boot: Carve out early cmdline parsing function

Carve out early cmdline parsing function into .../lib/cmdline.c so it
can be used by early code in the kernel proper as well.

Adapted from arch/x86/boot/cmdline.c.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/1400525957-11525-2-git-send-email-bp@alien8.de
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/cmdline.h |  6 +++
 arch/x86/lib/Makefile          |  2 +-
 arch/x86/lib/cmdline.c         | 84 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 91 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cmdline.h b/arch/x86/include/asm/cmdline.h
new file mode 100644
index 0000000..e01f7f7
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
index eabcb6e..4d4f96a 100644
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
index 0000000..422db00
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
