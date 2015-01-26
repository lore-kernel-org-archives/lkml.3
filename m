Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbbAZMzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:55:09 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:53792 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbbAZMzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:55:03 -0500
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <maasami.hiramatsu.pt@hitachi.com>
Cc: Vojtech Pavlik <vojtech@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
        Jiri Slaby <jslaby@suse.cz>,
        Andreas Krebbel <krebbel@linux.vnet.ibm.com>,
        Dominik Vogt <vogt@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH/RFC 2/3] ftrace: introduce nohotpatch function attribute
Date: Mon, 26 Jan 2015 13:54:53 +0100
Message-Id: <1422276894-31302-3-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422276894-31302-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1422276894-31302-1-git-send-email-heiko.carstens@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012612-0013-0000-0000-000002BF25FC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc supports an s390 specific function attribute called "hotpatch".
It can be used to specify the number of halfwords that shall be added before
and after a function that shall be filled with nops for runtime patching.

s390 will use the hotpatch attribute for function tracing, therefore
introduce a nohotpatch define, depending on CC_USING_HOTPATCH, and add it
to the existing notrace define.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 include/linux/compiler.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index b4fd7013c9f4..b4ab98e0e10b 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -54,7 +54,13 @@ extern void __chk_io_ptr(const volatile void __iomem *);
 #include <linux/compiler-gcc.h>
 #endif
 
-#define notrace __attribute__((no_instrument_function))
+#ifdef CC_USING_HOTPATCH
+#define nohotpatch __attribute__((hotpatch(0,0)))
+#else
+#define nohotpatch
+#endif
+
+#define notrace __attribute__((no_instrument_function)) nohotpatch
 
 /* Intel compiler defines __GNUC__. So we will overwrite implementations
  * coming from above header files here
-- 
2.1.4

